# mawa-evaluator-internal

Post-execution evaluator plugin for MAWA. Runs after every TaskRun and
produces an independent quality score, flags TaskRuns for expert review,
and generates Playbook improvement candidates.

## Quick start

1. FClaw invokes this skill after every TaskRun write
2. Evaluator reads the TaskRun, ATC, REGISTRATION, and PLAYBOOK
3. Scores the execution on 4 dimensions (25 points each)
4. Writes evaluation JSON to evaluation/{taskrun_id}.json
5. If expert_flag=true, FClaw routes to expert queue
6. Reflector collects candidates from playbook-candidates/ on its run

## Dimensions

| Dimension | Weight | What it measures |
|---|---|---|
| process_adherence | 25 | Did agent follow the ATC workflow? |
| output_quality | 25 | Is output complete and correctly structured? |
| playbook_application | 25 | Were Playbook bullets applied correctly? |
| delivery_correctness | 25 | Was output delivered to the right place? |

## Expert flag triggers

Expert review is flagged when ANY of:
- Total score < 70
- Same failure pattern seen 3+ times this week
- New failure pattern with no matching Playbook bullet

## Plugin interface

Any team can implement their own evaluator following the interface in
`plugin.yaml`. The core MAWA spec is unchanged.

## Output locations

- `evaluation/{taskrun_id}.json` — structured evaluation result
- `evaluation/viz/{taskrun_id}.txt` — human-readable visualization
- `playbook-candidates/{candidate_id}.json` — improvement candidates
