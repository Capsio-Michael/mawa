# MAWA on ArkClaw (火山引擎)

Second reference implementation of MAWA, running on ArkClaw — ByteDance's agent platform powered by 火山引擎 (Volcengine).

This implementation proves MAWA's platform portability: the same governance architecture deployed on a completely different runtime, with zero changes to the core spec.

**Status:** v0.1.0 — Active, continuously updated
**Case:** Apple HR Team — AI-powered recruitment for Capsio / 虾友.ai

---

## What This Implementation Proves

MAWA was originally built and validated on OpenClaw. This ArkClaw implementation demonstrates:

1. **Platform portability** — MAWA's MA+WA architecture, task governance, memory mechanism, and cron scheduling all work on ArkClaw without modifying the core spec.
2. **Real production use** — The HR team processed 5 real candidate resumes on day one and produced accurate cultural fit assessments without human intervention.
3. **New spec contributions** — Three new mechanisms discovered during this implementation have been proposed as MAWA spec additions (see Section 4 below).

---

## Team Structure

**Apple HR Team** — 1 MA + 5 WAs

| Position ID | Agent | Type | Core Responsibility |
|-------------|-------|------|---------------------|
| HR-MA-001 | Apple | MA | Coordinates with founder, orchestrates all WAs, escalates decisions |
| HR-WA-001 | Sourcer | WA | JD publishing, resume screening, candidate scoring |
| HR-WA-002 | Interviewer | WA | Interview scheduling, calendar coordination, feedback collection |
| HR-WA-003 | Evaluator | WA | Comprehensive candidate assessment, hiring recommendations |
| HR-WA-004 | Onboarder | WA | Onboarding process, probation tracking |
| HR-WA-005 | HRBPulse | WA | Performance tracking, strategy sync, talent discovery |

---

## Workspace File Structure

```
workspace/
├── IDENTITY.md              # Apple (MA) — includes behavioral rules
├── REGISTRATION.md          # HR Team registration
├── SESSION-CONTEXT.md       # Cross-session short-term memory
├── MAWA_DISPATCH_TABLE.md   # Message routing table
├── apple/
│   ├── PLAYBOOK.md          # MA orchestration playbook
│   ├── CRON-SCHEDULE.md     # Scheduled task configuration
│   └── ATC/                 # Task card files
├── agents/
│   ├── sourcer/             # Includes resume library
│   ├── interviewer/
│   ├── evaluator/
│   ├── onboarder/
│   └── hrbpulse/
└── taskruns/                # Execution records
```

---

## Key Design Decisions (Deviations from OpenClaw Reference)

### 1. Behavioral rules in IDENTITY.md, not SOUL.md

**Finding:** On ArkClaw, IDENTITY.md loads with higher priority and reliability than a separate SOUL.md. Embedding Hard Rules in IDENTITY.md ensures constraints are loaded every session.

**Test evidence:** Before fix — Apple sent an offer directly when asked. After fix — Apple correctly responded "I'll prepare a draft for your review before sending."

**Spec recommendation:** Add a mandatory "Behavioral Rules" section to the IDENTITY.md standard template, with ✅/❌ examples. Priority higher than SOUL.md.

### 2. Three-layer memory architecture with SESSION-CONTEXT.md

**Problem:** ArkClaw resets context window on every new conversation. Apple had no memory of previous sessions' work.

**Solution:** Three-layer memory system:

| Layer | File | Update Frequency | Purpose |
|-------|------|-----------------|---------|
| Long-term | IDENTITY.md / REGISTRATION.md / PLAYBOOK.md | Manual | Identity, rules, responsibilities |
| Mid-term (cross-day) | SESSION-CONTEXT.md | End of every session | Candidate pipeline state, pending decisions |
| Short-term (same day) | Cron 04:30 + messaging history | Daily automatic | Morning briefing, last 24h progress |

**Key insight:** SESSION-CONTEXT.md serves as the "workbench" file — equivalent to Pepper's memory role in the OpenClaw FClaw team. Both can be aligned to the same MAWA memory standard.

**Spec recommendation:** Add a "Short-term Memory Standard" section defining SESSION-CONTEXT.md structure and update protocol.

### 3. MAWA_DISPATCH_TABLE.md as mandatory MA file

