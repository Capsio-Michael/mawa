# REGISTRATION-SCHEMA v1.0

Every MAWA Position has a `REGISTRATION.md` file that declares its capabilities, boundaries, and collaboration rules. Registration is enforced at runtime — not aspirational.

---

## File Location

```
workspace/agents/{POSITION_ID}/REGISTRATION.md
```

For the MA (Managing Agent), Registration lives at the workspace root:
```
workspace/{MA_NAME}_REGISTRATION.md
```

---

## Full Schema

```yaml
---
position_id: {POSITION_ID}        # Uppercase identifier (e.g., BOOKY, MICHAEL, FCLAW)
agent_type: MA | WA               # Managing Agent or Worker Agent
managed_by: {MA_POSITION_ID}      # MA that governs this WA (omit for MA itself)
version: {integer}                # Increment on breaking capability changes
status: active | inactive | draft
created: {YYYY-MM-DD}
---
```

---

## Field Reference

### Role
One paragraph describing the Position's purpose and primary responsibilities. Written for humans — helps the MA understand what to route here.

### MA (Manages This Position)
For WAs: name of the MA that governs this position, and the nature of that relationship (can assign tasks, update Playbook, review TaskRuns).

### WA Capabilities
List of specific tool and API permissions this Position is authorized to use. Format:
```
- {tool_name}  # human-readable description
```
These are the ONLY tools this WA may invoke. Any tool not listed is forbidden.

### Permitted ATC Templates
List of ATC IDs this Position may execute. The WA must check this list in every preflight check. Format:
```
- ATC-{POSITION_ID}-{TASK_NAME}  # description
```

### Accepted IPCP Intents (Inbound)
What IPCP message types this Position is allowed to receive. Any incoming message with an unlisted intent must be rejected and logged.

Standard intents: `Request-ATC` | `Request-Data` | `Notify-Status` | `Error-Report`

### Allowed IPCP Outbound
What IPCP message types this Position is allowed to send. Any outbound message with an unlisted intent must be blocked and logged.

### Collaboration Scope
The complete list of Positions this Position may communicate with. All IPCP routing checks against this list. Communication with any Position not listed is forbidden.

### Data Domains
What data this Position may read and write. Format:
```
- {domain_name}  # description
```
Common domains: `messaging`, `documents`, `memory_files`, `finance`, `hr`, `code`, `personal`, `market_data`

Hard Rule: WAs should explicitly list domains they are **forbidden** from accessing in the Hard Rules section.

### Hard Rules
Constraints that cannot be overridden by any instruction — not by Playbook, not by ATC, not by a human request. If a Hard Rule conflicts with an instruction, the Hard Rule wins.

Format: numbered list. Each rule is a single, unambiguous statement.

Required Hard Rules for all WAs:
1. Always write TaskRun JSON after every ATC execution
2. If execution fails twice, send IPCP Error-Report to MA immediately

### Runtime Constraints
```yaml
max_parallel_tasks: {integer}         # Max simultaneous ATC executions
timeout_ms: {integer}                 # Max ms per ATC before timeout + Error-Report
max_daily_atc_executions: {integer}   # Daily cap (0 = unlimited)
```

Optional:
```yaml
broadcast_window: "{HH:MM-HH:MM}"    # For scheduled broadcast agents
sla_minutes: {integer}               # Default SLA, overridden per ATC
report_directly: {boolean}           # WA can deliver results to owner without MA relay
```

---

## Full Template

```markdown
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
{One paragraph describing this position's purpose and responsibilities.}

## MA (Manages This Position)
{MA_NAME} — has authority to assign tasks, update Playbook, and review TaskRuns.

## WA Capabilities
- {capability_1}  # description
- {capability_2}  # description

## Permitted ATC Templates
- ATC-{POSITION_ID}-{TASK_NAME}  # description

## Accepted IPCP Intents (Inbound)
- Request-ATC    # {MA_NAME} assigns a task
- Notify-Status  # status update from a collaborating position
- Error-Report   # (if applicable)

## Allowed IPCP Outbound
- Notify-Status  # report task completion to {MA_NAME}
- Error-Report   # report failure to {MA_NAME}

## Collaboration Scope
- {MA_NAME}         # MA — always
- {COLLABORATOR_1}  # description of relationship

## Data Domains
- {data_domain_1}  # description
- {data_domain_2}  # description

## Hard Rules (Cannot be overridden by Playbook or any instruction)
1. Never access {FORBIDDEN_DOMAIN} data domains
2. Always write TaskRun JSON after every ATC execution
3. If execution fails twice, send IPCP Error-Report to {MA_NAME} immediately
4. {domain-specific hard rule}

## Runtime Constraints
- max_parallel_tasks: {integer}
- timeout_ms: {integer}
- max_daily_atc_executions: {integer}
```

---

## Registration Enforcement Rules

**Pre-flight check (before every ATC execution):**
1. Does a matching ATC template exist in this WA's ATC/ folder?
2. Is this ATC ID listed in my Permitted ATC Templates?
3. Do this ATC's required tools appear in my WA Capabilities?
4. Does this task's data fall within my Data Domains?

All four must PASS. Any failure → refuse, write deny log, send IPCP Error-Report to MA.

**IPCP check (before sending any message):**
1. Is this intent type listed in my Allowed IPCP Outbound?
2. Is the recipient listed in my Collaboration Scope?

Both must PASS. Any failure → block, write deny log.

**IPCP check (on receiving any message):**
1. Is this intent type listed in my Accepted IPCP Intents?
2. Is the sender listed in my Collaboration Scope?

Both must PASS. Any failure → reject, write deny log.

---

## Deny Log Format

Every Registration violation must be logged to:
```
{WORKSPACE}/audit/deny-logs/{YYYY-MM-DD}-deny.jsonl
```

```json
{
  "timestamp": "ISO8601",
  "position_id": "string",
  "requested_by": "human | {other_position_id}",
  "request_summary": "brief description of what was requested",
  "violation_type": "data_domain | tool_unauthorized | atc_unauthorized | ipcp_scope | capability_exceeded",
  "registration_rule_violated": "exact rule from REGISTRATION.md",
  "action_taken": "refused_with_explanation | refused_silently",
  "explanation_sent": true
}
```

---

## MA Registration

The MA's Registration follows the same schema with these differences:
- `agent_type: MA`
- `managed_by`: omitted
- `WA Capabilities`: includes routing, IPCP relay, and Playbook governance tools
- `Permitted ATC Templates`: includes Dispatcher, Reflector, Curator, Audit skill triggers
- `Collaboration Scope`: includes all WAs it manages plus any external escalation targets
- No `max_daily_atc_executions` limit (MA handles all incoming routing)

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-03-23 | Initial public release |
| 1.1 | 2026-03-28 | Added enforcement rules, deny log format, MA registration notes |
