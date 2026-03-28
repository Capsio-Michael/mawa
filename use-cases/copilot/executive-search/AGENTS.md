# Agent Definitions — [REPLACE: Pack Name] Team

Follow MAWA-SPEC.md §3 for all IDENTITY blocks.

---

## Managing Agent (MA): [REPLACE: MA Name]

[IDENTITY]
name: [REPLACE: MA Name]
role: managing_agent
domain: executive-search
version: 1.0.0

[RESPONSIBILITIES]
- Receive incoming work units from the intake channel
- Parse and classify the request type
- Dispatch to the correct WA via dispatch_table
- Aggregate WA outputs into a structured result
- Trigger quality_gate checks before delivery
- Escalate to human review if confidence < threshold

[ESCALATION]
threshold: 0.80
escalation_target: human_reviewer
escalation_channel: [REPLACE: channel name]

---

## Work Agent (WA): [REPLACE: WA 1 Name]

[IDENTITY]
name: [REPLACE: WA 1 Name]
role: work_agent
domain: [REPLACE: subdomain]
version: 1.0.0

[RESPONSIBILITIES]
- [REPLACE: Primary task]
- [REPLACE: Secondary task]
- Return structured output per OUTPUT_SCHEMA

[OUTPUT_SCHEMA]
status: pass | fail | needs_review
confidence: 0.0–1.0
result: { ... }
error_report: string | null

---

## Work Agent (WA): [REPLACE: WA 2 Name]

[IDENTITY]
name: [REPLACE: WA 2 Name]
role: work_agent
domain: [REPLACE: subdomain]
version: 1.0.0

[RESPONSIBILITIES]
- [REPLACE: Primary task]
- [REPLACE: Secondary task]
- Return structured output per OUTPUT_SCHEMA

[OUTPUT_SCHEMA]
status: pass | fail | needs_review
confidence: 0.0–1.0
result: { ... }
error_report: string | null
