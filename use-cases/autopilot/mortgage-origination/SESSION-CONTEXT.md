# SESSION-CONTEXT: [REPLACE: Pack Name] Team

> Loaded by MA at session start. Updated after each work unit processed.

## Team state

[SESSION]
team: mortgage-origination-team
session_id: {{auto}}
started_at: {{auto}}
work_units_processed: 0
escalations_this_session: 0
last_updated: {{auto}}

## Active constraints

[CONSTRAINTS]
max_units_per_session: 100
escalation_threshold: 0.80
human_reviewer_online: true
compliance_mode: [REPLACE: e.g. MAS | BNM | OJK | none]

## Agent memory

[AGENT_MEMORY]
# MA notes patterns observed this session.
# WAs append quality issues.
# Cleared at session end; weekly digest sent to Reflector.
entries: []
