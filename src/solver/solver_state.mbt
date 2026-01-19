///|
/// Internal solver state modeled after EasySAT.
///
/// Key invariants and conventions:
/// - `assignment`: 1 = true, -1 = false, 0 = unassigned.
/// - `level`: decision level for each variable (0 for level-0/unit propagation).
/// - `reason`: clause index that implied the assignment, or -1 for decisions.
/// - `trail`: ordered list of assigned literals; `trail_limits` stores decision boundaries.
/// - `watches`: watch lists indexed by literal-id (stored on the negated watched literal).
/// - `mark` + `time_stamp`: cheap visited set for conflict analysis and LBD computation.
/// - `saved`/`local_best`: phase saving (last assignment / best trail snapshot).
priv struct Solver {
  clauses : Array[Clause]
  watches : FixedArray[Array[Watcher]]
  assignment : FixedArray[Int]
  level : FixedArray[Int]
  reason : FixedArray[Int]
  mark : FixedArray[Int]
  local_best : FixedArray[Int]
  saved : FixedArray[Int]
  activity : FixedArray[Double]
  trail : Array[Lit]
  trail_limits : Array[Int]
  mut reduce_map : Array[Int]
  lbd_queue : FixedArray[Int]
  vsids : VsidsHeap
  rand : @random.Rand
  mut origin_clauses : Int
  mut conflicts : Int
  mut rephases : Int
  mut reduces : Int
  mut rephase_limit : Int
  mut reduce_limit : Int
  mut threshold : Int
  mut propagated : Int
  mut decision_level : Int
  mut time_stamp : Int
  mut lbd_queue_size : Int
  mut lbd_queue_pos : Int
  mut fast_lbd_sum : Double
  mut slow_lbd_sum : Double
  mut var_inc : Double
  mut has_conflict : Bool
}

///|
/// Build a solver from a CNF formula.
///
/// The constructor:
/// - Seeds the VSIDS heap with all variables.
/// - Adds all non-unit clauses to the watch lists.
/// - Enqueues unit clauses at level 0 and detects early conflicts.
fn Solver::new(formula : CnfFormula) -> Solver {
  let var_count = formula.var_count().to_int()
  let activity = FixedArray::make(var_count, 0.0)
  let solver = {
    clauses: [],
    watches: FixedArray::makei(var_count * 2, _ => []),
    assignment: FixedArray::make(var_count, 0),
    level: FixedArray::make(var_count, 0),
    reason: FixedArray::make(var_count, -1),
    mark: FixedArray::make(var_count + 1, 0),
    local_best: FixedArray::make(var_count, 0),
    saved: FixedArray::make(var_count, 0),
    activity,
    trail: [],
    trail_limits: [],
    reduce_map: [],
    lbd_queue: FixedArray::make(50, 0),
    vsids: VsidsHeap::new(activity),
    rand: @random.Rand::new(),
    origin_clauses: 0,
    conflicts: 0,
    rephases: 0,
    reduces: 0,
    rephase_limit: 1024,
    reduce_limit: 8192,
    threshold: 0,
    propagated: 0,
    decision_level: 0,
    time_stamp: 0,
    lbd_queue_size: 0,
    lbd_queue_pos: 0,
    fast_lbd_sum: 0.0,
    slow_lbd_sum: 0.0,
    var_inc: 1.0,
    has_conflict: false,
  }
  // All variables start in the decision heap with zero activity.
  for v in 0..<var_count {
    solver.vsids.insert(v)
  }
  let clause_count = formula.clause_count()
  for i in 0..<clause_count {
    let clause = formula.clause(i)
    let len = clause.length()
    if len == 0 {
      solver.has_conflict = true
      break
    }
    if len == 1 {
      let lit = clause[0]
      let val = solver.lit_value(lit)
      if val == -1 {
        solver.has_conflict = true
        break
      }
      if val == 0 {
        // Level-0 unit propagation: conflict here means UNSAT immediately.
        if not(solver.assign(lit, 0, -1)) {
          solver.has_conflict = true
          break
        }
      }
      continue
    }
    // Normal clause: add to clause DB and initialize two watched literals.
    let _ = solver.add_clause(clause)

  }
  solver.origin_clauses = solver.clauses.length()
  solver
}

///|
/// Add a (non-empty) clause to the database and register two watched literals.
///
/// The watch lists are keyed by the negated watched literal. This way, when
/// a literal becomes true we scan the watch list at `lit_id(lit)`, which is
/// exactly the watch list for its negation.
fn Solver::add_clause(self : Solver, lits : MutArrayView[Lit]) -> Int {
  let idx = self.clauses.length()
  self.clauses.push({ lbd: 0, lits })
  let len = lits.length()
  let lit0 = lits[0]
  let lit1 = if len > 1 { lits[1] } else { lits[0] }
  self.watches[negate_id(lit_id(lit0))].push({ clause_idx: idx, blocker: lit1 })
  if len > 1 {
    self.watches[negate_id(lit_id(lit1))].push({
      clause_idx: idx,
      blocker: lit0,
    })
  }
  idx
}

///|
/// Build a total model from the current assignment.
///
/// Any unassigned variables are mapped to `false` (bit cleared).
fn Solver::build_model(self : Solver) -> Model {
  let model = Model::new(self.assignment.length())
  for i, val in self.assignment {
    if val == 1 {
      model.set(i, true)
    }
  }
  model
}
