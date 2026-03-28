# MAWA Industry Use-Case Packs

Each pack shows how to deploy a MAWA-standard agent team for a specific
industry vertical, following the Sequoia AI disruption matrix.

## Quadrant key

| Quadrant | Axis | AI timing | Priority |
|---|---|---|---|
| **Autopilot** | Outsourced + Intelligence | Replaces now | P1 |
| **Next Wave** | Insourced + Intelligence | Penetrates next | P2 |
| **Copilot** | Outsourced + Judgment | Augments, not replaces | P3 |
| **Watch** | Insourced + Judgment | Slower adoption | P3 |

## Pack structure

Every pack contains:

| File | Purpose |
|---|---|
| `README.md` | Industry context, MAWA fit rationale, agent roster |
| `AGENTS.md` | MA + WA definitions with IDENTITY blocks |
| `WORKFLOW.md` | ATC task cards and dispatch table |
| `SESSION-CONTEXT.md` | Memory layer seed for the team |
| `sample-input/` | Representative raw inputs (redacted) |
| `sample-output/` | Expected structured outputs |

## Contribution guide

Copy `_template/` into the correct quadrant folder and fill in each file.
Follow the naming conventions in `spec/MAWA-SPEC.md`.

See [GLOSSARY.md](GLOSSARY.md) for definitions of all regulatory frameworks,
accounting standards, and industry terms used across the packs. Add new terms
when contributing a pack.
