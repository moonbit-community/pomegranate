///|
/// Solve the given CNF formula with CDCL.
///
/// This runs the classic CDCL loop:
/// propagate -> (conflict? analyze & backtrack : decide) with periodic
/// restart/rephase/reduction heuristics.
pub fn solve(formula : CnfFormula) -> SolveResult {
  let solver = Solver::new(formula)
  if solver.has_conflict {
    return Unsat
  }
  // Initial propagation after unit clauses in the constructor.
  if solver.propagate() != -1 {
    return Unsat
  }
  while true {
    let conflict = solver.propagate()
    let restart_ready = solver.lbd_queue_size == 50 &&
      0.8 * solver.fast_lbd_sum / solver.lbd_queue_size.to_double() >
      solver.slow_lbd_sum / solver.conflicts.to_double()
    if conflict != -1 {
      match solver.analyze(conflict) {
        AnalyzeResult::Unsat => return Unsat
        AnalyzeResult::Learned(learned~, backtrack_level~, lbd~) => {
          solver.backtrack(backtrack_level)
          if learned.length() == 1 {
            // Unit learned clause: assert at level 0.
            let _ = solver.assign(learned[0], 0, -1)

          } else {
            let cref = solver.add_clause(learned.mut_view())
            solver.clauses[cref].lbd = lbd
            // Assert the UIP literal at the backtrack level.
            let _ = solver.assign(learned[0], backtrack_level, cref)

          }
          // Bump conflict counters and update heuristics.
          solver.var_inc = solver.var_inc / 0.8
          solver.conflicts += 1
          solver.rephases += 1
          solver.reduces += 1
          solver.update_local_best()
        }
      }
    } else if solver.reduces >= solver.reduce_limit {
      solver.reduce()
    } else if restart_ready {
      solver.restart()
    } else if solver.rephases >= solver.rephase_limit {
      solver.rephase()
    } else if not(solver.decide()) {
      // No decision variables left: model is complete.
      return Sat(model=solver.build_model())
    }
  }
  Unsat
}
