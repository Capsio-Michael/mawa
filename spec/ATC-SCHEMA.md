# ATC-SCHEMA v1.0

An ATC (Agent Task Card) is the task specification unit in MAWA. Every task executed by a MAWA agent must have a corresponding ATC template. No ATC = no execution.

---

## File Location

```
workspace/agents/{POSITION_ID}/ATC/ATC-{POSITION_ID}-{TASK_NAME}.md
```

---

## Full Schema

```yaml
---
atc_id: ATC-{POSITION_ID}-{TASK_NAME}   # Unique identifier, uppercase
position_id: {POSITION_ID}               # Owner position
what_id: WHAT-{POSITION_ID}-{TASK_NAME} # Reference to WHAT file (optional for simple ATCs)
version: 1                               # Increment on breaking changes
sla_minutes: {integer}                   # Max allowed execution time
retry_max: {integer}                     # Max retries before Error-Report (default: 1)
---
```

---

## Four-Section Structure (W-H-A-T)

Every ATC contains four sections:

### W — Work
What this task is and why it exists.

```markdown
## W — Work (What is this task?)
{One paragraph describing the task and its business intent.}
```

### H — How
Step-by-step execution instructions. These are the default path — Playbook bullets may override specific steps.

```markdown
## H — How (Execution steps)
1. {Step 1}
2. {Step 2}
3. ...
```

### A — Automation
Trigger conditions and tool requirements.

```markdown
## A — Automation
- Automation scope: FULL | PARTIAL | HUMAN_IN_LOOP
- Trigger: {cron schedule | event | manual}
- Tools required: {comma-separated list of tool names}
```

### T — Test (Quality Gate)
Acceptance criteria. The agent must validate its own output against these criteria before delivery. If any criterion fails, quality_gate = FAIL.

```markdown
## T — Test (Quality Validation)
- {criterion 1}
- {criterion 2}
- On FAIL: {retry | IPCP Error-Report to {MA_NAME} | both}
```

---

## Input / Output Schema

For ATCs that process structured data, declare explicit schemas:

```markdown
## Input Schema
\`\`\`json
{
  "taskrun_id": "string",
  "field_1": "type",
  "field_2": "type"
}
\`\`\`

## Output Schema
\`\`\`json
{
  "taskrun_id": "string",
  "result": "PASS | FAIL",
  "quality_gate": "PASS | FAIL",
  "field_1": "type"
}
\`\`\`
```

Every output schema must include `quality_gate: "PASS | FAIL"`.

---

## Quality Gate Rules

The Quality Gate is the agent's self-check before output delivery. Rules:

- quality_gate = FAIL if any required output field is null or missing
- quality_gate = FAIL if result = PASS but score < passing threshold
- quality_gate = FAIL if an impossible state is detected (e.g., red_line_triggered = true AND result = PASS)
- On quality_gate FAIL: do NOT deliver output. Follow the On FAIL instruction in the T section.

---

## TaskRun Requirement

Every ATC execution — including failures — must produce a TaskRun JSON written to:
```
{WORKSPACE}/taskruns/{position_id}/{YYYY-MM-DD}/ATC-{POSITION_ID}-{uuid}.json
```

Minimum TaskRun fields:
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
  "duration_ms": "integer",
  "token_estimate": "integer",
  "timestamp": "ISO8601"
}
```

---

## Minimal Example

```markdown
---
atc_id: ATC-BOOKY-DAILY-SUMMARY
position_id: BOOKY
what_id: WHAT-BOOKY-DAILY-SUMMARY
version: 1
sla_minutes: 15
retry_max: 2
---

# ATC: Daily Summary

## W — Work
Compile all meeting notes from today into a structured daily summary.
Business intent: give the owner a single reliable daily record without manual effort.

## H — How
1. Scan messaging platform for meeting notes posted today
2. For each meeting, extract: title, participants, decisions, action items, original link
3. Write summary to cloud doc and local file
4. Send notification to owner

## A — Automation
- Automation scope: FULL
- Trigger: cron (daily 23:00)
- Tools required: messaging_read, doc_create, notify, file_write

## T — Test
- Every meeting entry must include original_link (not null)
- At least one meeting found OR output explicitly states "no meetings today"
- Notification must be sent within 2 minutes of summary generation
- On FAIL: retry once. On second FAIL: IPCP Error-Report to {MA_NAME}
```

---

## ATC ID Naming Convention

```
ATC-{POSITION_ID}-{TASK_NAME}
```

- `POSITION_ID` — uppercase position identifier (e.g., BOOKY, QC, STOCKY)
- `TASK_NAME` — uppercase hyphenated task name (e.g., DAILY-SUMMARY, ASSET-EVALUATE)

Examples: `ATC-BOOKY-DAILY-SUMMARY`, `ATC-QC-ASSET-EVALUATE`, `ATC-STOCKY-ANOMALY-ALERT`

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
