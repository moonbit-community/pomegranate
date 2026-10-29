///|
test "odd whitespace" {
  let cnf = @dimacs.DimacsParser::parse(
    b"p  cnf  4   3  \n  1  \n 2  3\n0 -4 0 2\nccomment  \n\n0\n\n",
  )
  json_inspect(cnf, content=[["1", "2", "3"], ["-4"], ["2"]])
}

///|
test "invalid headers" {
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"pcnf 1 3")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p notcnf 1 3")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 1")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 1 2 3")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf foo bar")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf -3 -6")) catch { e => Err(e) })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 4 18446744073709551616")) catch {
      e => Err(e)
    })
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 1 2\np cnf 1 2\n")) catch {
      e => Err(e)
    })
    is Err(UnexpectedInputCharacter(unexpected='p', ..)),
  )
}

///|
test "invalid header data" {
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 1 1\n 2 0")) catch { e => Err(e) })
    is Err(VarCount(var_count=2, header_var_count=1)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 10 1\n 1 0 0")) catch {
      e => Err(e)
    })
    is Err(ClauseCount(clause_count=2, header_clause_count=1)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"p cnf 10 4\n 1 0")) catch { e => Err(e) })
    is Err(ClauseCount(clause_count=1, header_clause_count=4)),
  )
}

///|
test "syntax errors" {
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2 ?foo")) catch { e => Err(e) })
    is Err(UnexpectedInputCharacter(unexpected='?', ..)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2 - 3 0")) catch { e => Err(e) })
    is Err(UnexpectedInputCharacter(unexpected=' ', ..)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2 -\n3 0")) catch { e => Err(e) })
    is Err(UnexpectedInputCharacter(unexpected='\n', ..)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2 --3 0")) catch { e => Err(e) })
    is Err(UnexpectedInputCharacter(unexpected='-', ..)),
  )
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2-3 0")) catch { e => Err(e) })
    is Err(UnexpectedInputCharacter(unexpected='-', ..)),
  )
}

///|
test "unterminated_clause" {
  assert_true(
    (Ok(@dimacs.DimacsParser::parse(b"1 2 3")) catch { e => Err(e) })
    is Err(UnterminatedClause(..)),
  )
}
