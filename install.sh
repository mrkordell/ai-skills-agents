#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────
#  AI Skills & Agents Installer
#
#  macOS / Linux:
#    curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
#
#  Windows (Git Bash / MSYS2 / Cygwin):
#    curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
#
#  Windows (PowerShell):
#    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | wsl bash)))
#    — or just run the curl command above inside WSL / Git Bash.
# ─────────────────────────────────────────────────────────

REPO="mrkordell/ai-skills-agents"
BRANCH="main"

# ── Platform detection ──────────────────────────────────

detect_platform() {
  raw_os=$(uname -s)
  case "$raw_os" in
    Darwin*)             platform="macos"   ;;
    Linux*)              platform="linux"   ;;
    MINGW*|MSYS*|CYGWIN*) platform="windows" ;;
    *)                   platform="linux"   ;;
  esac
}

# ── Resolve config home based on platform ───────────────

resolve_paths() {
  if [[ "$platform" == "windows" ]]; then
    # Running inside Git Bash / MSYS2 / Cygwin — use Windows user profile
    win_home="$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')" || win_home=""
    if [[ -n "$win_home" ]]; then
      # Convert Windows path (C:\Users\tony) to unix-style (/c/Users/tony)
      home_dir="$(cygpath -u "$win_home" 2>/dev/null || echo "$win_home")"
    else
      home_dir="$HOME"
    fi
  else
    home_dir="$HOME"
  fi

  CLAUDE_AGENTS_DIR="$home_dir/.claude/agents"
  OPENCODE_AGENTS_DIR="$home_dir/.config/opencode/agents"
}

# ── Download repo ───────────────────────────────────────

download_repo() {
  TMPDIR="$(mktemp -d)"
  trap 'rm -rf "$TMPDIR"' EXIT

  if command -v git &>/dev/null; then
    echo "Cloning repo..."
    git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TMPDIR/repo" 2>/dev/null
  elif command -v curl &>/dev/null; then
    echo "Downloading archive..."
    curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" -o "$TMPDIR/repo.tar.gz"
    mkdir -p "$TMPDIR/repo"
    tar -xzf "$TMPDIR/repo.tar.gz" -C "$TMPDIR/repo" --strip-components=1
  elif command -v wget &>/dev/null; then
    echo "Downloading archive..."
    wget -qO "$TMPDIR/repo.tar.gz" "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
    mkdir -p "$TMPDIR/repo"
    tar -xzf "$TMPDIR/repo.tar.gz" -C "$TMPDIR/repo" --strip-components=1
  else
    echo "Error: git, curl, or wget is required."
    exit 1
  fi
}

# ── Install agents ──────────────────────────────────────

install_agents() {
  local src_dir="$1"
  local dest_dir="$2"
  local label="$3"

  if [[ -d "$src_dir" ]]; then
    mkdir -p "$dest_dir"
    count=0
    for f in "$src_dir"/*.md; do
      [[ -f "$f" ]] || continue
      cp "$f" "$dest_dir/"
      count=$((count + 1))
    done
    if [[ $count -gt 0 ]]; then
      echo "  $label agents installed ($count) -> $dest_dir"
    fi
  fi
}

# ── Main ────────────────────────────────────────────────

main() {
  echo ""
  echo "  AI Skills & Agents Installer"
  echo "  github.com/$REPO"
  echo ""

  detect_platform
  resolve_paths
  echo "  Platform: $platform"
  echo "  Home:     $home_dir"
  echo ""

  download_repo

  install_agents "$TMPDIR/repo/claude-code/agents" "$CLAUDE_AGENTS_DIR" "Claude Code"
  install_agents "$TMPDIR/repo/opencode/agents" "$OPENCODE_AGENTS_DIR" "OpenCode"

  echo ""
  echo "  Done! Restart Claude Code or OpenCode to pick up the new agents."
  echo ""
}

main
