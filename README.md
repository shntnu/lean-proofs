# lean_proofs

Lean 4 + Mathlib proofs of mathematical claims from morphological profiling and single-cell genomics.

## Workflow

Informal claim (`claims/*.md`) → Lean skeleton → proof → `lake build`. Uses Claude Code with the [`lean4-skills` plugin](https://github.com/cameronfreer/lean4-skills); see [`CLAUDE.md`](CLAUDE.md).

## Setup

```bash
nix develop              # Enter dev shell (provides elan, git, curl)
lake exe cache get       # Download Mathlib prebuilt cache (~first time only)
lake build               # Build and verify all proofs
```

Requires [Nix](https://nixos.org/) with flakes enabled, or install [elan](https://github.com/leanprover/elan) directly.

## Claims

Claims live in `claims/` (markdown) with corresponding proofs in `LeanProofs/` (one `.lean` file per claim).

## Background

Informal mathematical claims → formal Lean proofs, using Lean's type checker as ground truth. Started with a property of [Harmony](https://github.com/immunogenomics/harmony) batch correction ([original gist](https://gist.github.com/shntnu/05755e1bda79539a7f491b86d42c59ba), [motivating discussion](https://github.com/broadinstitute/jump_production/issues/17)).

[`LEARNING_LOG.md`](LEARNING_LOG.md) has session-by-session context on past decisions and open questions.
