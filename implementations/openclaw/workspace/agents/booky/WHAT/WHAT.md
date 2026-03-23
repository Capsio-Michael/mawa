---
what_id: WHAT-{POSITION_ID}-DAILY-SUMMARY
position_id: {POSITION_NAME}
version: 1
---

# WHAT: Daily Work Summary

## W — Work (What is this task?)
Generate a structured daily work summary from all {CHANNEL_NAME} meeting notes of the day.
Business intent: Give {OWNER_NAME} a single, reliable daily record of all meetings,
decisions, action items, and links — without manual effort.

## H — How (Execution steps)
1. Scan {CHANNEL_NAME} private messages from the meeting assistant bot for today's date
2. Scan all group chats for meeting notes posted today
3. For each meeting found, extract:
 - Meeting title and time
 - Participants
 - Core topics discussed
 - Key decisions made
 - Action items (owner + deadline if stated)
 - Original {CHANNEL_NAME} doc link
4. Synthesize cross-meeting insights (patterns, key themes of the day)
5. Compile tomorrow's action items from all meetings
6. Write summary to local file AND {CHANNEL_NAME} cloud doc
7. Send notification to {OWNER_NAME} via {CHANNEL_NAME} private message

## A — Automation
- Automation scope: FULL
- Trigger: Cron (daily 23:00)
- Tools required: {CHANNEL_NAME}_im_user_get_messages, {CHANNEL_NAME}_doc_create, {CHANNEL_NAME}_im_notify, file_write

## T — Test (Quality Validation)
- At least one meeting must be found OR output explicitly states "no meetings today"
- Every meeting entry must include original_link field (not null)
- action_items list must be present (can be empty array)
- Output JSON must pass schema validation before writing to file
- {CHANNEL_NAME} notification must be sent within 2 minutes of summary generation
