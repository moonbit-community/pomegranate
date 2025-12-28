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
pub fn Var::from_dimacs(number : UInt) -> Var raise FormulaError {
  Var::from_index(number - 1)
}

///|
/// Creates a variable from a 0-based index.
///
/// The index may not represent a variable past `Var::max_var()`.
pub fn Var::from_index(index : UInt) -> Var raise FormulaError {
  guard index < @uint.max_value >> 4 else { raise IndexTooLarge(index~) }
  Var::{ index, }
}

///|
pub fn Var::max_count() -> UInt {
  (@uint.max_value >> 4) + 1
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
  guard index <= (@uint.max_value >> 3) + 1 else { raise IndexTooLarge(index~) }
  Lit::{ code: (index << 1) | (if polarity { 1 } else { 0 }) }
}

///|
/// Creates a literal from an integer.
///
/// The absolute value is used as 1-based index, the sign of
/// the integer is used as sign of the literal.
pub fn Lit::from_dimacs(number : UInt) -> Lit raise FormulaError {
  Lit::from_litidx(Var::from_dimacs(number).index, number > 0)
}

///|
pub fn Lit::index(self : Lit) -> UInt {
  self.code >> 1
}
