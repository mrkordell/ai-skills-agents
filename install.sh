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
    Darwin*)              platform="macos"   ;;
    Linux*)               platform="linux"   ;;
    MINGW*|MSYS*|CYGWIN*) platform="windows" ;;
    *)                    platform="linux"   ;;
  esac

  # Detect WSL (reports as Linux but has access to Windows filesystem)
  is_wsl=false
  if [[ "$platform" == "linux" ]] && grep -qi microsoft /proc/version 2>/dev/null; then
    is_wsl=true
    platform="wsl"
  fi
}

# ── Resolve config home based on platform ───────────────

resolve_win_home() {
  # Get Windows USERPROFILE and convert to WSL/MSYS mount path
  local raw
  raw="$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')" || raw=""
  if [[ -n "$raw" ]]; then
    # Convert C:\Users\tony -> /mnt/c/Users/tony (WSL) or /c/Users/tony (Git Bash)
    echo "$(wslpath -u "$raw" 2>/dev/null || cygpath -u "$raw" 2>/dev/null || echo "$raw")"
  fi
}

resolve_paths() {
  home_dir="$HOME"
  win_home=""

  if [[ "$platform" == "windows" ]]; then
    win_home="$(resolve_win_home)"
    if [[ -n "$win_home" ]]; then
      home_dir="$win_home"
    fi
  fi

  if [[ "$platform" == "wsl" ]]; then
    win_home="$(resolve_win_home)"
  fi

  CLAUDE_AGENTS_DIR="$home_dir/.claude/agents"
  OPENCODE_AGENTS_DIR="$home_dir/.config/opencode/agents"

  # WSL also gets Windows-side paths
  if [[ -n "$win_home" && "$win_home" != "$home_dir" ]]; then
    WIN_CLAUDE_AGENTS_DIR="$win_home/.claude/agents"
    WIN_OPENCODE_AGENTS_DIR="$win_home/.config/opencode/agents"
  fi
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
  if [[ -n "${win_home:-}" && "$win_home" != "$home_dir" ]]; then
    echo "  Windows:  $win_home"
  fi
  echo ""

  download_repo

  # Install to primary home
  install_agents "$TMPDIR/repo/claude-code/agents" "$CLAUDE_AGENTS_DIR" "Claude Code"
  install_agents "$TMPDIR/repo/opencode/agents" "$OPENCODE_AGENTS_DIR" "OpenCode"

  # WSL: also install to Windows side
  if [[ -n "${WIN_CLAUDE_AGENTS_DIR:-}" ]]; then
    echo ""
    echo "  Installing to Windows side..."
    install_agents "$TMPDIR/repo/claude-code/agents" "$WIN_CLAUDE_AGENTS_DIR" "Claude Code (Windows)"
    install_agents "$TMPDIR/repo/opencode/agents" "$WIN_OPENCODE_AGENTS_DIR" "OpenCode (Windows)"
  fi

  echo ""
  echo "  Done! Restart Claude Code or OpenCode to pick up the new agents."
  echo ""
}

main
