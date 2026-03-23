---
version: 1
last_updated: {UPDATE_DATE}
maintained_by: {MA_NAME}
---

# MAWA Dispatch Table

## 说明
Dispatcher 的路由索引。优先级从高到低排列。
修改 WA 的 Registration 后必须同步更新此表。

---

## WA: {WA_2} 🏗️
**position_id:** {WA_2}
**role:** AI Quality Architect

### 触发渠道（source_channels）
- {TEAM_CHANNEL_ID} （{TEAM_NAME} 群）

### 触发关键词（trigger_keywords）
- A面 / A层 / 全流程 / A+6位编码
- B面 / B层 / ATC编号 / B+8位编码
- C面 / C层 / Skills / C+8位编码
- 工作汇报 / 技术报告 / 岗位智能体
- 归属节点 / 赋能岗位 / 业务目标

### 默认 ATC
- ATC-{WA_2}-ASSET-EVALUATE （通用评估）
- ATC-{WA_2}-RED-LINE-REJECT （触发红线时）
- ATC-{WA_2}-DAILY-QUALITY-REVIEW （每日汇总）

### 时间约束
- 仅工作日 16:00-18:30 内的消息触发自动路由
- 其他时间：关键词命中但超时 → {MA_NAME} 告知发送者"请在工作日16:00-18:30提交"

---

## WA: {WA_1} 📚
**position_id:** {WA_1}
**role:** Chief Summarist

### 触发渠道
- {CHANNEL_NAME}会议助手私信（meeting_assistant）
- 任何群中由会议助手发出的会议纪要

### 触发关键词
- 会议纪要 / 会议记录 / 今日会议
- meeting summary / 纪要

### 默认 ATC
- ATC-{WA_1}-MEETING-EXTRACT （单次会议提取）
- ATC-{WA_1}-DAILY-SUMMARY （每日汇总，由 cron 触发，不走 Dispatcher）

### 时间约束
- 无时间约束，任何时间收到会议纪要均触发

---

## WA: {WA_3} 🌶
**position_id:** {WA_3}
**role:** Personal Assistant

### 触发渠道
- {OWNER_NAME}的私信（仅限{OWNER_NAME}本人发送）

### 触发关键词
- 记住 / 提醒我 / 记一下
- 今天 / 明天 / 安排
- 个人备忘类自然语言

### 默认 ATC
- ATC-{WA_3}-CAPTURE-THOUGHT （想法捕捉）
- ATC-{WA_3}-REMINDER （提醒设置）
- ATC-{WA_3}-EVENING-SUMMARY （由 cron 触发，不走 Dispatcher）

### 时间约束
- 无时间约束

---

## WA: {WA_4} 📈
**position_id:** {WA_4}
**role:** Stock Monitor

### 触发渠道
- 不通过 Dispatcher 触发（纯 cron 驱动）
- 仅 {MA_NAME} 可手动触发：询问某支股票价格时

### 触发关键词（仅 {MA_NAME} 手动查询时）
- 股价 / 股票 / 涨跌幅

### 默认 ATC
- ATC-{WA_4}-SCHEDULED-BROADCAST （由 cron 触发）
- ATC-{WA_4}-ANOMALY-ALERT （自动触发，不走 Dispatcher）

### 时间约束
- 交易日 09:30-15:30

---

## {MA_NAME} 自处理（NO_MATCH）

以下情况由 {MA_NAME} 直接处理，不分发给任何 WA：
- 技术问题咨询
- 系统配置请求
- 跨 WA 的综合性问题
- 闲聊、问候
- 不符合任何 WA 能力范围的任务

{MA_NAME} 处理后写入：
{WORKSPACE}/audit/{ma_id}-handled.jsonl
