# Watch — Insourced × Judgment

**Quadrant:** Insourced work + Judgment-based decisions
**AI timing:** Slower adoption — monitor and re-evaluate (P3)
**Why:** These functions combine internal ownership with high judgment content.
The decisions are contextual, relationship-dependent, or creatively driven.
AI can handle the research and data layers, but the core value — human assessment,
relationship management, creative strategy — resists full automation.

---

## Packs in this quadrant (12)

| Pack | Market size | One-line description |
|---|---|---|
| [recruitment](recruitment/) | ~$600B | Candidate sourcing and screening support (judgment-heavy side) |
| [advertising](advertising/) | ~$800B | Campaign brief interpretation, audience analysis, and performance reporting |
| [freight-brokerage](freight-brokerage/) | ~$100B | Load matching, carrier negotiation support, and shipment tracking |
| [admin-assistants](admin-assistants/) | ~$100B | Calendar management, email triage, and internal coordination |
| [clinical-trials-cro](clinical-trials-cro/) | ~$50B | Protocol review, site monitoring support, and data cleaning |
| [seo-sem](seo-sem/) | ~$100B | Keyword research, content gap analysis, and campaign reporting |
| [erp-implementation](erp-implementation/) | ~$50B | Requirements gathering, configuration documentation, and testing support |
| [corporate-training](corporate-training/) | ~$400B | Content development, assessment generation, and learner progress tracking |
| [market-research](market-research/) | ~$100B | Survey design, data collection, and insight synthesis |
| [cybersecurity](cybersecurity/) | ~$200B | Threat intelligence aggregation, alert triage, and incident documentation |
| [patent-ip](patent-ip/) | ~$20B | Prior art search, claim drafting support, and portfolio analysis |
| [travel-mgmt](travel-mgmt/) | ~$150B | Itinerary optimisation, policy compliance checking, and expense reconciliation |

---

## MAWA fit rationale

Watch packs have the highest judgment content of any quadrant. The MAWA pattern here is:

1. **WAs handle the data layer** — research, aggregation, document extraction, monitoring
2. **MA synthesises and structures** — packages WA outputs into a decision-ready format
3. **Human makes the judgment call** — always in the loop for the core decision

The Reflector → Curator loop is particularly valuable in Watch packs because the
"what good looks like" judgment evolves quickly. Expert evaluation (v0.2.0 evaluator)
is the primary mechanism for capturing that evolving standard.

---

## Note on Recruitment placement

Recruitment appears in Watch (not Autopilot) because the high-value work —
interview assessment, cultural fit judgment, offer negotiation — is deeply judgment-based
and relationship-dependent. The Sourcer WA in the ArkClaw Apple HR implementation
handles the intelligence layer (resume screening, scoring); the human makes the hiring call.
This split is the correct MAWA pattern for this quadrant.

---

## Watch ≠ Do Nothing

"Watch" means: deploy AI on the data and research layers now, monitor AI capability
advances on the judgment layer, and be ready to shift more work to automation as
models improve. These markets are too large to ignore.

---

## 🔲 Scaffolded packs (ready to fill)

All 12 packs contain template files with `[REPLACE]` markers.
Copy `../_template/` conventions and follow `spec/MAWA-SPEC.md`.
