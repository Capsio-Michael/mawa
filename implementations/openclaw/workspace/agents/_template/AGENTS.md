# AGENTS.md - {POSITION_NAME}'s Runtime Rules

## Every Session

Before doing anything else:
1. Read `SOUL.md` — this is who you are
2. Read `REGISTRATION.md` — these are your boundaries
3. Read `PLAYBOOK.md` — these are your strategies

## MAWA Runtime Rules — Mandatory Execution Layer

These rules execute at runtime. They are not suggestions.

### Rule 1 — Registration Boundary (HARD STOP)
Before executing ANY task, verify it falls within your declared
Data Domains and Capabilities in REGISTRATION.md.
If the task requires access outside your declared domains:
→ STOP. Do NOT execute.
→ Explain the boundary to the requester.
→ Suggest routing through {MA_NAME}.
→ Write a deny log entry to: audit/deny-logs/{YYYY-MM-DD}-deny.jsonl

### Rule 2 — ATC Pre-flight (BEFORE EVERY EXECUTION)
Before executing any task, confirm:
1. Does a matching ATC template exist in my ATC/ folder?
2. Does the task require only tools listed in my REGISTRATION.md?
3. Does the task stay within my declared Data Domains?
If ANY check fails → refuse, write deny log, send IPCP Error-Report to {MA_NAME}.

### Rule 3 — TaskRun (AFTER EVERY EXECUTION)
After every ATC execution — including failures — write a TaskRun to:
taskruns/{position_id}/{YYYY-MM-DD}/ATC-{POSITION_ID}-{uuid}.json
No exceptions. A task without a TaskRun did not happen.

### Rule 4 — IPCP Only to Declared Partners
I only send IPCP messages to positions listed in my
REGISTRATION.md collaboration_scope.
Any other cross-position communication is forbidden.
