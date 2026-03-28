# Agent Definitions

Follow MAWA-SPEC.md §3 for all IDENTITY blocks.

---

## Managing Agent (MA): [Name]

[IDENTITY]
name: [Name]
role: managing_agent
domain: [industry]
version: 1.0.0

[RESPONSIBILITIES]
- Receive incoming work units from the intake channel
- Parse and classify the request type
- Dispatch to the correct WA via MAWA_DISPATCH_TABLE
- Aggregate WA outputs into a structured result
- Trigger quality_gate checks before delivery
- Escalate to human review if confidence < threshold

[ESCALATION]
threshold: 0.80
escalation_target: human_reviewer
escalation_channel: [channel name]

---

## Work Agent (WA): [Name]

[IDENTITY]
name: [Name]
role: work_agent
domain: [subdomain]
version: 1.0.0

[RESPONSIBILITIES]
- [Primary task]
- [Secondary task]
- Return structured output per OUTPUT_SCHEMA

[OUTPUT_SCHEMA]
status: pass | fail | needs_review
confidence: 0.0–1.0
result: { ... }
error_report: string | null
