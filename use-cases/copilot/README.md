# Copilot — Outsourced × Judgment

**Quadrant:** Outsourced work + Judgment-based decisions
**AI timing:** Augments, does not replace (P3)
**Why:** These services are sold on expert judgment and client relationships.
The work is outsourced but the value is in human insight, creative direction,
or strategic recommendation. AI can dramatically accelerate research, drafting,
and synthesis — but the human remains the decision-maker and the face to the client.

---

## Packs in this quadrant (4)

| Pack | Market size | One-line description |
|---|---|---|
| [management-consulting](management-consulting/) | $300–400B | Research synthesis, slide drafting, and analysis automation for consulting teams |
| [graphic-ux-design](graphic-ux-design/) | ~$100B | Brief interpretation, asset generation, and design iteration support |
| [executive-search](executive-search/) | ~$15B | Candidate research, profile synthesis, and outreach drafting |
| [pr-comms](pr-comms/) | ~$100B | Media monitoring, press release drafting, and coverage analysis |

---

## MAWA fit rationale

Copilot packs use a different MA topology than Autopilot:

- The **MA** acts as a research and drafting coordinator — it does NOT deliver final output
- **WAs** handle high-volume, rules-amenable sub-tasks: web scraping, document summarisation,
  competitor monitoring, first-draft generation
- The **human expert** reviews MA output, applies judgment, and delivers to the client
- The **quality_gate** in Copilot packs escalates earlier (confidence threshold: 0.70)
  because the human is always in the loop before delivery

The value proposition is throughput: a consultant supported by a MAWA Copilot pack
can handle 3–5× more client work without sacrificing quality on the judgment layer.

---

## Design principle: human as final gate

In Autopilot packs, human review is an exception path.
In Copilot packs, human review is the default final step — every output passes
through the human before delivery. The MAWA governance layer ensures the human
receives well-structured, fully cited, ready-to-edit content rather than raw AI output.

---

## 🔲 Scaffolded packs (ready to fill)

All 4 packs contain template files with `[REPLACE]` markers.
Copy `../_template/` conventions and follow `spec/MAWA-SPEC.md`.
