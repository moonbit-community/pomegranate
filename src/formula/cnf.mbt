///|
pub struct CnfFormula {
  mut var_count : UInt64
  literals : Array[Lit]
  clause_ranges : Array[(Int, Int)]
}

///|
pub impl Default for CnfFormula with default() {
  CnfFormula::{ var_count: 0, literals: [], clause_ranges: [] }
}

///|
pub impl ToJson for CnfFormula with to_json(self) {
  let arr = []
  for range in self.clause_ranges {
    arr.push(self.literals[range.0:range.1])
  }
  arr.to_json()
}

///|
pub fn CnfFormula::add_clause(
  self : CnfFormula,
  clause : ArrayView[Lit],
) -> Unit {
  let begin = self.literals.length()
  self.literals.append(clause)
  let end = self.literals.length()
  for lit in self.literals[begin:end] {
    // var_count tracks number of variables, so it is max index + 1.
    self.var_count = @cmp.maximum(lit.index() + 1, self.var_count)
  }
  self.clause_ranges.push((begin, end))
}

///|
pub fn CnfFormula::new_var(self : CnfFormula) -> Var raise FormulaError {
  let variable = Var::from_index(self.var_count)
  self.var_count += 1
  variable
}

///|
/// Increase the number of variables in the formula.
///
/// If the parameter is less than the current variable count do nothing.
pub fn CnfFormula::set_var_count(self : CnfFormula, count : UInt64) -> Unit {
  self.var_count = @cmp.maximum(self.var_count, count)
}
