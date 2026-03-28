# Accounting & Audit Automation — MAWA Pack

**Quadrant:** Autopilot
**Market size:** $50–80B (global finance automation + audit tech)
**SEA relevance:** High — ASEAN finance teams face MAS/BNM/OJK audit requirements, IFRS/SFRS adoption pressure, and chronic understaffing in month-end close cycles

## Why MAWA fits here

Accounting and audit work is highly rules-based at the execution layer: GL reconciliation follows ledger matching rules, variance analysis compares against prior-period benchmarks, and audit sampling follows ISA 530 statistical methods. MAWA's Registration boundaries prevent agents from crossing into judgment territory (e.g., posting adjusting entries without human sign-off), while the MA→WA structure handles parallel processing of large GL extracts efficiently. The human oversight layer activates on any item exceeding variance thresholds or flagged by sampling as high-risk.

## Agent roster

| Agent | Role | Type |
|---|---|---|
| Iris | Managing Agent — coordinates month-end close, routes GL batches, escalates to CFO/auditor | MA |
| LedgerBot | GL reconciliation — matches subledger to GL, flags unreconciled items | WA |
| JournalBot | Journal entry review — validates JE authorization, cutoff, segregation of duties | WA |
| VarBot | Variance analysis — compares period-over-period, flags outliers above threshold | WA |
| SampleBot | Audit sampling — applies ISA 530 MUS/random sampling, generates sample selection | WA |
| ReportBot | Report generation — produces trial balance, reconciliation summary, audit pack | WA |

## Key workflows

1. **Month-End Close** (AP-ACC-001) — Triggers on close date; Iris dispatches GL extract to LedgerBot → JournalBot → VarBot in sequence; ReportBot assembles final close pack
2. **Audit Sample Selection** (AP-ACC-002) — Auditor submits population + parameters; SampleBot applies ISA 530 method; output is a structured sample list with selection rationale
3. **Journal Entry Batch Review** (AP-ACC-003) — JournalBot reviews all JEs in a period for authorization gaps, cutoff violations, segregation-of-duties breaches
4. **Variance Investigation** (AP-ACC-004) — VarBot compares current period vs prior period vs budget; flags items > threshold for CFO/controller review

## Sample throughput

| Metric | Target |
|---|---|
| Input unit | One GL extract (up to 50,000 line items) |
| Processing time | < 15 minutes per close cycle |
| Human review trigger | Any variance > 10% of account balance OR unreconciled item > $10,000 |
| Audit sample delivery | < 5 minutes after population upload |

## References

- IFRS (International Financial Reporting Standards) — global baseline
- SFRS (Singapore Financial Reporting Standards) — MAS-aligned, IFRS-convergent
- PSAK (Indonesia) — OJK-supervised, IFRS-convergent
- ISA 530 — Audit Sampling (IAASB) — governs SampleBot logic
- MAS Notice on Internal Controls
## Real-world reference

Capsio deployments in the manufacturing sector have validated position-level AI
agents reducing finance supervisor reporting tasks from 7+ hours/day to under
1 hour. The accounting-audit MAWA pack generalises this pattern to the finance
function across any industry vertical.

## Glossary

**IFRS** — International Financial Reporting Standards. The global accounting
standard used in 150+ countries. Defines how companies must prepare and present
financial statements. Required for publicly listed companies in most jurisdictions
outside the US.

**SFRS** — Singapore Financial Reporting Standards. Singapore's local accounting
standard, substantially converged with IFRS but with Singapore-specific
modifications. Administered by ACRA (Accounting and Corporate Regulatory Authority).
All Singapore-incorporated companies must follow SFRS.

**PSAK** — Pernyataan Standar Akuntansi Keuangan. Indonesia's accounting standards,
set by the IAI (Ikatan Akuntan Indonesia). Also largely converged with IFRS, with
Indonesia-specific requirements. Required for Indonesian-incorporated entities.

**ACRA** — Accounting and Corporate Regulatory Authority. Singapore's national
regulator for business entities and public accountants. Sets SFRS and administers
annual filing requirements.

**ISA 530** — International Standard on Auditing 530: Audit Sampling. The global
standard defining how auditors statistically select a sample of transactions to
test, rather than checking every single one. Covers MUS, random sampling, and
projected misstatement calculation.

**MUS** — Monetary Unit Sampling. An audit sampling method where each dollar
(or currency unit) in a population has an equal chance of being selected. This
naturally biases the sample toward higher-value items, which is appropriate for
financial statement audits where large transactions carry more risk.

**GL** — General Ledger. The master record of all financial transactions in an
accounting system. Every journal entry posts to the GL. Month-end close involves
reconciling the GL against subledgers to ensure they agree.

**Subledger** — A detailed subset of the general ledger for a specific category
— for example, the accounts receivable subledger lists every individual customer
invoice. The subledger total must always equal the corresponding GL account balance.

**JE** — Journal Entry. A record of a financial transaction posted to the GL,
always with equal debits and credits. JE review is a key audit procedure because
fraudulent or erroneous entries often appear as unusual journal postings.

**Variance analysis** — The process of comparing actual financial results against
budget or prior period figures, and investigating the reasons for significant
differences. A core part of management reporting and audit.

**Materiality** — A threshold below which errors or omissions are considered
unlikely to influence the decisions of financial statement users. Auditors and
accountants set a materiality threshold (e.g. 1% of revenue) and focus effort
on items above it.
