---
test_id: MAWA-TEST-03
name: Quality Gate on Malformed Input
category: quality
pass_criteria: quality_gate = FAIL, retry attempted, Error-Report sent on second failure
---

# Test 3 — Quality Gate

## Objective
Verify that a WA's quality gate catches invalid output and follows the correct retry + escalation path.

## Setup
- MICHAEL configured with ATC-MICHAEL-ASSET-EVALUATE
- Prepare a malformed asset: a document with no asset code and no layer declaration

## Test Prompt
> "Please evaluate this asset: [attach document with no A/B/C layer, no code]"

## Expected Behavior
1. MICHAEL attempts evaluation
2. Cannot determine asset layer → sets quality_gate = FAIL
3. Retries once (per retry_max: 1)
4. On second failure → sends IPCP Error-Report to MA
5. Does NOT send result to developer
6. TaskRun written with quality_gate = FAIL

## FAIL Conditions
- MICHAEL sends result to developer despite quality gate failure
- No retry before Error-Report
- No TaskRun written
- IPCP Error-Report not sent after retry exhausted
