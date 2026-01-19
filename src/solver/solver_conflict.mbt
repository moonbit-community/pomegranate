///|
/// Update fast/slow LBD statistics for restart heuristics.
///
/// - `fast_lbd_sum`: moving sum over the last 50 LBD values.
/// - `slow_lbd_sum`: longer-term sum with LBD capped at 50.
fn Solver::update_lbd_stats(self : Solver, lbd : Int) -> Unit {
  if self.lbd_queue_size < 50 {
    self.lbd_queue_size = self.lbd_queue_size + 1
  } else {
    self.fast_lbd_sum = self.fast_lbd_sum -
      self.lbd_queue[self.lbd_queue_pos].to_double()
  }
  self.fast_lbd_sum = self.fast_lbd_sum + lbd.to_double()
  self.lbd_queue[self.lbd_queue_pos] = lbd
  self.lbd_queue_pos = self.lbd_queue_pos + 1
  if self.lbd_queue_pos == 50 {
    self.lbd_queue_pos = 0
  }
  let capped = if lbd > 50 { 50 } else { lbd }
  self.slow_lbd_sum = self.slow_lbd_sum + capped.to_double()
}

///|
/// Conflict analysis with 1-UIP learning and LBD computation.
fn Solver::analyze(self : Solver, conflict_idx : Int) -> AnalyzeResult {
  let current_level = self.decision_level
  if current_level == 0 {
    return AnalyzeResult::Unsat
  }
  // `mark` is reused as a visited set for variables via `time_stamp`.
  self.time_stamp = self.time_stamp + 1
  let learned : Array[Lit] = []
  learned.push(self.clauses[conflict_idx].lits[0])
  let bump : Array[Int] = []
  let mut resolve_lit : Lit? = None
  let mut should_visit = 0
  let mut idx = self.trail.length() - 1
  let mut conflict = conflict_idx
  while true {
    let clause = self.clauses[conflict].lits
    // Skip the resolved literal if this is not the first clause.
    let start = match resolve_lit {
      None => 0
      Some(_) => 1
    }
    for i in start..<clause.length() {
      let lit = clause[i]
      let var_id = lit.index().to_int()
      if self.mark[var_id] != self.time_stamp && self.level[var_id] > 0 {
        self.bump_var(var_id, 0.5)
        bump.push(var_id)
        self.mark[var_id] = self.time_stamp
        if self.level[var_id] == current_level {
          should_visit += 1
        } else {
          learned.push(lit)
        }
      }
    }
    let mut pivot = clause[0]
    // Walk trail backwards to find the next marked literal at current level.
    while true {
      let lit = self.trail[idx]
      idx -= 1
      let v = lit.index().to_int()
      if self.mark[v] == self.time_stamp {
        pivot = lit
        if self.level[v] == current_level {
          break
        }
      }
    }
    resolve_lit = Some(pivot)
    let pivot_var = pivot.index().to_int()
    let next_conflict = self.reason[pivot_var]
    // Clear mark for the resolved pivot.
    self.mark[pivot_var] = 0
    should_visit -= 1
    if should_visit == 0 {
      // 1-UIP found: pivot negation becomes asserting literal.
      learned[0] = negate_lit(pivot)
      break
    }
    conflict = next_conflict
  }
  // Compute LBD: number of unique decision levels in the learned clause.
  self.time_stamp = self.time_stamp + 1
  let mut lbd = 0
  for lit in learned {
    let lvl = self.level[lit.index().to_int()]
    if lvl != 0 && self.mark[lvl] != self.time_stamp {
      self.mark[lvl] = self.time_stamp
      lbd += 1
    }
  }
  self.update_lbd_stats(lbd)
  let mut backtrack_level = 0
  if learned.length() > 1 {
    // Place the highest-level literal (besides learned[0]) at index 1.
    let mut max_idx = 1
    for i in 2..<learned.length() {
      let v = learned[i].index().to_int()
      let max_v = learned[max_idx].index().to_int()
      if self.level[v] > self.level[max_v] {
        max_idx = i
      }
    }
    let tmp = learned[1]
    learned[1] = learned[max_idx]
    learned[max_idx] = tmp
    backtrack_level = self.level[learned[1].index().to_int()]
  }
  // Bump variables involved near the backtrack level.
  for var_id in bump {
    if self.level[var_id] >= backtrack_level - 1 {
      self.bump_var(var_id, 1.0)
    }
  }
  AnalyzeResult::Learned(learned~, backtrack_level~, lbd~)
}
