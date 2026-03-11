#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────
#  AI Skills & Agents Installer
#  curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
# ─────────────────────────────────────────────────────────

REPO="mrkordell/ai-skills-agents"
BRANCH="main"
TMPDIR="$(mktemp -d)"

CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
OPENCODE_AGENTS_DIR="$HOME/.config/opencode/agents"

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "🔧 Installing AI skills & agents..."
echo ""

# Clone the repo
if command -v git &>/dev/null; then
  git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TMPDIR/repo" 2>/dev/null
else
  echo "❌ git is required. Install it and try again."
  exit 1
fi

# Install Claude Code agents
if [[ -d "$TMPDIR/repo/claude-code/agents" ]]; then
  mkdir -p "$CLAUDE_AGENTS_DIR"
  cp "$TMPDIR/repo/claude-code/agents/"*.md "$CLAUDE_AGENTS_DIR/"
  count=$(ls -1 "$TMPDIR/repo/claude-code/agents/"*.md 2>/dev/null | wc -l)
  echo "✅ Claude Code agents installed ($count) → $CLAUDE_AGENTS_DIR"
fi

# Install OpenCode agents
if [[ -d "$TMPDIR/repo/opencode/agents" ]]; then
  mkdir -p "$OPENCODE_AGENTS_DIR"
  cp "$TMPDIR/repo/opencode/agents/"*.md "$OPENCODE_AGENTS_DIR/"
  count=$(ls -1 "$TMPDIR/repo/opencode/agents/"*.md 2>/dev/null | wc -l)
  echo "✅ OpenCode agents installed ($count) → $OPENCODE_AGENTS_DIR"
fi

echo ""
echo "🎉 Done! Restart Claude Code or OpenCode to pick up the new agents."
