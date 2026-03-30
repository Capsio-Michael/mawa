---
plugin_id: mawa-evaluator
plugin_type: post-execution
trigger: after_taskrun_write
version: 1.0.0
input: [taskrun, atc, registration, playbook]
output: [score, dimensions, candidates, expert_flag]
---

# MAWA Evaluator — Internal Skill

## Purpose

Runs automatically after every ATC execution. Produces a structured
evaluation score for each TaskRun. Flags TaskRuns that need expert review.
Generates Playbook improvement candidates when patterns are detected.

This skill does NOT replace the quality_gate — that is self-reported by
the WA at execution time. This skill provides independent post-hoc
assessment of what happened and whether it was good.

## Trigger

After every TaskRun is written to disk or storage, this skill is invoked
by FClaw (MA) with the following inputs:

[INPUT]
taskrun_path: path to the TaskRun JSON file
atc_path: path to the ATC file that was executed
registration_path: path to the WA's REGISTRATION.md
playbook_path: path to the WA's current PLAYBOOK.md

## Evaluation Dimensions

Each dimension is scored 0-25. Total score is 0-100.

[DIMENSIONS]

process_adherence (0-25):
  description: Did the agent follow the ATC workflow as specified?
  high (20-25): All required steps executed in order. No skipped steps.
                Preflight checks completed. IPCP used correctly.
  mid (10-19):  Minor deviations. Steps completed but order varied.
                One IPCP miss or preflight skip.
  low (0-9):    Major deviations. Steps skipped without reason.
                IPCP not sent when required. Preflight bypassed.

output_quality (0-25):
  description: Is the output complete, accurate, and correctly structured?
  high (20-25): Output schema fully populated. No missing required fields.
                Red line conditions correctly applied. Confidence scores
                within expected range for the task type.
  mid (10-19):  Output mostly complete. 1-2 missing optional fields.
                Minor formatting issues. Confidence score slightly off.
  low (0-9):    Output incomplete or incorrectly structured. Required fields
                missing. Red line conditions not applied when they should be.

playbook_application (0-25):
  description: Did the agent correctly apply relevant Playbook bullets?
  high (20-25): All applicable bullets triggered correctly. No bullets
                triggered when conditions were not met. New patterns
                handled appropriately despite no matching bullet.
  mid (10-19):  Most bullets applied correctly. One missed trigger or
                one false trigger.
  low (0-9):    Bullets consistently missed or incorrectly triggered.
                Pattern matches available bullet but agent did not apply it.

delivery_correctness (0-25):
  description: Was the output delivered to the right place, in the right
               format, at the right time?
  high (20-25): Delivery targets correct. Format matches expected output.
                Timing within SLA. Dual-path delivery (if required) completed.
  mid (10-19):  Delivery mostly correct. Minor format deviation.
                SLA met but close to limit.
  low (0-9):    Wrong delivery target. Format incorrect. SLA missed.
                Required dual-path delivery not completed.

## Scoring Thresholds

[THRESHOLDS]
expert_flag_below: 70
pattern_flag_count: 3
no_playbook_match: true

Expert review is flagged when ANY of:
- Total score < 70
- Same failure pattern seen 3+ times this week across this WA
- New failure pattern with no matching Playbook bullet exists

## Output Schema

[OUTPUT_SCHEMA]
evaluation_score: 0-100
dimension_scores:
  process_adherence: 0-25
  output_quality: 0-25
  playbook_application: 0-25
  delivery_correctness: 0-25
playbook_candidates: []
expert_flag: true | false
feedback: string
evaluated_at: ISO8601

## Playbook Candidate Generation

When a pattern triggers candidate generation, the evaluator produces a
structured candidate entry for the Reflector to collect:

[CANDIDATE_FORMAT]
candidate_id: auto-generated UUID
source_taskrun: taskrun_id
pattern_type: failure_pattern | gap_pattern | success_pattern
trigger_condition: plain English description of when this fires
recommended_action: plain English description of what to do
suggested_bullet_text: English text for the Playbook bullet
confidence: low | medium | high
times_seen_this_week: integer

## Visualization Output

In addition to the JSON evaluation, the evaluator produces a human-readable
visualization block for each TaskRun:

[VISUALIZATION_TEMPLATE]
```
{atc_id} | {timestamp}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Input:    {input_summary}
Result:   {quality_gate} | Score: {output_score}
{red_line_note if applicable}

Process:  {duration_bar} {duration_ms}ms | {retry_count} retries
Playbook: {bullets_hit} triggered | {bullets_missed} missed

IPCP:     {ipcp_status}
Delivery: {delivery_status}

Internal Eval:  {evaluation_score}/100
Expert Eval:    {expert_flag_status}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Integration Notes

- The evaluator reads but does not modify TaskRun files
- Evaluation results are written to: evaluation/{taskrun_id}.json
- Visualization blocks are written to: evaluation/viz/{taskrun_id}.txt
- Candidates are written to: playbook-candidates/{candidate_id}.json
- FClaw reads flagged TaskRuns and routes to expert queue if expert_flag=true
- Reflector collects from playbook-candidates/ on its scheduled run
