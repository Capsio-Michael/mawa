# DISPATCH-TABLE-SCHEMA v1.0

The Dispatch Table is the MA's routing index. It maps inbound messages to the correct WA and ATC based on source channel, keywords, and time constraints. The Dispatcher skill reads this table to make routing decisions.

---

## File Location

```
workspace/MAWA_DISPATCH_TABLE.md
```

One file per workspace. Maintained by the MA. Must be updated whenever a WA's REGISTRATION.md changes.

---

## Full Schema

```yaml
---
version: {integer}
last_updated: {YYYY-MM-DD}
maintained_by: {MA_POSITION_ID}
---
```

---

## WA Entry Format

Each WA has one entry block:

```markdown
## WA: {POSITION_ID}
**position_id:** {POSITION_ID}
**role:** {one-line role description}

### Source Channels (source_channels)
- {channel_id_1}  ({description})
- {channel_id_2}  ({description})

### Trigger Keywords (trigger_keywords)
- {keyword_1}
- {keyword_2}
- {keyword_3}

### Default ATCs
- {ATC_ID_1}  ({when to use})
- {ATC_ID_2}  ({when to use})

### Time Constraints
- {constraint description, or "None — triggers at any time"}
```

---

## Routing Priority

The Dispatcher evaluates rules in this order (highest priority first):

1. **Exact ATC match** — message contains a specific ATC ID → route directly, skip all other rules
2. **Keyword match** — message content matches a WA's `trigger_keywords` → route to that WA
3. **Source channel match** — message origin matches a WA's `source_channels` → route to that WA
4. **No match** → return `NO_MATCH`, MA handles directly

If multiple WAs match the same message, the highest-priority WA wins (order of appearance in the Dispatch Table = priority).

---

## NO_MATCH Handling

Messages that match no WA entry are handled directly by the MA:

```markdown
## MA Direct Handling (NO_MATCH)

The following are handled by {MA_POSITION_ID} directly:
- {category_1}  (e.g., general questions)
- {category_2}  (e.g., system configuration)
- {category_3}  (e.g., cross-WA synthesis tasks)
- Anything outside all WA capability scopes

MA logs all NO_MATCH handling to:
{WORKSPACE}/audit/{ma_id}-handled.jsonl
```

---

## Maintenance Rules

1. Every WA in the workspace must have an entry in this table
2. When a WA's REGISTRATION.md changes (capabilities, ATCs, channels), update this table on the same day
3. Version number increments on every update
4. Only the MA may modify this file (per REGISTRATION Hard Rule)

---

## Minimal Example

```markdown
---
version: 1
last_updated: 2026-01-15
maintained_by: FCLAW
---

# MAWA Dispatch Table

## WA: BOOKY
**position_id:** BOOKY
**role:** Chief Summarist

### Source Channels
- meeting_assistant_bot  (meeting notes from bot)
- all_groups  (any group where meeting assistant posts)

### Trigger Keywords
- 会议纪要 / 会议记录 / meeting summary

### Default ATCs
- ATC-BOOKY-MEETING-EXTRACT  (single meeting)
- ATC-BOOKY-DAILY-SUMMARY    (cron only — not dispatched)

### Time Constraints
- None — triggers at any time

---

## WA: STOCKY
**position_id:** STOCKY
**role:** Stock Monitor

### Source Channels
- Not dispatched — cron-driven only
- MA manual query only

### Trigger Keywords
- 股价 / 股票 / 涨跌幅  (MA manual query only)

### Default ATCs
- ATC-STOCKY-SCHEDULED-BROADCAST  (cron only)
- ATC-STOCKY-ANOMALY-ALERT         (auto-triggered, not dispatched)

### Time Constraints
- Trading days only: 09:30–15:30

---

## MA Direct Handling (NO_MATCH)

Handled by FCLAW directly:
- General questions and conversation
- System configuration requests
- Cross-WA synthesis tasks
- Anything outside all WA scopes

FCLAW logs NO_MATCH handling to:
{WORKSPACE}/audit/fclaw-handled.jsonl
```

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
