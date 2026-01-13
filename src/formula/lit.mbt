///|
/// A boolean variable.
///
/// A boolean value is represented by an index. Internally these are 0-based, i.e. the first
/// variable has the index 0. For user IO a 1-based index is used, to allow denoting negated
/// variables using negative integers. This convention is also used in the DIMACS CNF format.
///
/// Creating a variable with an index larger than `Var::max_var().index()` is unsupported. This
/// might panic or be interpreted as a different variable.
#valtype
pub struct Var {
  index : UInt
}

///|
/// Creates a variable from a 1-based index as used in the DIMCAS CNF encoding.
///
/// The parameter must be positive
pub fn Var::from_dimacs(number : Int64) -> Var raise FormulaError {
  Var::from_index((number - 1).reinterpret_as_uint64())
}

///|
pub fn Var::to_dimacs(self : Var) -> Int64 {
  (self.index + 1).to_int64()
}

///|
/// Creates a variable from a 0-based index.
///
/// The index may not represent a variable past `Var::max_var()`.
pub fn Var::from_index(index : UInt64) -> Var raise FormulaError {
  guard index < @uint.max_value.to_uint64() >> 4 else {
    raise IndexTooLarge(index~)
  }
  Var::{ index: index.to_uint() }
}

///|
pub fn Var::max_count() -> UInt64 {
  (@uint.max_value >> 4).to_uint64() + 1
}

///|
/// A boolean literal.
///
/// A literal is a variable or the negation of a variable.
///
/// Conceptually a literal consists of a `Var` and a `bool` indicating whether the literal
/// represents the variable (positive literal) or its negation (negative literal).
///
/// Internally a literal is represented as an integer that is two times the index of its variable
/// when it is positive or one more when it is negative. This integer is called the `code` of the
/// literal.
///
/// The restriction on the range of allowed indices for `Var` also applies to `Lit`.
pub struct Lit {
  code : UInt
}

///|
pub fn Lit::from_litidx(
  index : UInt,
  polarity : Bool,
) -> Lit raise FormulaError {
  guard index <= (@uint.max_value >> 3) + 1 else {
    raise IndexTooLarge(index=index.to_uint64())
  }
  Lit::{ code: (index << 1) | (if polarity { 0 } else { 1 }) }
}

///|
pub fn Lit::from_var(variable : Var, polarity : Bool) -> Lit raise FormulaError {
  Lit::from_litidx(variable.index, polarity)
}

///|
/// Creates a literal from an integer.
///
/// The absolute value is used as 1-based index, the sign of
/// the integer is used as sign of the literal.
pub fn Lit::from_dimacs(number : Int64) -> Lit raise FormulaError {
  Lit::from_var(Var::from_dimacs(number.abs()), number > 0)
}

///|
pub fn Lit::index(self : Lit) -> UInt64 {
  (self.code >> 1).to_uint64()
}

///|
pub fn Lit::to_var(self : Lit) -> Var {
  Var::{ index: self.code >> 1 }
}

///|
pub fn Lit::is_negative(self : Lit) -> Bool {
  (self.code & 1) != 0
}

///|
pub fn Lit::to_dimacs(self : Lit) -> Int64 {
  let mut number = self.to_var().to_dimacs()
  if self.is_negative() {
    number = number.neg()
  }
  return number
}

///|
pub impl ToJson for Lit with to_json(self) {
  self.to_dimacs().to_json()
}

///|
pub impl Show for Lit with output(self, logger) {
  logger.write_object(self.to_dimacs())
}

///|
test "roundtrip" {
  inspect(Lit::from_dimacs(-4), content="-4")
  inspect(Lit::from_dimacs(4), content="4")
}
