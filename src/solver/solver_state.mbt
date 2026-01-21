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
/// - `phase_default`: default polarity by variable (from weighted literal
///   occurrence counts in the original formula).
priv struct Solver {
  clauses : Array[Clause]
  watches : FixedArray[Array[Watcher]]
  assignment : FixedArray[Int]
  level : FixedArray[Int]
  reason : FixedArray[Int]
  mark : FixedArray[Int]
  minimize_mark : FixedArray[Int]
  local_best : FixedArray[Int]
  phase_default : FixedArray[Int]
  saved : FixedArray[Int]
  activity : FixedArray[Double]
  trail : Array[Lit]
  trail_limits : Array[Int]
  mut reduce_map : Array[Int]
  vsids : VsidsHeap
  rand : @random.Rand
  mut origin_clauses : Int
  mut conflicts : Int
  mut conflicts_total : Int
  mut conflicts_init : Int
  mut conflicts_original : Int
  mut conflicts_learned : Int
  mut restart_index : Int
  mut restart_limit : Int
  mut rephases : Int
  mut rephase_limit : Int
  mut reduce_limit : Int
  mut threshold : Int
  mut propagated : Int
  mut decision_level : Int
  mut decision_level_sum : Int
  mut decision_level_max : Int
  mut time_stamp : Int
  mut minimize_stamp : Int
  mut lbd_queue_size : Int
  mut fast_lbd_sum : Double
  mut slow_lbd_sum : Double
  mut var_inc : Double
  mut has_conflict : Bool
  mut assignments_total : Int
  mut assignments_level0_total : Int
  mut assignments_nonzero_total : Int
  mut decisions_total : Int
  mut decision_phase_saved_total : Int
  mut decision_phase_best_total : Int
  mut decision_phase_default_total : Int
  mut decision_random_total : Int
  mut restarts_total : Int
  mut restart_ready_total : Int
  mut restart_phase_local_best_total : Int
  mut restart_phase_invert_best_total : Int
  mut restart_phase_random_total : Int
  mut restart_phase_keep_total : Int
  mut rephases_total : Int
  mut rephase_phase_local_best_total : Int
  mut rephase_phase_invert_best_total : Int
  mut rephase_phase_random_total : Int
  mut rephase_phase_default_total : Int
  reductions : Array[(Int, Int)]
  mut reductions_removed_total : Int
  mut learned_clauses_total : Int
  mut learned_unit_total : Int
  mut learned_binary_total : Int
  mut learned_ternary_total : Int
  mut learned_len_sum : Int
  mut learned_len_min : Int
  mut learned_len_max : Int
  mut learned_lbd_sum : Int
  mut learned_lbd_min : Int
  mut learned_lbd_max : Int
  mut max_trail : Int
  mut backtrack_calls_total : Int
  mut backtrack_lits_removed_total : Int
  mut backtrack_lits_removed_max : Int
  mut propagate_calls : Int
  mut watcher_scans : Int
  mut blocker_hits : Int
  mut watch_replacements : Int
  mut vsids_bumps_total : Int
  mut vsids_bumps_strong_total : Int
  mut vsids_rescales_total : Int
  mut analyze_calls : Int
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
  let pos_weight = FixedArray::make(var_count, 0.0)
  let neg_weight = FixedArray::make(var_count, 0.0)
  let clause_count = formula.clause_count()
  let restart_base = {
    let base_vars = @cmp.maximum(
      RESTART_BASE_VAR_MIN,
      @cmp.minimum(RESTART_BASE_VAR_MAX, var_count / RESTART_BASE_VAR_DIV),
    )
    let base_clauses = @cmp.maximum(
      RESTART_BASE_CLAUSE_MIN,
      @cmp.minimum(
        RESTART_BASE_CLAUSE_MAX,
        clause_count / RESTART_BASE_CLAUSE_DIV,
      ),
    )
    @cmp.minimum(base_vars, base_clauses)
  }
  let rephase_start = {
    let base_vars = @cmp.maximum(
      REPHASE_BASE_VAR_MIN,
      @cmp.minimum(REPHASE_BASE_VAR_MAX, var_count / REPHASE_BASE_VAR_DIV),
    )
    let base_clauses = @cmp.maximum(
      REPHASE_BASE_CLAUSE_MIN,
      @cmp.minimum(
        REPHASE_BASE_CLAUSE_MAX,
        clause_count / REPHASE_BASE_CLAUSE_DIV,
      ),
    )
    @cmp.minimum(base_vars, base_clauses)
  }
  let solver = {
    clauses: [],
    watches: FixedArray::makei(var_count * 2, _ => []),
    assignment: FixedArray::make(var_count, 0),
    level: FixedArray::make(var_count, 0),
    reason: FixedArray::make(var_count, -1),
    mark: FixedArray::make(var_count + 1, 0),
    minimize_mark: FixedArray::make(var_count, 0),
    local_best: FixedArray::make(var_count, 0),
    phase_default: FixedArray::make(var_count, 1),
    saved: FixedArray::make(var_count, 0),
    activity,
    trail: [],
    trail_limits: [],
    reduce_map: [],
    vsids: VsidsHeap::new(activity),
    rand: @random.Rand::new(),
    origin_clauses: 0,
    conflicts: 0,
    conflicts_total: 0,
    conflicts_init: 0,
    conflicts_original: 0,
    conflicts_learned: 0,
    restart_index: 1,
    restart_limit: restart_base,
    rephases: 0,
    rephase_limit: rephase_start,
    reduce_limit: REDUCE_LIMIT_MIN,
    threshold: 0,
    propagated: 0,
    decision_level: 0,
    decision_level_sum: 0,
    decision_level_max: 0,
    time_stamp: 0,
    minimize_stamp: 0,
    lbd_queue_size: 0,
    fast_lbd_sum: 0.0,
    slow_lbd_sum: 0.0,
    var_inc: 1.0,
    has_conflict: false,
    assignments_total: 0,
    assignments_level0_total: 0,
    assignments_nonzero_total: 0,
    decisions_total: 0,
    decision_phase_saved_total: 0,
    decision_phase_best_total: 0,
    decision_phase_default_total: 0,
    decision_random_total: 0,
    restarts_total: 0,
    restart_ready_total: 0,
    restart_phase_local_best_total: 0,
    restart_phase_invert_best_total: 0,
    restart_phase_random_total: 0,
    restart_phase_keep_total: 0,
    rephases_total: 0,
    rephase_phase_local_best_total: 0,
    rephase_phase_invert_best_total: 0,
    rephase_phase_random_total: 0,
    rephase_phase_default_total: 0,
    reductions: [],
    reductions_removed_total: 0,
    learned_clauses_total: 0,
    learned_unit_total: 0,
    learned_binary_total: 0,
    learned_ternary_total: 0,
    learned_len_sum: 0,
    learned_len_min: 0,
    learned_len_max: 0,
    learned_lbd_sum: 0,
    learned_lbd_min: 0,
    learned_lbd_max: 0,
    max_trail: 0,
    backtrack_calls_total: 0,
    backtrack_lits_removed_total: 0,
    backtrack_lits_removed_max: 0,
    propagate_calls: 0,
    watcher_scans: 0,
    blocker_hits: 0,
    watch_replacements: 0,
    vsids_bumps_total: 0,
    vsids_bumps_strong_total: 0,
    vsids_rescales_total: 0,
    analyze_calls: 0,
  }
  for i in 0..<clause_count {
    let clause = formula.clause(i)
    let len = clause.length()
    let mut weight = 1.0
    for _ in 0..<len {
      weight = weight * 0.5
    }
    for lit in clause {
      let idx = lit.index().to_int()
      if lit.is_negative() {
        neg_weight[idx] = neg_weight[idx] + weight
      } else {
        pos_weight[idx] = pos_weight[idx] + weight
      }
    }
    if len == 0 {
      solver.has_conflict = true
      solver.conflicts_total += 1
      solver.conflicts_init += 1
      solver.conflicts_original += 1
      break
    }
    if len == 1 {
      let lit = clause[0]
      let val = solver.lit_value(lit)
      if val == -1 {
        solver.has_conflict = true
        solver.conflicts_total += 1
        solver.conflicts_init += 1
        solver.conflicts_original += 1
        break
      }
      if val == 0 {
        // Level-0 unit propagation: conflict here means UNSAT immediately.
        if not(solver.assign(lit, 0, -1)) {
          solver.has_conflict = true
          solver.conflicts_total += 1
          solver.conflicts_init += 1
          solver.conflicts_original += 1
          break
        }
      }
      continue
    }
    // Normal clause: add to clause DB and initialize two watched literals.
    let _ = solver.add_clause(clause)

  }
  for i in 0..<var_count {
    if neg_weight[i] > pos_weight[i] {
      solver.phase_default[i] = -1
    }
  }
  // Seed VSIDS activity from literal weights before filling the heap.
  for i in 0..<var_count {
    solver.activity[i] = pos_weight[i] + neg_weight[i]
  }
  for v in 0..<var_count {
    solver.vsids.insert(v)
  }
  solver.origin_clauses = solver.clauses.length()
  solver.restart_limit = solver.restart_base()
  solver.rephase_limit = solver.rephase_base()
  solver.reduce_limit = @cmp.maximum(
    REDUCE_LIMIT_MIN,
    @cmp.minimum(REDUCE_LIMIT_MAX, solver.origin_clauses / REDUCE_LIMIT_DIV),
  )
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
  self.clauses.push({ lbd: 0, used: 0, lits })
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

///|
/// Build a summary of solver metrics.
fn Solver::build_metrics(self : Solver) -> SolverMetrics {
  let assignments = self.assignments_total
  let decisions = self.decisions_total
  let propagations = assignments - decisions
  SolverMetrics::{
    decisions,
    decision_level_sum: self.decision_level_sum,
    decision_level_max: self.decision_level_max,
    decision_phase_saved: self.decision_phase_saved_total,
    decision_phase_best: self.decision_phase_best_total,
    decision_phase_default: self.decision_phase_default_total,
    decision_random: self.decision_random_total,
    propagations,
    conflicts: self.conflicts_total,
    conflicts_init: self.conflicts_init,
    conflicts_original: self.conflicts_original,
    conflicts_learned: self.conflicts_learned,
    analyze_calls: self.analyze_calls,
    restarts: self.restarts_total,
    restart_ready: self.restart_ready_total,
    restart_phase_local_best: self.restart_phase_local_best_total,
    restart_phase_invert_best: self.restart_phase_invert_best_total,
    restart_phase_random: self.restart_phase_random_total,
    restart_phase_keep: self.restart_phase_keep_total,
    rephases: self.rephases_total,
    rephase_phase_local_best: self.rephase_phase_local_best_total,
    rephase_phase_invert_best: self.rephase_phase_invert_best_total,
    rephase_phase_random: self.rephase_phase_random_total,
    rephase_phase_default: self.rephase_phase_default_total,
    reductions: self.reductions,
    reductions_removed: self.reductions_removed_total,
    learned_clauses: self.learned_clauses_total,
    learned_unit_clauses: self.learned_unit_total,
    learned_binary_clauses: self.learned_binary_total,
    learned_ternary_clauses: self.learned_ternary_total,
    learned_clause_len_sum: self.learned_len_sum,
    learned_clause_len_min: self.learned_len_min,
    learned_clause_len_max: self.learned_len_max,
    learned_lbd_sum: self.learned_lbd_sum,
    learned_lbd_min: self.learned_lbd_min,
    learned_lbd_max: self.learned_lbd_max,
    assignments,
    assignments_level0: self.assignments_level0_total,
    assignments_nonzero: self.assignments_nonzero_total,
    max_trail: self.max_trail,
    backtrack_calls: self.backtrack_calls_total,
    backtrack_lits_removed: self.backtrack_lits_removed_total,
    backtrack_lits_removed_max: self.backtrack_lits_removed_max,
    propagate_calls: self.propagate_calls,
    watcher_scans: self.watcher_scans,
    blocker_hits: self.blocker_hits,
    watch_replacements: self.watch_replacements,
    vsids_bumps: self.vsids_bumps_total,
    vsids_bumps_strong: self.vsids_bumps_strong_total,
    vsids_rescales: self.vsids_rescales_total,
    origin_clauses: self.origin_clauses,
    final_clauses: self.clauses.length(),
  }
}
