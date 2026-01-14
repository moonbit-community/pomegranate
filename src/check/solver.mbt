///|
/// CDCL (Conflict-Driven Clause Learning) SAT solver.
///
/// This solver expects a CNF formula and returns either a satisfying model
/// (array of variable assignments, indexed by variable id) or `Unsat`.
/// It implements:
/// - Two-watched literals for fast unit propagation
/// - Conflict analysis with 1-UIP learning
/// - Non-chronological backtracking
/// - First-unassigned branching heuristic
///
/// Notes:
/// - Variables are 0-based internally.
/// - A literal evaluates to 1 (true), 0 (false), or -1 (unassigned).
using @formula {type CnfFormula, type Lit, type Var}

///|
/// Result of SAT solving.
/// - `Sat` includes a total model for all variables.
/// - `Unsat` means the formula is provably inconsistent.
pub enum SolveResult {
  Sat(model~ : Array[Bool])
  Unsat
} derive(Show, ToJson)

///|
/// Internal solver state for CDCL.
priv struct Solver {
  // Clauses stored as arrays of literals.
  clauses : Array[Array[Lit]]
  // Indices of the two watched literals per clause.
  watch_a : Array[Int]
  watch_b : Array[Int]
  // Watch lists indexed by literal id (var * 2 + sign).
  watches : Array[Array[Int]]
  // Assignment per variable: -1 = unassigned, 0 = false, 1 = true.
  assignment : Array[Int]
  // Decision level of each assigned variable.
  level : Array[Int]
  // Reason clause index for each assignment (None for decisions).
  reason : Array[Int?]
  // Assignment trail in order of propagation/decisions.
  trail : Array[Lit]
  // Trail indices where each decision level starts.
  trail_limits : Array[Int]
  mut trail_head : Int
  mut decision_level : Int
  // Fast check for empty clause at initialization.
  mut has_empty_clause : Bool
  // Unit clauses collected at initialization.
  initial_units : Array[Lit]
}

///|
/// Lightweight DPLL solver for small formulas to avoid clause explosion.
priv struct DpllSolver {
  clauses : Array[Array[Lit]]
  assignment : Array[Int]
  trail : Array[Lit]
  mut has_empty_clause : Bool
}

///|
fn DpllSolver::new(formula : CnfFormula) -> DpllSolver {
  let var_count = formula.var_count().to_int()
  let clause_count = formula.clause_count()
  let clauses = Array::makei(clause_count, i => formula.clause(i).to_array())
  let solver = {
    clauses,
    assignment: Array::make(var_count, -1),
    trail: [],
    has_empty_clause: false,
  }
  for clause in clauses {
    if clause.is_empty() {
      solver.has_empty_clause = true
      break
    }
  }
  solver
}

///|
/// Build solver state and initialize watch lists and unit clauses.
fn Solver::new(formula : CnfFormula) -> Solver {
  let var_count = formula.var_count().to_int()
  let clause_count = formula.clause_count()
  let clauses = Array::makei(clause_count, i => formula.clause(i).to_array())
  let watch_a = Array::make(clause_count, 0)
  let watch_b = Array::make(clause_count, 0)
  let watches = Array::makei(var_count * 2, _ => [])
  let solver = {
    clauses,
    watch_a,
    watch_b,
    watches,
    assignment: Array::make(var_count, -1),
    level: Array::make(var_count, 0),
    reason: Array::make(var_count, None),
    trail: [],
    trail_limits: [],
    trail_head: 0,
    decision_level: 0,
    has_empty_clause: false,
    initial_units: [],
  }
  for i in 0..<clause_count {
    let clause = clauses[i]
    let len = clause.length()
    if len == 0 {
      solver.has_empty_clause = true
      continue
    }
    let a = 0
    let b = if len > 1 { 1 } else { 0 }
    solver.watch_a[i] = a
    solver.watch_b[i] = b
    let lit_a = clause[a]
    solver.watches[lit_id(lit_a)].push(i)
    if b != a {
      let lit_b = clause[b]
      solver.watches[lit_id(lit_b)].push(i)
    }
    if len == 1 {
      solver.initial_units.push(clause[0])
    }
  }
  solver
}

