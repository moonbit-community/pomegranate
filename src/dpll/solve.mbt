///|
const ASSIGN_UNSET : Int = -1

///|
const ASSIGN_FALSE : Int = 0

///|
const ASSIGN_TRUE : Int = 1

///|
fn lit_value(assignment : Array[Int], lit : Lit) -> Int {
  let idx = lit.index().to_int()
  let current = assignment[idx]
  if current == ASSIGN_UNSET {
    ASSIGN_UNSET
  } else {
    let mut is_true = current == ASSIGN_TRUE
    if lit.is_negative() {
      is_true = not(is_true)
    }
    if is_true {
      ASSIGN_TRUE
    } else {
      ASSIGN_FALSE
    }
  }
}

///|
fn assign_literal(assignment : Array[Int], lit : Lit) -> Bool {
  let idx = lit.index().to_int()
  let want = if lit.is_negative() { ASSIGN_FALSE } else { ASSIGN_TRUE }
  let current = assignment[idx]
  if current == ASSIGN_UNSET {
    assignment[idx] = want
    true
  } else {
    current == want
  }
}

///|
fn scan_clause(
  assignment : Array[Int],
  clause : MutArrayView[Lit],
) -> (Bool, Int, Lit?) {
  let mut satisfied = false
  let mut unassigned = 0
  let mut last_unassigned : Lit? = None
  for lit in clause {
    let value = lit_value(assignment, lit)
    if value == ASSIGN_TRUE {
      satisfied = true
      break
    } else if value == ASSIGN_UNSET {
      unassigned += 1
      last_unassigned = Some(lit)
    }
  }
  (satisfied, unassigned, last_unassigned)
}

///|
fn assign_pure_literals(formula : CnfFormula, assignment : Array[Int]) -> Bool {
  let var_count = assignment.length()
  let pos = Array::make(var_count, false)
  let neg = Array::make(var_count, false)
  let clause_count = formula.clause_count()
  for i in 0..<clause_count {
    let clause = formula.clause(i)
    let mut satisfied = false
    for lit in clause {
      if lit_value(assignment, lit) == ASSIGN_TRUE {
        satisfied = true
        break
      }
    }
    if satisfied {
      continue
    }
    for lit in clause {
      if lit_value(assignment, lit) == ASSIGN_UNSET {
        let idx = lit.index().to_int()
        if lit.is_negative() {
          neg[idx] = true
        } else {
          pos[idx] = true
        }
      }
    }
  }
  let mut assigned_any = false
  for idx in 0..<var_count {
    if assignment[idx] == ASSIGN_UNSET {
      if pos[idx] && not(neg[idx]) {
        assignment[idx] = ASSIGN_TRUE
        assigned_any = true
      } else if neg[idx] && not(pos[idx]) {
        assignment[idx] = ASSIGN_FALSE
        assigned_any = true
      }
    }
  }
  assigned_any
}

///|
fn propagate(formula : CnfFormula, assignment : Array[Int]) -> Bool {
  let mut changed = true
  let clause_count = formula.clause_count()
  while changed {
    changed = false
    for i in 0..<clause_count {
      let clause = formula.clause(i)
      let (satisfied, unassigned, last_unassigned) = scan_clause(
        assignment, clause,
      )
      if satisfied {
        continue
      }
      if unassigned == 0 {
        return true
      }
      if unassigned == 1 {
        match last_unassigned {
          Some(lit) => {
            if not(assign_literal(assignment, lit)) {
              return true
            }
            changed = true
          }
          None => return true
        }
      }
    }
    if assign_pure_literals(formula, assignment) {
      changed = true
    }
  }
  false
}

///|
fn formula_satisfied(formula : CnfFormula, assignment : Array[Int]) -> Bool {
  let clause_count = formula.clause_count()
  for i in 0..<clause_count {
    let clause = formula.clause(i)
    let mut satisfied = false
    for lit in clause {
      if lit_value(assignment, lit) == ASSIGN_TRUE {
        satisfied = true
        break
      }
    }
    if not(satisfied) {
      return false
    }
  }
  true
}

///|
fn pick_unassigned(assignment : Array[Int]) -> Int? {
  let count = assignment.length()
  for i in 0..<count {
    if assignment[i] == ASSIGN_UNSET {
      return Some(i)
    }
  }
  None
}

///|
fn build_model(assignment : Array[Int]) -> Model {
  let model = Model::new(assignment.length())
  for i in 0..<assignment.length() {
    if assignment[i] == ASSIGN_TRUE {
      model.set(i, true)
    }
  }
  model
}

///|
fn dpll(formula : CnfFormula, assignment : Array[Int]) -> Array[Int]? {
  if propagate(formula, assignment) {
    return None
  }
  let satisfied = formula_satisfied(formula, assignment)
  if satisfied {
    return Some(assignment)
  }
  match pick_unassigned(assignment) {
    None => None
    Some(var_idx) => {
      let try_true = assignment.copy()
      try_true[var_idx] = ASSIGN_TRUE
      match dpll(formula, try_true) {
        Some(result) => Some(result)
        None => {
          let try_false = assignment.copy()
          try_false[var_idx] = ASSIGN_FALSE
          dpll(formula, try_false)
        }
      }
    }
  }
}

///|
/// Solve a CNF formula using classic DPLL with unit propagation and
/// pure-literal elimination.
pub fn solve(formula : CnfFormula) -> Model? {
  let var_count = formula.var_count().to_int()
  let assignment = Array::make(var_count, ASSIGN_UNSET)
  match dpll(formula, assignment) {
    Some(result) => Some(build_model(result))
    None => None
  }
}
