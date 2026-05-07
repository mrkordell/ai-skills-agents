#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENT_DIR="$ROOT/opencode/agents"
DEV_LEAD="$AGENT_DIR/dev-lead.md"
EXPLORE="$AGENT_DIR/explore.md"

fail() {
  echo "validate-agents: $*" >&2
  exit 1
}

has_permission_deny() {
  local file="$1"
  local key="$2"

  awk -v key="$key" '
    /^permission:$/ { in_permission = 1; next }
    in_permission && /^[^[:space:]][^:]*:/ { in_permission = 0 }
    in_permission && $0 == "  " key ": deny" { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$file"
}

[[ -d "$AGENT_DIR" ]] || fail "missing $AGENT_DIR"
[[ -f "$DEV_LEAD" ]] || fail "missing dev-lead.md"

count=0
primary_count=0
for file in "$AGENT_DIR"/*.md; do
  [[ -f "$file" ]] || continue
  count=$((count + 1))
  first_line="$(sed -n '1p' "$file")"
  [[ "$first_line" == "---" ]] || fail "$file missing opening frontmatter"
  grep -q '^description:' "$file" || fail "$file missing description"
  grep -q '^mode:' "$file" || fail "$file missing mode"
  grep -q '^temperature:' "$file" || fail "$file missing temperature"
  grep -q '^color:' "$file" || fail "$file missing color"
  grep -q '^permission:' "$file" || fail "$file missing permission block"
  if grep -q '^mode: primary$' "$file"; then
    primary_count=$((primary_count + 1))
  fi
done

[[ "$count" -eq 40 ]] || fail "expected 40 OpenCode agents, found $count"
[[ "$primary_count" -eq 1 ]] || fail "expected exactly one primary OpenCode agent, found $primary_count"

has_permission_deny "$DEV_LEAD" "edit" || fail "dev-lead missing permission.edit deny"
has_permission_deny "$DEV_LEAD" "bash" || fail "dev-lead missing permission.bash deny"

if [[ -f "$EXPLORE" ]]; then
  has_permission_deny "$EXPLORE" "edit" || fail "explore missing permission.edit deny"
  has_permission_deny "$EXPLORE" "bash" || fail "explore missing permission.bash deny"
fi

for file in "$AGENT_DIR"/*.md; do
  name="$(basename "$file" .md)"
  [[ "$name" == "dev-lead" ]] && continue
  grep -q "\"$name\": allow" "$DEV_LEAD" || fail "dev-lead does not allow task routing to $name"
done

echo "validate-agents: ok ($count OpenCode agents)"
