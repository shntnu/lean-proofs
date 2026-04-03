# Learning Log

Tracks what we tried, what we learned, and what to do next — across sessions.

---

## 2026-04-03: SVD-PCA proof, skill retirement, and /lean4 adoption

### What was done
- Proved SVD-PCA equivalence: if X = USVᵀ with UᵀU = 1, then XᵀX = V(SᵀS)Vᵀ. Two theorems (`transpose_triple_mul`, `svd_pca_equiv`), 1-4 tactic lines each.
- Discovered the `/lean4` skill suite (lean4-skills plugin) which subsumes the custom `lean-theorem-prover` skill with LSP integration, mathlib search, cycle engines, golfing, refactoring, and more.
- Retired the custom skill: removed `.claude/skills/lean-theorem-prover/`, updated `CLAUDE.md` to reference `/lean4:formalize`, `/lean4:prove`, `/lean4:autoprove`.
- Added `.claude/settings.json` with `extraKnownMarketplaces` and `enabledPlugins` to auto-enable `lean4@lean4-skills` for collaborators.
- Deduplicated claims table: single source of truth in `README.md`, `CLAUDE.md` points there.
- Fixed GitHub math rendering in `claims/harmony_per_feature.md` — moved theorem text from `*...*` italic blocks to `>` blockquotes to avoid `$` math delimiter conflicts.
- Validated reproofing: an isolated worktree agent replaced all 5 proofs with `sorry` and re-proved them from scratch — identical results.

### Key findings
- **The custom skill's proving logic was redundant**: `/lean4` provides strictly more capable proof machinery (LSP tools, mathlib search, cycle engines). The custom skill's value was in the project-specific workflow (claims dir, README table), which lives better in `CLAUDE.md`.
- **No hard plugin enforcement in Claude Code**: `.claude/settings.json` can pre-register marketplaces and pre-enable plugins, but can't block sessions if a plugin is missing. Documentation in `CLAUDE.md` is the fallback.
- **GitHub math rendering quirk**: `$i$` and `$j$` inside `*...*` emphasis blocks don't render as math — the markdown parser conflicts. Blockquotes avoid the issue.

### What to do next
- Try `/lean4:formalize` or `/lean4:autoformalize` on a new claim to test the full pipeline with the adopted skill suite.
- Consider a claim from the morphological profiling domain (e.g., sphering/whitening properties, batch effect correction bounds).

---

## 2026-04-03: Skill eval iteration 1 — Analysis I exercises

### What was done
- Tested lean-theorem-prover skill against 3 exercises from Terry Tao's Analysis I formalization (`../analysis`):
  - **Number theory** (Section 4.4): `Nat.no_infinite_descent`, `Nat.even_or_odd''`, `Nat.not_even_and_odd`
  - **Continuity** (Section 9.4): 5 basic Mathlib continuity facts (constant + identity)
  - **Convergence** (Section 6.1): `Sequence.IsCauchy.convergent` (custom types, ε-δ)
- Ran 6 parallel subagents: 3 with skill, 3 baseline (no skill). All 6 succeeded (100% pass).
- Revised SKILL.md: added power tactics, induction/ε-δ patterns, project-agnostic diagnostics.

### Key findings
- **Skill helps most on hard exercises with custom types**: convergence exercise showed 42% token reduction (35K vs 59K) and 49% time savings (164s vs 320s) with the skill.
- **No correctness improvement on easy/medium**: number theory and continuity exercises had identical outcomes, with the skill adding slight overhead from reading instructions.
- **The original skill was matrix-algebra-specific**: strategy table (ext, Finset.sum_congr) and tactic playbook were never used in any of the 3 test cases. Power tactics (`omega`, `linarith`, `aesop`, `grind`) did the actual work.
- **`lean-diag.sh` is repo-specific**: subagents working in the analysis project couldn't use it, fell back on direct `lake build`.

### Observations needing verification
- Does the revised skill (with broader tactic coverage) actually reduce tokens on iteration-2 re-run?
- Are there Analysis I exercises where the baseline *fails* but with-skill succeeds? (These would be the most valuable test cases.)

### What to do next
- Run iteration-2 evals with revised skill against same 3 exercises
- Try harder exercises: `Rat.not_exist_sqrt_two` (√2 irrational), `ContinuousWithinAt.comp` (composition of continuous functions), `ContinuousWithinAt.tfae` (TFAE equivalence)
- Consider adding a new claim from your domain (morphological profiling) to test the full pipeline (claim → skeleton → proof)

---

## 2026-04-03: Initial repo setup and first proof

### What was done
- Created general-purpose lean_proofs repo (renamed from harmony_per_feature)
- Proved 3 Harmony per-feature independence theorems: `mul_col_eq`, `harmony_per_feature_independence`, `harmony_correction_independent`
- Built lean-theorem-prover skill encoding the claim → skeleton → proof pipeline
- Created `lean-diag.sh` for goal-state extraction at sorry positions

### Key insight
The skill's value is in the *process* (read definitions first, check dependencies, build after each theorem) more than the *tactics*. The model already knows Lean tactics — the skill prevents it from skipping steps and wasting time on dead-end approaches.
