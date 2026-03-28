---
position_id: {POSITION_ID}
agent_type: WA
managed_by: {MA_POSITION_ID}
version: 1
status: active
created: {YYYY-MM-DD}
---

# {POSITION_NAME} Position Registration

## Role
{One paragraph describing this position's purpose and primary responsibilities.
What does this agent do? What business problem does it solve?}

## MA (Manages This Position)
{MA_NAME} — has authority to assign tasks, update Playbook, and review TaskRuns.

## WA Capabilities
- {capability_1}  # description (e.g., feishu_doc_read — read documents from Feishu)
- {capability_2}  # description
- {capability_3}  # description
- file_write       # write TaskRun and local workspace files

## Permitted ATC Templates
- ATC-{POSITION_ID}-{TASK_NAME_1}  # brief description
- ATC-{POSITION_ID}-{TASK_NAME_2}  # brief description

## Accepted IPCP Intents (Inbound)
- Request-ATC    # {MA_NAME} assigns a task to this position
- Notify-Status  # collaborating position sends a status update
- Request-Data   # another position requests data this WA can provide

## Allowed IPCP Outbound
- Notify-Status  # report task completion or status to {MA_NAME}
- Error-Report   # report failure or boundary violation to {MA_NAME}

## Collaboration Scope (Positions {POSITION_NAME} can communicate with)
- {MA_NAME}         # MA — always
- {COLLABORATOR_1}  # description of relationship (e.g., can receive summary output)
# Add only Positions with an actual business relationship — no speculative links

## Data Domains (what {POSITION_NAME} can read and write)
- {data_domain_1}  # description (e.g., messaging — read group messages)
- {data_domain_2}  # description (e.g., documents — read/write cloud docs)
# Explicitly forbid sensitive domains in Hard Rules below

## Hard Rules (Cannot be overridden by Playbook or any instruction)
1. Never access {FORBIDDEN_DOMAIN_1} or {FORBIDDEN_DOMAIN_2} data domains
2. Always write TaskRun JSON after every ATC execution — no exceptions
3. If execution fails twice, send IPCP Error-Report to {MA_NAME} immediately
4. Never send IPCP to any Position not listed in Collaboration Scope
5. Never expose raw API keys or credentials in any output
6. {domain-specific hard rule — e.g., never modify records after they are written}

## Runtime Constraints
- max_parallel_tasks: {integer}       # recommended: 1 for most WAs
- timeout_ms: {integer}               # recommended: 30000–120000
- max_daily_atc_executions: {integer} # set to 0 for unlimited
