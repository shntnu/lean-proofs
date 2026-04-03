# CLAUDE.md

## Commands

```bash
lake build                # Build and verify all proofs
lake exe cache get        # Fetch Mathlib prebuilt cache (first time only)
nix develop               # Enter dev shell — or just cd in with direnv
```

- Lean toolchain: `lean-toolchain` (v4.29.0)
- Mathlib: pinned in `lakefile.lean`, cached oleans via `lake exe cache get`

## Directory Conventions

```
claims/                       # Mathematical claims as markdown
LeanProofs/                   # One .lean file per claim
LeanProofs.lean               # Root — imports all modules
```

## Adding a New Claim

1. Write `claims/your_claim.md` — the mathematical statement in plain language
2. Create `LeanProofs/YourClaim.lean` — theorem statements with `sorry`
3. Add `import LeanProofs.YourClaim` to `LeanProofs.lean`
4. Use the theorem-proving skill to iteratively replace `sorry` with proofs

## Proving Theorems

All interactive proof work (Lean MCP tools, tactic iteration, goal inspection) is handled by a dedicated theorem-proving skill. Do NOT attempt ad-hoc proof iteration outside that skill — it encodes the correct prove-check-adjust loop.

## Claims

| Claim | Lean file | Claim file | Status |
|-------|-----------|------------|--------|
| Harmony per-feature independence | `LeanProofs/HarmonyPerFeature.lean` | `claims/harmony_per_feature.md` | `sorry` (skeleton) |
