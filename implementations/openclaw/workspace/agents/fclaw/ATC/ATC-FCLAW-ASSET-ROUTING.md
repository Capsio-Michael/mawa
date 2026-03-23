---
atc_id: ATC-{MA_ID}-ASSET-ROUTING
position_id: {MA_NAME}
version: 1
sla_minutes: 5
---

# ATC: Asset Routing to {TARGET_WA}

## Trigger
When {MA_NAME} receives an @mention in {TEAM_CHANNEL} group:
1. Check the message itself for A/B/C format
2. If message references another message (reply_to), check the original too

**A/B/C Format Detection:**
- Contains "A面" or "B面" or "C面" sections
- Or contains "ATC编号" / "ATC " pattern
- Or contains "岗位智能体" in title
- Or contains "Skill 1:" / "Skill 2:" pattern (C-layer skills)

## Input Schema
```json
{
 "taskrun_id": "string",
 "message_id": "string",
 "reply_to_message_id": "string | null",
 "group_id": "string",
 "sender": "string (name)",
 "content": "string (full message content)",
 "referenced_content": "string | null (if reply_to exists)",
 "trigger": "direct | reply"
}
```

## Action Steps

1. **Collect Content**
   - If message has reply_to: fetch the original message content
   - Combine both for analysis

2. **Detect Asset Format**
   - Parse content for A/B/C layer markers
   - Identify which layer(s) are present (A/B/C)
   - Extract asset code if present (B20260320-1 format)

3. **If A/B/C Detected → Route to {TARGET_WA}**
   - Send IPCP to {TARGET_WA}:
   ```
   [IPCP] FROM: {MA_NAME} / TO: {TARGET_WA} / INTENT: Request-ATC /
   CORRELATION_ID: {taskrun_id} /
   PAYLOAD: {
     "asset_doc_url": "{CHANNEL_NAME}_message",
     "asset_layer": "A|B|C|multiple",
     "submitted_by": "{sender}",
     "submission_time": "{ISO8601}",
     "trigger": "group_message"
   }
   ```
   - Reply in group: "收到，已转交 {TARGET_WA} 进行质量评估 🦞"
   - STOP here (don't do acknowledgment)

4. **If NO A/B/C Detected**
   - This is a regular message, process normally
   - Do NOT route to {TARGET_WA}

## Quality Gate
- PASS: Message contains A/B/C format → route to {TARGET_WA}
- PASS: Message is reply with A/B/C in original → route to {TARGET_WA}
- FAIL: No A/B/C detected → normal processing (don't route)
- FAIL: message_id is invalid
- FAIL: sender is not identified
- FAIL: routing IPCP to {TARGET_WA} fails

## Hard Rule
If A/B/C is detected, I must route to {TARGET_WA} BEFORE any detailed acknowledgment.
The group should only see one evaluation result — from {TARGET_WA}, not {MA_NAME}.
