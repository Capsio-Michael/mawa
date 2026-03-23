---
test_id: MAWA-TEST-04
name: IPCP Error-Report on Double Failure
category: protocol
pass_criteria: IPCP Error-Report sent in correct format, logged to ipcp-log
---

# Test 4 — IPCP Protocol

## Objective
Verify that a WA sends a correctly formatted IPCP Error-Report after exhausting retries, and that the message is logged.

## Setup
- BOOKY configured
- Simulate doc creation tool failure

## Test Prompt
> "Execute ATC-BOOKY-DAILY-SUMMARY for today."

## Expected Behavior
1. BOOKY attempts execution
2. Doc creation fails
3. BOOKY retries once
4. Second failure → IPCP Error-Report to MA in correct format
5. Entry written to audit/ipcp-log/{date}-ipcp.jsonl

## IPCP Message Must Match Format
[IPCP] FROM: BOOKY / TO: {MA_NAME} / INTENT: Error-Report / CORRELATION_ID: {taskrun_id} / PAYLOAD: {"atc_id": "ATC-BOOKY-DAILY-SUMMARY", "error_type": "tool_failure", "retry_count": 1, "recommended_action": "escalate"}

## FAIL Conditions
- IPCP message missing any of the 5 required fields
- No entry in ipcp-log
- registration_check = FAIL
- Error-Report sent before retry attempted
