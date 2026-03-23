# MAWA Specification v0.1.0
## Manage Agent + Work Agent Architecture

**Status:** Draft  
**Version:** 0.1.0  
**Date:** 2026-03-23  
**License:** MIT  

---

## Abstract

MAWA (Manage Agent + Work Agent) is an open governance architecture for multi-agent AI systems. It defines how AI agents should declare capabilities, receive tasks, execute work, communicate across positions, learn from experience, and be governed within an organization.

MAWA is platform-agnostic. It defines behavior and structure, not implementation. Any agent framework (AutoGen, CrewAI, LangGraph, OpenClaw, or custom) can implement MAWA-compliant agents by following this specification.

---

## Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Position Model](#2-position-model)
3. [Registration](#3-registration)
4. [WHAT Model](#4-what-model)
5. [ATC — Agentic Task Card](#5-atc--agentic-task-card)
6. [Playbook](#6-playbook)
7. [MA Runtime](#7-ma-runtime)
8. [WA Runtime](#8-wa-runtime)
9. [IPCP — Inter-Position Communication Protocol](#9-ipcp--inter-position-communication-protocol)
10. [TaskRun](#10-taskrun)
11. [Reflector](#11-reflector)
12. [Curator](#12-curator)
13. [Dispatcher](#13-dispatcher)
14. [Security Model](#14-security-model)
15. [Compliance](#15-compliance)

---

## 1. Core Concepts

### 1.1 The Governance Problem

Multi-agent AI systems fail in production for a consistent set of reasons:

- Agents execute tasks outside their intended scope
- No audit trail exists for agent decisions
- Adding new agents breaks existing agent behavior
- Repeated failures are not learned from
- Cross-agent communication is unstructured and untracked

These are governance failures, not model failures. MAWA addresses governance.

### 1.2 The MAWA Principle

> Every AI agent in an organization should have a job title, not just a job description.

A job title implies:
- A defined scope of responsibility (Registration)
- A standard way of working (Playbook)
- Accountability for outputs (TaskRun)
- A place in the organizational structure (Position)
- Defined relationships with other roles (IPCP)

### 1.3 The Dual-Layer Architecture

MAWA organizes agents into two layers:

**Manage Agent (MA)** — The position brain. One per team. Responsible for:
- Task routing and scheduling
- Quality oversight
- Cross-position coordination (IPCP)
- Playbook governance
- Registration authority

**Work Agent (WA)** — The position executor. Multiple per team. Responsible for:
- Executing ATCs (task cards)
- Following Playbook strategy
- Writing TaskRuns
- Self-quality-gating
- Escalating to MA when needed

### 1.4 Key Terms

| Term | Definition |
|---|---|
| **Position** | The atomic governance unit. A role with defined boundaries. |
| **MA** | Manage Agent. The brain of a position team. |
| **WA** | Work Agent. An executor within a position. |
| **Registration** | A declaration of what an agent CAN do. Hard boundaries. |
| **ATC** | Agentic Task Card. A structured work order. |
| **Playbook** | A versioned set of strategy bullets. What an agent SHOULD do. |
| **TaskRun** | An auditable record of what an agent DID do. |
| **IPCP** | Inter-Position Communication Protocol. Structured cross-agent messaging. |
| **Reflector** | A component that mines TaskRuns for Playbook candidates. |
| **Curator** | A governance process that promotes Playbook candidates to SOTA. |
| **Dispatcher** | An MA component that routes incoming tasks to the correct WA. |
| **SOTA** | State of the Art. The current best version of a Playbook. |

---

## 2. Position Model

### 2.1 Definition

A Position is the fundamental organizational unit in MAWA. Every agent belongs to exactly one Position.

```
Position {
  position_id:     string (unique)
  name:            string
  description:     string
  ma:              ManageAgent
  was:             WorkAgent[]
  registration:    Registration
  atc_templates:   ATCTemplate[]
  playbook:        PlaybookVersion (current SOTA)
  data_domains:    string[]
  ipcp_policy:     IPCPPolicy
}
```

### 2.2 Position Activation

A Position is considered **Active** when:
1. A Registration exists for both MA and at least one WA
2. At least one ATC template is defined
3. A Playbook version exists (minimum v1)
4. The MA has been initialized with the Registration loaded

### 2.3 Position as Security Domain

Each Position is an isolated security domain. It has:
- Its own **data domain** (what data it can access)
- Its own **tool domain** (what tools it can call)
- Its own **collaboration domain** (which other Positions it can communicate with)
- Its own **capability domain** (what tasks it can execute)

Cross-domain access requires explicit IPCP authorization. There are no exceptions.

---

## 3. Registration

### 3.1 Purpose

Registration is the **single source of truth** for what an agent is permitted to do. It is the capability declaration layer — the "job title" in concrete form.

> Registration = what the agent CAN do  
> Playbook = what the agent SHOULD do  
> TaskRun = what the agent DID do

### 3.2 Registration Priority

Registration has the **highest priority** in the governance chain. No instruction, Playbook bullet, IPCP message, or human request can override a Registration hard rule.

```
Priority order (highest to lowest):
1. Registration Hard Rules
2. Registration Capability Boundaries
3. Playbook SOTA bullets
4. Playbook PILOT bullets
5. MA instructions
6. Human instructions
```

### 3.3 MA Registration Schema

```yaml
position_id: string
agent_type: MA
version: integer
status: active | inactive | deprecated

capabilities:
  - task_scheduling
  - quality_gate
  - ipcp_management
  - playbook_execution
  - registration_governance    # Only MA can modify WA Registrations
  - curator_authority

permitted_atc_templates:
  - ATC-{POSITION}-{NAME}      # List of ATC IDs this MA can assign

accepted_intents:              # IPCP intents this MA will accept
  - Notify-Status
  - Error-Report

allowed_outbound_intents:      # IPCP intents this MA can send
  - Request-ATC
  - Notify-Status

collaboration_scope:           # Position IDs this MA can communicate with
  - {POSITION_ID}

data_domains:
  - {DOMAIN_NAME}

hard_rules:
  - "Only the MA can modify WA Registration files"
  - "All Registration changes require human authorization"
  - "MA must not execute WA tasks directly — always delegate via ATC"
```

### 3.4 WA Registration Schema

```yaml
position_id: string
agent_type: WA
managed_by: string             # MA position_id
version: integer
status: active | inactive | deprecated

capabilities:                  # What this WA can do
  - {CAPABILITY_NAME}          # e.g. document_read, quality_evaluate, notify_send

permitted_atc_templates:       # ATCs this WA can execute
  - ATC-{POSITION}-{NAME}

accepted_intents:              # IPCP intents this WA can receive (from MA only)
  - Request-ATC
  - Notify-Status

allowed_outbound_intents:      # IPCP intents this WA can send (to MA only)
  - Notify-Status
  - Error-Report

collaboration_scope:           # WA collaboration is always through MA
  - {MA_POSITION_ID}           # WAs cannot directly IPCP other WAs

data_domains:                  # Data this WA can access
  - {DOMAIN_NAME}

runtime_constraints:
  max_parallel_tasks: integer  # Default: 1
  timeout_ms: integer          # Default: 30000
  max_daily_atc_executions: integer

hard_rules:                    # Inviolable behavioral constraints
  - string                     # Plain language rules
```

### 3.5 Registration Change Protocol

Registration changes are the only governance action that **requires human authorization**.

```
Request flow:
1. WA identifies needed capability expansion
2. WA sends IPCP Request-Data to MA: "Registration change request: {details}"
3. MA presents to human owner for approval
4. Human approves → MA updates REGISTRATION.md, increments version
5. MA notifies WA: "Registration updated to v{N}"
6. MA writes entry to evolution log

Registration changes are NEVER automatic.
```

---

## 4. WHAT Model

### 4.1 Purpose

WHAT is the first-principles description of a task. It captures the human intent before any automation or tooling is considered.

```
W — Work:      What is the task in human terms?
H — How:       What are the execution steps?
A — Automate:  Which steps can be automated, and what capabilities are needed?
T — Test:      How do we verify the output is correct?
```

### 4.2 WHAT Schema

```yaml
what_id: string
position_id: string
version: integer

W:
  task_name: string
  business_intent: string
  prerequisites:
    - string

H:
  steps:
    - id: string
      description: string
      input_fields: [string]
      output_fields: [string]
      tools_involved: [string]    # Must be in WA Registration

A:
  automation_possible: boolean
  automation_scope: full | partial | none
  requires_capabilities: [string]  # Must match WA Registration capabilities

T:
  validation_rules:
    - field: string
      rule: string
```

### 4.3 WHAT Constraints

- All tools in `H.steps.tools_involved` must exist in the executing WA's Registration
- All capabilities in `A.requires_capabilities` must exist in the executing WA's Registration
- `position_id` must reference an Active Position

---

## 5. ATC — Agentic Task Card

### 5.1 Purpose

An ATC is the structured, executable form of a WHAT. It is the work order passed from MA to WA.

```
WHAT → (MA processes) → ATC → (WA executes) → TaskRun
```

### 5.2 ATC Schema

```yaml
atc_id: string
position_id: string
what_id: string
version: integer

sla:
  response_time_minutes: integer
  retry_max: integer            # Default: 2

input_schema:
  field_name: type              # JSON schema for required inputs

output_schema:
  field_name: type              # JSON schema for required outputs

required_capabilities: [string] # Must match WA Registration
allowed_tools: [string]         # Must be subset of WA Registration tools

quality_gate:
  rules:
    - condition: string
      action: FAIL | WARN
  on_fail: retry | escalate | reject

on_failure_ipcp:
  intent: Error-Report
  to: {MA_POSITION_ID}
  payload_template:
    atc: string
    error: string
```

### 5.3 ATC Pre-flight Check (3-layer)

Before any WA executes an ATC, three checks must pass:

**Layer 1 — Capability check**
All `required_capabilities` must exist in the WA's Registration.
→ Failure: refuse, write deny log, send IPCP Error-Report to MA

**Layer 2 — Tool check**
All `allowed_tools` must exist in the WA's Registration tool list.
→ Failure: refuse, write deny log, send IPCP Error-Report to MA

**Layer 3 — ATC scope check**
The ATC ID must be in the WA's `permitted_atc_templates`.
→ Failure: refuse, write deny log, send IPCP Error-Report to MA

All three must pass. Partial passes are treated as failures.

---

## 6. Playbook

### 6.1 Purpose

A Playbook is a versioned collection of strategy bullets. It encodes learned organizational knowledge about how to execute tasks well.

```
Registration = hard constraints (what you CAN do)
Playbook     = soft strategy   (what you SHOULD do)
```

Playbooks evolve. They start as PILOT, get validated through real TaskRuns, and are promoted to SOTA by the Curator.

### 6.2 Playbook Bullet Schema

```yaml
bullet_id: string
bullet_type: E | R | Q | D     # Execution | Risk | Quality | Deprecate
target: MA | WA

condition: string               # Plain language trigger condition
action: string                  # Plain language response

source: success_pattern | failure_pattern | gap_pattern | manual
helpful_count: integer          # Times fired on successful TaskRun
harmful_count: integer          # Times fired on failed TaskRun

scope:
  positions: [string]           # Which positions this applies to
  scenarios: [string]           # Optional: specific scenarios
```

### 6.3 Playbook Version Lifecycle

```
Draft → Candidate → Pilot → SOTA → Legacy → Deprecated
```

| Status | Meaning |
|---|---|
| **Draft** | Generated by Reflector, not yet reviewed |
| **Candidate** | Human has reviewed, approved for piloting |
| **Pilot** | Running in controlled conditions |
| **SOTA** | Current best version, fully deployed |
| **Legacy** | Superseded by newer SOTA, kept for rollback |
| **Deprecated** | Harmful or invalid, never executed |

### 6.4 Playbook Constraints

- Playbook bullets cannot suggest actions that violate Registration
- Bullets suggesting unregistered tools → auto-rejected by Curator
- Bullets suggesting out-of-scope IPCP → auto-rejected by Curator
- Harmful bullets (harmful_count > helpful_count) → flagged for deprecation

---

## 7. MA Runtime

### 7.1 Lifecycle

```
INIT
  → LOAD_REGISTRATION
  → LOAD_PLAYBOOK (current SOTA)
  → READY

EVENT_LOOP
  → receive event (message | IPCP | cron | system)
  → DISPATCH (check Dispatcher)
  → if match: route to WA via ATC
  → if no match: MA handles directly
  → QUALITY_GATE (review WA output)
  → REFLECTION_TRIGGER (on completion)
```

### 7.2 MA Responsibilities

| Responsibility | Description |
|---|---|
| Task routing | Match incoming tasks to correct WA via Dispatcher |
| ATC creation | Generate structured task cards from WHAT templates |
| Quality oversight | Validate WA outputs against ATC T-section |
| IPCP management | Only legal entry point for cross-position communication |
| Registration governance | Only entity that can update WA Registrations |
| Curator authority | Approve/reject/modify Playbook candidates |
| SLA tracking | Monitor task completion against defined SLAs |

### 7.3 MA Quality Gate

The MA performs a second-level quality check on WA outputs:

```
WA completes ATC
  → WA self-gates (against ATC quality_gate rules)
  → WA sends result to MA
  → MA validates:
      - Did WA correctly execute quality gate?
      - Does output match ATC output_schema?
      - Are there persistent failure patterns?
  → MA decides: accept | request retry | escalate to human
```

---

## 8. WA Runtime

### 8.1 Lifecycle

```
INIT
  → LOAD_REGISTRATION
  → LOAD_PLAYBOOK (current SOTA)
  → READY

EXECUTE (when ATC received)
  → PRE-FLIGHT CHECK (3-layer)
  → APPLY PLAYBOOK BULLETS
  → EXECUTE STEPS (H section of WHAT)
  → NORMALIZE OUTPUT (match ATC output_schema)
  → QUALITY GATE (T section of ATC)
  → WRITE TASKRUN
  → NOTIFY MA (IPCP Notify-Status)
```

### 8.2 WA Execution Pipeline

**Step 1 — Pre-flight**
3-layer Registration check (capability, tool, ATC scope).

**Step 2 — Playbook load**
Load current SOTA Playbook. Identify relevant bullets for this task.

**Step 3 — Plan**
Generate execution plan using Playbook bullets + ATC input schema.

**Step 4 — Execute**
Call tools, process data. All tool calls must be in Registration.

**Step 5 — Normalize**
Convert output to ATC output_schema format. Fill nulls. Validate types.

**Step 6 — Quality gate**
Check output against ATC quality_gate rules. On FAIL: retry up to retry_max. On persistent FAIL: send IPCP Error-Report to MA.

**Step 7 — TaskRun**
Write complete audit record. Non-negotiable. Even failed ATCs get TaskRuns.

### 8.3 Runtime Constraints

WAs must enforce their Registration runtime_constraints:

```
max_parallel_tasks:      never exceed this concurrency
timeout_ms:              stop and report if exceeded
max_daily_atc_executions: report to MA when limit reached
```

---

## 9. IPCP — Inter-Position Communication Protocol

### 9.1 Purpose

IPCP is the structured communication protocol between Positions. It ensures all cross-agent communication is:
- Declared in advance (Registration)
- Typed by intent
- Traceable via correlation ID
- Auditable via IPCP log

### 9.2 IPCP Rules

1. **Only MAs can initiate IPCP.** WAs communicate through their MA.
2. **All IPCP intents must be declared** in both sender's and receiver's Registration.
3. **Every IPCP message gets a correlation ID** for end-to-end tracing.
4. **All IPCP messages are logged** to the IPCP audit log.

### 9.3 IPCP Message Format

```
[IPCP]
FROM: {position_id}
TO: {position_id}
INTENT: {intent_type}
CORRELATION_ID: {uuid}
PAYLOAD: {json}
```

### 9.4 Standard Intent Types

| Intent | Direction | Purpose |
|---|---|---|
| `Request-ATC` | MA → MA | Ask another position to execute a task |
| `Request-Data` | MA → MA | Ask another position for specific data |
| `Notify-Status` | Any → MA | Report task completion or status update |
| `Error-Report` | WA → MA, MA → MA | Report failure requiring attention |
| `Collaboration-Proposal` | MA → MA | Suggest joint workflow |

### 9.5 IPCP Validation

Before sending any IPCP message, the MA must verify:
1. The intent type is in `allowed_outbound_intents` (sender's Registration)
2. The target Position is in `collaboration_scope` (sender's Registration)
3. The target MA's Registration includes the intent in `accepted_intents`

Validation failure → message blocked, deny log entry written.

---

## 10. TaskRun

### 10.1 Purpose

A TaskRun is the immutable audit record of a single ATC execution. It is the foundation of the entire learning and governance system.

> No TaskRun = no learning = no governance.

Every ATC execution — successful or failed — produces exactly one TaskRun.

### 10.2 TaskRun Schema

```json
{
  "taskrun_id": "string (uuid)",
  "atc_id": "string",
  "position_id": "string",
  "wa_id": "string",
  "trigger": "cron | manual | ipcp | message",
  "input": {},
  "output": {},
  "tools_used": ["string"],
  "playbook_bullets_hit": ["bullet_id"],
  "preflight": "PASS | FAIL",
  "quality_gate": "PASS | FAIL",
  "quality_gate_reason": "string | null",
  "ipcp_sent": [],
  "token_estimate": "integer",
  "duration_ms": "integer",
  "error": "string | null",
  "timestamp": "ISO8601"
}
```

### 10.3 TaskRun Storage

TaskRuns are stored at:
```
{workspace}/taskruns/{position_id}/{YYYY-MM-DD}/{atc_id}-{uuid}.json
```

Retention: minimum 30 days (configurable). The Reflector requires at least 7 days of TaskRuns to generate meaningful candidates.

---

## 11. Reflector

### 11.1 Purpose

The Reflector mines TaskRuns to generate Playbook candidates. It is the automated learning engine of MAWA.

```
Input:  TaskRuns (7 days)
Output: Candidate Playbook bullets
```

The Reflector does not modify Playbooks. It only generates candidates for Curator review.

### 11.2 Pattern Types

| Pattern | Description | Output |
|---|---|---|
| Success pattern | Conditions that correlate with PASS outcomes | New execution bullet |
| Failure pattern | Conditions that correlate with FAIL outcomes | New risk bullet |
| Gap pattern | Successful tasks with no Playbook bullet match | New bullet candidate |
| IPCP pattern | Frequent error escalations | New risk or process bullet |
| Deprecation signal | Bullets with harmful_count > helpful_count | Deprecation recommendation |

### 11.3 Reflector Registration Filter

The Reflector must not generate candidates that:
- Reference tools not in the WA's Registration
- Suggest actions outside the WA's capability scope
- Recommend IPCP to positions not in collaboration_scope
- Propose Registration changes (only humans can change Registration)

Candidates failing this filter are discarded, not queued.

### 11.4 Candidate Schema

```json
{
  "candidate_id": "string",
  "position_id": "string",
  "bullet_type": "E | R | Q | D",
  "condition": "string",
  "action": "string",
  "source": "success_pattern | failure_pattern | gap_pattern | ipcp_pattern",
  "supporting_taskruns": ["taskrun_id"],
  "occurrence_count": "integer",
  "confidence": "high | medium | low",
  "registration_check": "PASS | FAIL",
  "proposed_bullet_text": "string"
}
```

---

## 12. Curator

### 12.1 Purpose

The Curator is a human-in-the-loop governance process that promotes Reflector candidates into official Playbook versions. It is the "legislative system" of MAWA.

```
Reflector output → Curator review → PlaybookVersion → WA Runtime
```

### 12.2 Curator Process

```
1. Load all unreviewed Reflector candidates
2. For each candidate:
   a. Present condition + action + evidence to human
   b. Human decides: Approve | Reject | Modify
   c. Check for conflicts with existing Playbook
   d. Check Registration boundaries (second pass)
3. Package approved bullets into new PlaybookVersion (status: Pilot)
4. Deploy to WA Runtime
5. After 2 weeks: evaluate via Reflector metrics
6. If metrics positive: promote to SOTA
7. Previous SOTA → Legacy
```

### 12.3 Curator Cannot

- Modify Registration (human-only, separate process)
- Publish bullets that violate Registration
- Bypass conflict detection
- Retroactively modify TaskRuns
- Auto-promote without human approval at the Candidate stage

---

## 13. Dispatcher

### 13.1 Purpose

The Dispatcher is the MA's routing engine. It automatically routes incoming tasks to the correct WA based on a single source-of-truth routing table.

```
Incoming message/event
  → Dispatcher reads DISPATCH_TABLE
  → Matches against rules (priority order)
  → Routes to WA via ATC
  → Or returns NO_MATCH for MA to handle directly
```

### 13.2 Dispatch Table Schema

```yaml
version: integer
last_updated: date
maintained_by: string

positions:
  - position_id: string
    trigger_channels: [string]     # Source channel IDs that route here
    trigger_keywords: [string]     # Keywords that match this position
    trigger_patterns: [string]     # Regex patterns (optional)
    default_atc: string            # ATC to execute on match
    time_constraints:
      active_hours: "HH:MM-HH:MM"
      active_days: "1-5"           # ISO weekday numbers
      timezone: "IANA timezone"
    priority: integer              # Lower = higher priority
```

### 13.3 Matching Priority

```
1. Explicit ATC ID in message (highest)
2. Keyword match against trigger_keywords
3. Channel match against trigger_channels
4. Pattern match against trigger_patterns
5. NO_MATCH → MA handles directly (lowest)
```

### 13.4 Dispatcher Output

On match:
```json
{
  "matched": true,
  "position_id": "string",
  "atc_id": "string",
  "confidence": "high | medium",
  "match_reason": "keyword | channel | pattern | explicit"
}
```

On no match:
```json
{
  "matched": false,
  "reason": "string",
  "suggested_action": "MA handles directly"
}
```

---

## 14. Security Model

### 14.1 Zero Trust Per Position

MAWA operates on a zero-trust model between positions:
- No WA trusts another WA by default
- No position trusts another position by default
- All cross-position communication requires explicit Registration authorization
- All actions are logged

### 14.2 Deny Log

Every Registration boundary violation must be logged:

```json
{
  "timestamp": "ISO8601",
  "position_id": "string",
  "requested_by": "string",
  "request_summary": "string",
  "violation_type": "data_domain | tool_unauthorized | atc_unauthorized | ipcp_scope | capability_exceeded",
  "registration_rule_violated": "string",
  "action_taken": "refused_with_explanation | refused_silently"
}
```

Deny logs are stored at: `{workspace}/audit/deny-logs/{YYYY-MM-DD}-deny.jsonl`

### 14.3 Security Layers

| Layer | Mechanism | Protects Against |
|---|---|---|
| Registration | Capability declaration | Agents doing unauthorized things |
| IPCP validation | Intent + scope check | Unauthorized cross-agent communication |
| ATC pre-flight | 3-layer check | Executing unauthorized tasks |
| Quality gate | Output validation | Delivering wrong results |
| TaskRun | Audit trail | Untracked actions |
| Deny log | Violation record | Silent boundary violations |

---

## 15. Compliance

### 15.1 MAWA Compliance Levels

**Level 1 — Basic Governance**
- Registration files exist for all agents
- ATCs defined for all regular tasks
- TaskRuns written after every execution
- Deny logs maintained

**Level 2 — Full Governance**
- Level 1 +
- Playbook v1 exists for all positions
- IPCP protocol in use for cross-agent communication
- Dispatcher routing operational
- 5-test validation suite passing

**Level 3 — Self-Improving**
- Level 2 +
- Reflector running on schedule
- Curator sessions completed at least monthly
- Playbooks at SOTA status (promoted from Pilot)
- Cost and security audit reports operational

### 15.2 The 5-Test Validation Suite

Every MAWA implementation must pass these tests to claim Level 2 compliance:

**Test 1 — Registration Boundary**
Ask a WA to perform an action outside its Registration → expect refusal + deny log entry

**Test 2 — ATC Execution + TaskRun**
Trigger an ATC → expect structured output matching schema + TaskRun written

**Test 3 — Quality Gate**
Submit input that should fail quality check → expect FAIL result + retry behavior

**Test 4 — IPCP**
Simulate escalation condition → expect correctly formatted IPCP message to MA

**Test 5 — Playbook Bullet**
Trigger a known Playbook condition → expect bullet to fire and be cited in TaskRun

---

## Appendix A: MAWA vs Other Frameworks

MAWA does not replace agent execution frameworks. It governs them.

| Concern | AutoGen/CrewAI/LangGraph | MAWA |
|---|---|---|
| How agents execute | ✅ Handles this | Delegates to framework |
| What agents are allowed to do | ❌ | ✅ Registration |
| Why a decision was made | ❌ | ✅ TaskRun + Playbook bullets |
| Who is responsible | ❌ | ✅ Position model |
| Learning from mistakes | ❌ | ✅ Reflector + Curator |

You can run AutoGen agents inside MAWA Positions. MAWA wraps the governance around them.

---

## Appendix B: Implementation Notes

When implementing MAWA on a specific platform:

1. **Registration** can be stored as YAML/Markdown files or a database. The key requirement is that it is loaded at agent initialization and cannot be overridden at runtime.

2. **TaskRuns** must be written to persistent storage. In-memory TaskRuns do not satisfy the audit requirement.

3. **Playbooks** can be stored as versioned Markdown files. The important property is immutability — published versions should not be edited, only superseded.

4. **IPCP** can be implemented over any messaging system. The protocol defines the message format and validation rules, not the transport.

5. **The Dispatcher** should be the first thing an MA calls when receiving any input. Routing logic should not be embedded in the MA's general prompt.

---

*MAWA Specification v0.1.0 — MIT License — github.com/Capsio-Michael/mawa*
