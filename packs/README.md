# MAWA Industry Packs

Industry packs are pre-configured MAWA team templates for specific use cases. Each pack contains a complete set of Position files (REGISTRATION, SOUL, ATC, PLAYBOOK) ready to deploy.

---

## Available Packs

| Pack | Positions | Use Case |
|------|-----------|----------|
| [tech-team](./tech-team/) | Quality Architect + Summarist + Assistant | R&D team daily operations |
| [customer-ops](./customer-ops/) | Support + QA + Knowledge + Escalation | Customer service automation |
| [trading](./trading/) | Market Monitor + Risk + Report + Alert | Financial data operations |
| [manufacturing](./manufacturing/) | QC + Process Engineer + Equipment + Scheduler | Factory floor AI |

---

## How to Use a Pack

1. Copy the pack directory into your `workspace/agents/` folder
2. Replace all `{placeholders}` in each REGISTRATION.md
3. Update your `MAWA_DISPATCH_TABLE.md` to add routing rules for the new positions
4. Run `./scripts/mawa-validate.sh` to confirm everything is wired correctly

---

## Contributing a Pack

Have a working MAWA team for a new domain? We'd love to include it. See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines. Requirements:

- Minimum 1 MA + 2 WAs
- All Hard Rules 1–5 present and unmodified
- At least 3 ATC templates per WA
- A README explaining the use case and target user
