///|
// test {
//   let files = @fs.read_dir("dimacs/flat200v479e")
//   let buf = StringBuilder::new()
//   for file in files {
//     let test_block =
//       $|test "\{file}" {
//       $|  check_sat("./dimacs/flat200v479e/\{file}")
//       #|}
//       #|
//     buf.write_string(test_block)
//   }
//   @fs.write_string_to_file("./flat200v479e_test", buf.to_string())
// }
