---
test_id: MAWA-TEST-02
name: ATC Execution and TaskRun
category: execution
pass_criteria: Structured output matches ATC schema AND TaskRun is written to disk
---

# Test 2 — ATC Execution + TaskRun

## Objective
Verify that a WA executes an ATC correctly and produces a valid TaskRun.

## Setup
- BOOKY configured with ATC-BOOKY-DAILY-SUMMARY
- At least one meeting note available in the messaging platform

## Test Prompt
> "Execute ATC-BOOKY-DAILY-SUMMARY for today."

## Expected Behavior
1. BOOKY runs the ATC step by step
2. Output matches the ATC Output Schema
3. quality_gate = PASS
4. TaskRun JSON written to taskruns/booky/{date}/

## TaskRun Must Contain
{"atc_id": "ATC-BOOKY-DAILY-SUMMARY", "quality_gate": "PASS", "preflight": "PASS", "tools_used": ["..."], "playbook_bullets_hit": ["..."], "duration_ms": "<integer>", "token_estimate": "<integer>"}

## FAIL Conditions
- Output missing required fields
- No TaskRun file written
- preflight field missing from TaskRun
- quality_gate = FAIL with no retry attempt
