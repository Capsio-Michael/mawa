---
atc_id: ATC-{POSITION_ID}-DAILY-SUMMARY
position_id: {POSITION_NAME}
what_id: WHAT-{POSITION_ID}-DAILY-SUMMARY
version: 1
sla_minutes: 15
retry_max: 2
---

# ATC: Daily Summary Task Card

## Input Schema
```json
{
 "date": "YYYY-MM-DD",
 "trigger": "cron | manual",
 "requested_by": "string"
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
 {"item": "string", "owner": "string", "deadline": "string | null"}
 ],
 "original_link": "string ({CHANNEL_NAME} URL)"
 }
 ],
 "cross_meeting_insights": ["string"],
 "tomorrows_actions": ["string"],
 "doc_url": "string",
 "local_file_path": "string",
 "notification_sent": "boolean",
 "quality_gate": "PASS | FAIL",
 "quality_gate_reason": "string | null"
}
```

## Quality Gate Rules
- quality_gate = FAIL if: any meeting has null original_link
- quality_gate = FAIL if: meetings_found > 0 but meetings array is empty
- quality_gate = FAIL if: doc_url is null
- On FAIL: retry once. On second FAIL: set quality_gate = FAIL, send IPCP Error-Report to {MA_NAME}

## On Failure IPCP
```
[IPCP]
FROM: {POSITION_NAME}
TO: {MA_NAME}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {"atc": "ATC-{POSITION_ID}-DAILY-SUMMARY", "date": "{date}", "error": "{reason}"}
```
