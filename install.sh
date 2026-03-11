#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────
#  AI Skills & Agents Installer
#  curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
# ─────────────────────────────────────────────────────────

REPO="mrkordell/ai-skills-agents"
BRANCH="main"

# ── Platform detection ──────────────────────────────────

detect_platform() {
  platform="linux"
  raw_os=$(uname -s)
  case "$raw_os" in
    Darwin*)              platform="macos"   ;;
    MINGW*|MSYS*|CYGWIN*) platform="windows" ;;
  esac

  # WSL reports as Linux but has /proc/version with "microsoft"
  if [[ "$platform" == "linux" ]] && grep -qi microsoft /proc/version 2>/dev/null; then
    platform="wsl"
  fi
}

# ── Resolve install paths ──────────────────────────────

resolve_paths() {
  install_targets=()

  case "$platform" in
    windows)
      # Git Bash/MSYS already sets $HOME to /c/Users/<user>
      install_targets+=("$HOME")
      ;;
    wsl)
      # Install to WSL home
      install_targets+=("$HOME")
      # Also install to Windows home
      local win_home
      win_home="$(wslpath "$(wslvar USERPROFILE)" 2>/dev/null)" || win_home=""
      if [[ -n "$win_home" && "$win_home" != "$HOME" ]]; then
        install_targets+=("$win_home")
      fi
      ;;
    *)
      install_targets+=("$HOME")
      ;;
  esac
}

# ── Download repo ───────────────────────────────────────

download_repo() {
  TMPDIR="$(mktemp -d)"
  trap 'rm -rf "$TMPDIR"' EXIT

  if command -v git &>/dev/null; then
    echo "  Cloning repo..."
    git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TMPDIR/repo" 2>/dev/null
  elif command -v curl &>/dev/null; then
    echo "  Downloading..."
    curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" -o "$TMPDIR/repo.tar.gz"
    mkdir -p "$TMPDIR/repo"
    tar -xzf "$TMPDIR/repo.tar.gz" -C "$TMPDIR/repo" --strip-components=1
  elif command -v wget &>/dev/null; then
    echo "  Downloading..."
    wget -qO "$TMPDIR/repo.tar.gz" "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
    mkdir -p "$TMPDIR/repo"
    tar -xzf "$TMPDIR/repo.tar.gz" -C "$TMPDIR/repo" --strip-components=1
  else
    echo "  Error: git, curl, or wget is required."
    exit 1
  fi
}

# ── Install agents to a single home dir ─────────────────

install_agents() {
  local src_dir="$1"
  local dest_dir="$2"
  local label="$3"

  if [[ -d "$src_dir" ]]; then
    mkdir -p "$dest_dir"
    local count=0
    for f in "$src_dir"/*.md; do
      [[ -f "$f" ]] || continue
      cp "$f" "$dest_dir/"
      count=$((count + 1))
    done
    if [[ $count -gt 0 ]]; then
      echo "  $label ($count) -> $dest_dir"
    fi
  fi
}

install_to_home() {
  local home_dir="$1"
  install_agents "$TMPDIR/repo/claude-code/agents" "$home_dir/.claude/agents" "Claude Code"
  install_agents "$TMPDIR/repo/opencode/agents" "$home_dir/.config/opencode/agents" "OpenCode"
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
  for t in "${install_targets[@]}"; do
    echo "  Target:   $t"
  done
  echo ""

  download_repo
  echo ""

  for t in "${install_targets[@]}"; do
    install_to_home "$t"
  done

  echo ""
  echo "  Done! Restart Claude Code or OpenCode to pick up the new agents."
  echo ""
}

main
