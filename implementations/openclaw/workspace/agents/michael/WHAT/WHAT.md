---
what_id: WHAT-{POSITION_ID}-DAILY-QUALITY-REVIEW
position_id: {POSITION_NAME}
version: 1
---

# WHAT: Daily Quality Review

## W — Work (What is this task?)
Monitor {TEAM_CHANNEL} group daily, receive developer submissions of A/B/C
layer assets, evaluate each against the A-B-C standard, register qualified
assets, and deliver evaluation reports back to developers and {OWNER_NAME}.

Business intent: Ensure every R&D asset produced by the team meets the
quality standard before it is counted as a valid organizational asset.
Prevent accumulation of low-quality, unstructured, or uncoded assets.

## H — How (Execution steps)
1. Monitor {TEAM_CHANNEL} group for developer submissions (19:00 trigger or on-demand)
2. For each submission received, identify asset layer: A (全流程), B (ATC), or C (Skills)
3. Apply layer-specific evaluation criteria (see ATC-{POSITION_ID}-ASSET-EVALUATE)
4. Score 0-100. Check red lines. If red line triggered → ATC-{POSITION_ID}-RED-LINE-REJECT
5. If score ≥ passing threshold → ATC-{POSITION_ID}-REGISTRY-UPDATE
6. Reply to developer in group thread with structured quality report
7. Compile daily summary of all evaluations
8. Send daily summary to {OWNER_NAME} via {CHANNEL_NAME} private message
9. Write TaskRun for each evaluation + one TaskRun for the daily summary

## A — Automation
- Automation scope: FULL (evaluation) + FULL (registry) + FULL (notification)
- Trigger: Daily 19:00 cron + real-time on group message receipt
- Tools: {CHANNEL_NAME}_chat_monitor, {CHANNEL_NAME}_doc_read, {CHANNEL_NAME}_im_reply,
 {CHANNEL_NAME}_doc_write, registry_write, {CHANNEL_NAME}_im_notify, file_write

## T — Test (Quality Validation)
- Every evaluation output must include: asset_id, layer, score (integer), 
 red_line_triggered (boolean), result (PASS/FAIL), reason
- Registry update must only happen if result = PASS AND red_line_triggered = false
- Developer reply must be sent within 30 minutes of submission receipt
- Daily summary must include total count of: submitted, passed, failed, red_line_rejections
- TaskRun must be written even if evaluation result is FAIL
