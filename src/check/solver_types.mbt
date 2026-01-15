///|
/// CDCL (Conflict-Driven Clause Learning) SAT solver result.
pub enum SolveResult {
  Sat(model~ : Array[Bool])
  Unsat
} derive(Show, ToJson)

///|
/// Internal clause representation with LBD metadata.
priv struct Clause {
  mut lbd : Int
  lits : MutArrayView[Lit]
}

///|
/// Two-watched literal entry with a blocker for fast satisfaction checks.
priv struct Watcher {
  mut clause_idx : Int
  blocker : Lit
}

///|
/// Conflict analysis output.
priv enum AnalyzeResult {
  Unsat
  Learned(learned~ : Array[Lit], backtrack_level~ : Int, lbd~ : Int)
}
