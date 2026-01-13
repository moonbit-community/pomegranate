///|
pub struct DimacsHeader {
  var_count : UInt64
  clause_count : UInt64
}

///|
pub fn DimacsHeader::new(
  var_count : UInt64,
  clause_count : UInt64,
) -> DimacsHeader {
  DimacsHeader::{ var_count, clause_count }
}

///|
/// Parser for DIMACS CNF files.
///
/// This parser can consume the input in chunks while also producing the parsed result in chunks.
pub struct DimacsParser {
  formula : CnfFormula
  partial_clause : Array[Lit]
  mut header : DimacsHeader?
  mut line_number : Int
  mut clause_count : UInt64
  mut partial_lit : UInt64
  mut negate_next_lit : Bool
  mut in_lit : Bool
  mut in_comment_or_header : Bool
  mut in_header : Bool
  mut start_of_line : Bool
  mut error : Bool
  mut header_line : @buffer.Buffer
}

///|
/// Create a new DIMACS CNF parser.
pub fn DimacsParser::new() -> DimacsParser {
  {
    formula: CnfFormula::default(),
    partial_clause: [],
    header: None,
    line_number: 1,
    clause_count: 0,
    partial_lit: 0,
    negate_next_lit: false,
    in_lit: false,
    in_comment_or_header: false,
    in_header: false,
    start_of_line: true,
    error: false,
    header_line: @buffer.new(),
  }
}

///|
/// Parse the given input and check the header if present.
///
/// This parses the whole input into a single CnfFormula.
pub fn DimacsParser::parse(input : Bytes) -> CnfFormula raise DIMACSParseError {
  let parser = DimacsParser::new()
  parser.parse_chunk(input)
  parser.eof()
  parser.check_header()
  parser.formula
}

///|
/// Parse a chunk of input.
///
/// After parsing the last chunk call the eof method.
///
/// If this method returns an error, the parser is in an invalid state and cannot parse further
/// chunks.
pub fn DimacsParser::parse_chunk(
  self : DimacsParser,
  chunk : Bytes,
) -> Unit raise DIMACSParseError {
  if self.error {
    raise DIMACSParseError::PreviousError
  }
  for byte in chunk {
    if byte == '\n' {
      self.line_number += 1
    }
    match byte {
      '\n' | '\r' if self.in_comment_or_header => {
        if self.in_header {
          self.in_header = false
          self.parse_header_line()
        }
        self.in_comment_or_header = false
        self.start_of_line = true
      }
      _ if self.in_comment_or_header =>
        if self.in_header {
          self.header_line.write_byte(byte)
        }
      '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' => {
        self.in_lit = true
        let digit = (byte - b'0').to_uint64()
        let can_overflow = Var::max_count() / 10
        let overflow_digit = Var::max_count() % 10
        // Overflow check
        if can_overflow <= self.partial_lit {
          let carry = if digit <= overflow_digit { 1UL } else { 0UL }
          if can_overflow + carry <= self.partial_lit {
            self.error = true
            raise DIMACSParseError::LiteralTooLarge(
              line=self.line_number,
              index=self.partial_lit,
              final_digit=digit,
            )
          }
        }
        self.partial_lit = self.partial_lit * 10 + digit
        self.start_of_line = false
      }
      b'-' if not(self.negate_next_lit) && not(self.in_lit) => {
        self.negate_next_lit = true
        self.start_of_line = false
      }
      b' ' | b'\n' | b'\r' if not(self.negate_next_lit) || self.in_lit => {
        self.finish_literal()
        self.negate_next_lit = false
        self.in_lit = false
        self.partial_lit = 0
        self.start_of_line = byte != b' '
      }
      b'c' if self.start_of_line => self.in_comment_or_header = true
      b'p' if self.start_of_line && self.header is None => {
        self.in_comment_or_header = true
        self.in_header = true
        self.header_line.write_byte(byte)
      }
      _ => {
        self.error = true
        raise DIMACSParseError::UnexpectedInputCharacter(
          line=self.line_number,
          unexpected=byte.to_char(),
        )
      }
    }
  }
}

