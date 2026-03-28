---
position_id: {POSITION_ID}
playbook_type: WA
version: 1
status: PILOT
created: {YYYY-MM-DD}
---

# {POSITION_NAME} WA Playbook v1

## Execution Bullets

### E-001
**Condition:** {Describe the specific situation — e.g., "Input document has no title field"}
**Action:** {What to do — e.g., "Use the first H1 heading as the title. If none found, set title to 'Untitled — {timestamp}'."}

### E-002
**Condition:** {Describe the specific situation}
**Action:** {What to do — be specific enough that no further judgment is required}

## Risk Control Bullets

### R-001
**Condition:** {Describe a failure or edge case — e.g., "API returns error on first call"}
**Action:** {How to handle — e.g., "Retry once after 30 seconds. If second call fails, write TaskRun with status = 'tool_failure' and send IPCP Error-Report to {MA_NAME}."}

### R-002
**Condition:** {Describe another failure or edge case}
**Action:** {How to handle}

## Quality Bullets

### Q-001
**Condition:** {Describe a quality judgment situation — e.g., "Output is technically valid but suspiciously short (< 50 words)"}
**Action:** {What to do — e.g., "Flag output with quality_gate_reason = 'output_length_suspicious'. Still deliver, but set quality_gate = FAIL for review."}

## Deprecated Bullets
(none — v1 pilot)
