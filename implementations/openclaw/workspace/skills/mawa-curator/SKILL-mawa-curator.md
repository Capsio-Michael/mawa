---
name: mawa-curator
description: MAWA Curator session — {MA_NAME} presents candidate Playbook bullets
 to {OWNER_NAME} for review. Approved bullets are promoted to a new Playbook
 version. Runs on-demand when {OWNER_NAME} says "开始Curator" or
 "start curator review".
---

# MAWA Curator Skill

## Trigger
Activated when {OWNER_NAME} says: "start curator", "start curator review",
or "review playbook candidates"

## Execution Workflow

### Phase 1: Load Candidates
1. Read all candidate files from playbook-candidates/ for all positions
2. Filter to only unreviewed candidates (no "reviewed" flag)
3. Count total candidates per position
4. Report to {OWNER_NAME}:
 "Found {n} pending candidate bullets across {positions}. Starting review."

### Phase 2: Present Each Candidate (Interactive)
For each candidate, present in this format and WAIT for decision:

```
━━━━━━━━━━━━━━━━━━━━━━
📋 Candidate Bullet Review
Position: {position_id} | ID: {candidate_id}
Type: {E-Execution / R-Risk / Q-Quality / D-Deprecate}
Source: {pattern source}
Frequency: {occurrence_count} times | Confidence: {confidence}

Trigger Condition:
{condition}

Proposed Action:
{action}

Full Bullet Text:
{proposed_playbook_text}

Supporting TaskRuns: {supporting_taskruns}
━━━━━━━━━━━━━━━━━━━━━━
Decision: [✅ Approve] [❌ Reject] [✏️ Edit] [⏸ Skip]
```

Wait for {OWNER_NAME}'s response:
- "approve" / "✅" / "yes" → mark APPROVED
- "reject" / "❌" / "no" → mark REJECTED, ask for reason
- "edit" → ask "Please provide the revised bullet text", save modified version
- "skip" → mark PENDING, review in next session

### Phase 3: Conflict Detection
Before writing approved bullets to Playbook, check:

1. **Bullet vs Bullet conflict**: Does new bullet contradict an existing one?
 Example: existing says "retry twice", new says "retry once" → flag conflict
 Present conflict to {OWNER_NAME}: "此 bullet 与现有 {bullet_id} 存在冲突，
 建议替换/合并/保留两者？"

2. **Cross-position consistency**: If bullet affects IPCP behavior,
 does it align with the receiving position's Registration?
 Example: Booky bullet says "send IPCP to Stocky" → Registration says NO → reject

3. **Registration boundary**: Reconfirm approved bullet uses only registered tools/ATCs
 (double-check even if Reflector already checked)

### Phase 4: Write New Playbook Version
After all candidates reviewed, for each position with ≥1 approved bullet:

1. Read current Playbook version file
2. Create new version file:
 {WORKSPACE}/playbook-versions/{position}/wa-playbook-v{N+1}.md

3. New version format:
```markdown
---
position_id: {position}
playbook_type: WA
version: {N+1}
status: PILOT
promoted_from_candidates: [{candidate_ids}]
curator_session_date: {date}
approved_by: {OWNER_NAME}
---

# {Position} WA Playbook v{N+1}

## New Bullets (added this version)
{approved new bullets}

## Modified Bullets (updated this version)
{modified bullets with change note}

## Deprecated Bullets (removed this version)
{deprecated bullet_ids with reason}

## Carried Bullets (unchanged from v{N})
{all bullets from previous version not deprecated}

## Changelog
- v{N+1} ({date}): Added {n} bullets, deprecated {n} bullets. Curator: {OWNER_NAME}
```

4. Update the WA's active PLAYBOOK reference:
 In agents/{position}/PLAYBOOK/ — copy new version as current active playbook

### Phase 5: Version Lifecycle Management

**PILOT → SOTA promotion rule:**
After a new Playbook version has been running for 2 weeks:
- Reflector will report bullet effectiveness in next weekly run
- If new bullets show helpful_count > 0 and harmful_count = 0 → auto-promote to SOTA
- If any new bullet shows harmful_count > helpful_count → flag for review

**SOTA → Legacy:**
When a new SOTA is promoted, previous SOTA moves to Legacy (kept in playbook-versions/ for rollback)

**Deprecate:**
Bullets explicitly rejected by {OWNER_NAME} → moved to DEPRECATED section, never executed again

### Phase 6: Session Summary
At end of Curator session, report:

```
✅ Curator Session Complete | {date}

Review Results:
• Approved:  {n}
• Rejected:  {n}
• Edited:    {n}
• Skipped:   {n}

Playbook Updates:
• {WA_1} → v{N} (PILOT) — {n} new bullets
• {WA_2} → v{N} (PILOT) — {n} new bullets
• {WA_3} → v{N} (PILOT) — {n} new bullets
• {WA_4} → no changes ({n} skipped)

Next Reflector run: {next Sunday 22:00}
Suggested next Curator session: {2 weeks later}

Team {TEAM_NAME} Playbooks are evolving 🦞
```
