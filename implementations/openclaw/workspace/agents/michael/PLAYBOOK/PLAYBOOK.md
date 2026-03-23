---
position_id: {POSITION_NAME}
playbook_type: WA
version: 1
status: PILOT
created: {CREATION_DATE}
---

# {POSITION_NAME} WA Playbook v1

## Execution Bullets

### E-000
**Condition:** {MA_NAME} routes an asset via IPCP (ATC-{MA_ID}-ASSET-ROUTING)
**Action:** 
1. Receive IPCP with asset details
2. Execute ATC-{POSITION_ID}-ASSET-EVALUATE
3. Post evaluation result to the group thread
4. Write TaskRun
5. Do NOT wait for {MA_NAME} confirmation — proceed directly
**Condition:** Developer submits multiple assets in one message
**Action:** Evaluate each asset independently. Generate one evaluation output
per asset. Reference them all in a single consolidated group reply.
Do not merge scores across assets.

### E-002
**Condition:** Asset doc URL is inaccessible (permission error or dead link)
**Action:** Reply to developer in group: "无法访问文档，请检查分享权限后重新提交。"
Do not attempt evaluation. Write TaskRun with error = "doc_inaccessible".

### E-003
**Condition:** Developer resubmits an asset that was previously FAIL
**Action:** Treat as a fresh evaluation. Do not reference or average with
previous score. Note in TaskRun: "resubmission — previous result: FAIL".

### E-004
**Condition:** Asset layer is ambiguous (developer did not specify A/B/C)
**Action:** Infer layer from content structure. If still ambiguous after reading,
reply to developer: "请确认资产层级（A全流程/B ATC/C Skills）后重新提交。"
Do not guess. Do not evaluate ambiguous layer assets.

### E-005
**Condition:** Score is between 55-65 (borderline)
**Action:** Add an extra dimension check pass before finalizing score.
Explicitly note in improvement_suggestions: "边界评分，建议重点关注以下维度提升。"

## Risk Control Bullets

### R-001
**Condition:** More than 8 assets submitted in one day
**Action:** Process in submission order. If processing time exceeds 19:30,
notify {OWNER_NAME}: "今日提交量较大，评估将延续至{estimated_completion_time}。"

### R-002
**Condition:** Registry file write fails (disk error or file lock)
**Action:** Cache the registry entry in TaskRun under "pending_registry_write".
Notify {MA_NAME} via IPCP Error-Report. Do not mark asset as registered until
confirmed written.

### R-003
**Condition:** Same asset code appears already in the registry
**Action:** Do NOT overwrite. Alert {MA_NAME} via IPCP: "Duplicate asset code detected:
{asset_code}. Manual review required." Write TaskRun with error = "duplicate_code".

## Quality Standard Bullets

### Q-001
**Condition:** A-layer asset has all required fields but coordinate is vague
 (e.g., "前期" instead of specific node)
**Action:** Deduct 10-15 points from traceability. Add improvement suggestion:
"当前坐标需精确到具体节点，避免使用模糊描述。"

### Q-002
**Condition:** B-layer asset has business goal defined but it's copy-pasted
 from A-layer without adaptation
**Action:** Deduct 10 points from structure_quality. Add: "B层业务目标需结合
具体ATC场景细化，不能直接复用A层描述。"
