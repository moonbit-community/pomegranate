///|
pub extend CnfFormula with Default::{default}

///|
pub extend CnfFormula with ToJson::{to_json}

///|
pub extend FormulaError with Show::{to_string, output}

///|
pub extend Lit with Show::{to_string, output}

///|
pub extend Lit with ToJson::{to_json}

///|
pub extend Model with Show::{to_string, output}

///|
pub extend Model with ToJson::{to_json}
