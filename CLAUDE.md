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

## Directory Conventions

```
claims/                       # Mathematical claims as markdown
LeanProofs/                   # One .lean file per claim
LeanProofs.lean               # Root — imports all modules
scripts/lean-diag.sh          # Proof diagnostics (goal states, status)
.claude/.lsp.json             # Lean language server config for Claude Code
.claude/skills/               # Skills (lean-theorem-prover)
```

## Adding a New Claim

1. Write `claims/your_claim.md` — the mathematical statement in plain language
2. Create `LeanProofs/YourClaim.lean` — theorem statements with `sorry`
3. Add `import LeanProofs.YourClaim` to `LeanProofs.lean`
4. Use the theorem-proving skill to iteratively replace `sorry` with proofs

## Proving Theorems

All interactive proof work is handled by the `lean-theorem-prover` skill (`.claude/skills/lean-theorem-prover/`). It encodes the correct prove-check-adjust loop using `lake build` for verification and `scripts/lean-diag.sh goals` for goal-state inspection. Do NOT attempt ad-hoc proof iteration outside that skill.

## Claims

| Claim | Lean file | Claim file | Status |
|-------|-----------|------------|--------|
| Harmony per-feature independence | `LeanProofs/HarmonyPerFeature.lean` | `claims/harmony_per_feature.md` | proved |
