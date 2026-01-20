///|
/// Bounded Variable Elimination (BVE) preprocessing.
///
/// Removes variables by resolution when the number of resolvents is bounded,
/// and records eliminated clauses for model reconstruction.
let bve_max_pairs : Int = 256

///|
/// Maximum number of resolvents allowed when eliminating a variable.
let bve_max_resolvents : Int = 64

///|
/// Maximum total occurrences (pos + neg) allowed for a variable.
let bve_max_occ : Int = 32

///|
/// Maximum number of passes over variables.
let bve_max_passes : Int = 1

///|
/// Skip preprocessing on very large formulas.
let bve_max_vars : Int = 50000

///|
let bve_max_clauses : Int = 200000

///|
/// One elimination step: variable id and the clauses removed for it.
priv struct ElimStep {
  var_id : Int
  clauses : Array[Array[Lit]]
}

///|
/// Preprocessing result with formula, active variables, and eliminations.
priv struct PreprocessResult {
  formula : CnfFormula
  active_vars : FixedArray[Bool]
  eliminations : Array[ElimStep]
}

///|
/// Compact an occurrence list by removing indices of dead clauses.
fn compact_occ(occ : Array[Int], alive : Array[Bool]) -> Array[Int] {
  let mut j = 0
  let len = occ.length()
  for i in 0..<len {
    let idx = occ[i]
    if idx < alive.length() && alive[idx] {
      occ[j] = idx
      j += 1
    }
  }
  occ.truncate(j)
  occ
}

///|
/// Normalize a clause view by removing duplicates and skipping tautologies.
fn normalize_clause(
  view : MutArrayView[Lit],
  mark_time : FixedArray[Int],
  mark_sign : FixedArray[Int],
  stamp : Int,
) -> (Array[Lit]?, Int) {
  let stamp = stamp + 1
  let clause : Array[Lit] = []
  for lit in view {
    let v = lit.index().to_int()
    let sign = if lit.is_negative() { -1 } else { 1 }
    if mark_time[v] != stamp {
      mark_time[v] = stamp
      mark_sign[v] = sign
      clause.push(lit)
    } else if mark_sign[v] != sign {
      return (None, stamp)
    }
  }
  (Some(clause), stamp)
}

///|
/// Build a resolvent for a variable, dropping tautologies and duplicates.
fn build_resolvent(
  pos_clause : Array[Lit],
  neg_clause : Array[Lit],
  var_id : Int,
  mark_time : FixedArray[Int],
  mark_sign : FixedArray[Int],
  stamp : Int,
) -> (Array[Lit]?, Int) {
  let stamp = stamp + 1
  let resolvent : Array[Lit] = []
  for lit in pos_clause {
    let v = lit.index().to_int()
    if v == var_id {
      continue
    }
    let sign = if lit.is_negative() { -1 } else { 1 }
    if mark_time[v] != stamp {
      mark_time[v] = stamp
      mark_sign[v] = sign
      resolvent.push(lit)
    } else if mark_sign[v] != sign {
      return (None, stamp)
    }
  }
  for lit in neg_clause {
    let v = lit.index().to_int()
    if v == var_id {
      continue
    }
    let sign = if lit.is_negative() { -1 } else { 1 }
    if mark_time[v] != stamp {
      mark_time[v] = stamp
      mark_sign[v] = sign
      resolvent.push(lit)
    } else if mark_sign[v] != sign {
      return (None, stamp)
    }
  }
  (Some(resolvent), stamp)
}

