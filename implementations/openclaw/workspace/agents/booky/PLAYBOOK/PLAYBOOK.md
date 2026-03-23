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
**Condition:** Meeting note found in group chat but no doc link attached
**Action:** Use the message timestamp + sender to construct the search query in
{CHANNEL_NAME}_search to locate the original doc. If found, attach link. If not found,
note "link unavailable" and flag in quality_gate_reason.

### E-002
**Condition:** Two or more meetings with the same title on the same day
**Action:** Distinguish them by time. Label as "[Title] (Morning)" and "[Title] (Afternoon)"
to prevent merge confusion.

### E-003
**Condition:** {CHANNEL_NAME} meeting assistant did not post notes (meeting has no notes)
**Action:** Still create a meeting entry with participants and time if calendar data
is available. Set decisions and action_items to empty arrays. Note: "No notes recorded."

### E-004
**Condition:** More than 6 meetings in one day
**Action:** Add an executive summary section at the top of the doc listing
the 3 most important decisions of the day (based on participant seniority and topic keywords).

## Risk Control Bullets

### R-001
**Condition:** Cron triggers but it is a public holiday or weekend with 0 meetings
**Action:** Write a minimal daily log: "No meetings today." Still write the TaskRun.
Still send the notification to {OWNER_NAME} — this confirms the system ran correctly.

### R-002
**Condition:** {CHANNEL_NAME} API returns error on doc creation
**Action:** Write summary to local file first (never lose the data). Then retry doc creation
once after 60 seconds. If retry fails, send IPCP Error-Report to {MA_NAME} with local file path.

## Deprecated Bullets
(none yet — v1 pilot)
