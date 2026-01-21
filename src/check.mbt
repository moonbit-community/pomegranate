///|
pub fn check_sat(path : String, print_metrics? : Bool = false) -> Unit raise {
  let source = @fs.read_file_to_bytes(path)
  let cnf = @dimacs.DimacsParser::parse(source)
  let solve_result = @solver.solve(cnf)
  guard solve_result.model is Some(model) else {
    fail("failed to solve \{path}, this is a bug")
  }
  guard cnf.eval(model) else {
    fail("find model but \{path} evaluate to false under it, this is a bug")
  }
  if print_metrics {
    println("-- \{path}")
    println(solve_result.metrics.to_json().stringify(indent=2))
  }
}

///|
pub fn check_unsat(path : String, print_metrics? : Bool = false) -> Unit raise {
  let source = @fs.read_file_to_bytes(path)
  let cnf = @dimacs.DimacsParser::parse(source)
  let solve_result = @solver.solve(cnf)
  guard solve_result.model is None else {
    fail("\{path} solved but this is a unsat testcase")
  }
  if print_metrics {
    println("-- \{path}")
    println(solve_result.metrics.to_json().stringify(indent=2))
  }
}
