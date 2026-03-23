# MAWA — Manage Agent + Work Agent

**Open governance architecture for multi-agent AI systems.**

> Give your AI agents a job title, not just a job.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MAWA Version](https://img.shields.io/badge/MAWA-v0.1.0-blue)](https://github.com/Capsio-Michael/mawa)
[![Reference Platform](https://img.shields.io/badge/Reference-OpenClaw-red)](https://openclaw.ai)

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

### MA (Manage Agent) = The brain
One per team. Handles routing, quality oversight, cross-agent coordination (IPCP), and strategy execution. FClaw in the reference implementation.

### WA (Work Agent) = The hands
Multiple per team. Each WA has a **Registration** (capabilities), **Playbook** (strategy), and executes structured **ATCs** (task cards) with a **TaskRun** audit trail.

### ATC (Agentic Task Card) = The work order
Every task is defined with:
- **W** — What is the work?
- **H** — How is it done?
- **A** — What can be automated?
- **T** — How do we verify quality?

### IPCP (Inter-Position Communication Protocol)
Structured cross-agent communication. Every message has a declared intent, sender, receiver, and correlation ID. No agent can talk to another without explicit Registration permission.

### Reflector → Curator → SOTA
The learning loop. TaskRuns feed a weekly Reflector that generates Playbook candidates. A Curator session (human + MA) reviews and promotes the best ones. Playbooks evolve from PILOT to SOTA over time.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│              Registration Layer                  │
│     (Capability boundaries for all agents)       │
└──────────────────────┬──────────────────────────┘
                       │
         ┌─────────────▼─────────────┐
         │      Manage Agent (MA)    │
         │  FClaw — the team brain   │
         │  • MAWA Dispatcher        │
         │  • Quality Gate           │
         │  • IPCP Router            │
         │  • Curator authority      │
         └──┬──────┬──────┬──────┬──┘
            │      │      │      │
     ┌──────▼─┐ ┌──▼───┐ ┌▼────┐ ┌▼──────┐
     │  WA-1  │ │ WA-2 │ │WA-3 │ │ WA-4  │
     │Quality │ │Summ- │ │Per- │ │Moni-  │
     │Archit. │ │arist │ │Asst │ │tor    │
     └────────┘ └──────┘ └─────┘ └───────┘
            │      │      │      │
            └──────┴──────┴──────┘
                       │
              TaskRun Store (audit)
                       │
              Reflector (weekly)
                       │
              Curator (human review)
                       │
              Playbook SOTA (deployed)
```

---

## Quick Start (OpenClaw)

### Prerequisites
- [OpenClaw](https://openclaw.ai) installed and running
- A Feishu/Lark workspace (or adapt for your messaging platform)

### Install

```bash
git clone https://github.com/Capsio-Michael/mawa
cd mawa
chmod +x setup.sh
./setup.sh
```

### What setup.sh does
1. Copies the MAWA workspace structure to `~/.openclaw/workspace/mawa/`
2. Installs 4 core skills: `mawa-dispatcher`, `mawa-reflector`, `mawa-curator`, `mawa-audit`
3. Sets up cron jobs for the learning loop (Sunday 22:00 Reflector, 22:30 Audit)
4. Creates your first MA Registration (FClaw)

### Configure your first WA

```bash
# Interactive WA generator — answers 5 questions, creates all files
./scripts/mawa-add-agent.sh
```

Or copy the template manually:
```bash
cp -r implementations/openclaw/workspace/agents/_template \
      ~/.openclaw/workspace/mawa/agents/my-new-agent
```

### Validate your setup

```bash
./scripts/mawa-validate.sh
```

Checks: Registration files present, ATC schemas valid, Playbook bullets within capability boundaries, IPCP scope declared.

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
- Complete workspace structure
- 4 WA templates (Quality Architect, Summarist, Personal Assistant, Monitor)
- All 4 core skills (Dispatcher, Reflector, Curator, Audit)
- Cron setup scripts
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

**Test 1 — Registration Boundary**
Ask a WA to access data outside its declared domain → expect refusal + deny log entry

**Test 2 — ATC Execution + TaskRun**
Trigger a task → expect structured output matching ATC schema + TaskRun written to disk

**Test 3 — Quality Gate**
Submit malformed input → expect quality_gate = FAIL + retry behavior

**Test 4 — IPCP**
Simulate double failure → expect [IPCP] Error-Report to MA in correct format

**Test 5 — Playbook Bullet**
Trigger a specific condition → expect the matching Playbook bullet to fire and be cited in TaskRun

All 5 tests passing = your MAWA team is production-ready.

---

## Implementing on Other Frameworks

MAWA is platform-agnostic. The `/spec` directory contains everything needed to implement on:

- **AutoGen** — use Registration as agent system prompts + tool restrictions
- **CrewAI** — map Positions to Crews, ATCs to Tasks, Playbooks to agent backstories
- **LangGraph** — Registration as node constraints, IPCP as edge conditions
- **Any LLM framework** — the spec defines behavior, not implementation

We welcome implementations! See [CONTRIBUTING.md](CONTRIBUTING.md).

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

## Real-World Validation

MAWA was developed and validated over 3 months building a production multi-agent team:

- **4 WAs** running in parallel (Quality Architect, Summarist, Personal Assistant, Stock Monitor)
- **20/20 tests passing** across all agents
- **Daily operations** including quality review of R&D assets, meeting summarization, personal scheduling, stock monitoring
- **Self-improving** — Playbooks have evolved from v1 PILOT to SOTA through the Reflector/Curator loop
- **Zero governance failures** — no agent has accessed data outside its Registration in production

---

## Roadmap

- [ ] `mawa-validate` CLI tool
- [ ] `mawa-add-agent` interactive generator
- [ ] Web UI for Curator sessions
- [ ] MAWA compliance badge
- [ ] Implementations for AutoGen, CrewAI, LangGraph
- [ ] More industry packs
- [ ] MAWA Hub — community pack registry

---

## Contributing

MAWA grows through community implementations and industry packs.

- **New implementation?** Add to `/implementations/your-framework/`
- **New industry pack?** Add to `/packs/your-use-case/`
- **Spec improvement?** Open an issue with `[spec]` tag

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT — free for personal and commercial use.

---

## Acknowledgments

MAWA was designed by [Li Zhongtao (Michael Capsio)](https://github.com/Capsio-Michael) based on real-world multi-agent system deployment experience. Architecture validation was conducted on the OpenClaw platform.

The core insight — that AI agents need job titles, not just job descriptions — came from watching enterprise AI projects fail in production for governance reasons that have nothing to do with model capability.

---

*Built with 🦞 on OpenClaw*