///|
/// Encode a literal into a dense id used for watch lists.
fn lit_id(lit : Lit) -> Int {
  let base = lit.index().to_int() * 2
  if lit.is_negative() {
    base + 1
  } else {
    base
  }
}

///|
/// Flip the sign bit of an encoded literal id.
fn negate_id(lit_id : Int) -> Int {
  lit_id ^ 1
}

///|
/// Construct the opposite literal.
fn negate_lit(lit : Lit) -> Lit {
  Lit::from_var(lit.to_var(), lit.is_negative()) catch {
    _ => panic()
  }
}

///|
/// Build a literal from a variable index and polarity.
fn lit_from_index(index : Int, polarity : Bool) -> Lit {
  let variable = Var::from_index(index.to_uint64()) catch { _ => panic() }
  Lit::from_var(variable, polarity) catch {
    _ => panic()
  }
}

///|
/// Evaluate a literal under the current assignment.
/// Returns -1 (unassigned), 0 (false), or 1 (true).
fn Solver::lit_value(self : Solver, lit : Lit) -> Int {
  let idx = lit.index().to_int()
  let val = self.assignment[idx]
  if val == -1 {
    -1
  } else if lit.is_negative() {
    1 - val
  } else {
    val
  }
}

///|
fn DpllSolver::lit_value(self : DpllSolver, lit : Lit) -> Int {
  let idx = lit.index().to_int()
  let val = self.assignment[idx]
  if val == -1 {
    -1
  } else if lit.is_negative() {
    1 - val
  } else {
    val
  }
}

///|
fn DpllSolver::assign(self : DpllSolver, lit : Lit) -> Bool {
  let idx = lit.index().to_int()
  let val = if lit.is_negative() { 0 } else { 1 }
  let current = self.assignment[idx]
  if current == -1 {
    self.assignment[idx] = val
    self.trail.push(lit)
    true
  } else {
    current == val
  }
}

///|
fn DpllSolver::backtrack(self : DpllSolver, trail_len : Int) -> Unit {
  for i in trail_len..<self.trail.length() {
    let lit = self.trail[i]
    let v = lit.index().to_int()
    self.assignment[v] = -1
  }
  self.trail.truncate(trail_len)
}

///|
fn DpllSolver::pick_unassigned(self : DpllSolver) -> Int? {
  for i in 0..<self.assignment.length() {
    if self.assignment[i] == -1 {
      return Some(i)
    }
  }
  None
}

///|
fn DpllSolver::propagate(self : DpllSolver) -> Bool {
  let mut changed = true
  while changed {
    changed = false
    for clause in self.clauses {
      let mut clause_sat = false
      let mut unassigned = 0
      let mut unit_lit = clause[0]
      for lit in clause {
        let val = self.lit_value(lit)
        if val == 1 {
          clause_sat = true
          break
        }
        if val == -1 {
          unassigned += 1
          unit_lit = lit
          if unassigned > 1 {
            // Still need to keep scanning for a satisfying literal.
            ()
          }
        }
      }
      if clause_sat {
        continue
      }
      if unassigned == 0 {
        return false
      }
      if unassigned == 1 {
        if not(self.assign(unit_lit)) {
          return false
        }
        changed = true
      }
    }
  }
  true
}

///|
fn DpllSolver::solve(self : DpllSolver) -> Bool {
  if not(self.propagate()) {
    return false
  }
  match self.pick_unassigned() {
    None => true
    Some(var_idx) => {
      let trail_len = self.trail.length()
      let lit_pos = lit_from_index(var_idx, true)
      if self.assign(lit_pos) && self.solve() {
        return true
      }
      self.backtrack(trail_len)
      let lit_neg = lit_from_index(var_idx, false)
      if self.assign(lit_neg) && self.solve() {
        return true
      }
      self.backtrack(trail_len)
      false
    }
  }
}

///|
fn DpllSolver::build_model(self : DpllSolver) -> Array[Bool] {
  let model = Array::make(self.assignment.length(), false)
  for i, val in self.assignment {
    model[i] = val == 1
  }
  model
}

