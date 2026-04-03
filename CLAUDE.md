# CLAUDE.md

## Commands

```bash
lake build                          # Build and verify all proofs
lake exe cache get                  # Fetch Mathlib prebuilt cache (first time only)
nix develop                         # Enter dev shell — or just cd in with direnv
```

- Lean toolchain: `lean-toolchain` (v4.29.0)
- Mathlib: pinned in `lakefile.lean`, cached oleans via `lake exe cache get`
- Required Claude Code plugin: `lean4@lean4-skills` (auto-enabled via `.claude/settings.json`; install with `/plugins add lean4-skills`)

## Directory Conventions

```
claims/                       # Mathematical claims as markdown
LeanProofs/                   # One .lean file per claim
LeanProofs.lean               # Root — imports all modules
.claude/.lsp.json             # Lean language server config for Claude Code
```

## Adding a New Claim

1. Write `claims/your_claim.md` — the mathematical statement in plain language
2. Use `/lean4:draft` to generate `LeanProofs/YourClaim.lean` (skeleton with `sorry`)
3. Add `import LeanProofs.YourClaim` to `LeanProofs.lean`
4. Use `/lean4:prove` or `/lean4:autoprove` to fill `sorry` placeholders

## Proving Theorems

Use the `/lean4` skill suite for all proof work.

## Domain Patterns

Claims in this repo come from morphological profiling and single-cell genomics. Common Lean type mappings:

- Matrices: `Matrix m n R` with `m n : Type*` (not `Fin n` or `ℕ`) and `[Fintype]` / `[DecidableEq]`
- Scalar field: `[CommRing R]` by default; `[Field R]` only when division appears
- Batch/cluster indices: named `Type*` with `[Fintype K]` (e.g., `B_plus_1`, `K`)
- Summations: `Finset.sum` with `Finset.sum_congr` for per-element rewriting
- Transpose/identity: `Aᵀ` and `1` via `open Matrix`

Follow the claim's decomposition — don't invent auxiliary lemmas beyond what the claim suggests.

## Claims

Claims live in `claims/` with proofs in `LeanProofs/`. No separate tracking table — the filesystem is the source of truth.
