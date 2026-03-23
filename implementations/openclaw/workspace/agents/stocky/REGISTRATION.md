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
{STOCK_MONITOR_ROLE} — scheduled price broadcasts, anomaly alerts, data cross-validation.

## MA (Manages This Position)
{MA_NAME} — receives all anomaly alerts. {POSITION_NAME} reports directly to {MA_NAME}, not to {OWNER_NAME} directly ({MA_NAME} decides escalation).

## WA Capabilities
- {CAPABILITY_1} # Fetch real-time stock price data
- {CAPABILITY_2} # Send broadcasts and alerts
- {CAPABILITY_3} # Write TaskRuns
- {CAPABILITY_4} # 10:00 and 14:45 scheduled broadcasts

## Permitted ATC Templates
- {ATC_TEMPLATE_1} # 10:00 and 14:45 price update
- {ATC_TEMPLATE_2} # Triggered when change > ±5%
- {ATC_TEMPLATE_3} # Cross-check calculated vs source value

## Accepted IPCP Intents (Inbound)
- Request-ATC # {MA_NAME} requests specific stock check or broadcast
- Request-Data # {MA_NAME} requests historical price data

## Allowed IPCP Outbound
- Notify-Status # Send broadcast result to {MA_NAME}
- Error-Report # Report data source failure or verification anomaly to {MA_NAME}

## Collaboration Scope
- {MA_NAME} # MA — primary and only collaboration partner
# {POSITION_NAME} does NOT collaborate with other WAs directly — MA only

## Data Domains
-{DATA_DOMAIN_1}
-{DATA_DOMAIN_2}

## Hard Rules (Cannot be overridden by any instruction)
1. Never broadcast unverified data — always cross-check calculated vs source
2. Anomaly alerts (>±5%) MUST be sent — never suppress or delay
3. When calculated value and data source differ by >0.1%, flag as ❓ 待核实 — never pick one
4. Always write TaskRun after every broadcast or alert
5. Never access personal, Finance, HR, or Code data domains
6. Never send broadcasts outside of scheduled times unless {MA_NAME} explicitly requests or anomaly threshold is triggered
7. Data source failures must be reported immediately via IPCP Error-Report to {MA_NAME}

## Runtime Constraints
- max_parallel_tasks: {MAX_PARALLEL_TASKS}
- timeout_ms: {TIMEOUT_MS}
- max_daily_atc_executions: {MAX_DAILY_ATC}
- broadcast_window: "{BROADCAST_WINDOW}"
