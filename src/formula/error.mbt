///|
pub suberror FormulaError {
  IndexTooLarge(index~ : UInt64)
}

///|
pub impl Show for FormulaError with output(self, logger) {
  match self {
    IndexTooLarge(index~) => logger.write_string("Index is too large: \{index}")
  }
}
