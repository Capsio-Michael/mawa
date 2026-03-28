# Workflow: [Primary Workflow Name]

## ATC Task Card

[ATC]
task_id: [QUADRANT_PREFIX]-[PACK_ABBREV]-001
task_name: [workflow name]
trigger: [e.g. new_item_received | scheduled_cron | api_call]
input_schema:
  - field: [name]
    type: [string | object | array]
    required: true

dispatch_table:
  - condition: type == "[type_a]"
    target_agent: [WA name]
  - condition: type == "[type_b]"
    target_agent: [WA name]
  - condition: default
    target_agent: [MA name]

quality_gate:
  min_confidence: 0.80
  required_fields: [list]
  on_fail: escalate_to_human

output_schema:
  status: pass | fail | escalated
  result: object
  processing_time_ms: number
  agent_trace: array

## Flow diagram

Input → MA ([Name])
  ├── [condition A] → WA ([Name]) → quality_gate → output
  ├── [condition B] → WA ([Name]) → quality_gate → output
  └── ambiguous → human_review queue
