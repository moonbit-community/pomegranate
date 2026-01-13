///|
test "odd whitespace" {
  let cnf = DimacsParser::parse(
    b"p  cnf  4   3  \n  1  \n 2  3\n0 -4 0 2\nccomment  \n\n0\n\n",
  )

}
