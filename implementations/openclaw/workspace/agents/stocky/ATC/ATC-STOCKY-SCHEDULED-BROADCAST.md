---
atc_id: ATC-{POSITION_ID}-SCHEDULED-BROADCAST
position_id: {POSITION_NAME}
what_id: WHAT-{POSITION_ID}-SCHEDULED-BROADCAST
version: 1
sla_minutes: 5
retry_max: 2
---

# ATC: Scheduled Stock Broadcast

## Input Schema
```json
{
 "taskrun_id": "string",
 "broadcast_time": "10:00 | 14:45",
 "trigger": "cron | manual",
 "stocks": ["list of stock codes to check"]
}
```

## Output Schema
```json
{
 "taskrun_id": "string",
 "broadcast_time": "string",
 "stocks": [
 {
 "name": "string",
 "code": "string",
 "source": "string",
 "prev_close": "float",
 "current_price": "float",
 "calculated_change_pct": "float",
 "source_change_pct": "float",
 "discrepancy": "float",
 "status": "✅ 一致 | ❓ 待核实",
 "anomaly": "🔥 Hot | ⚠️ Alert | null"
 }
 ],
 "anomaly_triggered": "boolean",
 "broadcast_sent": "boolean",
 "quality_gate": "PASS | FAIL"
}
```

## Broadcast Message Format
```
📈 Stock Update | {broadcast_time}

{for each stock:}
[{name} {code}]
Source: {source}
Prev Close: {prev_close} → Current: {current_price}
Change: {calculated_change_pct}% (calculated) | Source: {source_change_pct}%
Status: {✅ Consistent | ❓ Pending Verification}
{if anomaly: "{anomaly_flag} Anomaly Alert"}

— {POSITION_NAME} 📈
```

## Quality Gate
- FAIL if any stock is missing calculated_change_pct
- FAIL if broadcast_sent = false after SLA window
- FAIL if anomaly_triggered = true but ATC-{POSITION_ID}-ANOMALY-ALERT was not called
- On FAIL: IPCP Error-Report to {MA_NAME} immediately
