# MAWA — Multi-Agent Workspace Architecture

**Open governance architecture for multi-agent AI systems.**

> Give your AI agents a job title, not just a job.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MAWA Version](https://img.shields.io/badge/MAWA-v0.1.0-blue)](https://github.com/Capsio-Michael/mawa)
[![Reference Platform](https://img.shields.io/badge/Reference-OpenClaw-red)](https://openclaw.ai)

> **Three acronyms, one system:** MAWA is the architecture name. Within MAWA, agents are organized into two roles — **MA (Managing Agent)** coordinates the team, and **WA (Worker Agent)** executes the work.

---

## The Problem

You've built a multi-agent AI system. It works in demos.

Then in production:
- Agent A does something Agent B was supposed to do
- No one knows **why** a decision was made
- Adding Agent C **breaks** Agents A and B
- The same mistake happens **over and over**
- Your "autonomous" system needs constant babysitting

This is not a model problem. It's a **governance problem.**

---

## The Solution

MAWA gives every agent three things:

| Layer | What it is | What it prevents |
|---|---|---|
| **Registration** | What the agent CAN do — hard boundaries | Agents doing things they shouldn't |
| **Playbook** | What the agent SHOULD do — learned strategy | Agents making the same mistakes twice |
| **TaskRun** | What the agent DID do — audit trail | Black-box decisions |

And one routing layer — the **Dispatcher** — that automatically sends every incoming task to the right agent, based on a single source-of-truth table.

---

## Core Concepts

### Position = The atomic governance unit
Every agent belongs to a **Position** — a role with defined boundaries, responsibilities, and relationships. Just like in a real organization.

### MA (Managing Agent) = The brain
One per team. Handles routing, quality oversight, cross-agent coordination via IPCP, and Playbook governance. Delegates all execution to WAs — never does WA work directly.

### WA (Worker Agent) = The hands
Multiple per team. Each WA has a **Registration** (what it can do), **Playbook** (how it should decide), and executes structured **ATCs** (task cards) with a full **TaskRun** audit trail.

### ATC (Agent Task Card) = The work order
Every task is defined with four sections:
- **W** — What is the work and why does it matter?
- **H** — How is it executed, step by step?
- **A** — What is automated, and what tools are needed?
- **T** — How do we verify the output quality?

No ATC = no execution. ATCs eliminate ad-hoc agent behavior.

### IPCP (Inter-Position Communication Protocol)
Structured cross-agent communication. Every message declares intent, sender, receiver, and correlation ID. No agent can communicate with another without explicit Registration permission.

### Reflector → Curator → SOTA
The self-improvement loop. TaskRuns feed a weekly **Reflector** that generates Playbook improvement candidates. A **Curator** session lets the owner review and approve changes. Approved bullets promote the Playbook from PILOT to SOTA.

---

## Quick Start (OpenClaw)

```bash
git clone https://github.com/Capsio-Michael/mawa.git
cd mawa/implementations/openclaw
chmod +x setup.sh && ./setup.sh
```

Full guide: [implementations/openclaw/README.md](implementations/openclaw/README.md)

---

## What's Included

### Core Specification (`/spec`)
Platform-independent. Implement on any agent framework.
- `MAWA-SPEC.md` — Full architecture specification
- `REGISTRATION-SCHEMA.md` — Capability declaration standard
- `ATC-SCHEMA.md` — Task card format
- `PLAYBOOK-SCHEMA.md` — Strategy bullet format
- `IPCP-PROTOCOL.md` — Cross-agent communication standard
- `DISPATCH-TABLE-SCHEMA.md` — Routing table standard

### Reference Implementation (`/implementations/openclaw`)
Fully working on OpenClaw. Clone and run.
- 1 MA (FClaw) + 4 WAs (Booky, Michael, Pepper, Stocky)
- All 4 core skills (Dispatcher, Reflector, Curator, Audit)
- `setup.sh` — one-command bootstrap
- 5-test validation suite

### Industry Use-Case Packs (`/use-cases`)
34 industry packs organized by the Sequoia AI disruption matrix.

| Quadrant | Packs | AI timing |
|---|---|---|
| [Autopilot](use-cases/autopilot/) — Outsourced + Intelligence | 13 packs | Replaces now (P1) |
| [Next Wave](use-cases/next-wave/) — Insourced + Intelligence | 5 packs | Penetrates next (P2) |
| [Copilot](use-cases/copilot/) — Outsourced + Judgment | 4 packs | Augments, not replaces (P3) |
| [Watch](use-cases/watch/) — Insourced + Judgment | 12 packs | Slower adoption (P3) |

Fully built packs (with agents, workflows, sample data): **KYC/AML** and **Payroll & Compliance**.
All 32 remaining packs are scaffolded and ready to fill.

See [use-cases/README.md](use-cases/README.md) for the full directory.

---

## The 5-Test Validation Suite

Every MAWA implementation must pass these 5 tests:

| Test | What it verifies |
|---|---|
| Test 1 — Registration Boundary | WA refuses out-of-scope request + writes deny log |
| Test 2 — ATC Execution | Task produces structured output + TaskRun written to disk |
| Test 3 — Quality Gate | Malformed input triggers FAIL + retry + Error-Report |
| Test 4 — IPCP | Double failure produces Error-Report in correct format |
| Test 5 — Playbook Bullet | Condition triggers matching bullet, cited in TaskRun |

All 5 passing = your MAWA team is production-ready.

---

## Why MAWA vs Other Frameworks

| | AutoGen | CrewAI | LangGraph | **MAWA** |
|---|---|---|---|---|
| Hard capability boundaries | ❌ | ❌ | Partial | ✅ |
| Audit trail per task | ❌ | ❌ | ❌ | ✅ |
| Evolving strategy (Playbook) | ❌ | ❌ | ❌ | ✅ |
| Automatic task routing | ❌ | Partial | ❌ | ✅ |
| Cross-agent protocol | ❌ | ❌ | ❌ | ✅ |
| Self-improving agents | ❌ | ❌ | ❌ | ✅ |
| Enterprise governance | ❌ | ❌ | Partial | ✅ |

MAWA doesn't replace these frameworks — it governs them. You can run AutoGen agents inside a MAWA Position.

---

## Implementing on Other Frameworks

MAWA is platform-agnostic. The `/spec` directory contains everything needed to implement on:

- **AutoGen** — use Registration as agent system prompts + tool restrictions
- **CrewAI** — map Positions to Crews, ATCs to Tasks, Playbooks to agent backstories
- **LangGraph** — Registration as node constraints, IPCP as edge conditions
- **Any LLM framework** — the spec defines behavior, not implementation

We welcome implementations. See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Real-World Validation

> "审核是很重要的，能做好这件事本身就是未来智能体应用不断提升的一个基础。" — Michael Capsio

MAWA v0.1.0 has been deployed and validated in production on two platforms:

| Implementation | Platform | Team | Status |
|---|---|---|---|
| [OpenClaw](implementations/openclaw/) | OpenClaw | FClaw (1 MA + 4 WAs) | ✅ 5-test suite passed, daily production use |
| [ArkClaw](implementations/arkclaw/) | ArkClaw (火山引擎) | Apple HR (1 MA + 5 WAs) | ✅ Live, processing real candidates |

Both implementations passed the full 5-test validation suite. Key findings from production:

- **Registration boundaries hold** — WAs refused out-of-scope requests on first test, deny logs written correctly
- **IDENTITY.md behavioral rules** — embedding Hard Rules in IDENTITY.md produces more reliable enforcement than SOUL.md alone (confirmed independently on both platforms)
- **SESSION-CONTEXT.md as mid-term memory** — solves cross-session context loss on platforms that reset conversation history (see Memory Architecture in [MAWA-SPEC.md](spec/MAWA-SPEC.md))
- **Platform portability confirmed** — zero changes to MAWA spec between OpenClaw and ArkClaw deployments

See [OPENCLAW-LEARNINGS.md](implementations/openclaw/OPENCLAW-LEARNINGS.md) for detailed findings from v0.1.0 testing.

---

## What's Next — v0.2.0

MAWA v0.1.0 governs the X-axis: what agents can do, how tasks are routed, how failures escalate.

What it doesn't yet govern is the Y-axis: **how good the agent's work actually is, and how it gets better over time.**

The current Reflector → Curator loop improves Playbook strategy based on task outcomes. But it relies on the agent's own `quality_gate` assessment — which is self-reported. There is no independent verification that the agent did the right thing, the right way, in the right direction.

v0.2.0 adds the Y-axis: **third-party evaluation of ATC execution quality.**

See [ROADMAP-v0.2.0.md](docs/ROADMAP-v0.2.0.md) for the full plan.

---

## v0.2.0 — The Y-Axis (in progress)

v0.1.0 governs what agents do. v0.2.0 adds evaluation of how well they
do it — and a structured path for that quality to improve over time.

### New in v0.2.0

| Component | Status |
|---|---|
| `mawa-evaluator-internal` skill | 🔨 In progress |
| TaskRun schema update (evaluation field) | 🔨 In progress |
| Per-TaskRun visualization | Planned 4/1 |
| Registration runtime enforcement | Planned 3/31 |
| Benchmark — MAWA vs baseline | Planned 4/2 |

### The improvement loop

```
Execute (ATC) → Record (TaskRun) → Evaluate (Internal) →
Flag (Expert) → Reflect → Curate → Evolve (Playbook) →
Execute better next time
```

See [roadmap-v0.2.0.md](docs/ROADMAP-v0.2.0.md) for full detail.

---

## Roadmap

- [ ] `mawa-validate` CLI tool
- [ ] `mawa-add-agent` interactive scaffold
- [ ] Implementations for AutoGen, CrewAI, LangGraph
- [ ] Web UI for Curator sessions
- [ ] More industry packs
- [ ] MAWA compliance badge

---

## Contributing

MAWA grows through community implementations and industry packs.

- **New implementation?** Add to `/implementations/{your-framework}/`
- **New industry pack?** Add to `/packs/{your-use-case}/`
- **Spec improvement?** Open an issue with the `[spec]` tag

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT — free for personal and commercial use.

---

## Acknowledgments

MAWA was designed by [Michael Capsio](https://github.com/Capsio-Michael) based on 3 months of production multi-agent deployment experience. Reference implementation runs on [OpenClaw](https://openclaw.ai).

*The core insight — that AI agents need job titles, not just job descriptions — came from watching enterprise AI projects fail in production for governance reasons that have nothing to do with model capability.*

---

*Built with 🦞 on OpenClaw*
