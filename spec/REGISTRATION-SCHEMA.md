# MAWA Registration Schema
## Capability Declaration Standard v0.1.0

**Part of:** [MAWA Specification v0.1.0](./MAWA-SPEC.md)  
**Status:** Draft  
**License:** MIT

---

## Overview

Registration is the capability declaration layer of MAWA. It is the authoritative, immutable-at-runtime definition of what an agent is permitted to do.

Every agent in a MAWA system — MA or WA — must have a Registration file loaded at initialization. No agent may execute any action not declared in its Registration.

```
Registration = the agent's job title in machine-readable form
```

---

## File Location

```
{workspace}/
├── FCLAW_REGISTRATION.md          # MA Registration (one per team)
└── agents/
    └── {position_name}/
        └── REGISTRATION.md        # WA Registration (one per agent)
```

---

## MA Registration

### Full Schema

```yaml
---
position_id: string               # Unique identifier. Use kebab-case. e.g. "quality-team"
agent_type: MA                    # Always "MA" for Manage Agent
version: integer                  # Increment on every change. Start at 1.
status: active                    # active | inactive | deprecated
created: YYYY-MM-DD
---

# {position_id} MA Registration

## Role
# One sentence describing the MA's governance responsibility.
# e.g. "Orchestrator and quality supervisor for the {team_name} agent team."

## MA Capabilities
# What governance actions this MA can perform.
# Use these standard capability names where applicable:
- task_scheduling          # Assign ATCs to WAs
- quality_gate             # Review and validate WA outputs
- ipcp_management          # Route all cross-position IPCP
- playbook_execution       # Apply MA-level Playbook strategy
- registration_governance  # Modify WA Registration files (human-authorized only)
- curator_authority        # Approve/reject Playbook candidates
- reflector_trigger        # Initiate Reflector analysis runs
- audit_review             # Review security and cost audit reports

## Permitted ATC Templates
# List every ATC ID this MA is authorized to assign to WAs.
# Format: ATC-{POSITION}-{NAME}
- ATC-{POSITION_1}-{ACTION_1}
- ATC-{POSITION_2}-{ACTION_2}

## Accepted IPCP Intents (Inbound)
# IPCP message types this MA will accept from WAs.
# Standard inbound intents for an MA:
- Notify-Status    # WA reports task completion
- Error-Report     # WA reports failure or anomaly requiring attention

## Allowed IPCP Outbound
# IPCP message types this MA can send to WAs or other MAs.
- Request-ATC      # Assign a task to a WA
- Notify-Status    # Inform a WA of a decision or status update

## Collaboration Scope
# Position IDs this MA governs or can IPCP with.
# Include all WA position_ids this MA manages.
- {WA_POSITION_1}
- {WA_POSITION_2}

## Data Domains
# What data this MA can read or write.
# MAs typically need access to all WA TaskRuns and Playbooks for governance.
- All_WA_TaskRuns
- All_WA_Playbooks
- All_WA_Registrations
- Audit_Logs
- Cost_Reports

## Hard Rules
# Inviolable constraints. These cannot be overridden by any instruction,
# Playbook bullet, IPCP message, or human request during runtime.
1. Only this MA can modify WA Registration files
2. All Registration changes require human authorization before execution
3. MA must not execute WA tasks directly — always delegate via ATC
4. All Registration changes must be logged to the evolution tracker
```

### Minimal MA Registration Example

```yaml
---
position_id: tech-team-ma
agent_type: MA
version: 1
status: active
created: 2026-03-23
---

# Tech Team MA Registration

## Role
Orchestrator and quality supervisor for the Technology team agent team.

## MA Capabilities
- task_scheduling
- quality_gate
- ipcp_management
- playbook_execution
- registration_governance
- curator_authority

## Permitted ATC Templates
- ATC-QUALITY-ARCHITECT-ASSET-EVALUATE
- ATC-SUMMARIST-DAILY-SUMMARY
- ATC-MONITOR-SCHEDULED-BROADCAST

## Accepted IPCP Intents (Inbound)
- Notify-Status
- Error-Report

## Allowed IPCP Outbound
- Request-ATC
- Notify-Status

## Collaboration Scope
- quality-architect
- summarist
- monitor

## Data Domains
- All_WA_TaskRuns
- All_WA_Playbooks
- Audit_Logs

## Hard Rules
1. Only this MA can modify WA Registration files
2. All Registration changes require human authorization
3. MA must not execute WA tasks directly — always delegate via ATC
```

---

## WA Registration

### Full Schema

