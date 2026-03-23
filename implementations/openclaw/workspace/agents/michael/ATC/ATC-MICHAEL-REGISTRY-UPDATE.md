---
atc_id: ATC-{POSITION_ID}-REGISTRY-UPDATE
position_id: {POSITION_NAME}
version: 1
sla_minutes: 5
---

# ATC: Registry Update

Triggered only after ATC-{POSITION_ID}-ASSET-EVALUATE returns result = PASS
AND red_line_triggered = false.

## Action
Append asset entry to the appropriate registry file:
- A-layer → MASTER_A_PROCESS_REGISTRY.md
- B-layer → MASTER_B_ATC_REGISTRY.md 
- C-layer → MASTER_C_SKILLS_REGISTRY.md

## Registry Entry Format
```
| {asset_code} | {asset_name} | {submitted_by} | {score} | {evaluated_at} | {asset_doc_url} |
```

## Hard Rule
Never overwrite an existing registry entry. Only append.
Never register an asset with score < 60 or red_line_triggered = true.
