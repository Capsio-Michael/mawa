# Autopilot — Outsourced × Intelligence

**Quadrant:** Outsourced work + Intelligence-based decisions
**AI timing:** Replaces now (P1)
**Why:** These are already outsourced to humans who follow rules. The work is
high-volume, rules-heavy, and auditable. AI matches or exceeds human accuracy
at a fraction of the cost — and the client is already comfortable with
third-party delivery.

---

## Packs in this quadrant (13)

| Pack | Market size | One-line description |
|---|---|---|
| [kyc-aml](kyc-aml/) | ~$3B | Customer identity verification and sanctions screening |
| [payroll-compliance](payroll-compliance/) | ~$10B | Gross-to-net calculation and statutory filing across SEA jurisdictions |
| [accounting-audit](accounting-audit/) | ~$5B | GL reconciliation, ledger review, and audit evidence packaging |
| [it-managed-services](it-managed-services/) | ~$500B | Tier-1 ticket triage, incident classification, and runbook execution |
| [insurance-brokerage](insurance-brokerage/) | ~$200B | Policy comparison, premium calculation, and application processing |
| [claims-adjusting](claims-adjusting/) | ~$50B | Claims intake, document extraction, and settlement recommendation |
| [healthcare-rev-cycle](healthcare-rev-cycle/) | ~$40B | Insurance eligibility check, coding review, and claims submission |
| [paralegal-lpo](paralegal-lpo/) | ~$40B | Contract review, clause extraction, and legal research summarisation |
| [mortgage-origination](mortgage-origination/) | ~$25B | Application processing, income verification, and credit packaging |
| [tax-advisory](tax-advisory/) | ~$30B | Tax return preparation, deduction identification, and filing |
| [legal-transactional](legal-transactional/) | ~$100B | Due diligence, document drafting, and transaction management |
| [real-estate-closing](real-estate-closing/) | ~$20B | Title search, closing document preparation, and escrow management |
| [cost-estimation](cost-estimation/) | ~$10B | Bill-of-materials pricing, vendor comparison, and estimate generation |

---

## MAWA fit rationale

Autopilot packs share three properties:

1. **Rule-dense** — decision logic is encodable as Registration hard rules + Playbook bullets
2. **Auditable** — regulators or clients require traceable decision trails (TaskRun covers this)
3. **Outsourced** — the incumbent delivery model is already third-party, so AI substitution
   faces no internal culture resistance

The MA receives work units from an intake channel, dispatches to specialist WAs for
each sub-task, runs quality gates, and delivers structured output. Human review is
triggered only on low-confidence or exception cases.

---

## ✅ Fully built packs

- [kyc-aml](kyc-aml/) — complete with sample input/output
- [payroll-compliance](payroll-compliance/) — complete with sample input/output

## 🔲 Scaffolded packs (ready to fill)

All remaining 11 packs contain template files with `[REPLACE]` markers.
Copy `../_template/` conventions and follow `spec/MAWA-SPEC.md`.
