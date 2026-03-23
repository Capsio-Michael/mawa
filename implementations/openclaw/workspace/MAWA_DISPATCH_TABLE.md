---
version: 1
last_updated: {UPDATE_DATE}
maintained_by: {MA_NAME}
---

# MAWA Dispatch Table

## Overview
Routing index for the Dispatcher skill. Rules are listed in priority order (highest first).
This file must be updated whenever a WA's REGISTRATION.md changes.

---

## WA: {WA_2} 🏗️
**position_id:** {WA_2}
**role:** AI Quality Architect

### Source Channels
- {TEAM_CHANNEL_ID}  ({TEAM_NAME} group)

### Trigger Keywords
- A-layer / A-process / end-to-end / A + 6-digit code
- B-layer / ATC code / B + 8-digit code
- C-layer / Skills / C + 8-digit code
- work report / technical report / position agent
- parent node / empowered position / business goal

### Default ATCs
- ATC-{WA_2}-ASSET-EVALUATE      (general evaluation)
- ATC-{WA_2}-RED-LINE-REJECT     (when red line is triggered)
- ATC-{WA_2}-DAILY-QUALITY-REVIEW (daily summary)

### Time Constraints
- Weekdays only, 16:00–18:30
- Outside this window: keyword matched but outside hours → {MA_NAME} informs sender: "Please submit during weekday 16:00–18:30"

---

## WA: {WA_1} 📚
**position_id:** {WA_1}
**role:** Chief Summarist

### Source Channels
- Meeting assistant bot private messages
- Any group where the meeting assistant posts notes

### Trigger Keywords
- meeting notes / meeting summary / today's meetings

### Default ATCs
- ATC-{WA_1}-MEETING-EXTRACT   (single meeting extraction)
- ATC-{WA_1}-DAILY-SUMMARY     (daily summary — cron only, not dispatched)

### Time Constraints
- None — triggers at any time

---

## WA: {WA_3} 🌶
**position_id:** {WA_3}
**role:** Personal Assistant

### Source Channels
- {OWNER_NAME}'s private messages only

### Trigger Keywords
- remember / remind me / note this
- today / tomorrow / schedule
- personal memo — natural language

### Default ATCs
- ATC-{WA_3}-CAPTURE-THOUGHT    (thought capture)
- ATC-{WA_3}-REMINDER           (reminder setup)
- ATC-{WA_3}-EVENING-SUMMARY    (cron only — not dispatched)

### Time Constraints
- None — triggers at any time

---

## WA: {WA_4} 📈
**position_id:** {WA_4}
**role:** Stock Monitor

### Source Channels
- Not dispatched — cron-driven only
- {MA_NAME} manual query only

### Trigger Keywords (for {MA_NAME} manual queries only)
- stock price / stock / change percentage

### Default ATCs
- ATC-{WA_4}-SCHEDULED-BROADCAST  (cron only)
- ATC-{WA_4}-ANOMALY-ALERT         (auto-triggered — not dispatched)

### Time Constraints
- Trading days only: 09:30–15:30

---

## MA Direct Handling (NO_MATCH)

The following are handled by {MA_NAME} directly — not dispatched to any WA:
- General questions and conversation
- System configuration requests
- Cross-WA synthesis tasks
- Anything outside all WA capability scopes

{MA_NAME} logs all NO_MATCH handling to:
{WORKSPACE}/audit/{ma_id}-handled.jsonl
