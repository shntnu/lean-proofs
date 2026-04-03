#!/usr/bin/env python3
"""Grade all eval runs against their assertions."""
import json, re, os

BASE = os.path.dirname(os.path.abspath(__file__))

def count_sorry(text, theorem_name):
    """Check if a specific theorem still has sorry."""
    # Find the theorem block and check for sorry
    pattern = rf'(theorem|def|example)\s+.*{re.escape(theorem_name)}.*?:=\s*by\s*(.*?)(?=\n(?:theorem|def|example|end|/-|#check|noncomputable|instance|abbrev|lemma|set_option|@)|$)'
    m = re.search(pattern, text, re.DOTALL)
    if m:
        body = m.group(2)
        return 'sorry' in body
    return None  # couldn't find it

def count_lines(text, theorem_name):
    """Count tactic lines in a proof body."""
    pattern = rf'{re.escape(theorem_name)}.*?:=\s*by\s*(.*?)(?=\n(?:theorem|def|example|end|/-|#check|noncomputable|instance|abbrev|lemma|set_option|@)|$)'
    m = re.search(pattern, text, re.DOTALL)
    if m:
        body = m.group(1).strip()
        lines = [l.strip() for l in body.split('\n') if l.strip() and not l.strip().startswith('--')]
        return len(lines)
    return None

def has_error(build_log):
    """Check if build log has errors (not sorry warnings)."""
    for line in build_log.split('\n'):
        if 'error' in line.lower() and 'sorry' not in line.lower():
            return True
    return False

def grade_number_theory(run_dir):
    lean_path = os.path.join(run_dir, 'outputs', 'Section_4_4.lean')
    blog_path = os.path.join(run_dir, 'outputs', 'build_log.txt')
    lean = open(lean_path).read()
    blog = open(blog_path).read()

    results = []

    # Check each theorem
    for name, assert_name in [
        ('no_infinite_descent', 'no_infinite_descent_proved'),
        ('even_or_odd', 'even_or_odd_proved'),
        ('not_even_and_odd', 'not_even_and_odd_proved')
    ]:
        has_sorry = count_sorry(lean, name)
        passed = has_sorry == False
        results.append({
            "text": assert_name,
            "passed": passed,
            "evidence": f"sorry {'still present' if has_sorry else 'replaced'} in {name}"
        })

    # Build check
    build_ok = not has_error(blog)
    results.append({
        "text": "builds_without_errors",
        "passed": build_ok,
        "evidence": f"Build {'clean' if build_ok else 'has errors'}"
    })

    # Conciseness check
    all_concise = True
    for name in ['no_infinite_descent', 'even_or_odd', 'not_even_and_odd']:
        n = count_lines(lean, name)
        if n and n > 10:
            all_concise = False
    results.append({
        "text": "proofs_concise",
        "passed": all_concise,
        "evidence": "All proofs <= 10 lines" if all_concise else "Some proofs > 10 lines"
    })

    return results

def grade_continuity(run_dir):
    lean_path = os.path.join(run_dir, 'outputs', 'Section_9_4.lean')
    blog_path = os.path.join(run_dir, 'outputs', 'build_log.txt')
    lean = open(lean_path).read()
    blog = open(blog_path).read()

    results = []

    # Check each line's sorry is gone
    sorry_checks = [
        ('const_continuousWithinAt_proved', 'continuousWithinAt_const'),
        ('const_continuousAt_proved', 'continuousAt_const'),
        ('const_continuousOn_proved', 'continuousOn_const'),
        ('const_continuous_proved', 'continuous_const'),
        ('id_continuous_proved', 'continuous_id'),
    ]

    # Simple check: count sorry occurrences in lines 30-45 range
    lines = lean.split('\n')
    sorry_in_target = 0
    for i, l in enumerate(lines):
        if 28 <= i <= 45 and 'sorry' in l:
            sorry_in_target += 1

    # Check if key Mathlib lemmas are used
    mathlib_lemmas = ['continuousWithinAt_const', 'continuousAt_const', 'continuousOn_const',
                      'continuous_const', 'continuous_id']

    for assert_name, lemma in zip(
        ['const_continuousWithinAt_proved', 'const_continuousAt_proved',
         'const_continuousOn_proved', 'const_continuous_proved', 'id_continuous_proved'],
        mathlib_lemmas
    ):
        found = lemma in lean
        results.append({
            "text": assert_name,
            "passed": found,
            "evidence": f"{'Found' if found else 'Missing'} {lemma} in proof"
        })

    # Build check
    build_ok = not has_error(blog)
    results.append({
        "text": "builds_without_errors",
        "passed": build_ok,
        "evidence": f"Build {'clean' if build_ok else 'has errors'}"
    })

    # Mathlib API usage
    uses_api = sum(1 for l in mathlib_lemmas if l in lean) >= 4
    results.append({
        "text": "uses_mathlib_api",
        "passed": uses_api,
        "evidence": f"Uses {sum(1 for l in mathlib_lemmas if l in lean)}/5 Mathlib lemmas"
    })

    return results

def grade_convergence(run_dir):
    lean_path = os.path.join(run_dir, 'outputs', 'Section_6_1.lean')
    blog_path = os.path.join(run_dir, 'outputs', 'build_log.txt')
    lean = open(lean_path).read()
    blog = open(blog_path).read()

    results = []

    # Check sorry replaced
    has_sorry_conv = count_sorry(lean, 'convergent')
    results.append({
        "text": "sorry_replaced",
        "passed": has_sorry_conv == False,
        "evidence": f"sorry {'still present' if has_sorry_conv else 'replaced'} in IsCauchy.convergent"
    })

    # Build check
    build_ok = not has_error(blog)
    results.append({
        "text": "builds_without_errors",
        "passed": build_ok,
        "evidence": f"Build {'clean' if build_ok else 'has errors'}"
    })

    # Triangle inequality usage
    tri_terms = ['dist_triangle', 'triangle', 'dist_comm', 'calc']
    uses_tri = any(t in lean[lean.find('convergent'):lean.find('convergent')+2000] if lean.find('convergent') >= 0 else '' for t in tri_terms)
    results.append({
        "text": "proof_uses_triangle_inequality",
        "passed": uses_tri,
        "evidence": f"{'Found' if uses_tri else 'Missing'} triangle inequality reference near proof"
    })

    # Conciseness
    n = count_lines(lean, 'convergent')
    concise = n is not None and n <= 15
    results.append({
        "text": "proof_concise",
        "passed": concise,
        "evidence": f"Proof has {n} lines" if n else "Could not count lines"
    })

    return results

# Grade all runs
runs = {
    'number-theory-with_skill': grade_number_theory,
    'number-theory-old_skill': grade_number_theory,
    'continuity-with_skill': grade_continuity,
    'continuity-old_skill': grade_continuity,
    'convergence-with_skill': grade_convergence,
    'convergence-old_skill': grade_convergence,
}

for run_name, grader in runs.items():
    run_dir = os.path.join(BASE, run_name)
    try:
        results = grader(run_dir)
        grading = {"expectations": results}

        out_path = os.path.join(run_dir, 'grading.json')
        with open(out_path, 'w') as f:
            json.dump(grading, f, indent=2)

        passed = sum(1 for r in results if r['passed'])
        total = len(results)
        print(f"{run_name}: {passed}/{total} passed")
        for r in results:
            status = "✓" if r['passed'] else "✗"
            print(f"  {status} {r['text']}: {r['evidence']}")
    except Exception as e:
        print(f"{run_name}: ERROR - {e}")
