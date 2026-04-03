#!/usr/bin/env bash
# lean-diag.sh — Lean 4 diagnostic tool for proof development
#
# Usage:
#   ./scripts/lean-diag.sh                     # check all files, report sorries and errors
#   ./scripts/lean-diag.sh goals FILE          # show goal states at each sorry in FILE
#   ./scripts/lean-diag.sh check               # just run lake build, report pass/fail
#
# The "goals" subcommand works by temporarily inserting a trace_state tactic
# before each sorry, running the elaborator, and extracting the goal output.
# The original file is always restored.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cmd="${1:-status}"

case "$cmd" in
  status)
    echo -e "${CYAN}=== Lean Proof Status ===${NC}"
    echo ""

    # Run lake build and capture output
    build_out=$(lake build 2>&1) || true

    # Count sorries (grep -c exits 1 on no match; || : suppresses that)
    sorry_count=$(echo "$build_out" | grep -c "declaration uses .sorry." || :)
    error_count=$(echo "$build_out" | grep -c "error:" || :)

    if [ "$error_count" -gt 0 ]; then
      echo -e "${RED}Errors: $error_count${NC}"
      echo "$build_out" | grep "error:" | head -20
      echo ""
    fi

    if [ "$sorry_count" -gt 0 ]; then
      echo -e "${YELLOW}Unproved (sorry): $sorry_count${NC}"
      echo "$build_out" | grep "sorry" | while read -r line; do
        echo "  $line"
      done
      echo ""
    fi

    if [ "$error_count" -eq 0 ] && [ "$sorry_count" -eq 0 ]; then
      echo -e "${GREEN}All proofs verified ✓${NC}"
    fi

    # List all .lean files with sorry count
    echo ""
    echo -e "${CYAN}=== Per-File Summary ===${NC}"
    find LeanProofs -name '*.lean' | sort | while read -r f; do
      sc=$(grep -c 'sorry' "$f" || :)
      if [ "$sc" -gt 0 ]; then
        echo -e "  ${YELLOW}$f${NC} — $sc sorry(s)"
      else
        echo -e "  ${GREEN}$f${NC} — proved ✓"
      fi
    done
    ;;

  goals)
    file="${2:?Usage: lean-diag.sh goals FILE.lean}"
    if [ ! -f "$file" ]; then
      echo "Error: $file not found" >&2
      exit 1
    fi

    echo -e "${CYAN}=== Goal States at sorry positions in $file ===${NC}"
    echo ""

    # Find line numbers with sorry (tactic-mode sorry, not in comments)
    sorry_lines=$(grep -n '^\s*sorry' "$file" | grep -v '^\s*--' | cut -d: -f1)

    if [ -z "$sorry_lines" ]; then
      echo -e "${GREEN}No sorry found in $file${NC}"
      exit 0
    fi

    # Create a temporary copy with trace_state before each sorry
    tmp_file=$(mktemp --suffix=.lean)
    trap "rm -f '$tmp_file'" EXIT

    cp "$file" "$tmp_file"

    # Insert trace_state before each sorry (process in reverse order to preserve line numbers)
    for line_num in $(echo "$sorry_lines" | sort -rn); do
      # Get the indentation of the sorry line
      indent=$(sed -n "${line_num}p" "$tmp_file" | sed 's/\(^[[:space:]]*\).*/\1/')
      sed -i "${line_num}i\\${indent}trace_state" "$tmp_file"
    done

    # Run lean on the modified file and capture trace output
    # Use lake env to get the right LEAN_PATH
    lake env lean "$tmp_file" 2>&1 | while IFS= read -r line; do
      if echo "$line" | grep -q "trace_state"; then
        echo -e "${CYAN}--- Goal State ---${NC}"
      elif echo "$line" | grep -q "^.*:[0-9]*:[0-9]*:"; then
        # It's a diagnostic line
        if echo "$line" | grep -q "warning"; then
          echo -e "${YELLOW}$line${NC}"
        elif echo "$line" | grep -q "error"; then
          echo -e "${RED}$line${NC}"
        else
          echo "$line"
        fi
      else
        echo "$line"
      fi
    done
    ;;

  check)
    echo -e "${CYAN}Running lake build...${NC}"
    if lake build 2>&1; then
      # Check for sorry warnings
      build_out=$(lake build 2>&1)
      if echo "$build_out" | grep -q "sorry"; then
        echo -e "${YELLOW}Build succeeded with sorry warnings${NC}"
        exit 1
      else
        echo -e "${GREEN}Build clean — all proofs verified ✓${NC}"
        exit 0
      fi
    else
      echo -e "${RED}Build failed${NC}"
      exit 2
    fi
    ;;

  *)
    echo "Usage: lean-diag.sh [status|goals FILE|check]"
    exit 1
    ;;
esac
