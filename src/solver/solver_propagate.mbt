///|
/// Evaluate a literal under the current assignment.
///
/// Returns:
/// - `1` if the literal is true,
/// - `-1` if the literal is false,
/// - `0` if the variable is unassigned.
fn Solver::lit_value(self : Solver, lit : Lit) -> Int {
  let idx = lit.index().to_int()
  let val = self.assignment[idx]
  if val == 0 {
    0
  } else if lit.is_negative() {
    -val
  } else {
    val
  }
}

///|
/// Assign a literal at a given decision level with an optional reason clause.
///
/// Returns `false` if the assignment contradicts an existing assignment.
fn Solver::assign(self : Solver, lit : Lit, level : Int, reason : Int) -> Bool {
  let idx = lit.index().to_int()
  let val = if lit.is_negative() { -1 } else { 1 }
  let current = self.assignment[idx]
  if current == 0 {
    self.assignment[idx] = val
    self.level[idx] = level
    self.reason[idx] = reason
    self.trail.push(lit)
    true
  } else {
    current == val
  }
}

///|
/// Increase a variable's VSIDS activity and reheapify if needed.
fn Solver::bump_var(self : Solver, var_id : Int, mult : Double) -> Unit {
  let next = self.activity[var_id] + self.var_inc * mult
  self.activity[var_id] = next
  if next > 1.0e100 {
    // Scale down to avoid floating-point overflow.
    for i in 0..<self.activity.length() {
      self.activity[i] = self.activity[i] * 1.0e-100
    }
    self.var_inc = self.var_inc * 1.0e-100
  }
  if self.vsids.in_heap(var_id) {
    self.vsids.update(var_id)
  }
}

///|
/// Boolean constraint propagation using two-watched literals.
/// Returns a clause index on conflict or -1 on success.
fn Solver::propagate(self : Solver) -> Int {
  // Walk the trail from `propagated` and process watch lists.
  while self.propagated < self.trail.length() {
    let p = self.trail[self.propagated]
    self.propagated += 1
    // `watches[lit_id(p)]` is the list of clauses watching ~p.
    let key = lit_id(p)
    let ws = self.watches[key]
    let mut i = 0
    let mut j = 0
    let size = ws.length()
    while i < size {
      let watcher = ws[i]
      if self.lit_value(watcher.blocker) == 1 {
        // Blocker is satisfied: keep watcher and continue.
        ws[j] = watcher
        j += 1
        i += 1
        continue
      }
      let cref = watcher.clause_idx
      let clause = self.clauses[cref].lits
      // Ensure clause[0] is the literal not equal to ~p.
      if lit_id(clause[0]) == negate_id(lit_id(p)) {
        let tmp = clause[0]
        clause[0] = clause[1]
        clause[1] = tmp
      }
      let blocker = clause[0]
      let new_watcher = { clause_idx: cref, blocker }
      i += 1
      if self.lit_value(blocker) == 1 {
        // Clause already satisfied by the other watched literal.
        ws[j] = new_watcher
        j += 1
        continue
      }
      let mut k = 2
      let sz = clause.length()
      // Look for a new literal to watch that is not currently false.
      while k < sz && self.lit_value(clause[k]) == -1 {
        k += 1
      }
      if k < sz {
        let new_lit = clause[k]
        clause[1] = new_lit
        clause[k] = negate_lit(p)
        let target = negate_id(lit_id(new_lit))
        if target == key {
          // New watch also goes into current list.
          ws.push(new_watcher)
        } else {
          self.watches[target].push(new_watcher)
        }
      } else {
        // No new watch found: clause is unit or conflicting.
        ws[j] = new_watcher
        j += 1
        if self.lit_value(blocker) == -1 {
          // Both watched literals are false -> conflict.
          while i < size {
            ws[j] = ws[i]
            j += 1
            i += 1
          }
          ws.truncate(j)
          self.watches[key] = ws
          return cref
        } else {
          // Unit clause: propagate the remaining watched literal.
          let level = self.level[p.index().to_int()]
          if not(self.assign(blocker, level, cref)) {
            ws.truncate(j)
            self.watches[key] = ws
            return cref
          }
        }
      }
    }
    ws.truncate(j)
    self.watches[key] = ws
  }
  -1
}
