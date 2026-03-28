# Workflow: Accounting & Audit Automation

---

## ATC Task Card — AP-ACC-001: Month-End Close

[ATC]
task_id: AP-ACC-001
task_name: month_end_close
trigger: scheduled_cron | manual_trigger
sla_minutes: 15
retry_max: 1

input_schema:
  - field: run_id
    type: string
    required: true
  - field: entity_id
    type: string
    required: true
  - field: period
    type: string (YYYY-MM)
    required: true
  - field: gl_extract
    type: object (accounts array with line items)
    required: true
  - field: subledger_data
    type: object
    required: true
  - field: je_batch
    type: array
    required: true
  - field: prior_period_tb
    type: object
    required: false
  - field: budget_figures
    type: object
    required: false

dispatch_table:
  - step: 1
    target_agent: LedgerBot
    input: gl_extract + subledger_data
    output: reconciliation_result
  - step: 2
    target_agent: JournalBot
    input: je_batch
    output: je_review_result
  - step: 3
    target_agent: VarBot
    input: trial_balance + prior_period_tb + budget_figures
    output: variance_result
  - step: 4
    target_agent: ReportBot
    input: reconciliation_result + je_review_result + variance_result
    output: close_pack

quality_gate:
  min_confidence: 0.75
  required_fields: [overall_status, open_items, sign_off_required]
  on_fail: escalate_to_controller

output_schema:
  status: pass | fail | escalated
  result:
    close_pack: object
    overall_status: CLEAN | QUALIFIED | ESCALATED
    open_items: array
    confidence: number
  processing_time_ms: number
  agent_trace: array

---

## ATC Task Card — AP-ACC-002: Audit Sample Selection

[ATC]
task_id: AP-ACC-002
task_name: audit_sample_selection
trigger: api_call | auditor_request
sla_minutes: 5
retry_max: 1

input_schema:
  - field: request_id
    type: string
    required: true
  - field: entity_id
    type: string
    required: true
  - field: population
    type: array (transaction list)
    required: true
  - field: sampling_method
    type: string (MUS | random | stratified_random)
    required: true
  - field: confidence_level
    type: number (0.0–1.0)
    required: true
  - field: tolerable_misstatement
    type: number
    required: true

dispatch_table:
  - condition: sampling_method in [MUS, random, stratified_random]
    target_agent: SampleBot
  - condition: default
    target_agent: Iris (escalate — unknown method)

quality_gate:
  min_confidence: 0.90
  required_fields: [sample, isa_530_compliant, coverage_pct]
  on_fail: escalate_to_external_auditor

output_schema:
  status: pass | fail | escalated
  result:
    sample_list: array
    method: string
    coverage_pct: number
    isa_530_compliant: boolean
  processing_time_ms: number
  agent_trace: array

---

## ATC Task Card — AP-ACC-003: Journal Entry Batch Review

[ATC]
task_id: AP-ACC-003
task_name: je_batch_review
trigger: scheduled_cron | api_call
sla_minutes: 10
retry_max: 1

input_schema:
  - field: batch_id
    type: string
    required: true
  - field: entity_id
    type: string
    required: true
  - field: period
    type: string (YYYY-MM)
    required: true
  - field: je_list
    type: array
    required: true

dispatch_table:
  - condition: je_list.length > 0
    target_agent: JournalBot
  - condition: default
    target_agent: Iris (no JEs to review — log and close)

quality_gate:
  min_confidence: 0.80
  required_fields: [total_jes_reviewed, flagged_jes, aggregate_risk_score]
  on_fail: escalate_to_controller

output_schema:
  status: pass | fail | escalated
  result:
    je_review: object
    flagged_count: integer
    aggregate_risk_score: number
  processing_time_ms: number
  agent_trace: array

---

## ATC Task Card — AP-ACC-004: Variance Investigation

[ATC]
task_id: AP-ACC-004
task_name: variance_investigation
trigger: api_call | post_close_trigger
sla_minutes: 8
retry_max: 1

input_schema:
  - field: investigation_id
    type: string
    required: true
  - field: entity_id
    type: string
    required: true
  - field: period
    type: string (YYYY-MM)
    required: true
  - field: current_tb
    type: object
    required: true
  - field: prior_period_tb
    type: object
    required: false
  - field: budget
    type: object
    required: false
  - field: variance_threshold_pct
    type: number
    required: false (default: 0.10)

dispatch_table:
  - condition: current_tb present
    target_agent: VarBot
  - condition: default
    target_agent: Iris (missing TB — request resubmission)

quality_gate:
  min_confidence: 0.80
  required_fields: [flagged_accounts, requires_cfo_review]
  on_fail: escalate_to_controller

output_schema:
  status: pass | fail | escalated
  result:
    variance_report: object
    flagged_count: integer
    requires_cfo_review: boolean
  processing_time_ms: number
  agent_trace: array

---

## Flow diagram

```
Month-End Close (AP-ACC-001):
  Trigger → Iris
    ├── Step 1: GL extract + subledger → LedgerBot → reconciliation_result
    ├── Step 2: JE batch → JournalBot → je_review_result
    ├── Step 3: Trial balance → VarBot → variance_result
    └── Step 4: All results → ReportBot → close_pack → quality_gate
                  ├── PASS (confidence ≥ 0.75, all fields present) → deliver to controller
                  └── FAIL → escalate_to_controller + write Error-Report

Audit Sample Selection (AP-ACC-002):
  Auditor request → Iris
    └── population + params → SampleBot → sample_list → quality_gate
                  ├── PASS (isa_530_compliant = true) → deliver to auditor
                  └── FAIL → escalate_to_external_auditor

Journal Entry Review (AP-ACC-003):
  Cron / API → Iris
    └── je_list → JournalBot → je_review → quality_gate
                  ├── PASS → deliver JE risk report to controller
                  └── FAIL → escalate_to_controller

Variance Investigation (AP-ACC-004):
  API / post-close → Iris
    └── TB data → VarBot → variance_report → quality_gate
                  ├── requires_cfo_review = false → deliver to controller
                  └── requires_cfo_review = true → escalate_to_cfo
```
