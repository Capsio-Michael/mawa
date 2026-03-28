# Next Wave — Insourced × Intelligence

**Quadrant:** Insourced work + Intelligence-based decisions
**AI timing:** Penetrates next — 12–24 months behind Autopilot (P2)
**Why:** These functions are done in-house, which means AI adoption requires
internal buy-in, change management, and integration with existing systems.
The work itself is intelligence-heavy and highly suited for AI — the friction
is organisational, not technical.

---

## Packs in this quadrant (5)

| Pack | Market size | One-line description |
|---|---|---|
| [supply-chain-procurement](supply-chain-procurement/) | ~$400B | Vendor evaluation, PO processing, and spend analytics |
| [pharmacy-back-office](pharmacy-back-office/) | ~$15B | Prescription validation, inventory management, and payer reconciliation |
| [wealth-mgmt-ops](wealth-mgmt-ops/) | ~$50B | Portfolio rebalancing, client reporting, and compliance monitoring |
| [medical-admin](medical-admin/) | ~$50B | Prior authorisation, referral management, and scheduling optimisation |
| [fund-administration](fund-administration/) | ~$100B | NAV calculation, investor reporting, and regulatory filing |

---

## MAWA fit rationale

Next Wave packs share two properties:

1. **Intelligence-dense** — decisions follow well-defined rules but require
   cross-referencing large datasets (pricing tables, formularies, regulations)
2. **Insourced** — the function sits inside the company, so deployment requires
   integration with internal systems and stakeholder alignment

The MAWA pattern here typically involves a lighter MA (often integrated with an
existing workflow system) and WAs that interface with internal data stores. The
Reflector loop is especially valuable because internal teams have strong opinions
about what "good" looks like — the Curator session captures that institutional knowledge.

---

## Timeline expectation

Autopilot packs are deployable today with off-the-shelf LLMs + document tools.
Next Wave packs typically require 1–3 additional integrations (ERP, formulary databases,
custodian APIs) before the WAs can run fully autonomously. Budget 12–24 months for
full penetration behind Autopilot timelines.

---

## 🔲 Scaffolded packs (ready to fill)

All 5 packs contain template files with `[REPLACE]` markers.
Copy `../_template/` conventions and follow `spec/MAWA-SPEC.md`.
