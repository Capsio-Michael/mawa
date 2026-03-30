# MAWA TaskRun Schema

Every ATC execution produces a TaskRun record. This is the canonical
schema as of MAWA v0.1.2.

## Full Schema

```json
{
  "taskrun_id": "uuid",
  "atc_id": "string",
  "position_id": "string",
  "agent_id": "string",
  "triggered_by": "string",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "duration_ms": "integer",
  "token_estimate": "integer",

  "input": {},
  "output": {},

  "tools_used": ["string"],
  "retry_count": "integer",

  "playbook_bullets_hit": ["string"],
  "playbook_bullets_missed": ["string"],

  "quality_gate": "PASS | FAIL | PARTIAL_PASS",
  "preflight": "PASS | FAIL | SKIP",
  "ipcp_sent": "boolean",
  "ipcp_type": "Error-Report | Status-Update | Escalation | null",

  "red_line_triggered": "boolean",
  "red_line_code": "string | null",

  "delivery": {
    "targets": ["string"],
    "status": "DELIVERED | FAILED | PARTIAL",
    "dual_path": "boolean"
  },

  "evaluation": {
    "score": "0-100 | null",
    "dimensions": {
      "process_adherence": "0-25 | null",
      "output_quality": "0-25 | null",
      "playbook_application": "0-25 | null",
      "delivery_correctness": "0-25 | null"
    },
    "feedback": "string | null",
    "expert_flag": "boolean",
    "expert_reviewed": "boolean",
    "expert_feedback": "string | null",
    "evaluated_at": "ISO8601 | null",
    "expert_reviewed_at": "ISO8601 | null"
  },

  "timestamp": "ISO8601"
}
```

## Field notes

- `evaluation` is populated by mawa-evaluator-internal after TaskRun write
- `evaluation.score` is null until evaluator runs
- `expert_reviewed` is false until a human or expert agent reviews
- `playbook_bullets_missed` is populated by the evaluator, not the WA
- `quality_gate` is self-reported by the WA; `evaluation.score` is independent