///|
/// Finish parsing the input.
///
/// This does not check whether the header information was correct, call
/// check_header for this.
pub fn DimacsParser::eof(self : DimacsParser) -> Unit raise DIMACSParseError {
  if self.in_header {
    self.parse_header_line()
  }
  self.finish_literal()
  if not(self.partial_clause.is_empty()) {
    raise DIMACSParseError::UnterminatedClause(line=self.line_number)
  }
}

///|
/// Verifies the header information when present.
///
/// Does nothing when the input doesn't contain a header.
pub fn DimacsParser::check_header(
  self : DimacsParser,
) -> Unit raise DIMACSParseError {
  match self.header {
    Some(header) => {
      let var_count = self.formula.var_count
      if var_count != header.var_count {
        raise DIMACSParseError::VarCount(
          var_count~,
          header_var_count=header.var_count,
        )
      }
      if self.clause_count != header.clause_count {
        raise DIMACSParseError::ClauseCount(
          clause_count=self.clause_count,
          header_clause_count=header.clause_count,
        )
      }
    }
    None => ()
  }
}

///|
/// Return the DIMACS CNF header data if present.
pub fn DimacsParser::header(self : DimacsParser) -> DimacsHeader? {
  self.header
}

///|
/// Number of clauses parsed.
pub fn DimacsParser::clause_count(self : DimacsParser) -> UInt64 {
  self.clause_count
}

///|
/// Number of variables in the parsed formula.
pub fn DimacsParser::var_count(self : DimacsParser) -> UInt64 {
  self.formula.var_count
}

///|
/// Finish processing a literal and add it to the current clause or finish the clause.
fn DimacsParser::finish_literal(self : DimacsParser) -> Unit {
  if self.in_lit {
    if self.partial_lit == 0 {
      // End of clause
      self.formula.add_clause(self.partial_clause[:])
      self.partial_clause.clear()
      self.clause_count += 1
    } else {
      // Add literal to current clause
      let variable = Var::from_dimacs(self.partial_lit.reinterpret_as_int64()) catch {
        _ => panic()
      }
      let lit = Lit::from_var(variable, not(self.negate_next_lit)) catch {
        _ => panic()
      }
      self.partial_clause.push(lit)
    }
  }
}

///|
/// Parse the header line after it's been collected.
fn DimacsParser::parse_header_line(
  self : DimacsParser,
) -> Unit raise DIMACSParseError {
  let header_string = @encoding/utf8.decode(self.header_line.to_bytes()) catch {
    err => raise DecodeError(err)
  }
  let parts_iter = if header_string is ['p', ' ', .. rest] {
    rest.split(" ").collect().iter().filter(sv => sv != "")
  } else {
    self.invalid_header(header_string)
    return
  }

  // Check for "cnf"
  match parts_iter.next() {
    Some("cnf") => ()
    _ => {
      self.invalid_header(header_string)
      return
    }
  }

  // Parse variable count
  let var_count = match parts_iter.next() {
    Some(s) =>
      @strconv.parse_uint64(s) catch {
        _ => {
          self.invalid_header(header_string)
          return
        }
      }
    None => {
      self.invalid_header(header_string)
      return
    }
  }
  if var_count > Var::max_count() {
    self.error = true
    raise DIMACSParseError::LiteralTooLarge(
      line=self.line_number,
      index=var_count / 10,
      final_digit=var_count % 10,
    )
  }

  // Parse clause count
  let clause_count = match parts_iter.next() {
    Some(s) =>
      @strconv.parse_uint64(s) catch {
        _ => {
          self.invalid_header(header_string)
          return
        }
      }
    None => {
      self.invalid_header(header_string)
      return
    }
  }

  // Check for extra parts
  if parts_iter.next() is Some(_) {
    self.invalid_header(header_string)
    return
  }
  self.header = Some(DimacsHeader::new(var_count, clause_count))
  self.formula.set_var_count(var_count)
  self.header_line = @buffer.new()
}

///|
/// Handle invalid header format.
fn DimacsParser::invalid_header(
  self : DimacsParser,
  header_line : StringView,
) -> Unit raise DIMACSParseError {
  self.error = true
  raise DIMACSParseError::InvalidHeader(
    line=self.line_number,
    header=header_line,
  )
}
