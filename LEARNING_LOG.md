# Learning Log

Tracks what we tried, what we learned, and what to do next — across sessions.

---

## 2026-04-03: Notebook-to-proof — permutation preserves variance

### What was done
- Downloaded a Colab notebook ("Deconstruct sphering") and extracted 9 formalizable claims — 5 pure linear algebra, 4 PAC/probabilistic.
- Formalized and proved **permutation preserves variance**: column-wise permutation of a matrix preserves ∑ᵢⱼ M(i,j)² (Frobenius norm squared). Two theorems, zero sorries.
- Dropped the manually maintained claims table from README.md — the `claims/` and `LeanProofs/` directories are the source of truth.
- Updated CLAUDE.md with notebook workflow and tactic gotchas.

### Key findings
- **Notebooks are rich claim sources.** The sphering notebook yielded 9 distinct claims spanning pure algebra (whitening identity, null-space projection) to PAC-flavored statements (Marchenko-Pastur, variance partition, permutation test correctness).
- **`Equiv.sum_comp` is the key mathlib lemma** for permutation-invariance proofs. Pattern: `Equiv.sum_comp σ (f · ^ 2)` — found by grepping mathlib's `SumFourSquares.lean`.
- **`simp_rw [Finset.sum_comm]` loops** because `sum_comm` is its own inverse. Use `calc` blocks with explicit directional steps instead.
- **Lean LSP MCP tools were unavailable** in this session (not registered as deferred tools). Operated in `scripts_only` mode: `lake env lean` for validation, `$LEAN4_SCRIPTS` for sorry/axiom analysis. Proofs succeeded without live goal inspection.

### Remaining claims from the notebook
- Sphering produces identity covariance (whitening identity): `Wᵀ XᵀX W = I`
- Rank of mean-centered matrix ≤ n−1
- Variance partition under orthogonal projection (Pythagorean/Frobenius)
- Pseudoinverse via SVD / hat matrix equivalence
- Null-space projection equivalence (ε → 0 limit)
- Trace identity (total variance = d)
- Rescaling preserves variance budget

### What to do next
- Formalize the whitening identity (builds on existing SVD-PCA equivalence).
- Try the variance partition claim (Pythagorean theorem for Frobenius norm) — bridges algebra and the probabilistic layer.
- Investigate Lean LSP MCP availability for future sessions.

---

## 2026-04-03: Formalize-claim skill experiment — built, eval'd, retired

### What was done
- Created a `formalize-claim` skill to handle the "left side" of the pipeline: reading informal claims and producing Lean skeletons (type selection, decomposition, Mathlib structure choices).
- Ran 10 parallel subagent evals (5 with-skill, 5 baseline) across diverse domains: matrix algebra (Harmony, SVD-PCA), number theory (even/odd), real analysis (Cauchy convergence), topology (continuity).
- Graded on 8 assertions (import, namespace, sorry, doc comments, declaration count, type appropriateness, section markers, no tactic leakage).
- Result: with-skill scored 39/40, baseline 38/40. The only discriminating signal was decomposition discipline on SVD-PCA (baseline invented 5 declarations vs. claim's 2).
- Retired the skill and folded the useful domain patterns (type mappings, decomposition rule) into CLAUDE.md instead.

### Key findings
- **Skills that codify what the model already knows are overhead, not leverage.** The model already produces correct `import Mathlib`, namespaces, sorry placeholders, doc comments, and appropriate types without being told. A skill repeating these instructions costs ~20% more tokens for negligible quality gain.
- **Domain patterns belong in CLAUDE.md, not a separate skill.** CLAUDE.md is already read by every session and by `/lean4:draft`. Adding a skill layer just duplicates the delivery mechanism.
- **The right threshold for a custom skill: does it do something the model + lean4-skills + CLAUDE.md can't?** Formalizability triage, Mathlib gap detection, or claim quality review would clear this bar. A style guide doesn't.
- **Decomposition discipline was the one real signal.** The baseline over-decomposed on SVD-PCA (added `orthogonal_cancel`, `svd_pca_similarity` beyond the claim). A single line in CLAUDE.md ("Follow the claim's decomposition") captures this more cheaply than a full skill.

### What to do next
- Try `/lean4:formalize` or `/lean4:autoformalize` on a new claim to test the full pipeline end-to-end.
- Consider a claim from the morphological profiling domain (e.g., sphering/whitening properties, batch effect correction bounds).
- If a skill idea emerges that does something the model can't do alone (e.g., pre-checking Mathlib for required lemmas before drafting), revisit skill-creator then.

---

## 2026-04-03: Complementarity audit and cleanup

### What was done
- Cloned `cameronfreer/lean4-skills` and ran `/lean4:review --scope=project` with a complementarity lens — comparing every component in this repo against what the plugin provides.
- Deleted `scripts/lean-diag.sh` (140 lines) — its three subcommands (`status`, `goals`, `check`) duplicated `sorry_analyzer.py`, `lean_goal()` LSP, and `lean_diagnostic_messages()` from the plugin.
- Deleted `.claude/skills/lean-theorem-prover-workspace/` (34 files, 239K) — eval artifacts from the retired custom skill, whose insights were already captured in this log.
- Updated `CLAUDE.md` to remove all lean-diag.sh references.
- Cleaned stale permission entries from `.claude/settings.local.json`.

### Key findings
- **Plugin/project separation principle**: this repo should own only *content* (claims, proofs), *project config* (lakefile, toolchain, nix), and *workflow docs* (CLAUDE.md pointing to the plugin). All tooling — diagnostics, sorry analysis, goal extraction, axiom checking, golfing, refactoring — belongs in `lean4-skills`.
- **lean-diag.sh was a pre-plugin artifact**: built before `/lean4` adoption, it worked by mutating files (inserting `trace_state`) — fragile and slower than the LSP approach. The plugin's equivalents are strictly better (per-line precision, no file mutation, structured JSON output).
- **Eval artifacts vs. eval insights**: raw grading/timing JSON is disposable once the findings are written up. The learning log is the durable artifact, not the data files.

### What to do next
- Try `/lean4:formalize` or `/lean4:autoformalize` on a new claim to test the full pipeline with the adopted skill suite.
- Consider a claim from the morphological profiling domain (e.g., sphering/whitening properties, batch effect correction bounds).

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
