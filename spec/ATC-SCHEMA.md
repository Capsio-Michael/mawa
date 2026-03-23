# MAWA ATC Schema
## Agentic Task Card Standard v0.1.0

**Part of:** [MAWA Specification v0.1.0](./MAWA-SPEC.md)  
**Status:** Draft  
**License:** MIT

---

## Overview

An ATC (Agentic Task Card) is the structured, executable work order in MAWA. It is the bridge between human task intent (WHAT) and automated execution (WA Runtime).

```
Human intent → WHAT → (MA processes) → ATC → (WA executes) → TaskRun
```

Every repeatable task in a MAWA system should have an ATC. If a task has no ATC, it cannot be governed, audited, or learned from.

---

## The WHAT → ATC Relationship

Before writing an ATC, write the WHAT. The WHAT captures task intent in human terms. The ATC translates that intent into a machine-executable contract.

```
WHAT.W  →  ATC name and business context
WHAT.H  →  ATC execution steps (implicit in the WA's Playbook)
WHAT.A  →  ATC required_capabilities and allowed_tools
WHAT.T  →  ATC quality_gate rules
```

See [WHAT-MODEL.md](./WHAT-MODEL.md) for the full WHAT specification.

---

## File Location

```
{workspace}/agents/{position_name}/ATC/
├── ATC-{POSITION}-{ACTION}.md     # One file per ATC
└── ATC-{POSITION}-{ACTION-2}.md
```

**Naming convention:** `ATC-{POSITION_ID_UPPERCASE}-{ACTION_UPPERCASE}`

Examples:
- `ATC-QUALITY-ARCHITECT-ASSET-EVALUATE.md`
- `ATC-SUMMARIST-DAILY-SUMMARY.md`
- `ATC-MONITOR-ANOMALY-ALERT.md`

---

## ATC Full Schema

```yaml
---
atc_id: string               # Must match filename. e.g. ATC-QUALITY-ARCHITECT-ASSET-EVALUATE
position_id: string          # Must match the WA's position_id
what_id: string              # References the WHAT file this ATC implements
version: integer             # Increment on every change. Start at 1.
sla_minutes: integer         # Maximum allowed execution time
retry_max: integer           # How many times to retry on failure. Default: 2
---

# ATC: {Human-readable task name}

## Input Schema
# Define all required inputs using JSON schema types:
# string, integer, float, boolean, array, object, ISO8601 (for dates/times)
```json
{
  "field_name": "type — description",
  "field_name_2": "type — description"
}
```

## Output Schema
# Define all required outputs. WA must produce all fields.
# Incomplete output = quality_gate FAIL.
```json
{
  "taskrun_id": "string — unique ID for this execution",
  "field_name": "type — description",
  "quality_gate": "PASS | FAIL",
  "quality_gate_reason": "string | null"
}
```

## Required Capabilities
# Must be a subset of the executing WA's Registration capabilities.
# Pre-flight Layer 1 checks this list.
- {capability_name}

## Allowed Tools
# Must be a subset of the executing WA's Registration tools.
# Pre-flight Layer 2 checks this list.
- {tool_name}

## Quality Gate Rules
# Conditions that cause quality_gate = FAIL.
# On FAIL: retry up to retry_max times.
# On persistent FAIL: send IPCP Error-Report to MA.
- FAIL if: {condition_1}
- FAIL if: {condition_2}
- WARN if: {condition_3}   # Warning only — does not block output

## On Persistent Failure (IPCP)
# Message sent to MA when retry_max is exceeded.
```
[IPCP]
FROM: {position_id}
TO: {ma_position_id}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "{atc_id}", "error": "{reason}", "attempts": {retry_max}}
```
```

---

## ATC Examples

### Example 1: Quality Evaluation ATC

