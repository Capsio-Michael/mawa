# Payroll & Compliance Processing — MAWA Pack

**Quadrant:** Autopilot
**Market size:** ~$10B (Asia payroll outsourcing); global payroll processing ~$60B
**SEA relevance:** High — every SEA jurisdiction has mandatory statutory contributions
(CPF Singapore, EPF Malaysia, BPJS Indonesia, SSS/PhilHealth Philippines) with strict
filing deadlines and penalty regimes for errors.

## Why MAWA fits here

Payroll is deterministic: given employee data and the applicable statutory tables,
every calculation has exactly one correct answer. The MA→WA structure splits the
work cleanly — CalcBot applies tax/contribution formulas, CompBot validates against
current statutory rules, ReportBot packages the output for finance and regulators.
The Playbook captures jurisdiction-specific edge cases (e.g. CPF ceiling changes,
overtime caps) that are too numerous to hard-code but too important to leave to LLM judgment.

## Agent roster

| Agent | Role | Type |
|---|---|---|
| Rex | Managing Agent — payroll run coordinator | MA |
| CalcBot | Gross-to-net calculator (multi-jurisdiction tax tables) | WA |
| CompBot | Statutory compliance checker (CPF/EPF/BPJS/SSS/PhilHealth) | WA |
| ReportBot | Payslip and statutory filing report generator | WA |

## Key workflows

1. **Monthly payroll run** — Full gross-to-net cycle from payroll input to approved register
2. **Off-cycle run** — Termination payouts, bonus, commission, and corrections
3. **Statutory filing** — Generate CPF/EPF/BPJS submissions and deadline tracking

## Sample throughput

| Metric | Target |
|---|---|
| Input unit | One employee's monthly payroll record |
| Processing time | < 30 seconds per employee; < 10 minutes for 500-person payroll |
| Human review trigger | Calculation variance > 0.1%, new employee with missing fields, termination edge cases |
| Accuracy target | 99.9% (regulatory requirement in most SEA jurisdictions) |

## Compliance references

- CPF Act (Singapore) — contribution rates and ceiling schedule
- EPF Act 1991 (Malaysia) — mandatory contribution rates by age bracket
- BPJS Ketenagakerjaan (Indonesia) — Jamsostek contribution rules
- SSS/PhilHealth/Pag-IBIG (Philippines) — contribution table 2025
- MOM Employment Act (Singapore) — overtime cap and leave encashment rules

## Glossary

**CPF** — Central Provident Fund. Singapore's mandatory retirement and healthcare
savings scheme. Employers and employees each contribute a percentage of the
employee's monthly wage, subject to a salary ceiling. Rates vary by employee age.

**EPF** — Employees Provident Fund. Malaysia's equivalent of CPF. Mandatory
retirement savings contributions split between employer and employee, administered
by KWSP (Kumpulan Wang Simpanan Pekerja).

**BPJS** — Badan Penyelenggara Jaminan Sosial. Indonesia's national social
security agency, split into two schemes: BPJS Ketenagakerjaan (employment
insurance, workplace accident cover, and pension) and BPJS Kesehatan (national
health insurance). Employers must register and contribute for all Indonesian employees.

**SSS** — Social Security System. The Philippines' social insurance program for
private sector employees. Covers sickness, maternity, disability, retirement,
and death benefits. Both employer and employee contribute monthly.

**PhilHealth** — Philippine Health Insurance Corporation. The Philippines' national
health insurance program, separate from SSS. Provides hospitalisation and medical
coverage. Contributions are mandatory for all employed Filipinos.

**Gross-to-net** — The calculation that takes an employee's gross salary and
deducts all statutory contributions (CPF, EPF, BPJS, etc.), income tax
withholding, and voluntary deductions to arrive at the actual take-home pay.

**Statutory filing** — The mandatory reports and payment submissions that employers
must send to government agencies (CPF Board, KWSP, BPJS, SSS, PhilHealth) each
month, usually with strict deadlines and penalties for late submission.