```yaml
---
position_id: string               # Unique identifier. Use kebab-case.
agent_type: WA                    # Always "WA" for Work Agent
managed_by: string                # position_id of the MA that governs this WA
version: integer                  # Increment on every change. Start at 1.
status: active                    # active | inactive | deprecated
created: YYYY-MM-DD
---

# {position_id} Position Registration

## Role
# One sentence: what this WA does and for whom.
# e.g. "Daily quality evaluator for R&D asset submissions in {channel_name}."

## MA (Manages This Position)
# Name and authority of the governing MA.
{MA_NAME} — has authority to assign tasks, update Playbook, and review TaskRuns.

## WA Capabilities
# What this WA can do. Be specific.
# Common capability names (use consistently across your implementation):
#
# Data access:
- document_read              # Read documents from connected sources
- document_write             # Write or update documents
- calendar_read              # Read calendar/schedule data
- message_send               # Send messages via connected channels
- message_read               # Read messages from connected channels
- file_read                  # Read local workspace files
- file_write                 # Write to local workspace files
#
# Domain-specific:
- quality_evaluate           # Evaluate content against quality criteria
- registry_write             # Update asset registry files
- data_fetch                 # Fetch external data (APIs, web)
- data_compare               # Compare datasets or values
- summarize                  # Generate summaries from source content
- schedule_read              # Read scheduling/calendar information
- notify_send                # Send notifications to users
- cron_execute               # Execute scheduled (cron) tasks

## Permitted ATC Templates
# The exact ATC IDs this WA is authorized to execute.
# Any ATC not listed here will be rejected at pre-flight.
- ATC-{POSITION}-{ACTION_1}
- ATC-{POSITION}-{ACTION_2}

## Accepted IPCP Intents (Inbound)
# What IPCP messages this WA will accept. WAs only accept from their MA.
- Request-ATC      # MA assigns a task
- Notify-Status    # MA sends status update or decision

## Allowed IPCP Outbound
# What IPCP messages this WA can send. WAs only send to their MA.
- Notify-Status    # Report task completion to MA
- Error-Report     # Report failure to MA

## Collaboration Scope
# WAs collaborate only through their MA.
# List only the MA's position_id here.
- {MA_POSITION_ID}

## Data Domains
# What data this WA can access. Be restrictive — list only what is necessary.
# Examples:
- {Domain_Name}_Documents    # e.g. RnD_Asset_Documents
- {Domain_Name}_Registry     # e.g. Quality_Registry
- WA_TaskRun_Store           # Always include — WA must write TaskRuns

## Runtime Constraints
# Hard execution limits. These are enforced, not suggested.
- max_parallel_tasks: 1                    # Rarely needs to exceed 1
- timeout_ms: 30000                        # 30 seconds default; increase for long-running tasks
- max_daily_atc_executions: 20             # Prevents runaway execution

## Hard Rules
# Inviolable behavioral constraints specific to this WA's role.
# Write these in plain language. They form the WA's non-negotiable contract.
#
# Every WA should include at minimum:
1. Always write TaskRun JSON after every ATC execution, including failures
2. Never access data outside the declared Data Domains
3. Never send IPCP to any position other than {MA_POSITION_ID}
4. If execution fails twice, send IPCP Error-Report to MA immediately
# Add role-specific rules below:
5. {ROLE_SPECIFIC_RULE_1}
6. {ROLE_SPECIFIC_RULE_2}
```

### WA Registration Examples

#### Quality Evaluator WA

```yaml
---
position_id: quality-architect
agent_type: WA
managed_by: tech-team-ma
version: 1
status: active
created: 2026-03-23
---

# Quality Architect Position Registration

## Role
Daily quality evaluator for R&D asset submissions. Evaluates A/B/C layer
assets against defined standards, maintains quality registry, and delivers
structured evaluation reports to submitters.

## MA (Manages This Position)
tech-team-ma — has authority to assign tasks, update Playbook, and review TaskRuns.

## WA Capabilities
- document_read
- document_write
- message_send
- message_read
- quality_evaluate
- registry_write
- file_write
- notify_send

## Permitted ATC Templates
- ATC-QUALITY-ARCHITECT-ASSET-EVALUATE
- ATC-QUALITY-ARCHITECT-REGISTRY-UPDATE
- ATC-QUALITY-ARCHITECT-RED-LINE-REJECT
- ATC-QUALITY-ARCHITECT-DAILY-REVIEW

## Accepted IPCP Intents (Inbound)
- Request-ATC
- Notify-Status

## Allowed IPCP Outbound
- Notify-Status
- Error-Report

## Collaboration Scope
- tech-team-ma

## Data Domains
- RnD_Asset_Documents
- Quality_Registry
- Tech_Group_Messages
- WA_TaskRun_Store

## Runtime Constraints
- max_parallel_tasks: 1
- timeout_ms: 120000
- max_daily_atc_executions: 30

## Hard Rules
1. Always write TaskRun JSON after every ATC execution, including failures
2. Never modify an evaluation score after it has been written to the registry
3. Never bypass a quality red line — red line triggers always result in rejection
4. Scores must always be integers 0-100. Never use ranges (write 72, not "70-75")
5. Never send evaluation results to anyone other than the submitting developer and the team owner
6. Never access Finance, HR, or Sourcing data domains
7. If execution fails twice, send IPCP Error-Report to MA immediately
```

