///|
test "odd whitespace" {
  let cnf = DimacsParser::parse(
    b"p  cnf  4   3  \n  1  \n 2  3\n0 -4 0 2\nccomment  \n\n0\n\n",
  )
  @json.inspect(cnf, content=[["1", "2", "3"], ["-4"], ["2"]])
}

///|
test "invalid headers" {
  assert_true((try? DimacsParser::parse(b"pcnf 1 3")) is Err(InvalidHeader(_)))
  assert_true(
    (try? DimacsParser::parse(b"p notcnf 1 3")) is Err(InvalidHeader(_)),
  )
  assert_true((try? DimacsParser::parse(b"p cnf 1")) is Err(InvalidHeader(_)))
  assert_true(
    (try? DimacsParser::parse(b"p cnf 1 2 3")) is Err(InvalidHeader(_)),
  )
  assert_true(
    (try? DimacsParser::parse(b"p cnf foo bar")) is Err(InvalidHeader(_)),
  )
  assert_true(
    (try? DimacsParser::parse(b"p cnf -3 -6")) is Err(InvalidHeader(_)),
  )
  assert_true(
    (try? DimacsParser::parse(b"p cnf 4 18446744073709551616"))
    is Err(InvalidHeader(_)),
  )
  assert_true(
    (try? DimacsParser::parse(b"p cnf 1 2\np cnf 1 2\n"))
    is Err(UnexpectedInputCharacter(unexpected='p', ..)),
  )
}
