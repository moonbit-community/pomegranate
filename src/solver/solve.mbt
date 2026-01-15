///|
/// Solve the given CNF formula with CDCL.
pub fn solve(formula : CnfFormula) -> SolveResult {
  let solver = Solver::new(formula)
  if solver.has_conflict {
    return Unsat
  }
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
            let _ = solver.assign(learned[0], 0, -1)

          } else {
            let cref = solver.add_clause(learned.mut_view())
            solver.clauses[cref].lbd = lbd
            let _ = solver.assign(learned[0], backtrack_level, cref)

          }
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
      return Sat(model=solver.build_model())
    }
  }
  Unsat
}
