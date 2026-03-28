# MAWA-SPEC v1.0

**Multi-Agent Workspace Architecture — Full Specification**

> Give your AI agents a job title, not just a job.

---

## What Is MAWA?

MAWA is an open governance architecture for multi-agent AI systems. It solves the governance problem that appears when multi-agent systems move from demos to production: agents do the wrong things, with no audit trail, and no mechanism to improve over time.

MAWA gives every agent three things:

| Layer | What it is | What it prevents |
|---|---|---|
| **Registration** | What the agent CAN do — hard boundaries | Agents doing things they shouldn't |
| **Playbook** | What the agent SHOULD do — learned strategy | Agents making the same mistakes twice |
| **TaskRun** | What the agent DID do — audit trail | Black-box decisions |

And one routing layer — the **Dispatcher** — that automatically sends every incoming task to the right agent based on a single source-of-truth table.

---

## Core Concepts

### 1. Position

The atomic governance unit. Every agent in a MAWA system belongs to a Position.

A Position is not just a name. It defines:
- The agent's **role** and responsibilities
- The agent's **capabilities** (what tools and data it can access)
- The agent's **collaboration scope** (who it can communicate with)
- The agent's **hard rules** (constraints that cannot be overridden by any instruction)

Two Position types exist:

**MA (Managing Agent)** — One per team. Handles:
- Task routing via the Dispatcher
- Cross-agent coordination via IPCP
- Playbook governance (running Reflector and Curator)
- Quality oversight (receiving Error-Reports, deciding escalation)
- Never does WA work directly

**WA (Worker Agent)** — Multiple per team. Each WA:
- Has a declared Registration (scope boundaries)
- Executes tasks via structured ATCs
- Writes a TaskRun after every execution
- Reports to the MA via IPCP
- Improves over time via the Playbook loop

---

### 2. Registration

The capability declaration standard. Every Position has a `REGISTRATION.md` that declares what it can do, what data it can access, and who it can communicate with.

Registration is not aspirational. It is enforced. Any task that falls outside a WA's Registration is refused, logged, and reported to the MA.

Key Registration sections:
- **Role** — human-readable description of the Position's purpose
- **WA Capabilities** — specific tool/API permissions
- **Permitted ATC Templates** — the only ATCs this WA may execute
- **Accepted IPCP Intents** — what message types it may receive
- **Allowed IPCP Outbound** — what message types it may send
- **Collaboration Scope** — the only Positions it may communicate with
- **Data Domains** — the data it may read and write
- **Hard Rules** — constraints that override Playbook, ATC, and LLM judgment
- **Runtime Constraints** — execution limits (parallel tasks, timeout, daily max)

See `REGISTRATION-SCHEMA.md` for the full schema and field reference.

---

### 3. ATC (Agent Task Card)

The work order. Every task executed by a MAWA agent must have a corresponding ATC template. No ATC = no execution. ATCs eliminate ad-hoc agent behavior.

Every ATC has four sections (W-H-A-T):

- **W — Work** — What is the task and why does it matter?
- **H — How** — Step-by-step execution instructions (default path)
- **A — Automation** — Trigger conditions and required tools
- **T — Test** — Quality gate criteria. The agent validates its output against these before delivery.

ATCs also declare an Input Schema and Output Schema for structured data tasks. Every output must include `quality_gate: PASS | FAIL`.

See `ATC-SCHEMA.md` for the full schema.

---

### 4. Playbook

The strategy layer. A Position's Playbook contains conditional behavior rules — called bullets — that guide decisions beyond what ATC steps specify.

Playbook bullets have four types:
- **E- (Execution)** — override or extend a specific ATC step
- **R- (Risk Control)** — handle failures, edge cases, degraded states
- **Q- (Quality)** — adjust scoring or quality judgment criteria
- **D- (Deprecated)** — removed bullets, kept for audit trail

**Governance hierarchy** (highest priority wins):
```
Hard Rules (Registration)  ← always win
Playbook Bullets           ← override ATC defaults
ATC Steps                  ← default execution path
LLM Judgment               ← last resort only
```

Playbooks evolve through the Reflector → Curator loop. They start as `PILOT`, become `SOTA` after validation, and previous versions are archived as `LEGACY`.

See `PLAYBOOK-SCHEMA.md` for the full schema.

---

### 5. TaskRun

The audit trail. Every ATC execution — including failures — must produce a TaskRun JSON written to:

```
{WORKSPACE}/taskruns/{position_id}/{YYYY-MM-DD}/ATC-{POSITION_ID}-{uuid}.json
```

A task without a TaskRun did not happen.

Minimum required fields:
```json
{
  "taskrun_id": "uuid",
  "atc_id": "string",
  "position_id": "string",
  "input": {},
  "output": {},
  "tools_used": ["string"],
  "playbook_bullets_hit": ["string"],
  "quality_gate": "PASS | FAIL",
  "preflight": "PASS | FAIL",
  "ipcp_sent": "boolean",
  "duration_ms": "integer",
  "token_estimate": "integer",
  "timestamp": "ISO8601"
}
```

---

### 6. IPCP (Inter-Position Communication Protocol)

The cross-agent communication standard. All messages between Positions must conform to IPCP format.

```
[IPCP]
FROM: {position_id}
TO: {position_id}
INTENT: {intent_type}
CORRELATION_ID: {uuid}
PAYLOAD: {json_object}
```

