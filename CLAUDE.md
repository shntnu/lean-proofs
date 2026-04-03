# CLAUDE.md

## Commands

```bash
lake build                          # Build and verify all proofs
lake exe cache get                  # Fetch Mathlib prebuilt cache (first time only)
nix develop                         # Enter dev shell — or just cd in with direnv
./scripts/lean-diag.sh status       # Proof status overview (sorry count, errors)
./scripts/lean-diag.sh goals FILE   # Show goal states at each sorry in FILE
./scripts/lean-diag.sh check        # Pass/fail build check
```

- Lean toolchain: `lean-toolchain` (v4.29.0)
- Mathlib: pinned in `lakefile.lean`, cached oleans via `lake exe cache get`
- Required Claude Code plugin: `lean4@lean4-skills` (auto-enabled via `.claude/settings.json`; install with `/plugins add lean4-skills`)

## Directory Conventions

```
claims/                       # Mathematical claims as markdown
LeanProofs/                   # One .lean file per claim
LeanProofs.lean               # Root — imports all modules
scripts/lean-diag.sh          # Proof diagnostics (goal states, status)
.claude/.lsp.json             # Lean language server config for Claude Code
```

## Adding a New Claim

1. Write `claims/your_claim.md` — the mathematical statement in plain language
2. Use `/lean4:draft` to generate `LeanProofs/YourClaim.lean` (skeleton with `sorry`)
3. Add `import LeanProofs.YourClaim` to `LeanProofs.lean`
4. Use `/lean4:prove` or `/lean4:autoprove` to fill `sorry` placeholders

## Proving Theorems

Use the `/lean4` skill suite for all proof work. The `scripts/lean-diag.sh goals` script provides repo-specific goal-state inspection as a complement to the `/lean4` LSP tools.

## Claims

See the claims table in [`README.md`](README.md#claims) — that is the single source of truth for claim status.
