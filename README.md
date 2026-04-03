# lean_proofs

Formal Lean 4 + Mathlib proofs of mathematical claims, developed iteratively with Claude Code and [Lean MCP](https://github.com/leanprover-community/lean4-mcp) tools.

## How it works

1. Write a mathematical claim in `claims/` as markdown
2. Formalize theorem statements in `LeanProofs/` with `sorry` placeholders
3. Use Lean MCP tools to iteratively fill in proofs (tactic-by-tactic, inspecting goals)
4. `lake build` with zero `sorry` = machine-verified proof

## Setup

```bash
nix develop              # Enter dev shell (provides elan, git, curl)
lake exe cache get       # Download Mathlib prebuilt cache (~first time only)
lake build               # Build and verify all proofs
```

Requires [Nix](https://nixos.org/) with flakes enabled, or install [elan](https://github.com/leanprover/elan) directly.

## Claims

| Claim | Description | Lean | Status |
|-------|-------------|------|--------|
| [Harmony per-feature](claims/harmony_per_feature.md) | Harmony batch correction corrects each feature independently — no cross-feature mixing ([Korsunsky et al. 2019](https://doi.org/10.1038/s41592-019-0619-0)) | [`HarmonyPerFeature.lean`](LeanProofs/HarmonyPerFeature.lean) | skeleton (`sorry`) |

## Repository structure

```
claims/                   Mathematical claims (markdown, human-readable)
LeanProofs/               Lean 4 proof files (one per claim)
LeanProofs.lean           Root module — imports all proofs
lakefile.lean             Lake config (Mathlib dependency)
lean-toolchain            Lean version pin (v4.29.0)
flake.nix                 Nix devShell (elan + deps)
```

## Background

This repo was created to demonstrate a workflow where an AI agent iteratively develops formal proofs from informal mathematical claims, using Lean's type checker as ground truth. The first claim formalizes a property of the [Harmony](https://github.com/immunogenomics/harmony) batch correction algorithm used in single-cell genomics and morphological profiling (JUMP Cell Painting).

See the [original gist](https://gist.github.com/shntnu/05755e1bda79539a7f491b86d42c59ba) for the informal mathematical argument, and [broadinstitute/jump_production#17](https://github.com/broadinstitute/jump_production/issues/17) for the motivating discussion.
