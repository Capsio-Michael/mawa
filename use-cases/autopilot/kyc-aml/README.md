# KYC/AML Verification — MAWA Pack

**Quadrant:** Autopilot
**Market size:** ~$3B (identity verification services); KYC process costs $25–50M/year for large banks
**SEA relevance:** High — MAS (Singapore), BNM (Malaysia), OJK (Indonesia), BSP (Philippines),
and SBV (Vietnam) all mandate customer due diligence under FATF standards.

## Why MAWA fits here

KYC/AML decisions follow codified rules: FATF recommendations, OFAC/UN/EU sanctions lists,
and country-specific CDD regulations. The MA→WA structure maps naturally — one agent per
verification layer (document, risk, audit) — with the MA aggregating verdicts and escalating
edge cases to compliance officers. Every decision requires a traceable audit trail,
which TaskRun provides by design.

## Agent roster

| Agent | Role | Type |
|---|---|---|
| Vera | Managing Agent — KYC verification coordinator | MA |
| DocBot | Document authenticity checker (passport, ID, utility bill) | WA |
| RiskBot | PEP/sanctions screening against OFAC, UN, EU lists | WA |
| AuditBot | Compliant audit trail generator for regulators | WA |

## Key workflows

1. **Customer onboarding** — Full KYC flow from application receipt to pass/refer/reject decision
2. **Periodic review** — Re-verification of existing customers on annual cycle
3. **Transaction monitoring** — Flag unusual patterns for AML review

## Sample throughput

| Metric | Target |
|---|---|
| Input unit | One customer onboarding application |
| Processing time | < 4 minutes per application |
| Human review trigger | PEP match, sanctions hit, confidence < 0.80 on any document field |
| False positive rate | < 15% (industry benchmark for sanctions screening) |

## Compliance references

- FATF Recommendations 10–12 (Customer Due Diligence)
- MAS Notice SFA 04-N02 (Singapore)
- BNM AML/CFT Policy (Malaysia)
- OJK Regulation No. 12/POJK.01/2017 (Indonesia)
- OFAC SDN List, UN Consolidated List, EU Consolidated Financial Sanctions List

## Glossary

**KYC** — Know Your Customer. The process of verifying a customer's identity
before onboarding them. Regulators require it to prevent fraud and financial crime.

**AML** — Anti-Money Laundering. Rules and checks designed to detect and prevent
criminals from disguising illegally obtained funds as legitimate income.

**MAS** — Monetary Authority of Singapore. Singapore's central bank and financial
regulator. Sets the KYC/AML requirements that all Singapore-licensed financial
institutions must follow.

**OFAC** — Office of Foreign Assets Control. A US Treasury agency that publishes
the global sanctions list — individuals, entities, and countries that cannot be
transacted with. Screening against OFAC is required for any institution with USD
exposure or US correspondent banking relationships.

**FATF** — Financial Action Task Force. An intergovernmental body that sets the
global AML/KYC standards adopted by 200+ jurisdictions. Countries on the FATF
grey list or black list require enhanced due diligence from counterparties worldwide.

**PEP** — Politically Exposed Person. A current or former government official,
or close associate, who carries elevated money laundering risk due to their
access to public funds. PEP matches require enhanced due diligence.

**EDD** — Enhanced Due Diligence. A deeper level of customer verification applied
when standard checks flag elevated risk — for example, a PEP match or high-risk
jurisdiction. Typically requires human review.
