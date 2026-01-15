///|
// test {
//   let files = @fs.read_dir("dimacs/uuf50v218c")
//   let buf = StringBuilder::new()
//   for file in files {
//     let test_block =
//       $|test "\{file}" {
//       $|  check_unsat("./dimacs/uuf50v218c/\{file}")
//       #|}
//       #|
//     buf.write_string(test_block)
//   }
//   @fs.write_string_to_file("./uuf50v218c_test", buf.to_string())
// }
