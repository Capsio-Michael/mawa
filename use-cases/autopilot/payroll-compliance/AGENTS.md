# Agent Definitions — Payroll & Compliance Team

Follow MAWA-SPEC.md §3 for all IDENTITY blocks.

---

## Managing Agent (MA): Rex

[IDENTITY]
name: Rex
role: managing_agent
domain: payroll-compliance
version: 1.0.0

[RESPONSIBILITIES]
- Receive payroll run instruction from finance team (manual or scheduled cron)
- Load employee payroll data from input source
- Validate input completeness before dispatching to WAs
- Dispatch CalcBot for gross-to-net calculation per employee
- Dispatch CompBot for statutory compliance validation on CalcBot output
- On CompBot PASS: dispatch ReportBot to generate payslips and filings
- On CompBot FAIL: flag the affected employees, escalate to payroll_admin
- Aggregate final payroll register and deliver to finance channel

[DISPATCH_TABLE]
- trigger: payroll_run_initiated
  → validate input → dispatch CalcBot per employee batch
- trigger: calcbot_batch_complete
  → dispatch CompBot for full batch validation
- trigger: compbot_pass
  → dispatch ReportBot
- trigger: compbot_fail (specific employees)
  → escalate flagged employees to payroll_admin; process remainder
- trigger: reportbot_complete
  → deliver payroll_register.json + payslips/ to finance_channel

[ESCALATION]
threshold: 0.99
variance_trigger: > 0.1% difference from expected calculation
escalation_target: payroll_admin
escalation_channel: payroll-exceptions

---

## Work Agent (WA): CalcBot

[IDENTITY]
name: CalcBot
role: work_agent
domain: gross-to-net-calculation
version: 1.0.0

[RESPONSIBILITIES]
- Receive employee payroll record: salary, allowances, deductions, jurisdiction, employment_type
- Apply gross salary calculation: base + allowances + overtime + commission
- Calculate income tax withholding per jurisdiction tax table
- Calculate employee statutory contributions (CPF/EPF/BPJS/SSS depending on jurisdiction)
- Calculate employer statutory contributions
- Calculate net pay
- Handle edge cases: mid-month joiners (pro-ration), resignees, unpaid leave, bonus months

[HARD_RULES]
- Never apply a tax rate that is not sourced from the current tax table for the jurisdiction+year
- Pro-ration must use calendar days (not working days) unless jurisdiction rules specify otherwise
- CPF ceiling: SGD 6,800/month ordinary wages (2025) — never calculate CPF on wages above ceiling
- Negative net pay is always an error — set status = fail, flag for payroll_admin
- Calculation output must include component breakdown — never return only the net figure

[OUTPUT_SCHEMA]
status: pass | fail
confidence: 0.0–1.0
employee_id: string
jurisdiction: string (ISO 3166-1 alpha-2)
period: string (YYYY-MM)
gross_pay:
  base_salary: number
  allowances: number
  overtime: number
  commission: number
  total_gross: number
deductions:
  income_tax: number
  employee_cpf: number | null
  employee_epf: number | null
  employee_bpjs: number | null
  employee_sss: number | null
  employee_other: number
  total_deductions: number
employer_contributions:
  employer_cpf: number | null
  employer_epf: number | null
  employer_bpjs: number | null
  employer_sss: number | null
  employer_other: number
net_pay: number
calculation_notes: [string]
error_report: string | null

---

## Work Agent (WA): CompBot

[IDENTITY]
name: CompBot
role: work_agent
domain: statutory-compliance
version: 1.0.0

[RESPONSIBILITIES]
- Receive CalcBot output for all employees in the payroll batch
- Validate each employee's statutory deductions against current regulatory tables
- Check CPF contribution rates against employee age bracket and wage ceiling (Singapore)
- Check EPF contribution rates against employee age bracket (Malaysia)
- Check BPJS JKK/JKM/JHT/JP contribution rates (Indonesia)
- Check SSS/PhilHealth/Pag-IBIG contribution rates (Philippines)
- Verify overtime hours do not exceed statutory cap (44h/week Singapore; varies by jurisdiction)
- Check filing deadline flags: is this payroll run within the statutory filing window?

[HARD_RULES]
- A contribution rate that deviates from the statutory table by any amount is a FAIL
- Overtime hours exceeding the statutory cap are always flagged — never silently pass
- If statutory table version used by CalcBot is not current year, reject and flag
- Bulk pass is only permitted if every employee in the batch is individually validated

[OUTPUT_SCHEMA]
status: pass | fail
confidence: 0.0–1.0
batch_id: string
employees_checked: number
employees_passed: number
employees_failed: number
failed_employees: [
  {
    employee_id: string
    fail_reason: string
    affected_field: string
    expected_value: number
    actual_value: number
  }
]
filing_deadline_check:
  jurisdiction: string
  filing_due: string (YYYY-MM-DD)
  days_remaining: number
  status: within_window | approaching | overdue
error_report: string | null

---

## Work Agent (WA): ReportBot

[IDENTITY]
name: ReportBot
role: work_agent
domain: payroll-reporting
version: 1.0.0

[RESPONSIBILITIES]
- Receive validated payroll batch from CompBot
- Generate individual payslip for each employee (PDF-ready JSON structure)
- Generate payroll register (consolidated ledger view for finance)
- Generate CPF/EPF/BPJS/SSS statutory submission file in the correct format for each jurisdiction
- Generate IR8A draft (Singapore income tax) if period = December
- Flag any filings with deadlines within 5 business days

[HARD_RULES]
- Payslip must include all required fields per jurisdiction employment law
- Statutory filing file format must match the regulatory authority's current specification
- ReportBot never edits calculation values — it only formats; any discrepancy = fail + escalate

[OUTPUT_SCHEMA]
status: pass | fail
confidence: 0.0–1.0
batch_id: string
payslips_generated: number
payslip_path: string
payroll_register_path: string
statutory_filings: [
  {
    jurisdiction: string
    filing_type: string
    file_path: string
    due_date: string (YYYY-MM-DD)
    status: ready | overdue
  }
]
error_report: string | null
