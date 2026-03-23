---
atc_id: ATC-{POSITION_ID}-ASSET-EVALUATE
position_id: {POSITION_NAME}
what_id: WHAT-{POSITION_ID}-DAILY-QUALITY-REVIEW
version: 1
sla_minutes: 30
retry_max: 1
---

# ATC: Asset Evaluation

## Input Schema
```json
{
 "taskrun_id": "string",
 "asset_doc_url": "string ({CHANNEL_NAME} URL)",
 "asset_layer": "A | B | C",
 "submitted_by": "string (developer name)",
 "submission_time": "ISO8601",
 "trigger": "group_message | cron | manual"
}
```

## Evaluation Criteria by Layer

### A-Layer (全流程) — Required fields
- Code format: A + 6 digits (e.g., A123456) → RED LINE if missing
- Industry code: present → RED LINE if missing
- E2E start/end points: defined → RED LINE if missing
- Node segmentation: clearly defined
- Current coordinate (当前坐标): present
- Scoring: 0-100. Red line auto-fail regardless of score.

### B-Layer (ATC) — Required fields 
- Code format: B + 8 digits (e.g., B12345678) → RED LINE if missing
- Parent A-node reference: valid and traceable
- Empowered position (赋能岗位): defined
- Business goal (业务目标): clear
- B-layer self-nesting (B层自嗡): → RED LINE if detected
- Scoring: 0-100.

### C-Layer (Skills) — Required fields
- Code format: C + 8 digits (e.g., C12345678) → RED LINE if missing
- Abstract logic (底层抽象逻辑): present
- Mount instances (挂载实例): at least one defined
- Generalized scenarios (泛化场景): at least one defined
- Code contamination (C层代码污染): → RED LINE if detected
- Scoring: 0-100.

## Output Schema
```json
{
 "taskrun_id": "string",
 "asset_doc_url": "string",
 "asset_layer": "A | B | C",
 "asset_code": "string | null",
 "submitted_by": "string",
 "score": "integer (0-100)",
 "red_line_triggered": "boolean",
 "red_line_reason": "string | null",
 "result": "PASS | FAIL",
 "dimension_scores": {
 "code_format": "integer (0-20)",
 "completeness": "integer (0-30)",
 "structure_quality": "integer (0-30)",
 "traceability": "integer (0-20)"
 },
 "improvement_suggestions": ["string"],
 "quality_gate": "PASS | FAIL",
 "evaluated_at": "ISO8601"
}
```

## Quality Gate Rules
- quality_gate = FAIL if score field is not an integer
- quality_gate = FAIL if red_line_triggered = true AND result = PASS (impossible state)
- quality_gate = FAIL if result = PASS AND score < 60
- On quality_gate FAIL: do NOT send reply to developer. Send IPCP Error-Report to {MA_NAME}.

## Developer Reply Format (send to group thread)
```
📋 质量评估报告 | {asset_layer}层 | {asset_code}

评分：{score}/100
结果：{PASS ✅ | FAIL ❌}
{if red_line_triggered: "🔴 红线触发：{red_line_reason}"}

维度评分：
• 编码规范：{code_format}/20
• 完整性：{completeness}/30 
• 结构质量：{structure_quality}/30
• 可追溯性：{traceability}/20

改进建议：
{improvement_suggestions as numbered list}

— {POSITION_NAME} 🏗️ | Quality is non-negotiable.
```
