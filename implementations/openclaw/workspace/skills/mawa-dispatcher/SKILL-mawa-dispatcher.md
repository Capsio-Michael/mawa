---
name: mawa-dispatcher
description: MAWA unified task dispatcher. Called by {MA_NAME} on every inbound message.
  Reads the MAWA_DISPATCH_TABLE, matches the message to a WA, and routes it via ATC.
  Returns NO_MATCH if no WA fits — {MA_NAME} handles directly.
---

# MAWA Task Dispatcher

## Core Responsibility
This is {MA_NAME}'s routing layer.
Every inbound message passes through the Dispatcher before any action is taken.

## Execution Flow

### Phase 1: Load Dispatch Table
Read: {WORKSPACE}/MAWA_DISPATCH_TABLE.md
This is faster than reading all WA REGISTRATION.md files on every message.

### Phase 2: Parse Message
Extract from the input message:
- Source channel / group ID
- Sender identity
- Message content
- Message type (text / quote / @mention)

### Phase 3: Rule Matching (in priority order)

1. Exact ATC match
   Message contains a specific ATC ID (e.g., "ATC-{POSITION_ID}-ASSET-EVALUATE")
   → Route directly to the corresponding WA. Skip remaining rules.

2. Keyword match
   Message content matches a WA's trigger_keywords in the Dispatch Table
   → Route to the first matching WA and its default ATC

3. Source channel match
   Message origin matches a WA's declared source_channels
   → Route to the bound WA

4. No match
   → Return NO_MATCH. {MA_NAME} handles directly.

### Phase 4: Dispatch

**On match:**
1. Reply in the source channel:
   "Received [{sender}'s {task_type}] — assigned to {WA_name} under {ATC_ID}."
2. Notify the WA to execute the ATC, passing:
   - Original message content
   - Sender identity
   - Source channel
   - Timestamp
3. Write IPCP log:
   [IPCP] FROM: {MA_NAME} / TO: {WA} / INTENT: Request-ATC /
   CORRELATION_ID: {uuid} /
   PAYLOAD: {"atc": "{ATC_ID}", "source": "{channel}", "submitted_by": "{sender}", "message": "{summary}"}
4. Write TaskRun:
   {WORKSPACE}/taskruns/{ma_id}/{date}/DISPATCH-{uuid}.json

**On NO_MATCH:**
Return the following to {MA_NAME}:
{
  "matched": false,
  "reason": "No WA capability match",
  "suggested_action": "{MA_NAME} handle directly",
  "original_message": "{message content}"
}
{MA_NAME} responds based on context. No further Dispatcher call needed.
