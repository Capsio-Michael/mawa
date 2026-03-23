---
atc_id: ATC-{POSITION_ID}-EVENING-SUMMARY
position_id: {POSITION_NAME}
what_id: WHAT-{POSITION_ID}-EVENING-SUMMARY
version: 1
sla_minutes: 10
retry_max: 2
---

# ATC: Evening Summary

## Input Schema
```json
{
 "date": "YYYY-MM-DD",
 "trigger": "cron | manual"
}
```

## Output Schema
```json
{
 "taskrun_id": "string",
 "date": "YYYY-MM-DD",
 "key_insights": ["string"],
 "decisions_made": ["string"],
 "action_items": [
 {"item": "string", "deadline": "string | null", "priority": "high | medium | low"}
 ],
 "mood_note": "string | null",
 "memory_file_updated": "boolean",
 "memory_file_path": "string",
 "notification_sent": "boolean",
 "quality_gate": "PASS | FAIL"
}
```

## {CHANNEL_NAME} Message Format
```
🌶 晚间总结 | {date}

📌 今日关键洞察：
{key_insights as numbered list}

✅ 决策记录：
{decisions_made as numbered list, or "今日无重大决策"}

📋 明日待办：
{action_items sorted by priority}

— {POSITION_NAME} 🌶 晚安
```

## Quality Gate
- FAIL if memory_file_updated = false
- FAIL if notification sent to group chat (must be private only)
- On FAIL: retry once. On second FAIL: IPCP Error-Report to {MA_NAME}.
