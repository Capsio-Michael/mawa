---
name: mawa-dispatcher
description: MAWA 统一任务分发器。{MA_NAME} 收到任何消息后调用此 Skill，
 自动读取所有 WA 的 REGISTRATION.md，判断任务是否匹配某个 WA 的能力范围，
 匹配则自动按标准 ATC 分发执行，不匹配则返回 "NO_MATCH" 由 {MA_NAME} 自行处理。
---

# MAWA Task Dispatcher

## 核心职责
这是 {MA_NAME} 的"大脑路由层"。
每次收到消息，先过这个 Dispatcher，再决定谁来做。

## 执行流程

### Phase 1: 读取 Dispatch Table
读取文件：{WORKSPACE}/MAWA_DISPATCH_TABLE.md
这是所有 WA 能力和触发规则的索引（比每次读4个 REGISTRATION.md 更快）。

### Phase 2: 消息解析
从输入消息中提取：
- 来源群/渠道 ID
- 发送者
- 消息内容
- 消息类型（文本/引用/@mention）

### Phase 3: 规则匹配（按优先级顺序）

**规则匹配顺序：**

1. 精确 ATC 匹配
 消息中包含明确的 ATC ID（如 "ATC-{POSITION_ID}-ASSET-EVALUATE"）
 → 直接路由到对应 WA，跳过其他规则

2. 关键词匹配
 对照 DISPATCH_TABLE 中每个 WA 的 trigger_keywords
 → 找到第一个匹配的 WA 和对应 ATC

3. 来源渠道匹配
 消息来自特定群/渠道，且该群绑定了特定 WA
 → 路由到绑定的 WA

4. 无匹配
 → 返回 NO_MATCH，由 {MA_NAME} 自行处理

### Phase 4: 执行分发

**匹配成功时：**
1. 在原消息渠道回复：
 "收到 [{发送者}的{任务类型}]，已分配给 {WA名称} 按 {ATC_ID} 标准执行。"
2. 通知对应 WA 执行 ATC，传递：
 - 原始消息内容
 - 发送者
 - 来源渠道
 - 时间戳
3. 写 IPCP 日志：
 [IPCP] FROM: {MA_NAME} / TO: {WA} / INTENT: Request-ATC /
 CORRELATION_ID: {uuid} /
 PAYLOAD: {"atc": "{ATC_ID}", "source": "{渠道}", "submitted_by": "{发送者}",
 "message": "{内容摘要}"}
4. 写 TaskRun：
 {WORKSPACE}/taskruns/{ma_id}/{date}/DISPATCH-{uuid}.json

**NO_MATCH 时：**
返回以下结构给 {MA_NAME}：
{
 "matched": false,
 "reason": "无匹配的 WA 能力",
 "suggested_action": "{MA_NAME} 自行处理",
 "original_message": "{消息内容}"
}
{MA_NAME} 收到后根据情况自行回复，不需要再调用 Dispatcher。
