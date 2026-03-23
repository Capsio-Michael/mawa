# FILE 1: agents/michael/PLAYBOOK/PLAYBOOK.md
# (replace affected bullets only)

### E-005
**Condition:** Score is between 55–65 (borderline)
**Action:** Run an additional dimension check pass before finalizing the score.
Explicitly note in improvement_suggestions: "Borderline score — recommend focusing on the following dimensions to improve."

### Q-001
**Condition:** A-layer asset has all required fields but the current coordinate is vague
  (e.g., "early stage" instead of a specific node name)
**Action:** Deduct 10–15 points from traceability. Add improvement suggestion:
"Current coordinate must reference a specific node. Avoid vague stage descriptions."

### Q-002
**Condition:** B-layer asset has a business goal defined but it is copy-pasted
  from the A-layer without adaptation
**Action:** Deduct 10 points from structure_quality. Add:
"B-layer business goal must be refined for the specific ATC context. Do not reuse the A-layer description verbatim."

### On Red Lines (SOUL reference):
Red line = instant FAIL. No exceptions. No special cases. No overrides from anyone.
This is the core value of the {POSITION_NAME} position.


---


# FILE 2: agents/pepper/PLAYBOOK/PLAYBOOK.md
# (replace affected bullets only)

### E-002
**Condition:** {OWNER_NAME} sends a message starting with "remember" or "remind me"
**Action:** Immediately capture as a thought or reminder entry with timestamp.
Confirm receipt: "Noted ✓"

### E-003
**Condition:** An action item from yesterday appears in today's notes as incomplete
**Action:** Carry it forward to tomorrow's action items. Mark with "(carried over)"
so {OWNER_NAME} can track recurring items.

### E-004
**Condition:** Morning briefing finds 3 or more back-to-back meetings with no breaks
**Action:** Add a note in the morning briefing: "⚠️ Heavy meeting day — consider scheduling buffer time."


---


# FILE 3: agents/booky/PLAYBOOK/PLAYBOOK.md
# (replace affected bullets only)

### E-002
**Condition:** Two or more meetings with the same title on the same day
**Action:** Distinguish them by time. Label as "[Title] (Morning)" and "[Title] (Afternoon)"
to prevent merge confusion.

### E-004
**Condition:** More than 6 meetings in one day
**Action:** Add an executive summary section at the top of the doc listing
the 3 most important decisions of the day (based on participant seniority and topic keywords).

### R-001
**Condition:** Cron triggers but it is a public holiday or weekend with 0 meetings
**Action:** Write a minimal daily log: "No meetings today." Still write the TaskRun.
Still send the notification to {OWNER_NAME} — this confirms the system ran correctly.
