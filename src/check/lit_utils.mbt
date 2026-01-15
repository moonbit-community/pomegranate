///|
/// Encode a literal into a dense id (var * 2 + sign).
fn lit_id(lit : Lit) -> Int {
  let base = lit.index().to_int() * 2
  if lit.is_negative() {
    base + 1
  } else {
    base
  }
}

///|
/// Flip the sign bit of a literal id.
fn negate_id(id : Int) -> Int {
  id ^ 1
}

///|
/// Construct the opposite literal.
fn negate_lit(lit : Lit) -> Lit {
  Lit::from_var(lit.to_var(), lit.is_negative()) catch {
    _ => panic()
  }
}

///|
/// Build a literal from a variable index and polarity.
fn lit_from_index(index : Int, polarity : Bool) -> Lit {
  let variable = Var::from_index(index.to_uint64()) catch { _ => panic() }
  Lit::from_var(variable, polarity) catch {
    _ => panic()
  }
}
