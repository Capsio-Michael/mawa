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

# MAWA v0.2.0 Upgrade Plan
## Third-Party Evaluation + ATC Execution Visualization

> "审核是很重要的，能做好这件事本身就是未来智能体应用不断提升的一个基础。" — Michael Capsio

---

## The Y-Axis Problem

MAWA v0.1.0 governs the X-axis: what agents can do, how tasks are routed, how failures escalate.

What it doesn't yet govern is the Y-axis: **how good the agent's work actually is, and how it gets better over time.**

The current Reflector → Curator loop improves Playbook strategy based on task outcomes. But it relies on the agent's own quality_gate assessment — which is still self-reported. There is no independent verification that the agent did the right thing, the right way.

v0.2.0 adds the Y-axis: **third-party evaluation of ATC execution quality.**

---

## Core Concept: Third-Party Evaluator as Plugin

The evaluator is not a judge added after the fact. It is a plugin that plugs into the ATC execution flow, observing the full picture of what happened:

```
ATC Execution Flow (with Evaluator)

Input → [WA Executes ATC] → Output
              ↓
         TaskRun written
              ↓
    [Evaluator Plugin triggered]
         ↓           ↓
   Internal       Expert
   Evaluation     Evaluation
         ↓           ↓
    Score + Feedback fed into Reflector
              ↓
         Playbook evolves
```

The evaluator sees:
- **Input** — what was submitted
- **Process** — the conversation/reasoning trace
- **Output** — what was delivered
- **TaskRun** — the structured audit record

It does NOT just look at the output. It evaluates the full execution path.

---

## Two Evaluation Tracks

### Track 1 — Internal Evaluation (Automated)
Runs automatically after every ATC execution.

**What it evaluates:**
- Did the output match the ATC's T (Test) criteria?
- Were the correct Playbook bullets applied?
- Was the execution stable? (retries, timeouts, quality_gate flips)
- Was the information retrieved accurate? (cross-validation where possible)
- Was the result delivered to the correct channel?

**Output:**
- Internal quality score (0-100)
- Dimension breakdown (accuracy, completeness, process adherence, delivery)
- Candidate Playbook bullets for Reflector
- Flag for Expert Evaluation if score < threshold

**Implementation:**
- New skill: `mawa-evaluator-internal`
- Triggered automatically after every TaskRun write
- Results appended to TaskRun as `evaluation` field
- Feeds directly into Reflector's weekly analysis

---

### Track 2 — Expert Evaluation (Human or Expert Agent)
Triggered for flagged TaskRuns or on-demand.

**What it is:**
An expert evaluator — human expert or expert AI agent — reviews the full execution record and provides qualitative assessment.

The expert is NOT just reading the output. They review:
- The task input and context
- The reasoning/conversation trace
- The output
- The internal evaluation score
- Their domain expertise about what "good" looks like

**Example:** Michael (Quality Architect WA) evaluates R&D assets. An expert evaluator reviews Michael's evaluations — not the assets themselves, but Michael's judgment. Did Michael apply the A-B-C criteria correctly? Was the score fair? Was the red line decision justified?

**Output:**
- Expert score and qualitative feedback
- Correction to internal score if needed
- Strategic guidance fed into Curator session
- Human intent injected into Playbook evolution direction

**Key principle:**
> "人需给出方向和赛道领域，在人给定的方向上，智能体在优化角度会比使用的人强很多。"

The expert doesn't micromanage execution. They set the direction. The agent optimizes within that direction.

---

## ATC Execution Visualization

### The Problem
Today, ATC execution is a black box from the outside. You can read TaskRun JSON files, but there's no visual way to see what happened, why, and whether it was good.

### The Solution
A lightweight visualization layer that makes every ATC execution inspectable.