All five fields required. A Positions may only send/receive IPCP intents declared in its Registration.

Intent types: `Request-ATC` | `Request-Data` | `Notify-Status` | `Error-Report`

In standard MAWA topology, all inter-WA communication routes through the MA.

See `IPCP-PROTOCOL.md` for the full protocol specification.

---

### 7. Dispatcher

The routing layer. The MA uses the Dispatcher skill + `MAWA_DISPATCH_TABLE.md` to route every incoming task to the correct WA.

The Dispatch Table is a single source-of-truth mapping of keywords, channels, and trigger types to WA positions. When a task matches a registered trigger, the Dispatcher routes it automatically. No match → MA handles it directly.

See `DISPATCH-TABLE-SCHEMA.md` for the full schema.

---

### 8. Reflector → Curator → SOTA Loop

The self-improvement mechanism. This is how MAWA agents improve over time — not by becoming smarter models, but by accumulating evaluated experience and building better execution habits.

**Reflector** (runs weekly, typically Sunday 22:00):
- Mines all TaskRuns from the past week
- Identifies patterns: repeated FAIL conditions, missing Playbook bullets, effective strategies
- Generates candidate Playbook bullets for each WA

**Curator** (runs on-demand, owner-attended session):
- Presents each candidate bullet to the owner for review
- Owner approves, rejects, or edits each candidate
- Approved bullets are added to a new Playbook version (PILOT)

**SOTA Promotion**:
- A PILOT Playbook runs for 2 weeks under observation
- Reflector confirms: `helpful_count > 0 AND harmful_count = 0`
- PILOT → SOTA, previous SOTA → LEGACY

```
Execute (ATC)
    ↓
Record (TaskRun)
    ↓
Reflect (Reflector mines weekly TaskRuns)
    ↓
Curate (owner reviews candidates)
    ↓
Evolve (Playbook promoted)
    ↓
Execute better next time
```

---

## File Structure

Every MAWA workspace follows this structure:

```
workspace/
├── AGENTS.md                  ← MA runtime rules
├── IDENTITY.md                ← MA identity declaration
├── SOUL.md                    ← MA personality
├── {MA_NAME}_REGISTRATION.md  ← MA registration
├── MAWA_DISPATCH_TABLE.md     ← routing table
├── agents/
│   ├── {wa_name}/
│   │   ├── AGENTS.md          ← WA runtime rules
│   │   ├── IDENTITY.md        ← WA identity + execution protocol
│   │   ├── SOUL.md            ← WA personality
│   │   ├── REGISTRATION.md    ← WA capability declaration
│   │   ├── ATC/               ← task card templates
│   │   ├── PLAYBOOK/          ← strategy bullets
│   │   └── WHAT/              ← task context documents
│   └── _template/             ← blank templates for new WAs
├── skills/                    ← MAWA skill files
├── taskruns/                  ← execution audit trail
├── audit/
│   ├── deny-logs/             ← registration violation logs
│   └── ipcp-log/              ← IPCP message logs
└── playbook-versions/         ← historical playbook archive
```

The MA's files live at the workspace root. WAs each have their own subdirectory under `agents/`.

---

## The 5-Test Validation Suite

Every MAWA implementation must pass these 5 tests before going to production:

| Test | What it verifies |
|------|-----------------|
| Test 1 — Registration Boundary | WA refuses out-of-scope request + writes deny log |
| Test 2 — ATC Execution | Task produces structured output + TaskRun written |
| Test 3 — Quality Gate | Malformed input triggers FAIL + retry + Error-Report |
| Test 4 — IPCP | Double failure produces Error-Report in correct IPCP format |
| Test 5 — Playbook Bullet | Condition triggers matching bullet, cited in TaskRun |

All 5 passing = your MAWA team is production-ready.

---

## WA Bootstrap Protocol

When an MA spawns a WA as a subagent, the task instruction must begin with an explicit bootstrap directive to ensure the WA loads its own context and does not defer to the MA's context:

```
Before executing anything:
1. Read agents/{wa_name}/AGENTS.md — your runtime rules
2. Read agents/{wa_name}/REGISTRATION.md — your boundaries
3. Read agents/{wa_name}/SOUL.md — who you are
4. Read agents/{wa_name}/IDENTITY.md — your execution protocol
Then execute: {actual task}
```

This prevents WAs from inheriting MA context and ensures Registration boundaries are enforced correctly.

---

## What MAWA Does Not Define

MAWA is a governance architecture, not an agent framework. It does not define:
- How agents are implemented (model, framework, infrastructure)
- What tools agents use (platform-specific)
- The content of agent personalities (domain-specific)
- Business logic within ATCs (deployment-specific)

MAWA defines the structure — boundaries, protocols, audit trails, and improvement loops — that governance requires. Everything inside that structure is yours to define.

---

## Platform Compatibility

MAWA is platform-agnostic. It can be implemented on:

- **OpenClaw** — reference implementation (see `/implementations/openclaw`)
- **AutoGen** — use Registration as agent system prompts + tool restrictions
- **CrewAI** — map Positions to Crews, ATCs to Tasks, Playbooks to agent backstories
- **LangGraph** — Registration as node constraints, IPCP as edge conditions
- **Any LLM framework** — the spec defines behavior, not implementation

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
| 1.1 | 2026-03-28 | Added WA Bootstrap Protocol, File Structure section |
