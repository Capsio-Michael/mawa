# PLAYBOOK-SCHEMA v1.0

The Playbook is a Position's living strategy document. It contains conditional behavior rules — called bullets — that guide agent decisions beyond what ATC steps specify. Playbooks evolve over time through the Reflector → Curator loop.

---

## File Location

```
workspace/agents/{POSITION_ID}/PLAYBOOK/PLAYBOOK.md
```

Versioned history is stored at:
```
workspace/playbook-versions/{POSITION_ID}/playbook-v{N}.md
```

---

## Full Schema

```yaml
---
position_id: {POSITION_ID}
playbook_type: MA | WA
version: {integer}
status: PILOT | SOTA | LEGACY
created: {YYYY-MM-DD}
promoted_from_candidates: [{candidate_ids}]   # populated on v2+
curator_session_date: {YYYY-MM-DD}            # populated on v2+
approved_by: {OWNER_NAME}                     # populated on v2+
---
```

**Status definitions:**
- `PILOT` — newly promoted, under observation (first 2 weeks)
- `SOTA` — proven effective, current best version
- `LEGACY` — superseded, kept for rollback only

---

## Bullet Types

Every bullet belongs to one of four types:

| Type | Prefix | Purpose |
|------|--------|---------|
| Execution | `E-` | Override or extend default ATC step behavior |
| Risk Control | `R-` | Handle failure, edge cases, and degraded states |
| Quality | `Q-` | Adjust scoring or quality judgment criteria |
| Deprecated | `D-` | Removed bullets (kept for audit trail) |

---

## Bullet Format

```markdown
### {TYPE}-{SEQ}
**Condition:** {precise trigger condition — what must be true for this bullet to fire}
**Action:** {what the agent must do when condition is met}
```

Rules:
- Condition must be specific enough to be unambiguous
- Action must be executable without additional judgment
- One condition per bullet — if you need AND/OR logic, make it explicit
- Deprecated bullets must stay in the file under `## Deprecated Bullets` with a reason

---

## Governance Hierarchy

```
Hard Rules (Registration)     ← Always win
       ↓
Playbook Bullets              ← Override ATC defaults
       ↓
ATC Steps                     ← Default execution path
       ↓
LLM Judgment                  ← Used only when nothing else applies
```

A Playbook bullet cannot override a Hard Rule. If conflict is detected, the Hard Rule prevails and the conflict is logged.

---

## Full Template

```markdown
---
position_id: {POSITION_ID}
playbook_type: WA
version: 1
status: PILOT
created: {CREATION_DATE}
---

# {POSITION_ID} WA Playbook v1

## Execution Bullets

### E-001
**Condition:** {condition}
**Action:** {action}

### E-002
**Condition:** {condition}
**Action:** {action}

## Risk Control Bullets

### R-001
**Condition:** {condition}
**Action:** {action}

## Quality Bullets

### Q-001
**Condition:** {condition}
**Action:** {action}

## Deprecated Bullets
(none — v1 pilot)
```

---

## Playbook Lifecycle

```
Reflector (Sunday 22:00)
    ↓ mines TaskRuns
Candidate bullets written to playbook-candidates/
    ↓
Curator session (on-demand)
    ↓ owner reviews each candidate
Approved bullets → new Playbook version (PILOT)
    ↓ 2 weeks observation
Reflector confirms effectiveness
    ↓
PILOT → SOTA promotion
    ↓ next version promoted
Previous SOTA → LEGACY
```

---

## Bullet Effectiveness Tracking

The Reflector tracks two counters per bullet:

- `helpful_count` — times bullet fired on a PASS run
- `harmful_count` — times bullet fired on a FAIL run

Deprecation recommendation triggers when: `harmful_count > helpful_count`

Auto-promotion to SOTA triggers when after 2 weeks: `helpful_count > 0 AND harmful_count = 0`

---

## Minimal Example

```markdown
---
position_id: STOCKY
playbook_type: WA
version: 1
status: PILOT
created: 2026-01-15
---

# STOCKY WA Playbook v1

## Execution Bullets

### E-001
**Condition:** Data source returns stale data (timestamp > 15 minutes old)
**Action:** Mark stock status as ❓ pending verification regardless of discrepancy.
Add note in broadcast: "Data may be delayed, please verify with live market."

## Risk Control Bullets

### R-001
**Condition:** All stock data sources unavailable
**Action:** Do not send any broadcast. Send IPCP Error-Report to {MA_NAME}.
Write TaskRun with status = "data_source_failure".

## Deprecated Bullets
(none — v1 pilot)
```

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
