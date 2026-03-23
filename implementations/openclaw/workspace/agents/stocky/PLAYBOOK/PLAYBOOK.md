---
position_id: {POSITION_NAME}
playbook_type: WA
version: 1
status: PILOT
created: {CREATION_DATE}
---

# {POSITION_NAME} WA Playbook v1

## Execution Bullets

### E-001
**Condition:** Data source returns stale data (timestamp > 15 minutes old)
**Action:** Mark stock status as ❓ 待核实 regardless of discrepancy calculation.
Add note in broadcast: "数据可能延迟，请以实际市场为准。"

### E-002
**Condition:** Market is closed (weekend, public holiday, or pre/post market)
**Action:** Skip broadcast. Write TaskRun with status = "market_closed".
Do NOT send a broadcast message. Do NOT send error to {MA_NAME}.

### E-003
**Condition:** Single stock fetch fails but others succeed
**Action:** Broadcast the successful stocks normally. For the failed stock,
include: "【{name} {code}】数据获取失败，请稍后查看。"
Send IPCP Error-Report to {MA_NAME} for the failed stock only.

### E-004
**Condition:** Both calculated and source values show change > 5% and are consistent
**Action:** Trigger ATC-{POSITION_ID}-ANOMALY-ALERT even if status = ✅ 一致.
The anomaly threshold overrides the consistency check.

## Risk Control Bullets

### R-001
**Condition:** Data source completely unavailable (all stocks fail)
**Action:** Do not send any broadcast. Send IPCP Error-Report to {MA_NAME}:
"所有股票数据源不可用，播报已取消。" Write TaskRun with status = "data_source_failure".

### R-002
**Condition:** Cron trigger fires but previous broadcast TaskRun for same time slot
already exists today (duplicate trigger)
**Action:** Skip execution. Write a minimal TaskRun: "duplicate_trigger_skipped".
Do not send a second broadcast.
