///|
/// Internal solver state modeled after EasySAT.
priv struct Solver {
  clauses : Array[Clause]
  watches : Array[Array[Watcher]]
  assignment : Array[Int]
  level : Array[Int]
  reason : Array[Int]
  mark : Array[Int]
  local_best : Array[Int]
  saved : Array[Int]
  activity : Array[Double]
  trail : Array[Lit]
  trail_limits : Array[Int]
  mut reduce_map : Array[Int]
  lbd_queue : Array[Int]
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
fn Solver::new(formula : CnfFormula) -> Solver {
  let var_count = formula.var_count().to_int()
  let activity = Array::make(var_count, 0.0)
  let solver = {
    clauses: [],
    watches: Array::makei(var_count * 2, _ => []),
    assignment: Array::make(var_count, 0),
    level: Array::make(var_count, 0),
    reason: Array::make(var_count, -1),
    mark: Array::make(var_count + 1, 0),
    local_best: Array::make(var_count, 0),
    saved: Array::make(var_count, 0),
    activity,
    trail: [],
    trail_limits: [],
    reduce_map: [],
    lbd_queue: Array::make(50, 0),
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
        if not(solver.assign(lit, 0, -1)) {
          solver.has_conflict = true
          break
        }
      }
      continue
    }
    let _ = solver.add_clause(clause)

  }
  solver.origin_clauses = solver.clauses.length()
  solver
}

///|
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
fn Solver::build_model(self : Solver) -> Model {
  let model = Model::new(self.assignment.length())
  for i, val in self.assignment {
    if val == 1 {
      model.set(i, true)
    }
  }
  model
}
