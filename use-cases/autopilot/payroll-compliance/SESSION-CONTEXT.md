# SESSION-CONTEXT: Payroll & Compliance Team

> Loaded by Rex at session start. Updated after each payroll run or batch.

## Team state

[SESSION]
team: payroll-compliance-team
session_id: {{auto}}
started_at: {{auto}}
current_run_id: null
current_period: null
employees_processed: 0
employees_failed: 0
escalations_this_session: 0
last_updated: {{auto}}

## Active constraints

[CONSTRAINTS]
max_employees_per_run: 10000
escalation_threshold: 0.99
variance_trigger_pct: 0.1
human_payroll_admin_online: true
compliance_mode: multi_jurisdiction

## Jurisdiction context

[JURISDICTION_CONTEXT]
# Rex loads the active jurisdiction config at run start.
# Updated when a new payroll run is initiated.
active_jurisdictions: []
statutory_table_version:
  SG_CPF: 2025-01-01
  MY_EPF: 2025-01-01
  ID_BPJS: 2025-01-01
  PH_SSS: 2025-01-01
  PH_PHILHEALTH: 2025-01-01
  PH_PAGIBIG: 2025-01-01

## Filing deadlines

[FILING_DEADLINES]
# Rex tracks upcoming statutory filing deadlines.
# CompBot updates status after each compliance check.
SG_CPF: due on 14th of following month
MY_EPF: due on 15th of following month
ID_BPJS: due on 10th of following month
PH_SSS: due varies by employer ID last digit
PH_PHILHEALTH: due on 20th of following month
PH_PAGIBIG: due on 10/20 of following month

## Agent memory

[AGENT_MEMORY]
# Rex notes any calculation anomalies or recurring errors across runs.
# CalcBot appends jurisdiction-specific edge cases encountered.
# CompBot appends any statutory table discrepancies found.
# Cleared at session end; weekly digest sent to Reflector.
entries: []

## Exception queue

[EXCEPTION_QUEUE]
# Employees flagged for payroll_admin review.
# Rex updates status when admin resolves the exception.
pending: []
