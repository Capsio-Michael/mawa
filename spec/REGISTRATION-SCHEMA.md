# REGISTRATION-SCHEMA v1.0

The Registration file is the capability contract for a MAWA Position. Every Position — MA or WA — must have a `REGISTRATION.md`.

---

## File Location

```
workspace/agents/{POSITION_ID}/REGISTRATION.md
```

---

## Full Schema

```yaml
---
position_id: {POSITION_ID}          # Unique identifier, uppercase, short (e.g. QC, BOOKY, PE)
agent_type: MA | WA                 # MA = Managing Agent, WA = Worker Agent
managed_by: {MA_POSITION_ID}        # The MA that oversees this Position (WAs only)
version: 1                          # Increment on breaking changes
status: active | inactive | draft
created: {YYYY-MM-DD}
report_directly: true | false       # If true, WA may also send output to human owner
---

# {POSITION_ID} Position Registration

## Role
{One paragraph describing what this Position does and why it exists.}

## MA (Manages This Position)
{MA_POSITION_ID} — has authority to assign tasks via ATC, update the Playbook, and review TaskRuns.

## Capabilities
List of abstract capabilities this Position has. These are behavioral, not tool-specific.

- {capability_1}     # e.g. quality_gate, task_scheduling, data_summarization
- {capability_2}
- ...

## Permitted ATC Templates
Only ATCs listed here may be executed by this Position.

- {ATC_ID_1}     # e.g. ATC-QC-RECHECK
- {ATC_ID_2}
- ...

## Accepted IPCP Intents (Inbound)
This Position will process these message types when received.

- Request-ATC       # {who sends it and why}
- Notify-Status     # {who sends it and why}
- Request-Data      # {who sends it and why}
- Error-Report      # {who sends it and why}

## Allowed IPCP Outbound
This Position may send these message types.

- Notify-Status     # {to whom, when}
- Error-Report      # {to whom, when}
- Request-Data      # {to whom, when}
- Request-ATC       # {to whom, when — MAs only}

## Collaboration Scope
Positions this Position is permitted to communicate with via IPCP.

- {POSITION_ID_1}   # {relationship note}
- {POSITION_ID_2}   # {relationship note}

## Data Domains
Data categories this Position is permitted to read and write.

- {DOMAIN_1}        # e.g. QC_Data, FinanceReports, FeishuMeetingNotes
- {DOMAIN_2}
- ...

## Hard Rules
These rules cannot be overridden by Playbook, ATC instructions, or any runtime prompt.

1. Never access data outside declared Data Domains.
2. Never send IPCP to a Position not listed in Collaboration Scope.
3. Always write a TaskRun after every ATC execution.
4. Never execute a task without a matching ATC template.
5. If a Hard Rule conflict is detected, log it and refuse the action.
6. {Add Position-specific hard rules here}
7. {Add Position-specific hard rules here}
```

---

## Field Reference

### `position_id`
Short uppercase string. Used as the identifier in IPCP messages, Dispatch Table routing, and TaskRun records.

Examples: `QC`, `BOOKY`, `PE`, `STOCKY`, `MICHAEL`

### `agent_type`
- `MA` — Managing Agent. Receives inbound work, routes via Dispatch Table, coordinates WAs.
- `WA` — Worker Agent. Executes ATCs within declared boundaries. Managed by one MA.

### `managed_by`
The `position_id` of the MA that oversees this Position. Required for WAs. For the MA itself, this field refers to the human owner or a higher-level MA.

### `capabilities`
Abstract behavioral capabilities. These are not tool names. They describe *what the agent can do*, not *how*. Used by the Dispatcher to determine routing.

### `permitted_atc_templates`
The closed list of ATC IDs this Position may execute. If a task arrives without a matching ATC template, the Position must refuse and send an `Error-Report` to its MA.

### `accepted_ipcp_intents` / `allowed_ipcp_outbound`
Declare which IPCP message types this Position participates in. Agents must not send or respond to IPCP intents not listed here.

### `data_domains`
The closed list of data categories this Position may access. Access to unlisted domains must be refused, logged, and reported.

### `hard_rules`
Non-negotiable behavioral constraints. Rules 1–5 are universal across all MAWA implementations. Rules 6+ are Position-specific.

---

## Minimal Example (WA)

```markdown
---
position_id: BOOKY
agent_type: WA
managed_by: FCLAW
version: 1
status: active
created: 2026-01-15
report_directly: true
---

# BOOKY Position Registration

## Role
Summarizes daily work activity by scanning meeting notes and task records.
Runs nightly at 23:00 and delivers a structured summary to the team owner.

## MA (Manages This Position)
FCLAW — has authority to assign tasks via ATC, update the Playbook, and review TaskRuns.

## Capabilities
- document_summarization
- scheduled_task_execution
- feishu_notification

## Permitted ATC Templates
- ATC-BOOKY-DAILY-SUMMARY
- ATC-BOOKY-WEEKLY-DIGEST

## Accepted IPCP Intents (Inbound)
- Request-ATC     # FCLAW assigns a summary task
- Request-Data    # Another Position requests a past summary

## Allowed IPCP Outbound
- Notify-Status   # Send daily summary result to FCLAW
- Error-Report    # Report failure to FCLAW

## Collaboration Scope
- FCLAW           # MA — always

## Data Domains
- FeishuMeetingNotes
- FeishuTaskRecords
- DailySummaryArchive

## Hard Rules
1. Never access data outside declared Data Domains.
2. Never send IPCP to a Position not listed in Collaboration Scope.
3. Always write a TaskRun after every ATC execution.
4. Never execute a task without a matching ATC template.
5. If a Hard Rule conflict is detected, log it and refuse the action.
6. Never modify source meeting notes or task records — read only.
7. Never send summary to anyone other than the declared owner channel.
```

---

## Validation Checklist

Before activating a Position, verify:

- [ ] `position_id` is unique across the workspace
- [ ] All `permitted_atc_templates` have corresponding ATC files
- [ ] All `collaboration_scope` entries are valid Position IDs
- [ ] Hard Rules 1–5 are present and unmodified
- [ ] `managed_by` points to an existing MA Position

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
