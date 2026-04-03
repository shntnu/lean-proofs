# Learning Log

Tracks what we tried, what we learned, and what to do next — across sessions.

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