///|
/// Apply bounded variable elimination to a formula.
fn preprocess_bve(formula : CnfFormula) -> PreprocessResult {
  let var_count = formula.var_count().to_int()
  let clause_count = formula.clause_count()
  if var_count > bve_max_vars || clause_count > bve_max_clauses {
    let active_vars = FixedArray::make(var_count, false)
    for i in 0..<clause_count {
      for lit in formula.clause(i) {
        active_vars[lit.index().to_int()] = true
      }
    }
    return { formula, active_vars, eliminations: [] }
  }
  let mark_time = FixedArray::make(var_count, 0)
  let mark_sign = FixedArray::make(var_count, 0)
  let mut stamp = 0
  let clauses : Array[Array[Lit]] = []
  let alive : Array[Bool] = []
  for i in 0..<clause_count {
    let view = formula.clause(i)
    let (maybe_clause, next_stamp) = normalize_clause(
      view, mark_time, mark_sign, stamp,
    )
    stamp = next_stamp
    match maybe_clause {
      None => continue
      Some(clause) => {
        clauses.push(clause)
        alive.push(true)
      }
    }
  }
  let occ_pos : Array[Array[Int]] = []
  let occ_neg : Array[Array[Int]] = []
  for _ in 0..<var_count {
    occ_pos.push([])
    occ_neg.push([])
  }
  for i, clause in clauses {
    for lit in clause {
      let v = lit.index().to_int()
      if lit.is_negative() {
        occ_neg[v].push(i)
      } else {
        occ_pos[v].push(i)
      }
    }
  }
  let eliminated = FixedArray::make(var_count, false)
  let eliminations : Array[ElimStep] = []
  let mut pass = 0
  let mut changed = true
  while changed && pass < bve_max_passes {
    changed = false
    pass += 1
    for v in 0..<var_count {
      if eliminated[v] {
        continue
      }
      let pos_list = compact_occ(occ_pos[v], alive)
      let neg_list = compact_occ(occ_neg[v], alive)
      let pos_len = pos_list.length()
      let neg_len = neg_list.length()
      if pos_len == 0 && neg_len == 0 {
        eliminated[v] = true
        continue
      }
      if pos_len + neg_len > bve_max_occ {
        continue
      }
      let mut can_elim = false
      let resolvents : Array[Array[Lit]] = []
      if pos_len == 0 || neg_len == 0 {
        can_elim = true
      } else if pos_len * neg_len <= bve_max_pairs {
        let mut ok = true
        for pi in 0..<pos_len {
          let pos_clause = clauses[pos_list[pi]]
          for ni in 0..<neg_len {
            let neg_clause = clauses[neg_list[ni]]
            let (res_opt, next_stamp) = build_resolvent(
              pos_clause, neg_clause, v, mark_time, mark_sign, stamp,
            )
            stamp = next_stamp
            match res_opt {
              None => ()
              Some(resolvent) => {
                resolvents.push(resolvent)
                if resolvents.length() > bve_max_resolvents {
                  ok = false
                  break
                }
              }
            }
          }
          if not(ok) {
            break
          }
        }
        if ok && resolvents.length() <= pos_len + neg_len {
          can_elim = true
        }
      }
      if not(can_elim) {
        continue
      }
      let removed_clauses : Array[Array[Lit]] = []
      for idx in pos_list {
        if alive[idx] {
          alive[idx] = false
          removed_clauses.push(clauses[idx])
        }
      }
      for idx in neg_list {
        if alive[idx] {
          alive[idx] = false
          removed_clauses.push(clauses[idx])
        }
      }
      for resolvent in resolvents {
        let new_idx = clauses.length()
        clauses.push(resolvent)
        alive.push(true)
        let new_clause = clauses[new_idx]
        for lit in new_clause {
          let v2 = lit.index().to_int()
          if lit.is_negative() {
            occ_neg[v2].push(new_idx)
          } else {
            occ_pos[v2].push(new_idx)
          }
        }
      }
      eliminations.push({ var_id: v, clauses: removed_clauses })
      eliminated[v] = true
      changed = true
    }
  }
  let active_vars = FixedArray::make(var_count, false)
  let result = CnfFormula::default()
  for i in 0..<clauses.length() {
    if alive[i] {
      let clause = clauses[i]
      for lit in clause {
        active_vars[lit.index().to_int()] = true
      }
      result.add_clause(clause[:])
    }
  }
  result.set_var_count(formula.var_count())
  { formula: result, active_vars, eliminations }
}

///|
/// Determine if a clause forces a variable value under the current model.
fn clause_required_value(
  clause : Array[Lit],
  var_id : Int,
  model : Model,
) -> Int {
  let mut has_pos = false
  let mut has_neg = false
  for lit in clause {
    let v = lit.index().to_int()
    if v == var_id {
      if lit.is_negative() {
        has_neg = true
      } else {
        has_pos = true
      }
      continue
    }
    let mut value = model.get(v)
    if lit.is_negative() {
      value = not(value)
    }
    if value {
      return 0
    }
  }
  if has_pos && has_neg {
    0
  } else if has_pos {
    1
  } else if has_neg {
    -1
  } else {
    0
  }
}

///|
/// Reconstruct eliminated variables in reverse order.
fn extend_model(model : Model, eliminations : Array[ElimStep]) -> Model {
  let full = model
  let mut idx = eliminations.length()
  while idx > 0 {
    idx -= 1
    let step = eliminations[idx]
    let var_id = step.var_id
    let mut forced = 0
    for clause in step.clauses {
      let req = clause_required_value(clause, var_id, full)
      if req != 0 {
        if forced == 0 {
          forced = req
        } else if forced != req {
          panic()
        }
      }
    }
    if forced != 0 {
      full.set(var_id, forced == 1)
    }
  }
  full
}
