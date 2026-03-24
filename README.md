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

### Industry Packs (`/packs`)
Drop-in MAWA configurations for specific use cases.

| Pack | Agents | Use Case |
|---|---|---|
| `tech-team` | Quality Architect + Summarist + Assistant | R&D team daily operations |
| `customer-ops` | Support + QA + Knowledge + Escalation | Customer service automation |
| `trading` | Market Monitor + Risk + Report + Alert | Financial data operations |
| `manufacturing` | QC + Process Engineer + Equipment + Scheduler | Factory floor AI |

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

MAWA is not a research project. It is a production framework with a 3-year enterprise deployment history.

### The Track Record

**2023 — Enterprise Data Governance**
Capsio (the team behind MAWA) achieved SAP global integration certification and launched on the SAP App Store with an enterprise data governance platform. Core insight: enterprise AI fails not because of model capability, but because of missing standards, traceability, and governance.

**2024 — Agentic Task Card + MAWA Framework**
The ATC (Agentic Task Card) and MAWA architecture were formalized as a position-based AI governance system. Recognized with the Future AI Pioneer Award at the 2024 German Asia-Pacific Business Summit (AHK), co-presented with SAP China Research Institute.

> "Capsio's AI-driven data governance platform... enables enterprises to achieve position task digitization, process intelligence, and decision data-driven operations."
> — SAP China Research Institute

**2025 — Human-Robot Collaboration**
MAWA extended beyond software agents to physical execution. The framework now governs warehouse task automation spanning SAP LGM → Capsio ATC → humanoid robots. Robot-agnostic by design — currently integrated with MagicLab and Unitree robots, with a vendor-neutral connection layer that supports robots from different manufacturers. The full platform is available on the SAP App Store as the ATC Intelligent Task Orchestration Platform.

- Generates, assigns, and executes warehouse tasks intelligently
- Supports MagicLab bipedal humanoid robots for high-risk and repetitive operations
- Selected as Top 3 Best Case at AHK Innovation Night 2025
- Live demo environment visited by 670+ enterprise customers at SAP China Research Institute Future Exhibition Hall

### What This Means for MAWA

The same governance principles that coordinate AI agents — Registration boundaries, ATC task cards, Playbook strategy evolution, IPCP communication protocol, TaskRun audit trails — have been validated at every layer of enterprise operations:

```
SAP ERP Data Layer
      ↓
MAWA Position Agents (MA + WA)
      ↓
Humanoid Robot Execution (MagicLab)
```

MAWA is not designed for demos. It is designed for production environments where agents must be accountable, auditable, and continuously improving — just like the human employees they work alongside.

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
