///|
// test {
//   let files = @fs.read_dir("dimacs/bmc")
//   let buf = StringBuilder::new()
//   for file in files {
//     let test_block =
//       $|test "\{file}" {
//       $|  check_sat("./dimacs/bmc/\{file}")
//       #|}
//       #|
//     buf.write_string(test_block)
//   }
//   @fs.write_string_to_file("./bmc_test", buf.to_string())
// }
