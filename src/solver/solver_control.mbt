///|
/// Update the best (deepest) trail snapshot used for phase saving.
fn Solver::update_local_best(self : Solver) -> Unit {
  if self.trail.length() > self.threshold {
    self.threshold = self.trail.length()
    for i in 0..<self.assignment.length() {
      self.local_best[i] = self.assignment[i]
    }
  }
}

///|
/// Luby restart sequence helper.
fn luby(idx : Int) -> Int {
  let mut index = idx
  let mut k = 1
  while true {
    let power = 1 << k
    let boundary = power - 1
    if index == boundary {
      return 1 << (k - 1)
    }
    if index < boundary {
      index = index - (1 << (k - 1)) + 1
      k = 1
      continue
    }
    k += 1
  }
  1
}

///|
/// Base conflict budget for restarts, scaled by problem size.
fn Solver::restart_base(self : Solver) -> Int {
  let vars = self.assignment.length()
  let clauses = if self.origin_clauses == 0 {
    self.clauses.length()
  } else {
    self.origin_clauses
  }
  let base_vars = @cmp.maximum(
    RESTART_BASE_VAR_MIN,
    @cmp.minimum(RESTART_BASE_VAR_MAX, vars / RESTART_BASE_VAR_DIV),
  )
  let base_clauses = @cmp.maximum(
    RESTART_BASE_CLAUSE_MIN,
    @cmp.minimum(RESTART_BASE_CLAUSE_MAX, clauses / RESTART_BASE_CLAUSE_DIV),
  )
  @cmp.minimum(base_vars, base_clauses)
}

///|
/// Base conflict budget for rephasing, scaled by problem size.
fn Solver::rephase_base(self : Solver) -> Int {
  let vars = self.assignment.length()
  let clauses = if self.origin_clauses == 0 {
    self.clauses.length()
  } else {
    self.origin_clauses
  }
  let base_vars = @cmp.maximum(
    REPHASE_BASE_VAR_MIN,
    @cmp.minimum(REPHASE_BASE_VAR_MAX, vars / REPHASE_BASE_VAR_DIV),
  )
  let base_clauses = @cmp.maximum(
    REPHASE_BASE_CLAUSE_MIN,
    @cmp.minimum(REPHASE_BASE_CLAUSE_MAX, clauses / REPHASE_BASE_CLAUSE_DIV),
  )
  @cmp.minimum(base_vars, base_clauses)
}

///|
/// Scale down VSIDS activity to keep recent bumps influential.
fn Solver::decay_activities(self : Solver, factor : Double) -> Unit {
  if factor >= ACTIVITY_DECAY_SKIP {
    return
  }
  for i in 0..<self.activity.length() {
    self.activity[i] = self.activity[i] * factor
  }
  self.vsids_rescales_total += 1
}

///|
/// Choose a decision literal using VSIDS, phase saving, and occasional
/// shallow randomization to escape local traps.
///
/// Returns `false` if all variables are assigned (SAT).
fn Solver::decide(self : Solver) -> Bool {
  let mut next = -1
  let depth_before = self.trail_limits.length()
  let use_random = if depth_before < DECIDE_SHALLOW_RANDOM_DEPTH {
    self.rand.int(limit=100) < DECIDE_SHALLOW_RANDOM_PCT
  } else if depth_before > DECIDE_DEEP_RANDOM_DEPTH {
    self.rand.int(limit=100) < DECIDE_DEEP_RANDOM_PCT
  } else if depth_before >= DECIDE_MID_RANDOM_DEPTH {
    self.rand.int(limit=100) < DECIDE_MID_RANDOM_PCT
  } else {
    false
  }
  while next == -1 || self.assignment[next] != 0 {
    if self.vsids.empty() {
      return false
    }
    if use_random {
      next = self.vsids.pop_noisy(self.rand, DECIDE_RANDOM_SAMPLE_COUNT)
    } else {
      next = self.vsids.pop()
    }
  }
  // Start a new decision level.
  self.trail_limits.push(self.trail.length())
  let level = self.trail_limits.length()
  self.decision_level = level
  let saved = self.saved[next]
  let best = self.local_best[next]
  let depth = self.trail_limits.length()
  let mut use_saved = saved != 0
  if use_saved && best != 0 && self.rand.int(limit=100) < PHASE_BEST_PCT {
    use_saved = false
  }
  if use_saved {
    let phase_override = if depth > PHASE_OVERRIDE_DEPTH_1 {
      PHASE_OVERRIDE_PCT_1
    } else if depth > PHASE_OVERRIDE_DEPTH_2 {
      PHASE_OVERRIDE_PCT_2
    } else if depth > PHASE_OVERRIDE_DEPTH_3 {
      PHASE_OVERRIDE_PCT_3
    } else {
      PHASE_OVERRIDE_PCT_BASE
    }
    if self.rand.int(limit=100) < phase_override {
      use_saved = false
    }
  }
  let mut polarity = if use_saved {
    saved
  } else if best != 0 {
    best
  } else {
    self.phase_default[next]
  }
  let used_best = not(use_saved) && best != 0
  if not(use_saved) &&
    self.rand.int(limit=100) < PHASE_FLIP_PCT &&
    self.activity[next] <= self.var_inc * PHASE_FLIP_ACTIVITY_MULT {
    polarity = -polarity
  }
  let lit = lit_from_index(next, polarity == 1)
  let assigned = self.assign(lit, level, -1)
  if assigned {
    self.decisions_total += 1
    if use_random {
      self.decision_random_total += 1
    }
    if use_saved {
      self.decision_phase_saved_total += 1
    } else if used_best {
      self.decision_phase_best_total += 1
    } else {
      self.decision_phase_default_total += 1
    }
    self.decision_level_sum += level
    if level > self.decision_level_max {
      self.decision_level_max = level
    }
  }
  true
}

