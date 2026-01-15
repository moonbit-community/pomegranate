///|
fn Solver::update_local_best(self : Solver) -> Unit {
  if self.trail.length() > self.threshold {
    self.threshold = self.trail.length()
    for i in 0..<self.assignment.length() {
      self.local_best[i] = self.assignment[i]
    }
  }
}

///|
fn Solver::decide(self : Solver) -> Bool {
  let mut next = -1
  while next == -1 || self.assignment[next] != 0 {
    if self.vsids.empty() {
      return false
    }
    next = self.vsids.pop()
  }
  self.trail_limits.push(self.trail.length())
  let level = self.trail_limits.length()
  self.decision_level = level
  let polarity = if self.saved[next] != 0 { self.saved[next] } else { 1 }
  let lit = lit_from_index(next, polarity == 1)
  let _ = self.assign(lit, level, -1)
  true
}

///|
fn Solver::backtrack(self : Solver, backtrack_level : Int) -> Unit {
  if self.trail_limits.length() <= backtrack_level {
    return
  }
  let target = if backtrack_level == 0 {
    0
  } else {
    self.trail_limits[backtrack_level - 1]
  }
  let old_len = self.trail.length()
  for i in target..<old_len {
    let lit = self.trail[i]
    let v = lit.index().to_int()
    self.assignment[v] = 0
    self.level[v] = 0
    self.reason[v] = -1
    self.saved[v] = if lit.is_negative() { -1 } else { 1 }
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
fn Solver::restart(self : Solver) -> Unit {
  self.fast_lbd_sum = 0.0
  self.lbd_queue_size = 0
  self.lbd_queue_pos = 0
  self.backtrack(0)
  let phase_rand = self.rand.int(limit=100)
  if phase_rand - 60 < 0 {
    for i in 0..<self.saved.length() {
      self.saved[i] = self.local_best[i]
    }
  } else if phase_rand - 60 - 5 < 0 {
    for i in 0..<self.saved.length() {
      self.saved[i] = -self.local_best[i]
    }
  } else if phase_rand - 60 - 5 - 20 < 0 {
    for i in 0..<self.saved.length() {
      self.saved[i] = if self.rand.int(limit=2) == 0 { -1 } else { 1 }
    }
  }
}

///|
fn Solver::rephase(self : Solver) -> Unit {
  self.rephases = 0
  self.threshold = self.threshold * 9 / 10
  self.rephase_limit += 8192
}

///|
fn Solver::reduce(self : Solver) -> Unit {
  self.backtrack(0)
  self.reduces = 0
  self.reduce_limit += 512
  let old_size = self.clauses.length()
  let mut new_size = self.origin_clauses
  self.reduce_map = Array::make(old_size, -1)
  for i in self.origin_clauses..<old_size {
    let clause = self.clauses[i]
    let remove = clause.lbd >= 5 && self.rand.int(limit=2) == 0
    if remove {
      self.reduce_map[i] = -1
    } else {
      if new_size != i {
        self.clauses[new_size] = clause
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
}