///|
/// Assign a literal and record its reason and decision level.
/// Returns false if the assignment conflicts with an existing value.
fn Solver::assign(self : Solver, lit : Lit, reason? : Int) -> Bool {
  let idx = lit.index().to_int()
  let val = if lit.is_negative() { 0 } else { 1 }
  let current = self.assignment[idx]
  if current == -1 {
    self.assignment[idx] = val
    self.level[idx] = self.decision_level
    self.reason[idx] = reason
    self.trail.push(lit)
    true
  } else {
    current == val
  }
}

///|
/// Propagate implications using two-watched literals.
///
/// Returns Some(conflict_clause_index) if a conflict is detected.
fn Solver::propagate(self : Solver) -> Int? {
  while self.trail_head < self.trail.length() {
    let lit = self.trail[self.trail_head]
    self.trail_head += 1
    // Only clauses watching the negation of this literal can become unit/conflict.
    let neg_watch = negate_id(lit_id(lit))
    let watch_list = self.watches[neg_watch]
    let mut i = 0
    let mut conflict : Int? = None
    while i < watch_list.length() {
      let clause_idx = watch_list[i]
      let clause = self.clauses[clause_idx]
      let w1 = self.watch_a[clause_idx]
      let w2 = self.watch_b[clause_idx]
      let watch_idx = if lit_id(clause[w1]) == neg_watch { w1 } else { w2 }
      let other_idx = if watch_idx == w1 { w2 } else { w1 }
      let other_lit = clause[other_idx]
      let other_val = self.lit_value(other_lit)
      if other_val == 1 {
        i += 1
        continue
      }
      let mut moved = false
      // Try to find a new watch to replace the falsified one.
      for j in 0..<clause.length() {
        if j != other_idx && j != watch_idx {
          let cand = clause[j]
          let cand_val = self.lit_value(cand)
          if cand_val != 0 {
            if watch_idx == w1 {
              self.watch_a[clause_idx] = j
            } else {
              self.watch_b[clause_idx] = j
            }
            let cand_id = lit_id(cand)
            if cand_id == neg_watch {
              watch_list.push(clause_idx)
            } else {
              self.watches[cand_id].push(clause_idx)
            }
            let last_index = watch_list.length() - 1
            watch_list[i] = watch_list[last_index]
            let _ = watch_list.pop()
            moved = true
            break
          }
        }
      }
      if moved {
        continue
      }
      if other_val == -1 {
        // Clause is unit: force the other watched literal.
        if not(self.assign(other_lit, reason=clause_idx)) {
          conflict = Some(clause_idx)
          break
        }
        i += 1
      } else {
        // Both watched literals are false: conflict.
        conflict = Some(clause_idx)
        break
      }
    }
    self.watches[neg_watch] = watch_list
    match conflict {
      Some(idx) => return Some(idx)
      None => ()
    }
  }
  None
}

///|
/// Analyze a conflict and derive a learned clause using 1-UIP.
///
/// Returns the learned clause and the backtrack level.
fn Solver::analyze(self : Solver, conflict_idx : Int) -> (Array[Lit], Int) {
  let learned : Array[Lit] = []
  let seen = Array::make(self.assignment.length(), false)
  let mut path_count = 0
  let mut clause = self.clauses[conflict_idx]
  let mut idx = self.trail.length() - 1
  let current_level = self.decision_level
  let mut pivot = self.trail[0]
  while true {
    for lit in clause {
      let v = lit.index().to_int()
      if not(seen[v]) {
        seen[v] = true
        if self.level[v] == current_level {
          path_count += 1
        } else {
          learned.push(lit)
        }
      }
    }
    while true {
      let lit = self.trail[idx]
      idx = idx - 1
      let v = lit.index().to_int()
      if seen[v] {
        pivot = lit
        break
      }
    }
    if path_count == 1 {
      break
    }
    // Resolve with the reason of the current pivot literal.
    let v = pivot.index().to_int()
    let reason = self.reason[v]
    match reason {
      Some(r) => {
        clause = self.clauses[r]
        path_count -= 1
      }
      None => panic()
    }
  }
  // First literal is the negation of the 1-UIP.
  learned.insert(0, negate_lit(pivot))
  // Backtrack level is the max level of the remaining literals.
  let mut backtrack = 0
  for i in 1..<learned.length() {
    let v = learned[i].index().to_int()
    backtrack = @cmp.maximum(backtrack, self.level[v])
  }
  (learned, backtrack)
}

