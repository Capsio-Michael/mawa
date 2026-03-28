---
what_id: WHAT-{POSITION_ID}-{TASK_NAME}
position_id: {POSITION_ID}
version: 1
---

# WHAT: {Task Human-Readable Name}

## W — Work (What is this task?)
{One paragraph describing the task.
Business intent: what does completing this task give to the owner or team?
Who requests it? How often? Why does it matter?}

## H — How (Execution steps)
1. {Step 1 — where does the data come from?}
2. {Step 2 — how is it processed or transformed?}
3. {Step 3 — what is the output format?}
4. {Step 4 — where is the output delivered?}
5. {Step 5 — who is notified, and how?}

## A — Automation
- Automation scope: FULL | PARTIAL | HUMAN_IN_LOOP
- Trigger: {cron schedule | event trigger | manual}
- Tools required: {tool_1}, {tool_2}, file_write

## T — Test (Quality Validation)
- {Criterion 1 — e.g., output field X must not be null}
- {Criterion 2 — e.g., at least one item found, OR output explicitly states "none found"}
- {Criterion 3 — e.g., notification must be sent within 2 minutes of output generation}
- On FAIL: retry once. On second FAIL: IPCP Error-Report to {MA_NAME}.
