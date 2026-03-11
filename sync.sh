#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
OPENCODE_AGENTS_DIR="$HOME/.config/opencode/agents"

usage() {
  echo "Usage: $0 <push|pull>"
  echo ""
  echo "  push  - Copy local config files INTO this repo (for committing)"
  echo "  pull  - Copy repo files OUT to local config dirs (after git pull)"
  exit 1
}

[[ $# -lt 1 ]] && usage

case "$1" in
  push)
    echo "Pushing local configs into repo..."

    mkdir -p "$REPO_DIR/claude-code/agents"
    mkdir -p "$REPO_DIR/opencode/agents"

    if [[ -d "$CLAUDE_AGENTS_DIR" ]]; then
      rsync -av --delete "$CLAUDE_AGENTS_DIR/" "$REPO_DIR/claude-code/agents/"
      echo "✓ Claude Code agents synced"
    else
      echo "⚠ No Claude Code agents dir found at $CLAUDE_AGENTS_DIR"
    fi

    if [[ -d "$OPENCODE_AGENTS_DIR" ]]; then
      rsync -av --delete "$OPENCODE_AGENTS_DIR/" "$REPO_DIR/opencode/agents/"
      echo "✓ OpenCode agents synced"
    else
      echo "⚠ No OpenCode agents dir found at $OPENCODE_AGENTS_DIR"
    fi

    echo ""
    echo "Done. Review changes with 'git diff' then commit."
    ;;

  pull)
    echo "Pulling repo configs to local dirs..."

    mkdir -p "$CLAUDE_AGENTS_DIR"
    mkdir -p "$OPENCODE_AGENTS_DIR"

    if [[ -d "$REPO_DIR/claude-code/agents" ]]; then
      rsync -av "$REPO_DIR/claude-code/agents/" "$CLAUDE_AGENTS_DIR/"
      echo "✓ Claude Code agents installed"
    fi

    if [[ -d "$REPO_DIR/opencode/agents" ]]; then
      rsync -av "$REPO_DIR/opencode/agents/" "$OPENCODE_AGENTS_DIR/"
      echo "✓ OpenCode agents installed"
    fi

    echo ""
    echo "Done. Local configs updated."
    ;;

  *)
    usage
    ;;
esac
