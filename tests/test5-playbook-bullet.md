---
test_id: MAWA-TEST-05
name: Playbook Bullet Firing
category: playbook
pass_criteria: Matching bullet fires, bullet ID cited in TaskRun
---

# Test 5 — Playbook Bullet

## Objective
Verify that when a trigger condition is met, the Playbook bullet fires and is recorded in the TaskRun.

## Setup
- STOCKY configured with PLAYBOOK v1
- Bullet E-002: IF market is closed THEN skip broadcast, write TaskRun with status = market_closed
- Run on a weekend or public holiday

## Test Prompt
> "Execute ATC-STOCKY-SCHEDULED-BROADCAST."

## Expected Behavior
1. STOCKY detects market is closed
2. Playbook bullet E-002 fires
3. No broadcast sent
4. TaskRun written with status = "market_closed" and playbook_bullets_hit: ["E-002"]

## TaskRun Must Contain
{"atc_id": "ATC-STOCKY-SCHEDULED-BROADCAST", "status": "market_closed", "broadcast_sent": false, "playbook_bullets_hit": ["E-002"]}

## FAIL Conditions
- Broadcast sent on non-trading day
- playbook_bullets_hit is empty
- Bullet fired but not cited in TaskRun
- No TaskRun written
