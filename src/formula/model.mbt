///|
/// Compact bitmap for boolean assignments.
pub struct Model {
  length : Int32
  words : Array[UInt64]
}

///|
pub fn Model::new(length : Int32) -> Model {
  let word_count = (length + 63) / 64
  Model::{ length, words: Array::make(word_count, 0), }
}

///|
pub fn Model::length(self : Model) -> Int32 {
  self.length
}

///|
pub fn Model::get(self : Model, index : Int32) -> Bool {
  let word_index = index / 64
  let bit_index = index & 63
  let mask : UInt64 = 1 << bit_index
  (self.words[word_index] & mask) != 0
}

///|
pub fn Model::set(self : Model, index : Int32, value : Bool) -> Unit {
  let word_index = index / 64
  let bit_index = index & 63
  let mask : UInt64 = 1 << bit_index
  let current = self.words[word_index]
  self.words[word_index] = if value {
    current | mask
  } else {
    current & mask.lnot()
  }
}

///|
pub fn Model::from_array(values : Array[Bool]) -> Model {
  let map = Model::new(values.length())
  for i, value in values {
    if value {
      map.set(i, true)
    }
  }
  map
}

///|
pub fn Model::to_array(self : Model) -> Array[Bool] {
  let values = Array::make(self.length, false)
  for i in 0..<self.length {
    values[i] = self.get(i)
  }
  values
}

///|
pub impl ToJson for Model with fn to_json(self) {
  Json(self.to_array())
}

///|
pub impl Show for Model with fn output(self, logger) {
  logger.write_iter(self.to_array().iter())
}
