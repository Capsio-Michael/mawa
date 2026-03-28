# Workflow: Monthly Payroll Run

## ATC Task Card — AP-PAY-001: Monthly Payroll Run

[ATC]
task_id: AP-PAY-001
task_name: monthly_payroll_run
trigger: scheduled_cron (last working day of month, 06:00) | manual_trigger
sla_minutes: 30
retry_max: 1

input_schema:
  - field: run_id
    type: string
    required: true
  - field: period
    type: string (YYYY-MM)
    required: true
  - field: company_id
    type: string
    required: true
  - field: jurisdiction
    type: string (ISO 3166-1 alpha-2)
    required: true
    valid_values: [SG, MY, ID, PH, VN, TH]
  - field: employees
    type: array
    required: true
    min_items: 1
    item_schema:
      employee_id: string
      full_name: string
      employment_type: full_time | part_time | contract
      base_salary: number
      allowances: object
      overtime_hours: number
      commission: number
      unpaid_leave_days: number
      ic_number: string
      bank_account: string
      joined_date: string (YYYY-MM-DD)
      resigned_date: string (YYYY-MM-DD) | null

dispatch_table:
  - condition: input_validated
    target_agent: CalcBot
    task_id: AP-PAY-002
    batch_size: 50 employees per batch
  - condition: calcbot_all_batches_complete
    target_agent: CompBot
    task_id: AP-PAY-003
  - condition: compbot.status == pass
    target_agent: ReportBot
    task_id: AP-PAY-004
  - condition: compbot.employees_failed > 0
    → escalate failed employees to payroll_admin
    → continue with passed employees to ReportBot

quality_gate:
  min_confidence: 0.99
  required_fields: [run_id, payroll_register_path, employees_processed, employees_failed]
  variance_check: true
  on_fail: escalate_to_payroll_admin

output_schema:
  run_id: string
  period: string
  company_id: string
  jurisdiction: string
  employees_processed: number
  employees_failed: number
  total_gross_payroll: number
  total_net_payroll: number
  total_employer_contributions: number
  payroll_register_path: string
  payslips_path: string
  statutory_filings: array
  processing_time_ms: number
  agent_trace: array

---

## ATC Task Card — AP-PAY-002: Gross-to-Net Calculation

[ATC]
task_id: AP-PAY-002
task_name: gross_to_net_calculation
trigger: dispatched_by_rex
parent_task_id: AP-PAY-001
sla_minutes: 10
retry_max: 1

quality_gate:
  required_fields: [employee_id, gross_pay, deductions, employer_contributions, net_pay]
  net_pay_floor: 0 (negative net pay = immediate fail)
  on_fail: return_to_rex_with_error

---

## ATC Task Card — AP-PAY-003: Statutory Compliance Check

[ATC]
task_id: AP-PAY-003
task_name: statutory_compliance_check
trigger: dispatched_by_rex_after_calcbot
parent_task_id: AP-PAY-001
sla_minutes: 10
retry_max: 1

quality_gate:
  required_fields: [status, employees_checked, employees_passed, employees_failed, filing_deadline_check]
  on_fail: escalate_to_payroll_admin

---

## ATC Task Card — AP-PAY-004: Report Generation

[ATC]
task_id: AP-PAY-004
task_name: payroll_report_generation
trigger: dispatched_by_rex_after_compbot_pass
parent_task_id: AP-PAY-001
sla_minutes: 10
retry_max: 1

quality_gate:
  required_fields: [status, payslips_generated, payroll_register_path, statutory_filings]
  on_fail: escalate_to_payroll_admin

---

## Flow diagram

```
Finance channel / Cron
    ↓
Rex (AP-PAY-001)
    ↓ validate input
CalcBot (AP-PAY-002)
[gross-to-net per employee, batched]
    ↓
CompBot (AP-PAY-003)
[statutory compliance validation]
    ├── all pass → ReportBot (AP-PAY-004)
    │                   ↓
    │              payslips + register + filings
    │                   ↓
    │              deliver to finance_channel
    └── some fail → escalate failed to payroll_admin
                  → process remainder through ReportBot
```

## Jurisdiction-specific statutory tables

| Jurisdiction | Contribution | Employee rate | Employer rate | Ceiling (2025) |
|---|---|---|---|---|
| SG | CPF (age < 55) | 20% | 17% | SGD 6,800/month |
| MY | EPF (age < 60) | 11% | 13% | No ceiling |
| ID | BPJS JHT | 2% | 3.7% | No ceiling |
| ID | BPJS JP | 1% | 2% | IDR 9.5M/month |
| PH | SSS | 4.5% | 9.5% | PHP 29,750/month |
| PH | PhilHealth | 2.5% | 2.5% | PHP 100,000/month |
| PH | Pag-IBIG | 2% | 2% | PHP 5,000/month |

## Error codes

| Code | Meaning |
|------|---------|
| `CALC-001` | Negative net pay after deductions |
| `CALC-002` | Overtime hours exceed statutory cap |
| `CALC-003` | Pro-ration error (mid-month joiner/leaver) |
| `COMP-001` | Contribution rate mismatch vs statutory table |
| `COMP-002` | CPF/EPF ceiling exceeded in calculation |
| `COMP-003` | Filing deadline overdue |
| `RPT-001` | Required payslip field missing |
| `RPT-002` | Statutory filing format error |