///|
/// Start a new decision level by recording the trail boundary.
fn Solver::new_decision_level(self : Solver) -> Unit {
  self.trail_limits.push(self.trail.length())
  self.decision_level = self.decision_level + 1
}

///|
/// Undo assignments down to the requested decision level.
fn Solver::backtrack(self : Solver, level : Int) -> Unit {
  if self.decision_level <= level {
    return
  }
  let target = if level == 0 { 0 } else { self.trail_limits[level - 1] }
  for i in target..<self.trail.length() {
    let lit = self.trail[i]
    let v = lit.index().to_int()
    self.assignment[v] = -1
    self.reason[v] = None
    self.level[v] = 0
  }
  self.trail.truncate(target)
  self.trail_head = @cmp.minimum(self.trail_head, target)
  self.trail_limits.truncate(level)
  self.decision_level = level
}

///|
/// Pick the next decision literal (first unassigned, positive polarity).
fn Solver::pick_branch_lit(self : Solver) -> Lit? {
  for i in 0..<self.assignment.length() {
    if self.assignment[i] == -1 {
      return Some(lit_from_index(i, true))
    }
  }
  None
}

///|
/// Add a learned clause to the database and set up its watched literals.
fn Solver::add_clause(self : Solver, clause : Array[Lit]) -> Int {
  let idx = self.clauses.length()
  let len = clause.length()
  self.clauses.push(clause)
  let a = 0
  let b = if len > 1 { 1 } else { 0 }
  self.watch_a.push(a)
  self.watch_b.push(b)
  let lit_a = self.clauses[idx][a]
  self.watches[lit_id(lit_a)].push(idx)
  if b != a {
    let lit_b = self.clauses[idx][b]
    self.watches[lit_id(lit_b)].push(idx)
  }
  idx
}

///|
/// Convert the internal assignment to a Bool model array.
fn Solver::build_model(self : Solver) -> Array[Bool] {
  let model = Array::make(self.assignment.length(), false)
  for i, val in self.assignment {
    model[i] = val == 1
  }
  model
}

///|
/// Solve the given CNF formula with CDCL.
///
/// The returned model assigns every variable index present in the formula.
pub fn solve(formula : CnfFormula) -> SolveResult {
  let var_count = formula.var_count().to_int()
  let clause_count = formula.clause_count()
  if var_count <= 64 && clause_count <= 256 {
    let solver = DpllSolver::new(formula)
    if solver.has_empty_clause {
      return Unsat
    }
    if solver.solve() {
      return Sat(model=solver.build_model())
    }
    return Unsat
  }
  let solver = Solver::new(formula)
  if solver.has_empty_clause {
    return Unsat
  }
  // Apply unit clauses collected at initialization.
  for lit in solver.initial_units {
    if not(solver.assign(lit)) {
      return Unsat
    }
  }
  match solver.propagate() {
    Some(_) => return Unsat
    None => ()
  }
  while true {
    let decision = solver.pick_branch_lit()
    match decision {
      None => return Sat(model=solver.build_model())
      Some(lit) => {
        solver.new_decision_level()
        // Decision assignments have no reason clause.
        let _ = solver.assign(lit)

      }
    }
    while true {
      match solver.propagate() {
        None => break
        Some(conflict_idx) => {
          if solver.decision_level == 0 {
            return Unsat
          }
          let (learned, backtrack_level) = solver.analyze(conflict_idx)
          solver.backtrack(backtrack_level)
          let clause_idx = solver.add_clause(learned)
          let unit_lit = solver.clauses[clause_idx][0]
          // The learned clause is unit at the backtrack level.
          let _ = solver.assign(unit_lit, reason=clause_idx)

        }
      }
    } else {
      ()
    }
  } else {
    Unsat
  }
}
