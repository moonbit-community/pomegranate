///|
/// Update fast/slow LBD EMA metrics for restart heuristics.
///
/// - `fast_lbd_sum`: fast EMA of recent LBD values.
/// - `slow_lbd_sum`: slow EMA of capped LBD values.
fn Solver::update_lbd_metrics(self : Solver, lbd : Int) -> Unit {
  if self.lbd_queue_size < LBD_QUEUE_LEN {
    self.lbd_queue_size = self.lbd_queue_size + 1
  }
  let lbd_val = lbd.to_double()
  let capped = if lbd > LBD_CAP { LBD_CAP } else { lbd }
  let capped_val = capped.to_double()
  if self.lbd_queue_size == 1 {
    self.fast_lbd_sum = lbd_val
    self.slow_lbd_sum = capped_val
  } else {
    self.fast_lbd_sum = self.fast_lbd_sum +
      LBD_FAST_EMA_ALPHA * (lbd_val - self.fast_lbd_sum)
    self.slow_lbd_sum = self.slow_lbd_sum +
      LBD_SLOW_EMA_ALPHA * (capped_val - self.slow_lbd_sum)
  }
}

///|
/// Tighten the stored LBD of a learned clause if it is implied at lower levels.
fn Solver::tighten_clause_lbd(self : Solver, cref : Int) -> Unit {
  if cref < self.origin_clauses {
    return
  }
  let clause = self.clauses[cref]
  let current = clause.lbd
  if current <= LEARNED_LBD_UPDATE_MIN {
    return
  }
  let lits = clause.lits
  if lits.length() > LEARNED_LBD_UPDATE_MAX_LEN {
    return
  }
  self.time_stamp = self.time_stamp + 1
  let stamp = self.time_stamp
  let mut lbd = 0
  for lit in lits {
    let lvl = self.level[lit.index().to_int()]
    if lvl != 0 && self.mark[lvl] != stamp {
      self.mark[lvl] = stamp
      lbd += 1
      if lbd >= current {
        return
      }
    }
  }
  if lbd < current {
    clause.lbd = lbd
  }
}

///|
/// Map a decision level to an abstract bit for redundancy pruning.
fn abstract_level(level : Int) -> Int {
  1 << (level & 31)
}

///|
/// Check whether a learned literal is redundant using its reason chain.
///
/// A literal is redundant if all literals in its reason (recursively) are
/// implied by level-0 assignments or other literals already in the learned
/// clause. This variant uses abstract decision levels and poison marks to
/// prune failed branches quickly.
///
/// `learned_abstract` is a bitmask of decision levels present in the learned
/// clause. `poison_stamp` tracks literals known to block redundancy checks in
/// this minimization pass.
fn Solver::lit_redundant(
  self : Solver,
  lit : Lit,
  learned_stamp : Int,
  learned_abstract : Int,
  poison_stamp : Int,
) -> Bool {
  let stack : Array[Lit] = []
  let var_id = lit.index().to_int()
  if self.reason[var_id] == -1 {
    self.minimize_mark[var_id] = poison_stamp
    return false
  }
  self.time_stamp = self.time_stamp + 1
  let visit_stamp = self.time_stamp
  stack.push(lit)
  while true {
    match stack.pop() {
      None => break
      Some(p) => {
        let p_var = p.index().to_int()
        let reason_idx = self.reason[p_var]
        if reason_idx == -1 {
          self.minimize_mark[p_var] = poison_stamp
          return false
        }
        let clause = self.clauses[reason_idx].lits
        for q in clause {
          let q_var = q.index().to_int()
          let lvl = self.level[q_var]
          if lvl == 0 {
            continue
          }
          if self.mark[q_var] == learned_stamp {
            continue
          }
          if self.minimize_mark[q_var] == poison_stamp {
            return false
          }
          if self.mark[q_var] == visit_stamp {
            continue
          }
          if (abstract_level(lvl) & learned_abstract) == 0 {
            self.minimize_mark[q_var] = poison_stamp
            return false
          }
          if self.reason[q_var] == -1 {
            self.minimize_mark[q_var] = poison_stamp
            return false
          }
          self.mark[q_var] = visit_stamp
          stack.push(q)
        }
      }
    }
  }
  true
}

///|
/// Minimize learned clause by removing redundant literals.
fn Solver::minimize_learned(self : Solver, learned : Array[Lit]) -> Unit {
  if learned.length() <= 1 {
    return
  }
  self.time_stamp = self.time_stamp + 1
  let learned_stamp = self.time_stamp
  self.minimize_stamp = self.minimize_stamp + 1
  let poison_stamp = self.minimize_stamp
  let mut learned_abstract = 0
  for lit in learned {
    let v = lit.index().to_int()
    self.mark[v] = learned_stamp
    let lvl = self.level[v]
    if lvl > 0 {
      learned_abstract = learned_abstract | abstract_level(lvl)
    }
  }
  let mut write = 1
  let sz = learned.length()
  for i in 1..<sz {
    let lit = learned[i]
    if self.lit_redundant(lit, learned_stamp, learned_abstract, poison_stamp) {
      continue
    }
    learned[write] = lit
    write += 1
  }
  learned.truncate(write)
}

///|
/// Sort learned literals (excluding index 0) by decision level descending.
fn Solver::sort_learned_by_level(self : Solver, learned : Array[Lit]) -> Unit {
  let n = learned.length()
  if n <= 2 {
    return
  }
  for i in 2..<n {
    let key = learned[i]
    let key_level = self.level[key.index().to_int()]
    let mut j = i
    while j > 1 {
      let prev = learned[j - 1]
      let prev_level = self.level[prev.index().to_int()]
      if prev_level >= key_level {
        break
      }
      learned[j] = prev
      j -= 1
    }
    learned[j] = key
  }
}

///|
/// Conflict analysis with 1-UIP learning and LBD computation.
fn Solver::analyze(self : Solver, conflict_idx : Int) -> AnalyzeResult {
  let current_level = self.decision_level
  self.analyze_calls += 1
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
        self.bump_var(var_id, VSIDS_BUMP_RESOLVE_MULT)
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
  self.sort_learned_by_level(learned)
  self.minimize_learned(learned)
  if learned.length() >= LEARNED_MINIMIZE_SECOND_PASS_MIN_LEN {
    self.minimize_learned(learned)
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
  self.update_lbd_metrics(lbd)
  if lbd <= LEARNED_STRONG_LBD_MAX {
    for lit in learned {
      let v = lit.index().to_int()
      self.bump_var(v, VSIDS_BUMP_LBD_MULT)
    }
  }
  let learned_len = learned.length()
  self.learned_len_sum += learned_len
  if self.learned_len_min == 0 || learned_len < self.learned_len_min {
    self.learned_len_min = learned_len
  }
  if learned_len > self.learned_len_max {
    self.learned_len_max = learned_len
  }
  self.learned_lbd_sum += lbd
  if self.learned_lbd_min == 0 || lbd < self.learned_lbd_min {
    self.learned_lbd_min = lbd
  }
  if lbd > self.learned_lbd_max {
    self.learned_lbd_max = lbd
  }
  if learned_len == 1 {
    self.learned_unit_total += 1
  } else if learned_len == 2 {
    self.learned_binary_total += 1
  } else if learned_len == 3 {
    self.learned_ternary_total += 1
  }
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
    if self.level[var_id] >= backtrack_level - BACKTRACK_BUMP_WINDOW {
      self.bump_var(var_id, VSIDS_BUMP_BACKTRACK_MULT)
    }
  }
  AnalyzeResult::Learned(learned~, backtrack_level~, lbd~)
}
