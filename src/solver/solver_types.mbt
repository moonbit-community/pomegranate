///|
/// Summary metrics for a solver run.
///
/// Most counters are totals across the entire `solve` call (they are not reset
/// by restarts or rephases); `reductions` records per-reduction clause counts.
///
/// - `decisions`: number of decision assignments (each time a new decision
///   literal is chosen and successfully assigned).
/// - `decision_level_sum`: sum of decision levels at each decision, useful for
///   computing average search depth.
/// - `decision_level_max`: maximum decision level reached.
/// - `decision_phase_saved`: decisions that used a saved phase.
/// - `decision_phase_best`: decisions that used the local-best phase snapshot.
/// - `decision_phase_default`: decisions that fell back to default polarity
///   (derived from literal occurrence counts).
/// - `decision_random`: decisions that used random/perturbed VSIDS selection.
/// - `propagations`: number of implied assignments; computed as
///   `assignments - decisions`, so it includes level-0 unit propagation and
///   implications from both original and learned clauses.
/// - `assignments_level0`: assignments made at decision level 0.
/// - `assignments_nonzero`: assignments made at decision levels > 0.
/// - `propagate_calls`: number of BCP invocations.
/// - `watcher_scans`: number of watched-list entries scanned.
/// - `blocker_hits`: number of times a blocker literal short-circuited a scan.
/// - `watch_replacements`: number of times a new watched literal was found.
/// - `conflicts`: total conflicts detected, including early conflicts during
///   CNF loading and every conflict in the main CDCL loop.
/// - `conflicts_init`: conflicts detected during CNF loading or initial
///   level-0 propagation.
/// - `conflicts_original`: conflicts whose clause is from the original CNF.
/// - `conflicts_learned`: conflicts whose clause is learned.
/// - `analyze_calls`: number of conflict analyses performed.
/// - `restarts`: number of restart operations executed.
/// - `restart_ready`: number of times the LBD restart condition fired.
/// - `restart_phase_local_best`: restarts that copied the local-best phase.
/// - `restart_phase_invert_best`: restarts that inverted the local-best phase.
/// - `restart_phase_random`: restarts that randomized phases.
/// - `restart_phase_keep`: restarts that kept the current saved phase.
/// - `rephases`: number of phase re-initializations executed.
/// - `rephase_phase_local_best`: rephases that copied the local-best phase.
/// - `rephase_phase_invert_best`: rephases that inverted the local-best phase.
/// - `rephase_phase_random`: rephases that randomized phases.
/// - `rephase_phase_default`: rephases that reset to default polarity.
/// - `reductions`: per-reduction learned-clause counts in the database,
///   as `(before, after)` pairs.
/// - `reductions_removed`: total learned clauses removed by reductions.
/// - `learned_clauses`: total learned clauses produced by conflict analysis
///   (including unit learned clauses), regardless of whether they are later
///   deleted by reductions.
/// - `learned_unit_clauses`: learned clauses of length 1.
/// - `learned_binary_clauses`: learned clauses of length 2.
/// - `learned_ternary_clauses`: learned clauses of length 3.
/// - `learned_clause_len_sum`: sum of learned clause lengths.
/// - `learned_clause_len_min`: minimum learned clause length (0 if none).
/// - `learned_clause_len_max`: maximum learned clause length.
/// - `learned_lbd_sum`: sum of learned clause LBD values.
/// - `learned_lbd_min`: minimum learned clause LBD (0 if none).
/// - `learned_lbd_max`: maximum learned clause LBD.
/// - `assignments`: total successful assignments pushed onto the trail
///   (decisions + propagations).
/// - `max_trail`: maximum trail length observed (peak number of assigned
///   literals/variables at any point).
/// - `backtrack_calls`: number of non-trivial backtracks performed.
/// - `backtrack_lits_removed`: total literals popped by backtracking.
/// - `backtrack_lits_removed_max`: maximum literals removed in a single
///   backtrack.
/// - `vsids_bumps`: number of VSIDS activity bumps.
/// - `vsids_bumps_strong`: number of strong (mult=1.0) VSIDS bumps.
/// - `vsids_rescales`: number of VSIDS activity rescale events.
/// - `origin_clauses`: count of original (non-learned) clauses stored in the
///   clause database after CNF loading; reductions never remove these.
/// - `final_clauses`: number of clauses remaining in the database at the end
///   of the run (original + retained learned).
pub struct SolverMetrics {
  decisions : Int
  decision_level_sum : Int
  decision_level_max : Int
  decision_phase_saved : Int
  decision_phase_best : Int
  decision_phase_default : Int
  decision_random : Int
  propagations : Int
  conflicts : Int
  conflicts_init : Int
  conflicts_original : Int
  conflicts_learned : Int
  analyze_calls : Int
  restarts : Int
  restart_ready : Int
  restart_phase_local_best : Int
  restart_phase_invert_best : Int
  restart_phase_random : Int
  restart_phase_keep : Int
  rephases : Int
  rephase_phase_local_best : Int
  rephase_phase_invert_best : Int
  rephase_phase_random : Int
  rephase_phase_default : Int
  reductions : Array[(Int, Int)]
  reductions_removed : Int
  learned_clauses : Int
  learned_unit_clauses : Int
  learned_binary_clauses : Int
  learned_ternary_clauses : Int
  learned_clause_len_sum : Int
  learned_clause_len_min : Int
  learned_clause_len_max : Int
  learned_lbd_sum : Int
  learned_lbd_min : Int
  learned_lbd_max : Int
  assignments : Int
  assignments_level0 : Int
  assignments_nonzero : Int
  max_trail : Int
  backtrack_calls : Int
  backtrack_lits_removed : Int
  backtrack_lits_removed_max : Int
  propagate_calls : Int
  watcher_scans : Int
  blocker_hits : Int
  watch_replacements : Int
  vsids_bumps : Int
  vsids_bumps_strong : Int
  vsids_rescales : Int
  origin_clauses : Int
  final_clauses : Int
} derive(Show, ToJson)

///|
pub struct SolveResult {
  metrics : SolverMetrics
  model : Model?
} derive(Show, ToJson)

///|
/// Internal clause representation with LBD metadata.
///
/// `lits` is a mutable view into a clause array owned by the solver.
/// `lbd` is the Literal Block Distance for learned clauses (0 for originals).
/// `used` tracks how often a learned clause is used as a reason.
priv struct Clause {
  mut lbd : Int
  mut used : Int
  lits : MutArrayView[Lit]
}

///|
/// Two-watched literal entry with a blocker for fast satisfaction checks.
///
/// `blocker` is another watched literal used as a quick satisfied test
/// (if blocker is true, the clause is already satisfied).
priv struct Watcher {
  mut clause_idx : Int
  blocker : Lit
}

///|
/// Conflict analysis output.
///
/// `Learned` holds the learned clause, the backtrack level, and the LBD score.
priv enum AnalyzeResult {
  Unsat
  Learned(learned~ : Array[Lit], backtrack_level~ : Int, lbd~ : Int)
}
