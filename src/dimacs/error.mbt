///|
/// Possible errors while parsing a DIMACS CNF formula.
pub suberror DIMACSParseError {
  UnexpectedInputCharacter(line~ : Int, unexpected~ : Char)
  LiteralTooLarge(line~ : Int, index~ : UInt64, final_digit~ : UInt64)
  InvalidHeader(line~ : Int, header~ : StringView)
  UnterminatedClause(line~ : Int)
  VarCount(var_count~ : UInt64, header_var_count~ : UInt64)
  ClauseCount(clause_count~ : UInt64, header_clause_count~ : UInt64)
  FormulaError(FormulaError)
  DecodeError(@encoding/utf8.Malformed)
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
    FormulaError(err) => logger.write_string("Formula error: \{err}")
    DecodeError(_) => logger.write_string("Decode Error")
    PreviousError =>
      logger.write_string("Parser invoked after a previous error")
  }
}

///|
pub impl ToJson for DIMACSParseError with to_json(self) {
  Json::string(self.to_string())
}
