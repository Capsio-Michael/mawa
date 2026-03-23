# MAWA on OpenClaw

Reference implementation of MAWA using [OpenClaw](https://github.com/JVS-Claw/openclaw) — a local LLM agent runtime for macOS.

This is the battle-tested implementation that MAWA was designed and proven on. Clone it, configure it, and have a working multi-agent team running in under 30 minutes.

---

## What You Get

A fully wired MAWA team with:

- **1 MA** (FClaw) — orchestrator, dispatcher, curator, audit hub
- **4 WAs** — Booky (summarist), Michael (quality architect), Pepper (personal assistant), Stocky (stock monitor)
- **4 Skills** — Dispatcher, Reflector, Curator, Audit
- **Cron jobs** — automatic daily and weekly execution
- **Full audit trail** — deny logs, IPCP logs, TaskRuns, cost reports

---

## Prerequisites

- macOS (Apple Silicon or Intel)
- [OpenClaw](https://github.com/JVS-Claw/openclaw) installed and running
- Node.js 18+
- A messaging platform API key (Feishu/Lark recommended — other platforms require adapter)

---

## Quickstart

### Step 1 — Clone the repo

```bash
git clone https://github.com/Capsio-Michael/mawa.git
cd mawa/implementations/openclaw
```

### Step 2 — Run setup

```bash
chmod +x setup.sh
./setup.sh
```

This creates the full workspace directory structure and copies all template files.

### Step 3 — Configure your workspace

Edit `workspace/config.yaml`:

```yaml
owner_name: "Your Name"
ma_name: "FClaw"          # Your MA's name
messaging_platform: "feishu"
api_key: "your-api-key"
workspace_path: "/path/to/your/workspace"
```

### Step 4 — Configure your WAs

For each agent in `workspace/agents/`, edit `REGISTRATION.md` and replace all `{placeholders}` with your actual values:

```bash
# Example: configure Booky
nano workspace/agents/booky/REGISTRATION.md
```

Key values to replace:
- `{POSITION_NAME}` → your chosen name for this agent
- `{MA_NAME}` → your MA name (from config.yaml)
- `{OWNER_NAME}` → your name
- `{CHANNEL_NAME}` → your messaging platform name
- `{CREATION_DATE}` → today's date

### Step 5 — Set up cron jobs

```bash
chmod +x cron/setup-cron-jobs.sh
./cron/setup-cron-jobs.sh
```

This sets up:
- Daily summaries (23:00)
- Stock broadcasts (10:00, 14:45 on trading days)
- Weekly Reflector (Sunday 22:00)
- Weekly Audit (Sunday 22:30)

### Step 6 — Validate

Run the 5-test validation suite:

```bash
./scripts/mawa-validate.sh
```

All 5 tests passing = your MAWA team is production-ready.

---

## Directory Structure

```
openclaw/
├── README.md                    # This file
├── setup.sh                     # One-command bootstrap
├── workspace/
│   ├── MAWA_DISPATCH_TABLE.md   # Routing index (edit after configuring WAs)
│   ├── agents/
│   │   ├── _template/           # Copy this to create a new Position
│   │   ├── fclaw/               # MA
│   │   │   ├── REGISTRATION.md
│   │   │   ├── SOUL.md
│   │   │   └── ATC/
│   │   ├── booky/               # Chief Summarist WA
│   │   ├── michael/             # Quality Architect WA
│   │   ├── pepper/              # Personal Assistant WA
│   │   └── stocky/              # Stock Monitor WA
│   └── skills/
│       ├── mawa-dispatcher/
│       ├── mawa-reflector/
│       ├── mawa-curator/
│       └── mawa-audit/
├── cron/
│   └── setup-cron-jobs.sh
└── scripts/
    ├── mawa-validate.sh
    └── mawa-add-agent.sh
```

---

## Adding a New Agent

```bash
./scripts/mawa-add-agent.sh my-new-agent
```

This copies `_template/` to `agents/my-new-agent/` and prompts you to fill in the key values. Then update `MAWA_DISPATCH_TABLE.md` to add routing rules for the new position.

---

## The 5-Test Validation Suite

| Test | What it checks |
|------|---------------|
| Test 1 — Registration Boundary | WA refuses data outside declared domain |
| Test 2 — ATC Execution | Task produces structured output + TaskRun |
| Test 3 — Quality Gate | Malformed input triggers FAIL + retry |
| Test 4 — IPCP | Double failure produces Error-Report in correct format |
| Test 5 — Playbook Bullet | Condition triggers matching bullet, cited in TaskRun |

---

## Adapting to Your Use Case

The 4 included WA patterns cover the most common agent archetypes:

| Pattern | WA | Adapt for |
|---------|-----|-----------|
| Summarist | Booky | Any periodic document processing |
| Quality Architect | Michael | Any evaluation or scoring workflow |
| Personal Assistant | Pepper | Any personal productivity automation |
| Monitor | Stocky | Any scheduled data fetch + alert |

To adapt: copy the relevant agent folder, rename it, and replace the domain-specific content in REGISTRATION.md, ATC files, and PLAYBOOK.md.

---

## Troubleshooting

**Agent not responding to messages**
→ Check that the source channel ID in `MAWA_DISPATCH_TABLE.md` matches your actual channel

**TaskRun not being written**
→ Verify `workspace_path` in config.yaml points to a writable directory

**Cron not triggering**
→ Run `crontab -l` to verify jobs were registered; check system logs

**Quality gate always failing**
→ Check the T section of the relevant ATC — the output schema may not match what the agent is producing
