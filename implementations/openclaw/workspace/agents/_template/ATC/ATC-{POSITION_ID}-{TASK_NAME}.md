---
atc_id: ATC-{POSITION_ID}-{TASK_NAME}
position_id: {POSITION_ID}
what_id: WHAT-{POSITION_ID}-{TASK_NAME}
version: 1
sla_minutes: {integer}
retry_max: 1
---

# ATC: {Task Human-Readable Name}

## W — Work (What is this task?)
{One paragraph describing what this task does and why it exists.
Include the business intent: what problem does completing this task solve?}

## Input Schema
```json
{
  "taskrun_id": "string",
  "field_1": "type — description",
  "field_2": "type — description",
  "trigger": "manual | cron | ipcp"
}
```

## H — How (Execution steps)
1. {Step 1 — specific action}
2. {Step 2 — specific action}
3. {Step 3 — specific action}
4. Validate output against T (Test) section below
5. If quality_gate = PASS → deliver output
6. If quality_gate = FAIL → retry once → if still FAIL → IPCP Error-Report to {MA_NAME}

## A — Automation
- Automation scope: FULL | PARTIAL | HUMAN_IN_LOOP
- Trigger: {cron schedule (e.g., daily 09:00) | event (e.g., new message in group) | manual}
- Tools required: {tool_1}, {tool_2}, file_write

## Output Schema
```json
{
  "taskrun_id": "string",
  "result": "PASS | FAIL",
  "quality_gate": "PASS | FAIL",
  "field_1": "type — description",
  "field_2": "type — description",
  "completed_at": "ISO8601"
}
```

## Quality Gate Rules
- quality_gate = FAIL if any required output field is null or missing
- quality_gate = FAIL if {domain-specific impossibility — e.g., result = PASS but score < 60}
- On quality_gate FAIL: do NOT deliver output. Retry once. On second FAIL: IPCP Error-Report to {MA_NAME}.

## Output Delivery
Send output to:
1. {Where to deliver — e.g., the channel/thread where the task was submitted}
2. {Optional: owner DM if applicable}

```
{Optional: human-readable output format template}
```
