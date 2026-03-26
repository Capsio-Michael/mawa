# OpenClaw Implementation Learnings

Lessons learned from running MAWA in production on OpenClaw.
These are not in the core spec — they are OpenClaw-specific implementation insights.

---

## 1. IDENTITY.md is the Most Reliable Execution Layer for Subagents

**Problem:** AGENTS.md rules were not consistently followed when a WA ran as a subagent.

**Root cause:** In OpenClaw's subagent model, the subagent inherits the parent agent's workspace context. AGENTS.md is loaded, but the subagent doesn't always treat it as its own authoritative rules — it may defer to the MA's context instead.

**Solution:** Place all critical MAWA execution rules in each WA's `IDENTITY.md`. This file is loaded with higher effective priority in subagent sessions.

**What to put in IDENTITY.md:**
- quality_gate = FAIL → retry → IPCP Error-Report flow
- TaskRun mandatory fields
- Result delivery rules (who receives output, never broadcast to wrong channels)
- Position-specific hard execution rules (e.g., market_closed check for Stocky)

**What can stay in AGENTS.md:**
- General workspace guidelines
- Memory and file management rules
- Safety rules that apply to all sessions

---

## 2. WA Bootstrap Pattern — Explicit File Loading When Spawning Subagents

**Problem:** When the MA spawns a WA as a subagent, the WA doesn't automatically know it is "Booky" or "Michael." It inherits the MA's workspace and may not load its own REGISTRATION.md or SOUL.md.

**Solution:** Every time the MA spawns a WA subagent, the task instruction must begin with an explicit bootstrap directive:

```
Before executing anything:
1. Read agents/{wa_name}/AGENTS.md — these are your runtime rules
2. Read agents/{wa_name}/REGISTRATION.md — these are your boundaries
3. Read agents/{wa_name}/SOUL.md — this is who you are
4. Read agents/{wa_name}/IDENTITY.md — this is your execution protocol
Then execute: {actual task}
```

**Where to add this:** In the MA's `AGENTS.md` or `IDENTITY.md` under a "WA Bootstrap" rule. The MA must include this preamble automatically for every WA spawn — not just when explicitly asked.

**Result:** WAs correctly enforce their own Registration boundaries, write TaskRuns, and follow their Playbook bullets.

---

## 3. Registration Boundary Check — MA Must Read WA's REGISTRATION.md Before Routing

**Problem:** The MA was routing tasks to WAs without checking if the task fell within the WA's declared scope.

**Solution:** Add an explicit Registration Boundary Check step in the MA's AGENTS.md, executed before every routing decision:

```
### Step 0c — Registration Boundary Check (BEFORE ROUTING)
Before routing any task to a WA:
1. Read that WA's REGISTRATION.md
2. Check if the task falls within their declared Data Domains and Capabilities
3. If out of scope → refuse, explain boundary, do NOT route to WA
```

**Result:** Tasks requesting Finance data are blocked before reaching Booky. The MA explains the boundary and suggests creating a dedicated Finance WA instead.

---

## 4. "WA Reports, MA Decides" — Never Let WAs Judge Whether to Escalate

**Problem:** Michael evaluated an empty document, got quality_gate = FAIL, but decided on its own that "this is a user error, not worth reporting." ipcp_sent stayed false.

**Root cause:** The WA was making a judgment call about whether the failure deserved escalation. This is the MA's job, not the WA's.

**Solution:** Add this rule explicitly to every WA's IDENTITY.md:

```
When quality_gate = FAIL after retry:
ALWAYS send IPCP Error-Report to {MA_NAME}. No exceptions.
Do NOT judge whether the failure is the user's fault or a system fault.
That judgment belongs to {MA_NAME}, not to me.
WA reports. MA decides.
```

**Principle:** WAs are executors, not decision-makers. Every failure above threshold goes up. The MA has full context to decide what to do with it.

---

## 5. Result Delivery Scope — Never Broadcast to Wrong Channels

**Problem:** Michael sent evaluation results to Technology.Claw group even when the task was submitted via DM.

**Root cause:** Michael's default behavior was to post results to the group it monitors, regardless of where the task originated.

**Solution:** Add explicit delivery scope rule to Michael's IDENTITY.md:

```
Send evaluation results ONLY to:
1. The channel/person where the task was submitted
2. {OWNER_NAME} via private message
NEVER broadcast results to group chats unless the original submission came from that group.
```

**General principle:** Every WA should track the `source_channel` of the incoming task and deliver results only back to that source.

---

## 6. Dispatcher Timeout — Fallback to Direct Routing

**Observed behavior:** The Dispatcher skill sometimes times out. When it does, FClaw falls back to direct routing based on its own knowledge of WA capabilities.

**Current status:** This is acceptable behavior — the routing decision is usually correct even without the Dispatcher. The Dispatcher adds structure and logging; it's not the only routing mechanism.

**Recommendation for v0.2.0:** Add a timeout handler that logs the fallback and still writes an IPCP dispatch record, so the audit trail is maintained even when the Dispatcher times out.

---

## 7. File Location Alignment — MA Files at Workspace Root

**OpenClaw workspace structure:**
```
workspace/
├── AGENTS.md          ← MA's runtime rules
├── IDENTITY.md        ← MA's identity
├── SOUL.md            ← MA's personality
├── FCLAW_REGISTRATION.md  ← MA's registration
├── MAWA_DISPATCH_TABLE.md
├── agents/
│   ├── booky/
│   ├── michael/
│   ├── pepper/
│   └── stocky/
└── skills/
```

The MA (FClaw) does NOT have its own subdirectory under `agents/`. Its files live at the workspace root. WAs each have their own subdirectory.

This mirrors how OpenClaw loads bootstrap files — the main agent's files are at the root, subagents' files are in their respective directories.

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-25 | Initial documentation from v0.1.0 validation testing |