```yaml
---
atc_id: ATC-QUALITY-ARCHITECT-ASSET-EVALUATE
position_id: quality-architect
what_id: WHAT-QUALITY-ARCHITECT-DAILY-REVIEW
version: 1
sla_minutes: 30
retry_max: 1
---

# ATC: Asset Quality Evaluation

## Input Schema
```json
{
  "taskrun_id": "string — unique ID for this execution",
  "asset_doc_url": "string — URL of the asset document to evaluate",
  "asset_layer": "string — A | B | C",
  "submitted_by": "string — name of the developer who submitted",
  "submission_time": "ISO8601 — when the asset was submitted",
  "trigger": "string — group_message | manual | cron"
}
```

## Output Schema
```json
{
  "taskrun_id": "string",
  "asset_doc_url": "string",
  "asset_layer": "string",
  "asset_code": "string | null",
  "submitted_by": "string",
  "score": "integer — 0 to 100",
  "red_line_triggered": "boolean",
  "red_line_reason": "string | null",
  "result": "PASS | FAIL",
  "dimension_scores": {
    "code_format": "integer — 0 to 20",
    "completeness": "integer — 0 to 30",
    "structure_quality": "integer — 0 to 30",
    "traceability": "integer — 0 to 20"
  },
  "improvement_suggestions": ["string"],
  "quality_gate": "PASS | FAIL",
  "evaluated_at": "ISO8601"
}
```

## Required Capabilities
- document_read
- quality_evaluate
- message_send
- registry_write
- file_write

## Allowed Tools
- {document_reader_tool}
- {message_tool}
- {file_tool}

## Quality Gate Rules
- FAIL if: score field is not an integer
- FAIL if: red_line_triggered = true AND result = PASS
- FAIL if: result = PASS AND score < 60
- FAIL if: asset_doc_url is null or inaccessible
- FAIL if: quality_gate = FAIL but output was sent to developer

## On Persistent Failure (IPCP)
```
[IPCP]
FROM: quality-architect
TO: {ma_position_id}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "ATC-QUALITY-ARCHITECT-ASSET-EVALUATE", "error": "{reason}", "attempts": 1}
```
```

---

### Example 2: Daily Summary ATC

```yaml
---
atc_id: ATC-SUMMARIST-DAILY-SUMMARY
position_id: summarist
what_id: WHAT-SUMMARIST-DAILY-SUMMARY
version: 1
sla_minutes: 15
retry_max: 2
---

# ATC: Daily Work Summary

## Input Schema
```json
{
  "date": "YYYY-MM-DD — date to summarize",
  "trigger": "string — cron | manual"
}
```

## Output Schema
```json
{
  "taskrun_id": "string",
  "date": "YYYY-MM-DD",
  "meetings_found": "integer",
  "meetings": [
    {
      "title": "string",
      "time": "string",
      "participants": ["string"],
      "core_topics": ["string"],
      "decisions": ["string"],
      "action_items": [
        {
          "item": "string",
          "owner": "string | null",
          "deadline": "string | null"
        }
      ],
      "original_link": "string — source document URL"
    }
  ],
  "cross_meeting_insights": ["string"],
  "tomorrows_actions": ["string"],
  "doc_url": "string — URL of generated summary document",
  "local_file_path": "string",
  "notification_sent": "boolean",
  "quality_gate": "PASS | FAIL",
  "quality_gate_reason": "string | null"
}
```

## Required Capabilities
- message_read
- document_write
- file_write
- notify_send

## Allowed Tools
- {message_reader_tool}
- {document_tool}
- {file_tool}
- {notification_tool}

## Quality Gate Rules
- FAIL if: any meeting entry has null original_link
- FAIL if: meetings_found > 0 but meetings array is empty
- FAIL if: doc_url is null after successful execution
- FAIL if: notification_sent = false after SLA window

## On Persistent Failure (IPCP)
```
[IPCP]
FROM: summarist
TO: {ma_position_id}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "ATC-SUMMARIST-DAILY-SUMMARY", "date": "{date}", "error": "{reason}"}
```
```

---

### Example 3: Anomaly Alert ATC

