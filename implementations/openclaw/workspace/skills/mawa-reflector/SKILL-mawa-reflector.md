---
name: mawa-reflector
description: Weekly MAWA Reflector — reads all WA TaskRuns from past 7 days,
 analyzes execution patterns per position, generates candidate Playbook bullets.
 Runs every Sunday at 22:00. Output sent to playbook-candidates/ folder and
 summary sent to {OWNER_NAME} via {CHANNEL_NAME}.
---

# MAWA Reflector Skill

## Prerequisites
TaskRun JSON files must exist in:
- {WORKSPACE}/taskruns/{wa_1}/
- {WORKSPACE}/taskruns/{wa_2}/
- {WORKSPACE}/taskruns/{wa_3}/
- {WORKSPACE}/taskruns/{wa_4}/

## Execution Workflow

### Phase 1: Collect TaskRuns
For each position ({wa_list}):
1. Use `exec` to list all TaskRun JSON files from the past 7 days
2. Use `read` to load each TaskRun file
3. Build a position dataset: list of all executions with inputs, outputs,
 quality_gate results, playbook_bullets_hit, errors

### Phase 2: Pattern Analysis (per position)
For each position dataset, analyze and extract:

**Success Patterns** — what conditions led to quality_gate = PASS?
- Which playbook bullets were hit in successful runs?
- Which input conditions correlated with fast, clean execution?
- Any tool sequences that consistently worked well?

**Failure Patterns** — what conditions led to quality_gate = FAIL or errors?
- Which conditions triggered retries?
- Which errors appeared more than once?
- Any missing inputs that caused repeated failures?

**Bullet Effectiveness** — for each existing Playbook bullet:
- Count: how many times was it triggered? (helpful_count)
- Count: how many times was it triggered on a FAIL run? (harmful_count)
- Flag for deprecation if harmful_count > helpful_count

**Gap Patterns** — tasks that succeeded but had NO bullet match:
- These are candidates for NEW bullets
- What was the condition? What did the agent do that worked?

**IPCP Patterns** (for positions that send IPCP):
- Which Error-Reports were sent most often? → candidate for new Risk bullet
- Were there repeated patterns in what {MA_NAME} had to handle?

### Phase 3: Generate Candidate Bullets
For each pattern identified, generate a candidate bullet in this format:

```json
{
 "candidate_id": "CAND-{position}-{date}-{seq}",
 "position_id": "string",
 "bullet_type": "E (execution) | R (risk) | Q (quality) | D (deprecate)",
 "condition": "string — precise trigger condition",
 "action": "string — what the agent should do",
 "source": "success_pattern | failure_pattern | gap_pattern | ipcp_pattern",
 "supporting_taskruns": ["taskrun_id list"],
 "occurrence_count": "integer — how many times this pattern appeared",
 "confidence": "high | medium | low",
 "registration_check": "PASS — does not require unregistered tools or ATC",
 "proposed_bullet_text": "full bullet in Playbook format"
}
```

**Registration Check Rule (critical):**
Before writing any candidate, verify:
- Does the proposed action use only tools listed in the position's REGISTRATION.md?
- Does it reference only ATCs listed in the position's REGISTRATION.md?
- Does it suggest IPCP only to positions in the position's collaboration_scope?
If ANY check fails → do NOT write the candidate. Log it as "rejected_registration_violation".

### Phase 4: Write Candidate Files
For each position, write to:
`{WORKSPACE}/playbook-candidates/{position}/candidates-{YYYY-MM-DD}.md`

Format:
```markdown
---
position_id: {position}
reflector_run_date: {date}
taskruns_analyzed: {count}
week_covered: {start} to {end}
---

# Candidate Bullets — {position} — {date}

## Summary
- TaskRuns analyzed: {n}
- Successful runs: {n} ({pct}%)
- Failed runs: {n} ({pct}%)
- Existing bullets triggered: {n} times total
- Bullets flagged for deprecation: {list}
- New candidate bullets generated: {n}
- Candidates rejected (registration violation): {n}

## Candidates for NEW bullets

### {CAND-001}
**Type:** E / R / Q
**Condition:** {condition}
**Proposed Action:** {action}
**Source:** {pattern type}
**Seen:** {occurrence_count} times
**Confidence:** {high/medium/low}
**Supporting TaskRuns:** {list}
**Proposed Playbook Text:**
> {full bullet text}

[repeat for each candidate]

## Bullets Flagged for Deprecation

### {existing_bullet_id}
**Reason:** triggered {n} times on FAIL runs vs {n} times on PASS runs
**Recommendation:** Deprecate and replace with {CAND-XXX} if approved

## Bullets Confirmed Effective (no change needed)
{list of bullets with high helpful_count and low harmful_count}
```

### Phase 5: Send Weekly Summary to {OWNER_NAME}

Send private message:

```
🔍 MAWA Reflector Weekly Report | {date}

TaskRun analysis complete for this week:

📊 Execution Stats:
• {WA_1}: {n} executions, {pass_rate}% pass rate
• {WA_2}: {n} executions, {pass_rate}% pass rate
• {WA_3}: {n} executions, {pass_rate}% pass rate
• {WA_4}: {n} executions, {pass_rate}% pass rate

💡 New Candidate Bullets:
• {WA_1}: {n} new candidates
• {WA_2}: {n} new candidates
• {WA_3}: {n} new candidates
• {WA_4}: {n} new candidates

⚠️ Bullets Flagged for Deprecation: {total}

📁 Candidate files written to playbook-candidates/

Review candidates when ready — reply "start curator" to begin.

— {MA_NAME} Reflector 🦞
```

## Cron Schedule
Run every Sunday at 22:00.
If no TaskRuns exist for a position this week, skip that position and note in summary.
