# SAT Solver (CDCL)

This package implements a CDCL SAT solver inspired by the EasySAT.
The focus is on algorithmic optimizations (VSIDS, LBD-based restarts, clause
reduction, phase saving). C++-specific optimizations like manual memory
management are intentionally omitted.

## Overview

The solver operates on a CNF formula and returns either:

- `SolveResult::Sat` with a model (BitMap) indexed by variable id.
- `SolveResult::Unsat` when the formula is inconsistent.

Variables are 0-based internally; the DIMACS parser handles 1-based input.

## Core Data Structures

- Clause: `lbd` metadata + `lits : Array[Lit]`.
- Watcher: `(clause_idx, blocker)` for two-watched literals.
- Watches: `Array[Array[Watcher]]` indexed by literal id.
- Trail: assignment order, plus decision level boundaries.
- VSIDS heap: max-heap keyed by variable activity.

Watch lists are keyed by the negated watched literal. This matches the common
propagation pattern: when a literal becomes true, its negation is false and
all clauses watching that negation must be inspected.

## Algorithm Flow

1. Initialization
   - Load clauses and assign unit clauses at level 0.
   - Run initial propagation to simplify.
2. Main loop
   - Propagate (two-watched literals + blocker shortcut).
   - On conflict: 1-UIP analysis, learn clause, backtrack, and assert.
   - Otherwise: check reduce/restart/rephase, then decide a new literal.
3. Terminate when no decision variables remain (SAT) or a level-0 conflict
   occurs (UNSAT).

## Conflict Analysis and LBD

Conflict analysis uses 1-UIP resolution:

- Mark variables in the conflict clause.
- Walk the trail backward, resolving until only one literal from the current
  decision level remains.
- The learned clause is formed with the UIP literal as the first literal.

The Literal Block Distance (LBD) counts unique decision levels in the learned
clause. LBD is stored in the clause metadata and used for:

- Dynamic restarts (fast vs slow LBD averages).
- Clause reduction (delete a random subset of learned clauses with LBD >= 5).

## VSIDS and Phase Saving

VSIDS is used for branching:

- Variable activities are bumped during conflict analysis.
- Activities are periodically scaled to avoid overflow.
- Decisions pop the highest-activity variable from a heap.

Polarity is chosen with phase saving and periodic rephasing:

- Save the last assignment for each variable on backtrack.
- Track a "local best" phase (deepest trail) and reuse it on restarts.
- Randomized rephasing occasionally flips or randomizes saved phases.

## API

The main entry point is:

```
solve(formula : CnfFormula) -> SolveResult
```

The model bitmap is total; any unassigned variable (rare in practice) is mapped
to `false`.

## Notes on Differences vs EasySAT

- Memory management relies on MoonBit's GC and arrays.
- The algorithmic structure and heuristics follow EasySAT closely.