Same pattern as OpenClaw implementation. Routing priority: (1) explicit WA name; (2) keyword match; (3) source channel match; (4) no match → Apple handles directly.

**Spec recommendation:** MAWA_DISPATCH_TABLE.md should be a required file for all MA positions, not optional.

---

## Behavior Test Results

Tests run before and after deploying behavioral rules to IDENTITY.md:

| Test | Scenario | Before | After |
|------|----------|--------|-------|
| Test 1 | Identity stability | ✅ Pass | ✅ Pass |
| Test 2 | Task decomposition | ⚠️ Partial | ✅ Pass |
| Test 3 | Offer decision boundary | ❌ Fail | ✅ Pass |
| Test 4 | Cultural fit judgment | ✅ Strong Pass | ✅ Strong Pass |

**Test 4 highlight:** Apple independently identified "no independent projects" as a core risk signal and provided three precise assessment dimensions — without any prompting. Cultural values transmitted through IDENTITY.md effectively.

---

## Candidate Scoring Framework

| Dimension | Score | Criteria |
|-----------|-------|----------|
| Role fit | 1–5 | 5 = fully meets requirements; 3 = meets most; 1 = missing core requirements |
| Culture signal | 0–3 | 1pt each: independent project history / tool-building experience / specific application content |
| Social engagement | Strong/Medium/Weak | Leadership, volunteering, team involvement |
| Pass threshold | — | Role fit ≥ 3 AND Culture signal ≥ 1 AND Social engagement ≠ Weak |

**First batch results (5 candidates, IDs only):**

| ID | Role Fit | Culture Signal | Result |
|----|----------|---------------|--------|
| HR-001 | 4/5 | 3/3 | ✅ Strongly recommended |
| HR-002 | 3/5 | 1/3 | ✅ Recommended (needs culture deep-dive) |
| HR-003 | 2/5 | 0/3 | ❌ Not recommended |
| HR-004 | 5/5 | 3/3 | ✅ Highest priority |
| HR-005 | 4/5 | 1/3 | ✅ Recommended |

---

## ArkClaw-Specific Technical Notes

```bash
# Cron job must be updated via CLI — direct jobs.json edits not picked up
openclaw cron edit <job_id> \
  --token <gateway_token> \
  --announce \
  --channel feishu \
  --to <chat_id>

# Get current gateway token
cat ~/.openclaw/openclaw.json | python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d['gateway']['auth']['token'])"
```

- Gateway token regenerates after every `openclaw doctor --fix` — update related scripts
- ArkClaw auth.mode is `trusted-proxy` — local cron calls via 127.0.0.1 are auto-trusted
- Feishu delivery requires `--announce --channel feishu --to` params — cannot be set in jobs.json directly

---

## MAWA Compliance Status

| Module | Status | Notes |
|--------|--------|-------|
| REGISTRATION.md | ✅ Complete | Team registration and boundary declaration |
| IDENTITY.md × 6 | ✅ Complete | MA + 5 WAs, includes behavioral rules |
| MAWA_DISPATCH_TABLE.md | ✅ Complete | 5 WAs with keyword and channel routing |
| PLAYBOOK.md | ✅ Complete | 5 core scenario workflows |
| SESSION-CONTEXT.md | ✅ Complete | Cross-session memory, validated effective |
| TaskRun records | ✅ Complete | First record established |
| Cron jobs | ✅ Complete | 4 jobs, Feishu delivery verified |
| ATC task cards | ⚠️ Partial | 3 drafts — interview/eval/onboard/offer pending |
| IPCP-PROTOCOL.md | ⚠️ Partial | Format defined in PLAYBOOK, not standalone file yet |
| SOUL.md | ⚠️ Merged | Content merged into IDENTITY.md (design decision) |
| Reflector/Curator | ⚠️ Pending | Sunday 22:00 cron configured, first run pending |

---

## Roadmap

- [ ] Complete 4 remaining ATC files (interview, evaluation, offer, onboarding)
- [ ] Create standalone IPCP-PROTOCOL.md
- [ ] Verify Reflector/Curator first run
- [ ] BOSS直聘 API integration
- [ ] 虾友.ai community channel integration

---

*Implementation by Michael Capsio (李仲涛) — Capsio / 虾友.ai*
*Platform: ArkClaw (火山引擎) | Framework: MAWA v0.1.0*
*Report date: 2026-03-27 | Status: Continuously updated*
