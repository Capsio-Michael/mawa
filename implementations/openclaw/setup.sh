#!/bin/bash
# MAWA Setup for OpenClaw
# Run once after installing OpenClaw
# Usage: chmod +x setup.sh && ./setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$SCRIPT_DIR/workspace"

echo ""
echo "🦞 MAWA Setup for OpenClaw"
echo "================================"
echo ""

# ── Step 1: Check prerequisites ──────────────────────────────────────────────
echo "▶ Checking prerequisites..."

if ! command -v node &>/dev/null; then
  echo "  ✗ Node.js not found. Please install Node.js 18+ and re-run."
  exit 1
fi

NODE_VER=$(node -e "process.exit(parseInt(process.version.slice(1)) < 18 ? 1 : 0)" 2>/dev/null && echo "ok" || echo "old")
if [ "$NODE_VER" = "old" ]; then
  echo "  ✗ Node.js 18+ required. Current: $(node --version)"
  exit 1
fi

echo "  ✓ Node.js $(node --version)"

# ── Step 2: Create workspace directory structure ──────────────────────────────
echo ""
echo "▶ Creating workspace structure..."

dirs=(
  "$WORKSPACE/agents/_template/ATC"
  "$WORKSPACE/agents/_template/PLAYBOOK"
  "$WORKSPACE/agents/_template/WHAT"
  "$WORKSPACE/agents/fclaw/ATC"
  "$WORKSPACE/agents/booky/ATC"
  "$WORKSPACE/agents/booky/PLAYBOOK"
  "$WORKSPACE/agents/booky/WHAT"
  "$WORKSPACE/agents/michael/ATC"
  "$WORKSPACE/agents/michael/PLAYBOOK"
  "$WORKSPACE/agents/michael/WHAT"
  "$WORKSPACE/agents/pepper/ATC"
  "$WORKSPACE/agents/pepper/PLAYBOOK"
  "$WORKSPACE/agents/stocky/ATC"
  "$WORKSPACE/agents/stocky/PLAYBOOK"
  "$WORKSPACE/skills/mawa-dispatcher"
  "$WORKSPACE/skills/mawa-reflector"
  "$WORKSPACE/skills/mawa-curator"
  "$WORKSPACE/skills/mawa-audit"
  "$WORKSPACE/taskruns"
  "$WORKSPACE/audit/deny-logs"
  "$WORKSPACE/audit/ipcp-log"
  "$WORKSPACE/playbook-candidates"
  "$WORKSPACE/playbook-versions"
  "$WORKSPACE/cost/weekly"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

echo "  ✓ Workspace directories created"

# ── Step 3: Copy template files ───────────────────────────────────────────────
echo ""
echo "▶ Copying template files..."

agents=("fclaw" "booky" "michael" "pepper" "stocky")
for agent in "${agents[@]}"; do
  src="$SCRIPT_DIR/workspace/agents/$agent"
  dst="$WORKSPACE/agents/$agent"
  if [ -d "$src" ]; then
    cp -rn "$src/." "$dst/" 2>/dev/null || true
  fi
done

# Copy skills
skills=("mawa-dispatcher" "mawa-reflector" "mawa-curator" "mawa-audit")
for skill in "${skills[@]}"; do
  src="$SCRIPT_DIR/workspace/skills/$skill"
  dst="$WORKSPACE/skills/$skill"
  if [ -d "$src" ]; then
    cp -rn "$src/." "$dst/" 2>/dev/null || true
  fi
done

# Copy dispatch table
if [ -f "$SCRIPT_DIR/workspace/MAWA_DISPATCH_TABLE.md" ]; then
  cp -n "$SCRIPT_DIR/workspace/MAWA_DISPATCH_TABLE.md" "$WORKSPACE/MAWA_DISPATCH_TABLE.md" 2>/dev/null || true
fi

echo "  ✓ Template files copied"

# ── Step 4: Create config.yaml if not exists ──────────────────────────────────
echo ""
echo "▶ Creating config.yaml..."

CONFIG="$WORKSPACE/config.yaml"
if [ ! -f "$CONFIG" ]; then
  cat > "$CONFIG" << 'CONFIG_EOF'
# MAWA Configuration
# Fill in all values before running agents

owner_name: "Your Name"
ma_name: "FClaw"
messaging_platform: "feishu"   # feishu | slack | teams
api_key: "your-api-key-here"
workspace_path: ""             # Leave blank to use this directory

# Runtime defaults (can be overridden per-agent in REGISTRATION.md)
default_max_parallel_tasks: 2
default_timeout_ms: 300000
default_max_daily_atc: 50
CONFIG_EOF
  echo "  ✓ config.yaml created — edit this file before starting agents"
else
  echo "  ✓ config.yaml already exists — skipping"
fi

# ── Step 5: Make scripts executable ───────────────────────────────────────────
echo ""
echo "▶ Setting permissions..."

[ -f "$SCRIPT_DIR/cron/setup-cron-jobs.sh" ] && chmod +x "$SCRIPT_DIR/cron/setup-cron-jobs.sh"
[ -f "$SCRIPT_DIR/scripts/mawa-validate.sh" ] && chmod +x "$SCRIPT_DIR/scripts/mawa-validate.sh"
[ -f "$SCRIPT_DIR/scripts/mawa-add-agent.sh" ] && chmod +x "$SCRIPT_DIR/scripts/mawa-add-agent.sh"

echo "  ✓ Scripts are executable"

# ── Step 6: Placeholder check ─────────────────────────────────────────────────
echo ""
echo "▶ Checking for unconfigured placeholders..."

PLACEHOLDER_COUNT=$(grep -r "{POSITION_NAME}\|{MA_NAME}\|{OWNER_NAME}\|{CHANNEL_NAME}\|{CREATION_DATE}" \
  "$WORKSPACE/agents" 2>/dev/null | grep -v "_template" | wc -l | tr -d ' ')

if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then
  echo "  ⚠  Found $PLACEHOLDER_COUNT unconfigured placeholder(s) in agent files"
  echo "     Run: grep -r '{' workspace/agents/ | grep -v _template"
  echo "     to see which files need configuration"
else
  echo "  ✓ No unconfigured placeholders found"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "================================"
echo "✅ MAWA setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit workspace/config.yaml with your API key and settings"
echo "  2. Replace {placeholders} in all agent REGISTRATION.md files"
echo "  3. Run: ./cron/setup-cron-jobs.sh   (set up scheduled jobs)"
echo "  4. Run: ./scripts/mawa-validate.sh  (run 5-test validation)"
echo ""
echo "Docs: https://github.com/Capsio-Michael/mawa"
echo "🦞"
