---
name: mawa-curator
description: MAWA Curator session — {MA_NAME} presents candidate Playbook bullets
 to {OWNER_NAME} for review. Approved bullets are promoted to a new Playbook
 version. Runs on-demand when {OWNER_NAME} says "开始Curator" or
 "start curator review".
---

# MAWA Curator Skill

## Trigger
Activated when {OWNER_NAME} says: "开始Curator", "start curator", or
"review playbook candidates"

## Execution Workflow

### Phase 1: Load Candidates
1. Read all candidate files from playbook-candidates/ for all positions
2. Filter to only unreviewed candidates (no "reviewed" flag)
3. Count total candidates per position
4. Report to {OWNER_NAME}:
 "发现 {n} 条待审候选策略，涉及 {positions}。开始逐条审查。"

### Phase 2: Present Each Candidate (Interactive)
For each candidate, present in this format and WAIT for decision:

```
━━━━━━━━━━━━━━━━━━━━━━
📋 候选策略审查
位置：{position_id} | 编号：{candidate_id}
类型：{E执行 / R风险 / Q质量 / D废弃}
来源：{pattern source}
出现频率：{occurrence_count} 次 | 置信度：{confidence}

触发条件：
{condition}

建议动作：
{action}

完整 Bullet 文本：
{proposed_playbook_text}

支撑 TaskRun：{supporting_taskruns}
━━━━━━━━━━━━━━━━━━━━━━
决策：[✅ 批准] [❌ 拒绝] [✏️ 修改] [⏸ 跳过]
```

Wait for {OWNER_NAME}'s response:
- "批准" / "✅" / "yes" / "approve" → mark APPROVED
- "拒绝" / "❌" / "no" / "reject" → mark REJECTED, ask for reason
- "修改" / "edit" → ask "请输入修改后的 bullet 文本", save modified version
- "跳过" / "skip" → mark PENDING, review next session

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
✅ Curator 会话完成 | {date}

审查结果：
• 批准：{n} 条
• 拒绝：{n} 条
• 修改：{n} 条
• 跳过（下次）：{n} 条

Playbook 更新：
• {WA_1} → v{N} (PILOT) — {n} 新 bullets
• {WA_2} → v{N} (PILOT) — {n} 新 bullets
• {WA_3} → v{N} (PILOT) — {n} 新 bullets
• {WA_4} → 无变化（{n} 条跳过）

下次 Reflector 运行：{next Sunday 22:00}
下次 Curator 建议时间：{2 weeks later}

Team {TEAM_NAME} Playbook 持续进化中 🦞
```
