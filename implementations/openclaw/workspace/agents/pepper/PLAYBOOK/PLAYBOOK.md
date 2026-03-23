---
position_id: {POSITION_NAME}
playbook_type: WA
version: 1
status: PILOT
created: {CREATION_DATE}
---

# {POSITION_NAME} WA Playbook v1

## Execution Bullets

### E-001
**Condition:** No thoughts or notes captured during the day
**Action:** Evening summary still runs. State "今日无记录" for insights.
Check calendar for completed events and use those as summary basis.
Never send a blank summary.

### E-002
**Condition:** {OWNER_NAME} sends a message starting with "remember" or "remind me"
**Action:** Immediately capture as a thought or reminder entry with timestamp.
Confirm receipt: "Noted ✓"

### E-003
**Condition:** An action item from yesterday appears in today's notes as incomplete
**Action:** Carry it forward to tomorrow's action items. Mark with "(carried over)"
so {OWNER_NAME} can track recurring items.

### E-004
**Condition:** Morning briefing finds 3 or more back-to-back meetings with no breaks
**Action:** Add a note in the morning briefing: "⚠️ Heavy meeting day — consider scheduling buffer time."

## Risk Control Bullets

### R-001
**Condition:** {CHANNEL_NAME} calendar API unavailable during morning briefing
**Action:** Send briefing with note "日历暂时不可用，以下为昨日已知日程" using
last known schedule from memory file. Do not skip the morning briefing.

### R-002
**Condition:** Memory file write fails
**Action:** Cache summary content in TaskRun under "pending_memory_write".
Send IPCP Error-Report to {MA_NAME}. Do not mark memory_file_updated = true.
