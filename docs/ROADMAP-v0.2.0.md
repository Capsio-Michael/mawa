# MAWA Roadmap — v0.2.0
## The Y-Axis Upgrade

> *"When optimization itself gets commoditized, all that's left to figure out is what's worth optimizing, and what's not."*
> — Justin Zhao, [The Y-Axis Problem](https://www.justinxzhao.com/blog/2026/the-y-axis-problem/) (March 2026)

---

## The Problem v0.2.0 Solves

MAWA v0.1.0 governs the X-axis: what agents can do, how tasks are routed, how failures escalate, how policies evolve.

What it doesn't yet govern is the Y-axis: **how good the agent's work actually is, and how that improves over time.**

The current Reflector → Curator loop improves Playbook strategy based on task outcomes. But it relies on the agent's own `quality_gate` assessment — which is self-reported. There is no independent verification that the agent did the right thing, the right way, in the right direction.

As Justin Zhao argues in *The Y-Axis Problem*: when optimization becomes automated, the hard part is no longer doing the optimization — it's choosing what to optimize, and knowing when to change it. MAWA's expert evaluation track is a direct institutional response: the point where human judgment re-enters the optimization loop.

---

## What's New in v0.2.0

### 1. `mawa-evaluator-internal` Skill

A new skill that runs automatically after every ATC execution.

**Trigger:** After every TaskRun write
**Input:** TaskRun + ATC file + REGISTRATION.md + PLAYBOOK.md
**Output:**
```json
{
  "evaluation_score": 0-100,
  "dimension_scores": {
    "process_adherence": 0-25,
    "output_quality": 0-25,
    "playbook_application": 0-25,
    "delivery_correctness": 0-25
  },
  "playbook_candidates": [],
  "expert_flag": false,
  "feedback": "string"
}
```

**Flags for expert review when:**
- evaluation_score < 70
- Same failure pattern appears 3+ times this week
- New pattern with no matching Playbook bullet

---

### 2. TaskRun Schema Update

Every TaskRun gains an `evaluation` field:

```json
{
  "taskrun_id": "uuid",
  "atc_id": "string",
  "position_id": "string",
  "input": {},
  "output": {},
  "tools_used": ["string"],
  "playbook_bullets_hit": ["string"],
  "quality_gate": "PASS | FAIL",
  "preflight": "PASS | FAIL",
  "ipcp_sent": "boolean",
  "duration_ms": "integer",
  "token_estimate": "integer",
  "timestamp": "ISO8601",
  "evaluation": {
    "score": 0-100,
    "dimensions": {},
    "feedback": "string",
    "expert_flag": "boolean",
    "evaluated_at": "ISO8601"
  }
}
```

---

### 3. Expert Evaluation Interface

A structured interface for human or expert agent review of flagged TaskRuns.

The expert sees:
- Task input and context
- Full execution trace
- Output delivered
- Internal evaluation score and dimensions
- Their domain knowledge about what "good" looks like

The expert does NOT micromanage execution. They set direction. The agent optimizes within that direction.

**Key principle:**
> Agent performance improves when humans give direction and domain expertise.
> Within that direction, the agent's optimization will surpass what any individual could do manually.
> But direction without human input drifts — and that drift is invisible until it becomes a problem.

---

### 4. Per-TaskRun Visualization

Every ATC execution becomes inspectable:

```
ATC-MICHAEL-ASSET-EVALUATE | 2026-03-25 09:46
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Input:    Asset "B20260325-1" | submitted by Zhang Wei
Result:   FAIL ❌ | Score: 0/100
Red Line: A-layer missing 6-digit code

Process:  ████████████████░░░░ 4.2s | 0 retries
Playbook: E-000 triggered | Q-001 not applicable

IPCP:     Error-Report → FClaw ✅
Delivery: Submitter DM ✅ | Owner DM ✅

Internal Eval:  82/100
Expert Eval:    Pending
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 5. Registration Runtime Enforcement

Moving Registration boundaries from prompt-level to code-level.

**v0.1.0:** MA reads REGISTRATION.md and checks scope before routing (prompt-level)
**v0.2.0:** Tool invocations are checked against a declared allowlist before execution (code-level)

```yaml
enforcement:
  tool_allowlist: [feishu_read, file_write, notify]
  tool_denylist: [finance_api, hr_api, exec]
  data_path_sandbox: workspace/agents/booky/
  cross_agent_acl:
    can_receive_from: [fclaw]
    can_send_to: [fclaw]
```

---

### 6. Benchmark — MAWA vs Baseline

First published comparison of MAWA-governed agents vs ungoverned multi-agent setup.

**Metrics:**
- Task completion rate
- Boundary violation rate
- Repeated error rate (same mistake in same week)
- Human intervention frequency
- Token cost per completed task
- Playbook efficiency (bullet_hit_count / total_executions)

**Design:** Same task set, same agents, same tools — with and without MAWA governance layer.

---

## Evaluator as Plugin

The evaluator is designed as a plugin — not a core MAWA component — because different deployments need different evaluation criteria.

**Plugin interface:**
```yaml
---
plugin_id: mawa-evaluator
plugin_type: post-execution
trigger: after_taskrun_write
input: [taskrun, atc, registration, playbook]
output: [score, dimensions, candidates, expert_flag]
---
```

Any team can implement their own evaluator following this interface. The core MAWA spec is unchanged.

---

## The Full Improvement Loop (v0.2.0)

```
Execute (ATC)
    ↓
Record (TaskRun)
    ↓
Evaluate (Internal Evaluator — automatic)
    ↓
Flag (Expert Evaluation — human judgment injected)
    ↓
Reflect (Reflector mines evaluations + TaskRuns)
    ↓
Curate (Curator reviews candidates with human direction)
    ↓
Evolve (Playbook updated — PILOT → SOTA)
    ↓
Execute better next time
```

This is what it means for an agent to improve like an employee: not by becoming a smarter model, but by accumulating evaluated experience, receiving expert direction, and building better execution habits over time.

---

## Delivery Schedule

| Day | Deliverable |
|-----|-------------|
| 3/27 | v0.1.0 public release |
| 3/28 | v0.1.1 — bug fixes, template completion |
| 3/29 | Evaluator skill design + TaskRun schema update |
| 3/30 | Evaluator first test on Michael, v0.1.2 |
| 3/31 | Registration runtime enforcement prototype |
| 4/1  | Per-TaskRun visualization |
| 4/2  | Benchmark first data |
| 4/3  | v0.2.0 release |

---

## References

- Justin Zhao, [*The Y-Axis Problem*](https://www.justinxzhao.com/blog/2026/the-y-axis-problem/), March 2026
- Andrej Karpathy, [autoresearch](https://github.com/karpathy/autoresearch), March 2026
- Stanford ACE Framework, [*Evolving Contexts for Self-Improving Language Models*](https://arxiv.org/abs/2510.04618), January 2026