**Per-TaskRun view:**
```
ATC-MICHAEL-ASSET-EVALUATE | 2026-03-25 09:46
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Input:    Asset "B20260325-1" submitted by 许鹏飞
Result:   FAIL ❌ | Score: 0/100
Red Line: A-layer missing 6-digit code

Process:  ████████████████░░░░ 4.2s
Retries:  0
Quality:  FAIL → not retried (red line = auto-fail)

Playbook: E-000 triggered (asset routing from MA)
          Q-001 not triggered (coordinate N/A)

IPCP:     Error-Report → FClaw ✅
Delivery: Group thread + owner DM ✅

Internal Eval:  72/100 (process adherence high, red line correctly applied)
Expert Eval:    Pending
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Team dashboard view:**
```
Team Performance | Week of 2026-03-24
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Position  | Executions | Pass Rate | Avg Score | Trend
Booky     |     7      |   86%     |    78     |  ↑
Michael   |    12      |   67%     |    71     |  →
Pepper    |    14      |   93%     |    84     |  ↑
Stocky    |    10      |   90%     |    88     |  ↑
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Playbook Efficiency: 64% (↑ from 51% last week)
Expert Evals Pending: 3
```

---

## Implementation as MAWA Plugin

The evaluator is designed as a plugin — not a core MAWA component — because:
1. Different deployments need different evaluation criteria
2. Expert evaluation requires domain-specific knowledge
3. Not every team needs full expert evaluation from day one

**Plugin interface:**
```yaml
---
plugin_id: mawa-evaluator
plugin_type: post-execution
trigger: after_taskrun_write
input:
  - taskrun_json
  - atc_file
  - registration_file
  - playbook_file
output:
  - evaluation_score
  - dimension_scores
  - feedback
  - playbook_candidates
  - expert_flag: boolean
---
```

Any team can implement their own evaluator plugin following this interface. The core MAWA spec remains unchanged.

---

## The Y-Axis Problem — Why Third-Party Evaluation Matters

Justin Zhao's essay [*The Y-Axis Problem*](https://www.justinxzhao.com/blog/2026/the-y-axis-problem/) (March 2026) frames the core challenge that MAWA's evaluation layer is designed to address.

Karpathy's autoresearch demonstrates that when you have a clean, cheap-to-compute metric (val_bpb) and a fast iteration loop, AI can autonomously optimize better than human experts. The optimizer works. But as Justin argues:

> *"When optimization is cheap and automated, the hard part becomes something else entirely: choosing what to optimize."*

He documents how well-intentioned metrics consistently backfire — No Child Left Behind optimized test scores while undermining actual learning; YouTube's watch time metric optimized engagement while degrading viewer wellbeing; the "pain as fifth vital sign" initiative optimized pain scores while fueling the opioid crisis.

> *"What's hard — and what may be the defining challenge ahead — is choosing a y-axis that deserves one, anticipating what it incentivizes, and knowing when to change it."*

**MAWA's third-party evaluation mechanism is a direct institutional response to this problem.**

In enterprise agent deployments, the easy y-axes are: task completion rate, quality_gate pass rate, token cost per ATC. These are measurable. But an agent that maximizes these metrics might still be doing the wrong work, in the wrong way, drifting from what the business actually needs.

The two-track evaluation design addresses this directly:

- **Internal evaluation** — measures the easy, verifiable things: did the output match the ATC schema? were Playbook bullets applied? was the TaskRun complete?
- **Expert evaluation** — injects human judgment about direction: is the agent optimizing the right thing? is the y-axis still correct? does the Playbook need to evolve in a different direction?

The Curator session is not just a review mechanism. It is the point where human intent re-enters the optimization loop — where someone with domain knowledge and values can say "this metric is drifting from what we actually care about" and redirect the agent's evolution.

Justin frames this as the defining challenge of the AI era. MAWA treats it as a first-class architectural concern.

**On Karpathy's autoresearch:** autoresearch works because val_bpb is a clean, objective, domain-specific metric. Enterprise work rarely has this. A quality architect evaluating R&D assets, a personal assistant managing schedules, a summarist capturing meeting decisions — these tasks involve tradeoffs, context, and judgment that resist a single metric. The expert evaluation track exists precisely because these y-axes cannot be fully automated.

---

## v0.2.0 Delivery Plan

| Component | Priority | Description |
|-----------|----------|-------------|
| `mawa-evaluator-internal` skill | P0 | Automated post-execution evaluation |
| TaskRun `evaluation` field | P0 | Add to schema, update all WA IDENTITY files |
| Per-TaskRun visualization | P1 | Web UI or markdown report per execution |
| Expert evaluation interface | P1 | Structured input for human/expert agent review |
| Team dashboard | P2 | Weekly performance view across all positions |
| Evaluator plugin spec | P2 | Published spec for custom evaluator implementations |

---

## The Bigger Picture

With the Y-axis in place, MAWA's full improvement loop becomes:

```
Execute (ATC)
    ↓
Record (TaskRun)
    ↓
Evaluate (Internal + Expert)
    ↓
Reflect (Reflector mines evaluations)
    ↓
Curate (Curator reviews candidates with human direction)
    ↓
Evolve (Playbook updated)
    ↓
Execute better next time
```

This is what it means for an agent to improve like an employee — not by becoming a smarter model, but by accumulating evaluated experience, receiving expert direction, and building better execution habits over time.

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
