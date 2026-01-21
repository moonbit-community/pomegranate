///|
/// Solve the given CNF formula with CDCL.
///
/// This runs the classic CDCL loop:
/// propagate -> (conflict? analyze & backtrack : decide) with periodic
/// restart/rephase/reduction heuristics.
pub fn solve(formula : CnfFormula) -> SolveResult {
  let solver = Solver::new(formula)
  if solver.has_conflict {
    return SolveResult::{ model: None, metrics: solver.build_metrics() }
  }
  // Initial propagation after unit clauses in the constructor.
  let initial_conflict = solver.propagate()
  if initial_conflict != -1 {
    solver.conflicts_total += 1
    solver.conflicts_init += 1
    if initial_conflict < solver.origin_clauses {
      solver.conflicts_original += 1
    } else {
      solver.conflicts_learned += 1
    }
    return SolveResult::{ model: None, metrics: solver.build_metrics() }
  }
  while true {
    let conflict = solver.propagate()
    let lbd_ready = solver.lbd_queue_size >= LBD_READY_MIN_QUEUE &&
      solver.conflicts_total >= LBD_READY_MIN_CONFLICTS &&
      solver.fast_lbd_sum > solver.slow_lbd_sum * (1.0 + LBD_EMA_MARGIN)
    let deep_stuck = solver.decision_level > DEEP_STUCK_LEVEL &&
      solver.conflicts >= solver.restart_limit / DEEP_STUCK_CONFLICTS_DIV
    let restart_due = solver.conflicts >= solver.restart_limit || deep_stuck
    let restart_ready = lbd_ready || restart_due
    if conflict != -1 {
      solver.update_local_best()
      solver.conflicts_total += 1
      if conflict < solver.origin_clauses {
        solver.conflicts_original += 1
      } else {
        solver.conflicts_learned += 1
      }
      match solver.analyze(conflict) {
        AnalyzeResult::Unsat =>
          return SolveResult::{ model: None, metrics: solver.build_metrics() }
        AnalyzeResult::Learned(learned~, backtrack_level~, lbd~) => {
          solver.learned_clauses_total += 1
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
          solver.var_inc = solver.var_inc / VAR_INC_DECAY
          solver.conflicts += 1
          solver.rephases += 1
        }
      }
    } else {
      let rephase_due = solver.rephases >= solver.rephase_limit ||
        (
          restart_ready &&
          solver.rephases >= solver.rephase_limit / REPHASE_SOON_DIV
        )
      if lbd_ready {
        solver.restart_ready_total += 1
      }
      let learned_now = solver.clauses.length() - solver.origin_clauses
      if learned_now >= solver.reduce_limit {
        solver.reduce()
      } else if rephase_due {
        solver.rephase()
      } else if restart_ready {
        solver.restart()
      } else if not(solver.decide()) {
        // No decision variables left: model is complete.
        return SolveResult::{
          model: Some(solver.build_model()),
          metrics: solver.build_metrics(),
        }
      }
    }
  }
  SolveResult::{ model: None, metrics: solver.build_metrics() }
}
