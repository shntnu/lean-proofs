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
2. `/lean4:draft` — generates `LeanProofs/YourClaim.lean` with theorem statements and `sorry` placeholders from the claim
3. Add `import LeanProofs.YourClaim` to `LeanProofs.lean`
4. `/lean4:prove` — iteratively replace `sorry` with verified proofs

Or combine steps 2–4: `/lean4:formalize` (interactive) or `/lean4:autoformalize --source=claims/your_claim.md` (autonomous).

## Proving Theorems

Use the `/lean4` skill suite for all proof work:

| Command | When to use |
|---------|-------------|
| `/lean4:draft` | Generate Lean skeleton from an informal claim |
| `/lean4:formalize` | Interactive: draft + guided proving in one session |
| `/lean4:autoformalize --source=...` | Autonomous: claim file → skeleton → proof, hands-off |
| `/lean4:prove` | Fill `sorry` placeholders interactively (cycle-by-cycle) |
| `/lean4:autoprove` | Fill `sorry` placeholders autonomously (with hard stop rules) |
| `/lean4:refactor` | Leverage mathlib, extract helpers, simplify strategies |
| `/lean4:golf` | Shorten and clean up compiled proofs |
| `/lean4:checkpoint` | Save progress (per-file build + commit) |

The `scripts/lean-diag.sh goals` script provides goal-state inspection as a complement to the `/lean4` LSP tools.

## Claims

See the claims table in [`README.md`](README.md#claims) — that is the single source of truth for claim status.
