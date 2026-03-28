# Workflow: KYC/AML Customer Onboarding

## ATC Task Card — AP-KYC-001: Full Onboarding KYC

[ATC]
task_id: AP-KYC-001
task_name: customer_onboarding_kyc
trigger: new_application_received
sla_minutes: 4
retry_max: 1

input_schema:
  - field: application_id
    type: string
    required: true
  - field: applicant
    type: object
    required: true
    fields: [full_name, dob, nationality, id_type, id_number, address]
  - field: documents_submitted
    type: array
    required: true
    valid_values: [passport_scan, national_id_scan, utility_bill, selfie, bank_statement]
  - field: source_of_funds
    type: string
    required: true
  - field: account_type
    type: string
    required: true
    valid_values: [personal, corporate, joint]
  - field: submitted_at
    type: string (ISO8601)
    required: true

dispatch_table:
  - condition: always (parallel dispatch)
    target_agent: DocBot
    task_id: AP-KYC-002
  - condition: always (parallel dispatch)
    target_agent: RiskBot
    task_id: AP-KYC-003
  - condition: docbot.status == fail OR riskbot.status == reject
    → verdict: reject
  - condition: riskbot.pep_result.is_pep == true OR docbot.confidence < 0.80 OR riskbot.confidence < 0.80
    → verdict: refer_to_compliance
  - condition: docbot.status == pass AND riskbot.status == pass AND all confidence >= 0.80
    → verdict: pass
  - condition: verdict in [refer_to_compliance, reject, pass]
    target_agent: AuditBot
    task_id: AP-KYC-004

quality_gate:
  min_confidence: 0.80
  required_fields: [application_id, verdict, docbot_result, riskbot_result, audit_record_id]
  on_fail: escalate_to_human

output_schema:
  application_id: string
  verdict: pass | refer_to_compliance | reject
  reject_reason_code: string | null
  refer_reason: string | null
  docbot_result: object
  riskbot_result: object
  audit_record_id: string
  processing_time_ms: number
  agent_trace: array

---

## ATC Task Card — AP-KYC-002: Document Verification

[ATC]
task_id: AP-KYC-002
task_name: document_verification
trigger: dispatched_by_vera
parent_task_id: AP-KYC-001
sla_minutes: 2
retry_max: 1

input_schema:
  - field: application_id
    type: string
    required: true
  - field: documents_submitted
    type: array
    required: true
  - field: applicant_declared
    type: object
    fields: [full_name, dob, nationality, id_type, id_number, address]

quality_gate:
  required_fields: [status, confidence, extracted_fields, flags]
  on_fail: return_to_vera_with_error

---

## ATC Task Card — AP-KYC-003: PEP/Sanctions Screening

[ATC]
task_id: AP-KYC-003
task_name: pep_sanctions_screening
trigger: dispatched_by_vera
parent_task_id: AP-KYC-001
sla_minutes: 2
retry_max: 1

input_schema:
  - field: application_id
    type: string
    required: true
  - field: full_name
    type: string
    required: true
  - field: dob
    type: string (YYYY-MM-DD)
    required: true
  - field: nationality
    type: string (ISO 3166-1 alpha-2)
    required: true

quality_gate:
  required_fields: [status, confidence, sanctions_result, pep_result, risk_tier]
  on_fail: return_to_vera_with_error

---

## ATC Task Card — AP-KYC-004: Audit Trail Generation

[ATC]
task_id: AP-KYC-004
task_name: audit_trail_generation
trigger: dispatched_by_vera_after_verdict
parent_task_id: AP-KYC-001
sla_minutes: 1
retry_max: 2

quality_gate:
  required_fields: [status, audit_record_id, audit_record_path]
  on_fail: escalate_immediately (audit failure is a compliance event)

---

## Flow diagram

```
Intake channel
    ↓
Vera (AP-KYC-001)
    ├─────────────────────────────┐
    ↓                             ↓
DocBot (AP-KYC-002)          RiskBot (AP-KYC-003)
[document verification]      [PEP/sanctions screening]
    ↓                             ↓
    └──────────── Vera ───────────┘
                    ↓
            Decision logic
                    ├── pass → AuditBot → delivery
                    ├── refer_to_compliance → AuditBot → compliance_officer queue
                    └── reject → AuditBot → rejection notice + compliance log
```

## Reject reason codes

| Code | Meaning |
|------|---------|
| `SANC-001` | Confirmed sanctions list match (OFAC/UN/EU/MAS) |
| `DOC-001` | Document authenticity check failed |
| `DOC-002` | Document expired |
| `DOC-003` | Name mismatch between document and application |
| `DOC-004` | Required document not submitted |
| `RISK-001` | Risk tier = prohibited (jurisdiction restriction) |

## Refer reason codes

| Code | Meaning |
|------|---------|
| `PEP-001` | PEP match — requires enhanced due diligence |
| `PEP-002` | RCA match — relative/close associate of PEP |
| `DOC-LOW` | Document confidence below 0.80 — manual review required |
| `SANC-LOW` | Possible sanctions match (0.80–0.95) — manual confirmation required |
| `SOF-001` | Source of funds requires additional documentation |
