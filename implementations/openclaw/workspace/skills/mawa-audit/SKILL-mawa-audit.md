---
name: mawa-audit
description: Weekly MAWA Security and Cost Audit — reads deny logs, IPCP logs,
 TaskRuns, and quality gate results to produce a security posture report and
 cost observability report. Runs every Sunday at 22:30 (30 min after Reflector).
 Sends summary to {OWNER_NAME} via {CHANNEL_NAME}.
---

# MAWA Audit Skill

## Execution Workflow

### Phase 1: Security Audit

#### 1A — Deny Log Analysis
Read all deny log entries from past 7 days:
`{WORKSPACE}/audit/deny-logs/`

Compute per position:
- Total boundary violations attempted
- Breakdown by violation_type
- Most frequent violation (what keeps getting tried?)
- Trend: increasing or decreasing vs prior week?

Flag for {OWNER_NAME}'s attention:
- Any single violation_type appearing > 3 times in one week
- Any violation from an unexpected requestor
- Any violation where explanation_sent = false (silent refusal — needs review)

#### 1B — IPCP Audit
Read all IPCP log entries from past 7 days:
`{WORKSPACE}/audit/ipcp-log/`

Compute:
- Total IPCP messages per position (inbound + outbound)
- registration_check = FAIL count (attempted unauthorized IPCP)
- Most active IPCP pair (which two positions communicate most?)
- Error-Report count per position (how often is each WA escalating failures?)
- Any IPCP with outcome = rejected (attempted out-of-scope communication)

#### 1C — Quality Gate Audit
Read all TaskRun files, extract quality_gate field:
- quality_gate = FAIL rate per position per ATC
- Positions with FAIL rate > 20% this week → flag as "needs Playbook attention"
- ATCs that failed quality gate more than once → list for Curator review

#### 1D — Generate Security Posture Report
Write to: `{WORKSPACE}/audit/security-report-{YYYY-MM-DD}.md`

```markdown
# MAWA Security Posture Report — {date}

## Zero-Trust Status: {STRONG / MODERATE / NEEDS_ATTENTION}

### Deny Log Summary (7 days)
| Position | Total Violations | Top Violation Type | Trend |
|----------|-----------------|-------------------|-------|
| {WA_1} | {n} | {type} | ↑/↓/→ |
| {WA_2} | {n} | {type} | ↑/↓/→ |
| {WA_3} | {n} | {type} | ↑/↓/→ |
| {WA_4} | {n} | {type} | ↑/↓/→ |

### IPCP Audit Summary
| Pair | Messages | Unauthorized Attempts | Error-Reports |
|---------------|----------|-----------------------|---------------|
| {WA_1}→{MA_NAME} | {n} | {n} | {n} |
| {WA_2}→{MA_NAME} | {n} | {n} | {n} |
| {WA_3}→{MA_NAME} | {n} | {n} | {n} |
| {WA_4}→{MA_NAME} | {n} | {n} | {n} |

### Quality Gate Health
| Position | ATC | FAIL Rate | Status |
|----------|---------------------------|-----------|-----------|
| {pos} | {atc} | {pct}% | ✅ / ⚠️ |

### Flags Requiring Attention
{list any items flagged above, or "无异常" if clean}

### Registration Integrity
All {WA_COUNT} WA REGISTRATION.md files: {verified / needs_review}
Hard rules enforced: {n} violations caught this week
```

---

### Phase 2: Cost Observability

#### 2A — Per-Position Cost Analysis
Read all TaskRun files from past 7 days. For each position, extract:
- `token_estimate` field (sum across all TaskRuns)
- `tools_used` field (count tool calls per tool per position)
- `duration_ms` field (total execution time)
- ATC execution count (how many tasks ran)
- quality_gate PASS/FAIL ratio (efficiency metric)

#### 2B — Per-ATC Cost Breakdown
For each unique ATC, compute:
- Average token_estimate per execution
- Average duration_ms per execution
- Total executions this week
- Cost trend vs prior week (if prior week data exists)
- Most expensive ATC (highest avg token_estimate)

#### 2C — Playbook Efficiency Score
Compare this week vs last week (if data available):
- Did Playbook bullet hits INCREASE? (good — means fewer raw LLM decisions)
- Did token_estimate per ATC DECREASE? (good — Playbook reducing reasoning cost)
- Compute: Playbook Efficiency = bullet_hit_count / total_atc_executions

This number should grow over time as Playbooks improve.

#### 2D — Generate Cost Report
Write to: `{WORKSPACE}/cost/weekly/cost-report-{YYYY-MM-DD}.md`

```markdown
# MAWA Cost Report — {date}

## Team Summary (7 days)
| Position | ATC Executions | Est. Tokens | Avg Token/ATC | Pass Rate | Playbook Efficiency |
|----------|---------------|-------------|---------------|-----------|---------------------|
| {WA_1} | {n} | {n} | {n} | {pct}% | {pct}% |
| {WA_2} | {n} | {n} | {n} | {pct}% | {pct}% |
| {WA_3} | {n} | {n} | {n} | {pct}% | {pct}% |
| {WA_4} | {n} | {n} | {n} | {pct}% | {pct}% |
| **Total**| {n} | {n} | {n} | {pct}% | {pct}% |

## Most Expensive ATCs This Week
| ATC | Avg Tokens | Executions | Total Tokens |
|----------------------------------|------------|------------|--------------|
| {atc_id} | {n} | {n} | {n} |

## Tool Usage Frequency
| Tool | Calls | Positions Using |
|-----------------------|-------|-----------------|
| {channel}_im_send | {n} | {WA_3}, {WA_4} |
| {channel}_doc_write | {n} | {WA_1}, {WA_2} |
| {other tools} | {n} | {positions} |

## Efficiency Trends
- Playbook Efficiency this week: {pct}% (target: >60%)
- Token/ATC trend: {↓ improving / ↑ increasing / → stable}
- Top cost driver: {position} / {atc}

## Optimization Suggestions
{auto-generate 2-3 suggestions based on data, e.g.:}
- "{WA_2}'s ATC-{WA_2}-ASSET-EVALUATE 平均消耗最高，
 建议 Reflector 分析是否有 Playbook 优化空间"
- "{WA_4} 的 market_closed 跳过率高，建议检查 cron 是否误触发非交易日"
```

---

### Phase 3: Combined Weekly {CHANNEL_NAME} Report

Send to {OWNER_NAME} via private message:

```
🛡️ MAWA 安全 & 成本周报 | {date}

━━━━━━━━ 安全状态 ━━━━━━━━
零信任状态：{STRONG ✅ / MODERATE ⚠️ / NEEDS_ATTENTION 🔴}

本周边界防护：
• 捕获越权尝试：{total} 次
• IPCP 违规拦截：{n} 次
• Quality Gate 拦截：{n} 次
{if flags: "⚠️ 需关注：{flag_count} 项，详见报告"}

━━━━━━━━ 成本状态 ━━━━━━━━
本周总估算 Token：{total}
最高消耗岗位：{position} ({n} tokens)
Playbook 效率：{pct}% {↑↓→}
{if trend improving: "✅ 成本持续优化中"}
{if trend worsening: "⚠️ 成本上升，建议 Curator 审查"}

━━━━━━━━ 行动项 ━━━━━━━━
{list flags + suggestions, or "本周无需人工介入 ✅"}

📁 完整报告：
• 安全报告：audit/security-report-{date}.md
• 成本报告：cost/weekly/cost-report-{date}.md

— {MA_NAME} MAWA Audit 🦞
```

## Cron Schedule
Run every Sunday at 22:30 (30 minutes after Reflector finishes).