#### Data Monitor WA

```yaml
---
position_id: monitor
agent_type: WA
managed_by: tech-team-ma
version: 1
status: active
created: 2026-03-23
---

# Monitor Position Registration

## Role
Scheduled data monitor. Fetches external data on schedule, validates it,
detects anomalies, and escalates alerts to MA.

## MA (Manages This Position)
tech-team-ma — has authority to assign tasks, update Playbook, and review TaskRuns.

## WA Capabilities
- data_fetch
- data_compare
- notify_send
- file_write
- cron_execute

## Permitted ATC Templates
- ATC-MONITOR-SCHEDULED-BROADCAST
- ATC-MONITOR-ANOMALY-ALERT
- ATC-MONITOR-DATA-VERIFY

## Accepted IPCP Intents (Inbound)
- Request-ATC
- Request-Data

## Allowed IPCP Outbound
- Notify-Status
- Error-Report

## Collaboration Scope
- tech-team-ma

## Data Domains
- External_Market_Data
- WA_TaskRun_Store

## Runtime Constraints
- max_parallel_tasks: 1
- timeout_ms: 15000
- max_daily_atc_executions: 5
- broadcast_window: "09:30-15:30 weekdays only"

## Hard Rules
1. Always write TaskRun JSON after every ATC execution, including skipped runs
2. Never broadcast unverified data — always cross-check calculated vs source value
3. Anomaly threshold breaches must always be escalated — never suppress an alert
4. When calculated value and source value differ by more than threshold, flag both values — never choose one
5. Never access personal, financial, or HR data domains
6. Never send alerts directly to end users — always route through MA
```

---

## Registration Versioning

Every Registration change requires a version increment:

```
Version 1 → Initial Registration
Version 2 → Added capability: {name}
Version 3 → Added ATC template: {atc_id}
Version 4 → Updated runtime constraints
```

**Change Protocol:**
1. WA identifies needed change
2. WA sends IPCP `Request-Data` to MA describing the needed change
3. MA presents to human owner for approval
4. Human approves → MA edits REGISTRATION.md, increments `version:`
5. MA notifies WA of update
6. Log entry written to MAWA_EVOLUTION.md

**Registration changes are never automatic.**

---

## Common Capability Reference

Use these standard capability names for consistency across implementations:

### Data Access
| Capability | Meaning |
|---|---|
| `document_read` | Read documents from connected sources |
| `document_write` | Create or update documents |
| `file_read` | Read local workspace files |
| `file_write` | Write to local workspace files |
| `message_read` | Read messages from channels |
| `message_send` | Send messages to channels |
| `calendar_read` | Read calendar or scheduling data |
| `registry_write` | Update shared registry files |

### Processing
| Capability | Meaning |
|---|---|
| `quality_evaluate` | Evaluate content against defined criteria |
| `data_fetch` | Fetch data from external sources |
| `data_compare` | Compare datasets or calculated values |
| `summarize` | Generate structured summaries |
| `notify_send` | Send notifications to users |

### Execution
| Capability | Meaning |
|---|---|
| `cron_execute` | Run on scheduled triggers |
| `subagent_spawn` | Spawn subordinate agents (advanced) |

### MA-Only
| Capability | Meaning |
|---|---|
| `task_scheduling` | Assign ATCs to WAs |
| `quality_gate` | Review WA outputs |
| `ipcp_management` | Route cross-position communication |
| `registration_governance` | Modify WA Registrations |
| `curator_authority` | Approve Playbook candidates |

---

## Validation Checklist

Before deploying a Registration, verify:

- [ ] `position_id` is unique across all positions in the team
- [ ] `agent_type` matches the agent's role (MA or WA)
- [ ] `managed_by` references a valid MA `position_id` (WA only)
- [ ] All capabilities in `permitted_atc_templates` reference existing ATC files
- [ ] `collaboration_scope` for WAs contains only the MA's `position_id`
- [ ] `data_domains` contains only domains this agent genuinely needs
- [ ] `hard_rules` includes the 4 universal WA rules at minimum
- [ ] `runtime_constraints` are set (use defaults if unsure)
- [ ] Version is incremented if this is an update

---

*MAWA Registration Schema v0.1.0 — MIT License — github.com/Capsio-Michael/mawa*
