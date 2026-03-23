---
atc_id: ATC-{POSITION_ID}-ANOMALY-ALERT
position_id: {POSITION_NAME}
version: 1
sla_minutes: 2
---

# ATC: Anomaly Alert

Triggered automatically when |change| > 5% for any stock.
This is a hard trigger — it cannot be suppressed.

## Alert Message to {MA_NAME} via IPCP
```
[IPCP]
FROM: {POSITION_NAME}
TO: {MA_NAME}
INTENT: Notify-Status
CORRELATION_ID: {taskrun_id}
PAYLOAD: {
 "stock_name": "string",
 "stock_code": "string",
 "change_pct": "float",
 "direction": "🔥 Hot | ⚠️ Alert",
 "current_price": "float",
 "broadcast_time": "string"
}
```

{MA_NAME} decides whether to escalate to {OWNER_NAME}.
{POSITION_NAME} does NOT directly message {OWNER_NAME} for anomalies.
