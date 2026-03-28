# SESSION-CONTEXT: Accounting & Audit Team

> Loaded by Iris at session start. Updated after each close cycle or audit task.

## Team state

[SESSION]
team: accounting-audit-team
session_id: {{auto}}
started_at: {{auto}}
current_run_id: null
current_period: null
close_cycles_completed: 0
audit_samples_generated: 0
je_batches_reviewed: 0
variance_investigations_completed: 0
escalations_this_session: 0
last_updated: {{auto}}

## Active constraints

[CONSTRAINTS]
max_gl_lines_per_run: 50000
escalation_threshold: 0.75
variance_threshold_pct: 0.10
variance_threshold_abs: 10000
round_number_je_threshold: 50000
controller_online: true
external_auditor_online: false
compliance_mode: multi_jurisdiction

## Jurisdiction accounting standards

[JURISDICTION_STANDARDS]
# Iris loads applicable standard based on entity jurisdiction at run start.
SG:
  standard: SFRS (Singapore Financial Reporting Standards)
  audit_standard: SSA 530 (Singapore Standard on Auditing — aligned with ISA 530)
  regulator: ACRA / MAS
  close_deadline: 45 days after period end
MY:
  standard: MFRS (Malaysian Financial Reporting Standards — IFRS-aligned)
  audit_standard: ISA 530
  regulator: SC / BNM
  close_deadline: 60 days after period end
ID:
  standard: PSAK (Pernyataan Standar Akuntansi Keuangan — IFRS-convergent)
  audit_standard: ISA 530
  regulator: OJK
  close_deadline: 60 days after period end
PH:
  standard: PFRS (Philippine Financial Reporting Standards — IFRS-aligned)
  audit_standard: PSA 530 (Philippine Standard on Auditing — ISA 530 equivalent)
  regulator: SEC / BSP
  close_deadline: 60 days after period end
VN:
  standard: VAS (Vietnamese Accounting Standards)
  audit_standard: ISA 530 (applied in practice)
  regulator: MOF / SBV
  close_deadline: 90 days after period end

## Prior period context

[PRIOR_PERIOD]
# Iris loads prior period summary at close start for VarBot baseline.
# Updated after each completed close cycle.
last_closed_period: null
last_close_status: null
open_items_carried_forward: []
recurring_variance_flags: []

## Agent memory

[AGENT_MEMORY]
# Iris notes close cycle anomalies across runs.
# LedgerBot appends recurring unmatched item patterns.
# JournalBot appends recurring JE authorization gaps by preparer.
# VarBot appends accounts with persistent variance above threshold.
# SampleBot appends population characteristics affecting sample size.
# ReportBot appends formatting or delivery issues.
# Cleared at session end; weekly digest sent to Reflector.
entries: []

## Escalation queue

[ESCALATION_QUEUE]
# Active escalations awaiting controller or external auditor response.
# Iris updates status when reviewer responds.
pending: []
