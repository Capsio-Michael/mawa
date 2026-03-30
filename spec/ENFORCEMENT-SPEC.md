# MAWA Registration Enforcement Spec

## v0.1.0 vs v0.2.0

v0.1.0: Prompt-level enforcement — MA reads REGISTRATION.md and
        enforces scope through instruction. Relies on model compliance.

v0.2.0: Code-level enforcement — tool invocations checked against
        ENFORCEMENT.yaml allowlist before execution. Model compliance
        is not required; the runtime blocks regardless.

## Enforcement Config Location

Each agent has a companion enforcement file:
- MA:  workspace/{MA_ID}_ENFORCEMENT.yaml
- WA:  workspace/agents/{WA_ID}/{WA_ID}_ENFORCEMENT.yaml

## What Gets Enforced

### 1. Tool allowlist
Every tool call is checked before execution.
If tool is not in allowlist → BLOCKED, logged, IPCP Error-Report to MA.

### 2. Data path sandbox
Every file read/write is checked against declared paths.
If path outside sandbox → BLOCKED, logged, IPCP Error-Report to MA.

### 3. Cross-agent ACL
Every IPCP message is checked against can_send_to / can_receive_from.
If agent not in ACL → BLOCKED, logged.
If violation is send attempt to denied agent → escalated to owner.

### 4. IPCP allowlist
Every IPCP intent is checked against allowlist.
If intent not in allowlist → BLOCKED, logged.

### 5. Hard rules (WA-specific)
Coded as named constraints in enforcement config.
Violations are logged and escalated to owner immediately.

## Deny Log Format

Every enforcement block produces a deny log entry:

```json
{
  "deny_id": "DENY-{POSITION_ID}-{TIMESTAMP}",
  "position_id": "string",
  "taskrun_id": "string | null",
  "violation_type": "tool_deny | data_deny | acl_deny | ipcp_deny | hard_rule",
  "attempted_action": "string",
  "blocked_value": "string",
  "enforcement_rule": "string",
  "action_taken": "log_and_block | log_and_escalate_to_fclaw | log_and_escalate_to_owner",
  "timestamp": "ISO8601"
}
```

Deny logs are written to: `audit/deny-log/{YYYY-MM-DD}.jsonl`

## Enforcement is additive

The enforcement layer does not replace REGISTRATION.md.
REGISTRATION.md remains the human-readable declaration.
ENFORCEMENT.yaml is the machine-executable version.
Both must be kept in sync. FClaw is responsible for sync on update.
