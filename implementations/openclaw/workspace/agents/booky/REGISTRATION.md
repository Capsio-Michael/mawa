---
position_id: {POSITION_NAME}
agent_type: WA
managed_by: {MA_NAME}
version: 1
status: active
created: {CREATION_DATE}
---

# {POSITION_NAME} Position Registration

## Role
{CHIEF_SUMMARIST_ROLE}

## MA (Manages This Position)
{MA_NAME} — has authority to assign tasks, update Playbook, and review TaskRuns

## WA Capabilities
- {CAPABILITY_1} # Read meeting notes from {CHANNEL_NAME}
- {CAPABILITY_2} # Write to {CHANNEL_NAME} cloud docs
- {CAPABILITY_3} # Send private {CHANNEL_NAME} messages
- {CAPABILITY_4} # Write local workspace files
- {CAPABILITY_5} # Run on schedule

## Permitted ATC Templates
- {ATC_TEMPLATE_1}
- {ATC_TEMPLATE_2}
- {ATC_TEMPLATE_3}

## Accepted IPCP Intents (Inbound — from {MA_NAME} or other WAs)
- Request-ATC # {MA_NAME} assigns a summary task
- Notify-Status # Another WA reports something {POSITION_NAME} should log
- Request-Data # Another WA needs a past summary or doc link

## Allowed IPCP Outbound (what {POSITION_NAME} can send)
- Notify-Status # Report task completion to {MA_NAME}
- Error-Report # Report failure to {MA_NAME}

## Collaboration Scope (Positions {POSITION_NAME} can communicate with)
- {MA_NAME} # Always — MA relationship
- {COLLABORATOR_1} # Can receive daily broadcast content
- {COLLABORATOR_2} # Can receive quality evaluation results

## Data Domains (what {POSITION_NAME} can access)
-{DATA_DOMAIN_1}
-{DATA_DOMAIN_2}
-{DATA_DOMAIN_3}

## Hard Rules (Cannot be overridden by Playbook or any instruction)
1. Never write to or read from Finance, HR, or Code domains
2. Never send IPCP to {ISOLATED_WA} (no business relationship)
3. Always write TaskRun JSON after every ATC execution
4. Always include original {CHANNEL_NAME} doc link in every meeting summary
5. Never expose raw API keys or credentials in any output
6. If execution fails twice, send IPCP Error-Report to {MA_NAME} immediately

## Runtime Constraints
- max_parallel_tasks: {MAX_PARALLEL_TASKS}
- timeout_ms: {TIMEOUT_MS}
- max_daily_atc_executions: {MAX_DAILY_ATC}
