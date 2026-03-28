# SESSION-CONTEXT: KYC/AML Team

> Loaded by Vera at session start. Updated after each application processed.

## Team state

[SESSION]
team: kyc-aml-team
session_id: {{auto}}
started_at: {{auto}}
applications_processed: 0
applications_passed: 0
applications_referred: 0
applications_rejected: 0
escalations_this_session: 0
last_updated: {{auto}}

## Active constraints

[CONSTRAINTS]
max_applications_per_session: 500
escalation_threshold: 0.80
pep_always_escalate: true
sanctions_hit_always_reject: true
human_compliance_officer_online: true
compliance_mode: MAS
active_sanctions_lists: [OFAC_SDN, UN_CONSOLIDATED, EU_CONSOLIDATED, MAS_TERRORIST]
sanctions_list_max_age_hours: 24

## Compliance context

[COMPLIANCE]
jurisdiction_default: SG
applicable_regulation: MAS_AML_CFT_NOTICE
fatf_recommendation_version: 2023
audit_retention_years: 5
cdd_required_for: [personal, corporate, joint]
enhanced_dd_triggers: [pep_match, high_risk_country, unusual_transaction_pattern]
high_risk_countries: [IR, KP, SY, MM]

## Agent memory

[AGENT_MEMORY]
# Vera notes patterns observed this session.
# DocBot appends document quality issues (e.g. low-quality scans from specific regions).
# RiskBot appends any new name variation patterns encountered.
# Cleared at session end; weekly digest sent to Reflector.
entries: []

## Escalation queue

[ESCALATION_QUEUE]
# Active refer_to_compliance cases awaiting human review.
# Vera updates status when compliance officer responds.
pending: []
