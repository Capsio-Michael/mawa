# Workflow: [REPLACE: Primary Workflow Name]

## ATC Task Card — WT-CORTRA-001

[ATC]
task_id: WT-CORTRA-001
task_name: [REPLACE: workflow_name]
trigger: [REPLACE: new_item_received | scheduled_cron | api_call]
sla_minutes: [REPLACE: integer]
retry_max: 1

input_schema:
  - field: item_id
    type: string
    required: true
  - field: [REPLACE: field_name]
    type: [REPLACE: string | object | array]
    required: true

dispatch_table:
  - condition: type == "[REPLACE: type_a]"
    target_agent: [REPLACE: WA 1 Name]
  - condition: type == "[REPLACE: type_b]"
    target_agent: [REPLACE: WA 2 Name]
  - condition: default
    target_agent: [REPLACE: MA Name]

quality_gate:
  min_confidence: 0.80
  required_fields: [REPLACE: list required output fields]
  on_fail: escalate_to_human

output_schema:
  status: pass | fail | escalated
  result: object
  processing_time_ms: number
  agent_trace: array

## Flow diagram

```
Input → MA ([REPLACE: MA Name])
  ├── [REPLACE: condition A] → WA ([REPLACE: WA 1 Name]) → quality_gate → output
  ├── [REPLACE: condition B] → WA ([REPLACE: WA 2 Name]) → quality_gate → output
  └── ambiguous → human_review queue
```
