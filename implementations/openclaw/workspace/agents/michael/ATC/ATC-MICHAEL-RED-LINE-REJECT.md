---
atc_id: ATC-{POSITION_ID}-RED-LINE-REJECT
position_id: {POSITION_NAME}
version: 1
sla_minutes: 10
---

# ATC: Red Line Rejection

Triggered when any red line is detected during evaluation.
This ATC overrides all other scoring — result is always FAIL.

## Red Line Conditions
- A-layer: missing code | missing industry code | missing E2E points | fake full-process (伪全流程)
- B-layer: missing code | B-layer self-nesting detected (B层自嗡)
- C-layer: missing code | code contamination detected (C层代码污染)

## Actions
1. Set result = FAIL, score = 0, red_line_triggered = true
2. Do NOT update any registry
3. Send developer reply with red line reason clearly stated
4. Write TaskRun with red_line_reason populated
5. Include in daily summary under red_line_rejections count

## Developer Reply Format
```
🔴 红线拒绝 | {asset_layer}层 | {asset_code | "无编码"}

触发红线：{red_line_reason}

此资产无法通过质量评估，请修正后重新提交。
具体要求：{specific_fix_instruction}

— {POSITION_NAME} 🏗️ | Quality is non-negotiable.
```
