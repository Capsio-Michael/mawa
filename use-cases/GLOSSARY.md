# MAWA Use-Cases — Master Glossary

This glossary covers regulatory frameworks, accounting standards, and industry
terminology used across the MAWA use-case packs. Each pack's own README also
contains a pack-level glossary limited to its relevant acronyms.

---

## Financial compliance & KYC/AML

**KYC** — Know Your Customer. The process of verifying a customer's identity
before onboarding. Required by financial regulators worldwide to prevent fraud
and financial crime. → [kyc-aml pack](autopilot/kyc-aml/)

**AML** — Anti-Money Laundering. Rules and detection procedures designed to
prevent criminals from disguising illegal funds as legitimate income.

**PEP** — Politically Exposed Person. A current or former government official,
or close associate, who carries elevated money laundering risk. PEP matches
require Enhanced Due Diligence (EDD).

**EDD** — Enhanced Due Diligence. A deeper level of customer verification applied
when standard checks flag elevated risk — PEP match, high-risk jurisdiction, or
unusual transaction patterns.

**FATF** — Financial Action Task Force. The intergovernmental body that sets
global AML/KYC standards, adopted by 200+ jurisdictions. Maintains grey and
black lists of high-risk countries.

**OFAC** — Office of Foreign Assets Control (US Treasury). Publishes the global
sanctions list — entities and individuals that cannot be transacted with. Screening
is required for any institution with USD exposure.

**MAS** — Monetary Authority of Singapore. Singapore's central bank and financial
regulator. Sets KYC/AML requirements for all Singapore-licensed financial institutions.

**BNM** — Bank Negara Malaysia. Malaysia's central bank and financial regulator.

**OJK** — Otoritas Jasa Keuangan. Indonesia's Financial Services Authority.
Regulates banking, capital markets, and insurance.

**SBV** — State Bank of Vietnam. Vietnam's central bank and banking regulator.

**BSP** — Bangko Sentral ng Pilipinas. The Philippines' central bank.

---

## Payroll & statutory contributions

**CPF** — Central Provident Fund. Singapore's mandatory retirement and healthcare
savings scheme. Contributions split between employer and employee; rates vary by
age. → [payroll-compliance pack](autopilot/payroll-compliance/)

**EPF** — Employees Provident Fund (Malaysia). Mandatory retirement savings,
administered by KWSP. Employer and employee both contribute.

**BPJS** — Badan Penyelenggara Jaminan Sosial (Indonesia). National social
security agency with two arms: BPJS Ketenagakerjaan (employment/pension) and
BPJS Kesehatan (health insurance).

**SSS** — Social Security System (Philippines). Social insurance for private
sector employees covering sickness, maternity, disability, retirement, and death.

**PhilHealth** — Philippine Health Insurance Corporation. National health
insurance for all employed Filipinos, separate from SSS.

**Gross-to-net** — The calculation chain from an employee's gross salary to
take-home pay, after all statutory deductions, tax withholding, and voluntary
deductions are applied.

**Statutory filing** — Mandatory monthly submissions to government agencies
(CPF Board, KWSP, BPJS, SSS, PhilHealth) with associated payment. Late
submissions attract penalties.

---

## Accounting standards

**IFRS** — International Financial Reporting Standards. The global accounting
standard used in 150+ countries. Defines financial statement preparation and
presentation. → [accounting-audit pack](autopilot/accounting-audit/)

**SFRS** — Singapore Financial Reporting Standards. Singapore's local standard,
converged with IFRS. Administered by ACRA. Required for all Singapore-incorporated
companies.

**PSAK** — Pernyataan Standar Akuntansi Keuangan. Indonesia's accounting standards,
set by IAI. Converged with IFRS with local modifications.

**MFRS** — Malaysian Financial Reporting Standards. Malaysia's IFRS-converged
accounting standard, administered by MASB.

**ACRA** — Accounting and Corporate Regulatory Authority (Singapore). Regulates
business entities and public accountants; administers SFRS and annual filing.

**IAI** — Ikatan Akuntan Indonesia. Indonesia's Institute of Accountants; sets PSAK.

---

## Audit standards & methodology

**ISA 530** — International Standard on Auditing 530: Audit Sampling. Defines
how auditors statistically select transaction samples for testing, covering MUS,
random sampling, and projected misstatement calculation.

**MUS** — Monetary Unit Sampling. Audit sampling method where each currency unit
has equal selection probability, naturally weighting toward higher-value items.
Appropriate for financial statement audits.

**IAASB** — International Auditing and Assurance Standards Board. Sets the ISA
standards used by auditors in most countries outside the US.

---

## General accounting

**GL** — General Ledger. The master record of all financial transactions. Every
journal entry posts to the GL; subledger totals must reconcile to GL balances.

**Subledger** — A detailed subset of the GL for a specific category (e.g.
accounts receivable, accounts payable). Must always agree with the parent GL account.

**JE** — Journal Entry. A financial transaction record posted to the GL, always
with equal debits and credits. Unusual JEs are a key audit focus area.

**Variance analysis** — Comparison of actual results against budget or prior
period, with investigation of significant differences. Core to management
reporting and audit procedures.

**Materiality** — The threshold below which errors are unlikely to influence
financial statement users. Drives prioritisation in both audit sampling and
month-end review.

**Month-end close** — The recurring process of reconciling all accounts,
reviewing journal entries, and producing financial statements at period end.
Typically takes 2–5 business days manually; the accounting-audit pack targets
< 45 minutes.

---

## How to contribute a pack

If you're adding a new pack, add its domain-specific acronyms here under the
relevant section (or create a new section if the domain is not yet covered).
Keep entries concise: full name + one plain-English sentence + link to the pack.