///|
/// Undo assignments back to a target decision level.
fn Solver::backtrack(self : Solver, backtrack_level : Int) -> Unit {
  let current_level = self.trail_limits.length()
  if backtrack_level >= current_level {
    return
  }
  let target = if backtrack_level == 0 {
    if current_level > 0 {
      self.trail_limits[0]
    } else {
      self.trail.length()
    }
  } else {
    self.trail_limits[backtrack_level]
  }
  let old_len = self.trail.length()
  let removed = old_len - target
  self.backtrack_calls_total += 1
  self.backtrack_lits_removed_total += removed
  if removed > self.backtrack_lits_removed_max {
    self.backtrack_lits_removed_max = removed
  }
  for i in target..<old_len {
    let lit = self.trail[i]
    let v = lit.index().to_int()
    self.assignment[v] = 0
    self.level[v] = 0
    self.reason[v] = -1
    self.saved[v] = if lit.is_negative() { -1 } else { 1 }
    // Put variable back into the decision heap if needed.
    if not(self.vsids.in_heap(v)) {
      self.vsids.insert(v)
    }
  }
  self.trail.truncate(target)
  self.propagated = @cmp.minimum(self.propagated, target)
  self.trail_limits.truncate(backtrack_level)
  self.decision_level = backtrack_level
}

///|
/// Restart search while preserving learned clauses.
///
/// Also rephases (copies or perturbs saved phases) with a small probability,
/// and may keep a small suffix of decision levels to reuse recent trail work.
fn Solver::restart(self : Solver) -> Unit {
  self.restarts_total += 1
  // Reset fast EMA to the slow baseline; keep slow EMA across restarts.
  self.fast_lbd_sum = self.slow_lbd_sum
  self.conflicts = 0
  self.decay_activities(ACTIVITY_DECAY_RESTART)
  let full_restart = self.rand.int(limit=100) < RESTART_FULL_PCT
  let keep_window = RESTART_KEEP_WINDOW
  let keep_levels = if full_restart {
    0
  } else if self.decision_level > keep_window {
    self.decision_level - keep_window
  } else {
    0
  }
  self.backtrack(keep_levels)
  let phase_rand = self.rand.int(limit=100)
  if phase_rand - RESTART_PHASE_LOCAL_BEST_PCT < 0 {
    self.restart_phase_local_best_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = self.local_best[i]
    }
  } else if phase_rand -
    RESTART_PHASE_LOCAL_BEST_PCT -
    RESTART_PHASE_INVERT_BEST_PCT <
    0 {
    self.restart_phase_invert_best_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = -self.local_best[i]
    }
  } else if phase_rand -
    RESTART_PHASE_LOCAL_BEST_PCT -
    RESTART_PHASE_INVERT_BEST_PCT -
    RESTART_PHASE_RANDOM_PCT <
    0 {
    self.restart_phase_random_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = if self.rand.int(limit=2) == 0 { -1 } else { 1 }
    }
  } else {
    self.restart_phase_keep_total += 1
  }
  self.restart_index += 1
  self.restart_limit = self.restart_base() * luby(self.restart_index)
}