```yaml
---
atc_id: ATC-MONITOR-ANOMALY-ALERT
position_id: monitor
what_id: WHAT-MONITOR-SCHEDULED-BROADCAST
version: 1
sla_minutes: 2
retry_max: 1
---

# ATC: Anomaly Alert

## Trigger Condition
This ATC is triggered automatically when a monitored metric
exceeds the anomaly threshold. It cannot be suppressed.

## Input Schema
```json
{
  "taskrun_id": "string",
  "metric_name": "string — name of the monitored metric",
  "metric_code": "string — identifier code",
  "current_value": "float",
  "change_pct": "float — percentage change",
  "direction": "string — increase | decrease",
  "threshold_pct": "float — the threshold that was exceeded",
  "broadcast_time": "ISO8601"
}
```

## Output Schema
```json
{
  "taskrun_id": "string",
  "alert_sent": "boolean",
  "alert_target": "string — who received the alert",
  "metric_name": "string",
  "change_pct": "float",
  "direction": "string",
  "quality_gate": "PASS | FAIL"
}
```

## Required Capabilities
- notify_send
- file_write

## Allowed Tools
- {notification_tool}
- {file_tool}

## Quality Gate Rules
- FAIL if: alert_sent = false
- FAIL if: alert was sent directly to end user instead of MA

## Hard Rule
This ATC cannot be skipped or delayed. Any threshold breach
must trigger this ATC immediately regardless of time of day,
day of week, or other conditions.

## On Persistent Failure (IPCP)
```
[IPCP]
FROM: monitor
TO: {ma_position_id}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "ATC-MONITOR-ANOMALY-ALERT", "metric": "{metric_name}", "error": "{reason}"}
```
```

---

## Blank Template

Copy this to create a new ATC:

```yaml
---
atc_id: ATC-{POSITION}-{ACTION}
position_id: {position_id}
what_id: WHAT-{POSITION}-{ACTION}
version: 1
sla_minutes: 15
retry_max: 2
---

# ATC: {Human-readable task name}

## Input Schema
```json
{
  "taskrun_id": "string",
  "trigger": "string — cron | manual | message | ipcp"
}
```

## Output Schema
```json
{
  "taskrun_id": "string",
  "quality_gate": "PASS | FAIL",
  "quality_gate_reason": "string | null"
}
```

## Required Capabilities
- {capability_1}

## Allowed Tools
- {tool_1}

## Quality Gate Rules
- FAIL if: {condition}

## On Persistent Failure (IPCP)
```
[IPCP]
FROM: {position_id}
TO: {ma_position_id}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "ATC-{POSITION}-{ACTION}", "error": "{reason}"}
```
```

---

## ATC Design Principles

**1. Every output field is required**
If a field appears in the output schema, the WA must produce it. Null is acceptable only where explicitly marked `| null`. Missing fields = quality_gate FAIL.

**2. taskrun_id is always in both input and output**
The taskrun_id threads through the entire execution, linking the ATC invocation to the TaskRun record.

**3. quality_gate is always the last output field**
The WA self-evaluates before returning. The MA may apply a second-level gate. Both results are in the TaskRun.

**4. Failure is first-class**
Failed ATCs are not errors to be hidden. They are valuable data for the Reflector. Always write the TaskRun. Always send the IPCP Error-Report.

**5. SLA is a commitment, not a target**
If `sla_minutes` is set to 15, the WA must report SLA risk before exceeding it. The MA tracks SLA compliance across all ATCs.

**6. Tools are declared, not discovered**
The `allowed_tools` list in an ATC must exactly match what is used in execution. If a new tool is needed, update the ATC and the WA Registration — do not use an undeclared tool.

---

## ATC Validation Checklist

Before deploying an ATC, verify:

- [ ] `atc_id` matches the filename exactly
- [ ] `position_id` matches the WA's Registration `position_id`
- [ ] `what_id` references an existing WHAT file
- [ ] All `required_capabilities` exist in the WA's Registration
- [ ] All `allowed_tools` exist in the WA's Registration
- [ ] `output_schema` includes `taskrun_id`, `quality_gate`, and `quality_gate_reason`
- [ ] At least one `quality_gate` rule is defined
- [ ] `on_persistent_failure` IPCP block is complete
- [ ] `sla_minutes` is set realistically (test before setting)

---

*MAWA ATC Schema v0.1.0 — MIT License — github.com/Capsio-Michael/mawa*
