# MAWA Specification v1.0

**Multi-Agent Workspace Architecture**
Platform-independent. Implement on OpenClaw, AutoGen, CrewAI, LangGraph, or any LLM framework.

---

## Overview

MAWA is a governance architecture for multi-agent AI teams. It defines how agents are declared, how tasks are structured, how agents communicate, and how agent behavior improves over time.

MAWA does not replace agent frameworks. It governs them.

---

## Core Concepts

### 1. Position

A Position is the fundamental unit of MAWA. Every agent operates within exactly one Position.

A Position is not an agent. It is a *role declaration* — a contract that defines what an agent is allowed to do, what data it can access, and what tasks it can execute.

```
Position = Registration + Identity + Soul + Playbook + ATC Templates
```

**Position types:**
- **MA (Managing Agent)** — Coordinates work, routes tasks, manages WAs
- **WA (Worker Agent)** — Executes tasks within declared boundaries

### 2. Registration

The `REGISTRATION.md` file is the capability contract for a Position. It is the source of truth for:

- What this Position can do (`capabilities`)
- What tasks it may execute (`permitted_atc_templates`)
- What messages it may send and receive (`ipcp_intents`)
- What data it may touch (`data_domains`)
- What it must never do (`hard_rules`)

Registration is immutable during a session. It cannot be overridden by Playbook or runtime instructions.

### 3. ATC (Agent Task Card)

An ATC is a structured task specification. Every task executed by a MAWA agent must have a corresponding ATC template.

ATCs define:
- **W** — Work: what the task is and why it matters
- **H** — How: step-by-step execution instructions
- **A** — Acceptance: quality criteria for PASS/FAIL
- **T** — Tools: which tools may be used

ATCs eliminate ad-hoc task execution. No ATC = no execution.

### 4. Playbook

The Playbook is a living strategy document. It contains conditional behavior rules (bullets) that guide agent decisions beyond what ATC steps specify.

Playbook bullets follow the format:
```
IF [condition] THEN [action]
```

Playbooks evolve. Bullets are added, updated, and deprecated over time based on TaskRun outcomes. This is how MAWA agents improve without retraining.

### 5. IPCP (Inter-Position Communication Protocol)

IPCP defines how Positions communicate with each other. All cross-Position messages must declare:

- `FROM` — sending Position
- `TO` — receiving Position
- `INTENT` — one of: `Request-ATC`, `Request-Data`, `Notify-Status`, `Error-Report`
- `CORRELATION_ID` — for tracing multi-hop workflows
- `PAYLOAD` — structured data

Agents may only send/receive IPCP intents declared in their Registration.

### 6. TaskRun

Every ATC execution produces a TaskRun — a structured audit record written to persistent storage.

TaskRuns capture:
- Input and output
- Tools used
- Playbook bullets triggered
- Quality gate result (PASS / FAIL)
- IPCP messages sent
- Token usage and duration

TaskRuns are the raw material for the Reflector skill.

### 7. Dispatcher

The Dispatcher is the MA's routing engine. It reads every inbound message and routes it to the correct Position based on the Dispatch Table.

The Dispatch Table maps intent patterns to Position IDs.

### 8. Reflector

The Reflector is a periodic skill (typically weekly) that mines TaskRuns to generate candidate Playbook bullets. It identifies:

- Bullets that consistently correlate with task success
- Bullets that correlate with failure
- Recurring task patterns with no matching bullet (candidate new bullets)

The Reflector outputs candidates. A human or Curator reviews them before promotion.

### 9. Curator

The Curator governs Playbook quality. It:

- Reviews candidate bullets from the Reflector
- Promotes, rejects, or modifies bullets
- Deprecates bullets that are no longer valid
- Maintains version history

---

## File Structure

Each Position has its own directory:

```
workspace/
├── MAWA_DISPATCH_TABLE.md
├── MAWA_SECURITY.md
├── MAWA_EVOLUTION.md
├── {MA_POSITION}/
│   ├── REGISTRATION.md
│   ├── IDENTITY.md
│   ├── SOUL.md
│   └── PLAYBOOK/
│       └── PLAYBOOK.md
└── agents/
    └── {WA_POSITION}/
        ├── REGISTRATION.md
        ├── IDENTITY.md
        ├── SOUL.md
        ├── WHAT/
        │   └── WHAT.md
        ├── ATC/
        │   └── ATC-{POSITION}-{NAME}.md
        └── PLAYBOOK/
            └── PLAYBOOK.md
```

---

## Governance Hierarchy

```
Hard Rules (Registration)     ← Cannot be overridden
       ↓
Playbook Bullets              ← Override default behavior
       ↓
ATC Steps                     ← Default execution path
       ↓
LLM Judgment                  ← Used only when no rule applies
```

Hard Rules always win. If a Playbook bullet conflicts with a Hard Rule, the Hard Rule prevails and the conflict is logged.

---

## Lifecycle

```
1. Declare    → Write REGISTRATION.md
2. Instantiate → Agent loads Registration + SOUL + IDENTITY at session start
3. Dispatch   → Inbound messages routed by Dispatcher
4. Execute    → Agent runs ATC, consulting Playbook bullets
5. Record     → TaskRun written to disk
6. Reflect    → Reflector mines TaskRuns weekly
7. Evolve     → Curator promotes candidate bullets to Playbook
```

---

## Implementing on Other Frameworks

| Framework | Position → | Registration → | ATC → | Playbook → |
|-----------|-----------|---------------|-------|------------|
| AutoGen | Agent | System prompt constraints | Tool definitions | Memory/instructions |
| CrewAI | Crew member | Agent backstory + tools | Task | Agent instructions |
| LangGraph | Node | Node input schema + guards | Node function | Conditional edges |
| OpenClaw | Skill/Agent | REGISTRATION.md file | Skill file | PLAYBOOK.md file |

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
