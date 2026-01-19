///|
/// CDCL (Conflict-Driven Clause Learning) SAT solver result.
///
/// `Sat` returns a total model bitmap (indexed by variable id).
/// `Unsat` indicates a level-0 conflict was proven.
pub enum SolveResult {
  Sat(model~ : Model)
  Unsat
} derive(Show, ToJson)

///|
/// Internal clause representation with LBD metadata.
///
/// `lits` is a mutable view into a clause array owned by the solver.
/// `lbd` is the Literal Block Distance for learned clauses (0 for originals).
priv struct Clause {
  mut lbd : Int
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
