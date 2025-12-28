///|
/// Possible errors while parsing a DIMACS CNF formula.
pub suberror DIMACSParseError {
  UnexpectedInputCharacter(line~ : Int, unexpected~ : Char)
  LiteralTooLarge(line~ : Int, index~ : UInt, final_digit~ : UInt)
  InvalidHeader(line~ : Int, header~ : StringView)
  UnterminatedClause(line~ : Int)
  VarCount(var_count~ : UInt, header_var_count~ : UInt)
  ClauseCount(clause_count~ : UInt, header_clause_count~ : UInt)
  PreviousError
}

///|
pub impl Show for DIMACSParseError with output(self, logger) {
  match self {
    UnterminatedClause(line~) =>
      logger.write_string("line \{line}: Unterminated clause")
    InvalidHeader(line~, header~) =>
      logger.write_string("line \{line}: Invalid header syntax: \{header}")
    LiteralTooLarge(line~, index~, final_digit~) =>
      logger.write_string(
        "line \{line}: Literal index is too large: \{index}\{final_digit}...",
      )
    UnexpectedInputCharacter(line~, unexpected~) =>
      logger.write_string(
        "line \{line}: Unexpected character in DIMACS CNF input: \{unexpected}",
      )
    VarCount(var_count~, header_var_count~) =>
      logger.write_string(
        "Formula has \{var_count} variables while the header specifies \{header_var_count} variables",
      )
    ClauseCount(clause_count~, header_clause_count~) =>
      logger.write_string(
        "Formula has \{clause_count} clauses while the header specifies \{header_clause_count} clauses",
      )
    PreviousError =>
      logger.write_string("Parser invoked after a previous error")
  }
}
