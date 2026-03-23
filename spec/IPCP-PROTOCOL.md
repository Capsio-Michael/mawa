# IPCP-PROTOCOL v1.0

**Inter-Position Communication Protocol**

IPCP defines how Positions communicate with each other in a MAWA system. All cross-Position messages must conform to this protocol.

---

## Design Principles

1. **Declared only** — Positions may only send/receive IPCP intents listed in their REGISTRATION.md
2. **Logged always** — Every IPCP message must be appended to the IPCP audit log
3. **MA-routed** — In standard MAWA topology, all inter-WA communication routes through the MA
4. **Traceable** — Every message carries a correlation ID for multi-hop tracing

---

## Message Format

```
[IPCP]
FROM: {position_id}
TO: {position_id}
INTENT: {intent_type}
CORRELATION_ID: {uuid}
PAYLOAD: {json_object}
```

All five fields are required. A message missing any field is malformed and must be rejected.

---

## Intent Types

| Intent | Direction | Purpose |
|--------|-----------|---------|
| `Request-ATC` | MA → WA | Assign a task to a WA |
| `Request-Data` | Any → Any | Request data from another Position |
| `Notify-Status` | WA → MA | Report task completion or status update |
| `Error-Report` | WA → MA | Report failure, anomaly, or boundary violation |

Positions may only use intents declared in their REGISTRATION.md. Attempting to send an undeclared intent is a violation — log it and refuse.

---

## IPCP Audit Log

Every IPCP message sent or received must be appended to:
```
{WORKSPACE}/audit/ipcp-log/{YYYY-MM-DD}-ipcp.jsonl
```

Log entry format (one JSON line per message):
```json
{
  "timestamp": "ISO8601",
  "direction": "inbound | outbound",
  "from_position": "string",
  "to_position": "string",
  "intent": "Request-ATC | Request-Data | Notify-Status | Error-Report",
  "correlation_id": "string",
  "payload_summary": "one-line description (no sensitive data)",
  "registration_check": "PASS | FAIL",
  "outcome": "delivered | rejected | pending"
}
```

`registration_check` must be evaluated before delivery — PASS only if both sender and receiver have declared this intent type.

---

## Standard Flows

### Task Assignment (MA → WA)
```
[IPCP]
FROM: {MA_ID}
TO: {WA_ID}
INTENT: Request-ATC
CORRELATION_ID: {uuid}
PAYLOAD: {
  "atc_id": "ATC-{WA_ID}-{TASK}",
  "submitted_by": "string",
  "source_channel": "string",
  "message": "string (content summary)",
  "timestamp": "ISO8601"
}
```

### Task Completion (WA → MA)
```
[IPCP]
FROM: {WA_ID}
TO: {MA_ID}
INTENT: Notify-Status
CORRELATION_ID: {same uuid as Request-ATC}
PAYLOAD: {
  "atc_id": "string",
  "taskrun_id": "string",
  "status": "complete | skipped | partial",
  "quality_gate": "PASS | FAIL",
  "summary": "one-line result description"
}
```

### Error Report (WA → MA)
```
[IPCP]
FROM: {WA_ID}
TO: {MA_ID}
INTENT: Error-Report
CORRELATION_ID: {taskrun_id}
PAYLOAD: {
  "atc_id": "string",
  "error_type": "tool_failure | input_invalid | timeout | quality_gate_fail | data_unavailable",
  "error_detail": "string",
  "retry_count": "integer",
  "recommended_action": "retry | escalate | skip"
}
```

### Data Request (Any → Any, via MA)
```
[IPCP]
FROM: {REQUESTER_ID}
TO: {MA_ID}
INTENT: Request-Data
CORRELATION_ID: {uuid}
PAYLOAD: {
  "data_type": "string",
  "filters": {},
  "reason": "string"
}
```

---

## Correlation ID

The `CORRELATION_ID` links related messages across a workflow:

- MA assigns task → generates a UUID as CORRELATION_ID
- WA uses same CORRELATION_ID in its Notify-Status or Error-Report reply
- All TaskRuns in the same workflow chain share the same CORRELATION_ID
- This enables full tracing of a task from assignment to completion

---

## Error Handling

When a WA encounters a failure during ATC execution:

1. Write TaskRun with error details
2. If `retry_max` not yet reached → retry
3. If retries exhausted → send `Error-Report` to MA
4. MA decides: retry again, escalate to owner, or skip

WAs never silently fail. Every failure produces a TaskRun and (if retries exhausted) an Error-Report.

---

## Registration Enforcement

Before sending any IPCP message, the sender must verify:
1. The intent type is listed in my `allowed_ipcp_outbound` in REGISTRATION.md
2. The recipient Position is listed in my `collaboration_scope` in REGISTRATION.md

Before processing any received IPCP message, the receiver must verify:
1. The intent type is listed in my `accepted_ipcp_intents` in REGISTRATION.md
2. The sender Position is listed in my `collaboration_scope` in REGISTRATION.md

If either check fails → reject the message, write a deny log entry, send Error-Report to MA.

---

## Implementing on Other Platforms

IPCP is platform-agnostic. The message format can be transmitted via:

- **Messaging platforms** (Feishu, Slack, Teams) — send as structured text message
- **Message queues** (Redis, RabbitMQ) — serialize as JSON
- **Function calls** — pass as structured parameters
- **Shared files** — write to a watched inbox directory

What matters is the five-field structure and the audit log — not the transport layer.

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