///|
/// Periodically adjust rephase limits and soften the "best trail" threshold.
fn Solver::rephase(self : Solver) -> Unit {
  self.rephases_total += 1
  self.rephases = 0
  self.threshold = self.threshold *
    LOCAL_BEST_THRESHOLD_NUM /
    LOCAL_BEST_THRESHOLD_DEN
  self.rephase_limit += REPHASE_LIMIT_STEP
  self.decay_activities(ACTIVITY_DECAY_REPHASE)
  let mode = self.rephases_total % 4
  if mode == 0 {
    self.rephase_phase_local_best_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = self.local_best[i]
    }
  } else if mode == 1 {
    self.rephase_phase_invert_best_total += 1
    for i in 0..<self.saved.length() {
      let val = self.local_best[i]
      self.saved[i] = if val == 0 { 0 } else { -val }
    }
  } else if mode == 2 {
    self.rephase_phase_random_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = if self.rand.int(limit=2) == 0 { -1 } else { 1 }
    }
  } else {
    self.rephase_phase_default_total += 1
    for i in 0..<self.saved.length() {
      self.saved[i] = self.phase_default[i]
    }
  }
}

///|
/// Reduce the learned clause database.
///
/// This keeps all original/locked/low-LBD clauses, and removes the worst half
/// of remaining learned clauses by (LBD, length). Watch lists are updated with
/// the new indices.
fn Solver::reduce(self : Solver) -> Unit {
  let learned_before = self.clauses.length() - self.origin_clauses
  self.backtrack(0)
  self.reduce_limit += REDUCE_LIMIT_STEP
  let old_size = self.clauses.length()
  let mut new_size = self.origin_clauses
  self.reduce_map = Array::make(old_size, -1)
  let mut removed = 0
  let locked = FixedArray::make(old_size, false)
  for idx in self.reason {
    if idx >= self.origin_clauses {
      locked[idx] = true
    }
  }
  let candidates : Array[(Int, Int, Int, Int)] = []
  for i in self.origin_clauses..<old_size {
    let clause = self.clauses[i]
    let len = clause.lits.length()
    let lbd = clause.lbd
    let used = clause.used
    let keep = locked[i] ||
      len <= LEARNED_KEEP_LEN_MAX ||
      lbd <= LEARNED_KEEP_LBD_CORE_MAX ||
      (lbd <= LEARNED_KEEP_LBD_TIER_MAX && used > 0) ||
      used >= LEARNED_KEEP_USED_MIN
    if keep {
      continue
    }
    candidates.push((i, lbd, used, len))
  }
  // Sort candidates by (LBD desc, used asc, length desc) to drop the worst slice.
  for i in 1..<candidates.length() {
    let key = candidates[i]
    let mut j = i
    while j > 0 {
      let prev = candidates[j - 1]
      let worse = prev.1 < key.1 ||
        (prev.1 == key.1 && prev.2 > key.2) ||
        (prev.1 == key.1 && prev.2 == key.2 && prev.3 < key.3)
      if not(worse) {
        break
      }
      candidates[j] = prev
      j -= 1
    }
    candidates[j] = key
  }
  let remove_quota = candidates.length() *
    LEARNED_DROP_RATIO_NUM /
    LEARNED_DROP_RATIO_DEN
  let drop = FixedArray::make(old_size, false)
  for i in 0..<remove_quota {
    drop[candidates[i].0] = true
  }
  for i in self.origin_clauses..<old_size {
    let clause = self.clauses[i]
    let len = clause.lits.length()
    let remove = len > LEARNED_KEEP_LEN_MAX && drop[i]
    if remove {
      self.reduce_map[i] = -1
      removed += 1
    } else {
      if clause.used > 0 {
        clause.used = clause.used / LEARNED_USED_DECAY_DIV
      }
      if new_size != i {
        self.clauses[new_size] = clause
      } else {
        self.clauses[i] = clause
      }
      self.reduce_map[i] = new_size
      new_size += 1
    }
  }
  self.clauses.truncate(new_size)
  for lit_id in 0..<self.watches.length() {
    let ws = self.watches[lit_id]
    let mut j = 0
    let sz = ws.length()
    for i in 0..<sz {
      let old_idx = ws[i].clause_idx
      let new_idx = if old_idx < self.origin_clauses {
        old_idx
      } else {
        self.reduce_map[old_idx]
      }
      if new_idx != -1 {
        ws[i].clause_idx = new_idx
        if j != i {
          ws[j] = ws[i]
        }
        j += 1
      }
    }
    ws.truncate(j)
    self.watches[lit_id] = ws
  }
  let learned_after = self.clauses.length() - self.origin_clauses
  self.reductions.push((learned_before, learned_after))
  self.reductions_removed_total += removed
}
