///|
fn test_sat(path : String) -> Unit raise {
  let source = @fs.read_file_to_bytes(path)
  let cnf = @dimacs.DimacsParser::parse(source)
  guard solve(cnf) is Sat(model~) else {
    fail("failed to solve \{path}, this is a bug")
  }
  guard cnf.eval(model) else {
    fail("find model but \{path} evaluate to false under it, this is a bug")
  }
}

///|
test "uf20-0519.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0519.cnf")
}

///|
test "uf20-0710.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0710.cnf")
}

///|
test "uf20-0487.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0487.cnf")
}

///|
test "uf20-0555.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0555.cnf")
}

///|
test "uf20-0153.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0153.cnf")
}

///|
test "uf20-054.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-054.cnf")
}

///|
test "uf20-058.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-058.cnf")
}

///|
test "uf20-0103.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0103.cnf")
}

///|
test "uf20-0899.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0899.cnf")
}

///|
test "uf20-0743.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0743.cnf")
}

///|
test "uf20-0490.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0490.cnf")
}

///|
test "uf20-027.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-027.cnf")
}

///|
test "uf20-0216.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0216.cnf")
}

///|
test "uf20-0495.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0495.cnf")
}

///|
test "uf20-039.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-039.cnf")
}

///|
test "uf20-075.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-075.cnf")
}

///|
test "uf20-0779.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0779.cnf")
}

///|
test "uf20-0253.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0253.cnf")
}

///|
test "uf20-0957.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0957.cnf")
}

///|
test "uf20-0945.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0945.cnf")
}

///|
test "uf20-0967.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0967.cnf")
}

///|
test "uf20-0676.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0676.cnf")
}

///|
test "uf20-0652.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0652.cnf")
}

///|
test "uf20-0284.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0284.cnf")
}

///|
test "uf20-0466.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0466.cnf")
}

///|
test "uf20-0816.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0816.cnf")
}

///|
test "uf20-0691.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0691.cnf")
}

///|
test "uf20-04.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-04.cnf")
}

///|
test "uf20-0168.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0168.cnf")
}

///|
test "uf20-0472.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0472.cnf")
}

///|
test "uf20-0548.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0548.cnf")
}

///|
test "uf20-0697.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0697.cnf")
}
//

///|
test "uf20-0265.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0265.cnf")
}

///|
test "uf20-0711.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0711.cnf")
}

///|
test "uf20-0114.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0114.cnf")
}

///|
test "uf20-0552.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0552.cnf")
}

///|
test "uf20-079.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-079.cnf")
}

///|
test "uf20-0494.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0494.cnf")
}

///|
test "uf20-0157.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0157.cnf")
}

///|
test "uf20-0716.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0716.cnf")
}

///|
test "uf20-095.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-095.cnf")
}

///|
test "uf20-0310.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0310.cnf")
}

///|
test "uf20-0115.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0115.cnf")
}

///|
test "uf20-0450.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0450.cnf")
}

///|
test "uf20-0172.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0172.cnf")
}

///|
test "uf20-0288.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0288.cnf")
}

///|
test "uf20-0978.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0978.cnf")
}

///|
test "uf20-0257.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0257.cnf")
}

///|
test "uf20-0677.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0677.cnf")
}

///|
test "uf20-0758.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0758.cnf")
}

///|
test "uf20-0394.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0394.cnf")
}

///|
test "uf20-0489.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0489.cnf")
}

///|
test "uf20-0771.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0771.cnf")
}

///|
test "uf20-0817.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0817.cnf")
}

///|
test "uf20-0869.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0869.cnf")
}

///|
test "uf20-0242.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0242.cnf")
}

///|
test "uf20-0529.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0529.cnf")
}

///|
test "uf20-0962.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0962.cnf")
}

///|
test "uf20-0918.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0918.cnf")
}

///|
test "uf20-0229.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0229.cnf")
}

///|
test "uf20-0458.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0458.cnf")
}

///|
test "uf20-0804.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0804.cnf")
}

///|
test "uf20-0737.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0737.cnf")
}

///|
test "uf20-0480.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0480.cnf")
}
//

///|
test "uf20-0654.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0654.cnf")
}
//

///|
test "uf20-032.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-032.cnf")
}
//

///|
test "uf20-0880.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0880.cnf")
}
//

///|
test "uf20-0414.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0414.cnf")
}
//

///|
test "uf20-0401.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0401.cnf")
}
//

///|
test "uf20-090.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-090.cnf")
}
//

///|
test "uf20-0267.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0267.cnf")
}
//

///|
test "uf20-0645.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0645.cnf")
}

///|
test "uf20-0202.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0202.cnf")
}

///|
test "uf20-0382.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0382.cnf")
}
//

///|
test "uf20-0199.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0199.cnf")
}
//

///|
test "uf20-0611.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0611.cnf")
}
//

///|
test "uf20-0328.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0328.cnf")
}
//

///|
test "uf20-0390.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0390.cnf")
}
//

///|
test "uf20-0181.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0181.cnf")
}
//

///|
test "uf20-0595.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0595.cnf")
}
//

///|
test "uf20-0610.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0610.cnf")
}
//

///|
test "uf20-0203.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0203.cnf")
}
//

///|
test "uf20-0187.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0187.cnf")
}
//

///|
test "uf20-0428.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0428.cnf")
}
//

///|
test "uf20-0179.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0179.cnf")
}
//

///|
test "uf20-0154.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0154.cnf")
}
//

///|
test "uf20-0702.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0702.cnf")
}
//

///|
test "uf20-0322.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0322.cnf")
}
//

///|
test "uf20-0965.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0965.cnf")
}
//

///|
test "uf20-0629.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0629.cnf")
}
//

///|
test "uf20-0208.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0208.cnf")
}
//

///|
test "uf20-0232.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0232.cnf")
}
//

///|
test "uf20-0249.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0249.cnf")
}
//

///|
test "uf20-0561.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0561.cnf")
}
//

///|
test "uf20-0903.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0903.cnf")
}
//

///|
test "uf20-0757.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0757.cnf")
}
//

///|
test "uf20-0407.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0407.cnf")
}
//

///|
test "uf20-0726.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0726.cnf")
}
//

///|
test "uf20-084.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-084.cnf")
}
//

///|
test "uf20-0170.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0170.cnf")
}
//

///|
test "uf20-0530.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0530.cnf")
}
//

///|
test "uf20-0898.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0898.cnf")
}

///|
test "uf20-0739.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0739.cnf")
}

///|
test "uf20-0150.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0150.cnf")
}
//

///|
test "uf20-042.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-042.cnf")
}
//

///|
test "uf20-0415.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0415.cnf")
}
//

///|
test "uf20-0169.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0169.cnf")
}
//

///|
test "uf20-0374.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0374.cnf")
}
//

///|
test "uf20-099.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-099.cnf")
}
//

///|
test "uf20-0854.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0854.cnf")
}

///|
test "uf20-0568.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0568.cnf")
}

///|
test "uf20-0624.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0624.cnf")
}
//

///|
test "uf20-0849.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0849.cnf")
}
//

///|
test "uf20-0732.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0732.cnf")
}
//

///|
test "uf20-0136.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0136.cnf")
}
//

///|
test "uf20-0889.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0889.cnf")
}
//

///|
test "uf20-0254.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0254.cnf")
}
//

///|
test "uf20-0587.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0587.cnf")
}
//

///|
test "uf20-0417.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0417.cnf")
}
//

///|
test "uf20-0917.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0917.cnf")
}

///|
test "uf20-0146.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0146.cnf")
}

///|
test "uf20-0680.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0680.cnf")
}
//

///|
test "uf20-0634.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0634.cnf")
}
//

///|
test "uf20-0736.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0736.cnf")
}
//

///|
test "uf20-0959.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0959.cnf")
}
//

///|
test "uf20-025.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-025.cnf")
}
//

///|
test "uf20-0196.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0196.cnf")
}
//

///|
test "uf20-0679.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0679.cnf")
}
//

///|
test "uf20-073.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-073.cnf")
}
//

///|
test "uf20-0932.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0932.cnf")
}
//

///|
test "uf20-0935.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0935.cnf")
}
//

///|
test "uf20-0892.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0892.cnf")
}
//

///|
test "uf20-0553.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0553.cnf")
}
//

///|
test "uf20-0643.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0643.cnf")
}
//

///|
test "uf20-096.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-096.cnf")
}

///|
test "uf20-0513.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0513.cnf")
}
//

///|
test "uf20-0964.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0964.cnf")
}
//

///|
test "uf20-0325.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0325.cnf")
}
//

///|
test "uf20-053.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-053.cnf")
}
//

///|
test "uf20-0574.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0574.cnf")
}
//

///|
test "uf20-050.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-050.cnf")
}
//

///|
test "uf20-0468.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0468.cnf")
}
//

///|
test "uf20-0497.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0497.cnf")
}
//

///|
test "uf20-0297.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0297.cnf")
}
//

///|
test "uf20-0994.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0994.cnf")
}

///|
test "uf20-072.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-072.cnf")
}

///|
test "uf20-01.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-01.cnf")
}
//

///|
test "uf20-0852.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0852.cnf")
}
//

///|
test "uf20-028.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-028.cnf")
}
//

///|
test "uf20-0569.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0569.cnf")
}
//

///|
test "uf20-0141.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0141.cnf")
}
//

///|
test "uf20-0135.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0135.cnf")
}
//

///|
test "uf20-0581.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0581.cnf")
}
//

///|
test "uf20-0720.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0720.cnf")
}
//

///|
test "uf20-0332.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0332.cnf")
}
//

///|
test "uf20-0163.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0163.cnf")
}
//

///|
test "uf20-0102.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0102.cnf")
}
//

///|
test "uf20-0619.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0619.cnf")
}
//

///|
test "uf20-0768.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0768.cnf")
}

///|
test "uf20-0833.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0833.cnf")
}
//

///|
test "uf20-0125.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0125.cnf")
}
//

///|
test "uf20-0120.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0120.cnf")
}
//

///|
test "uf20-0902.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0902.cnf")
}
//

///|
test "uf20-0416.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0416.cnf")
}
//

///|
test "uf20-0802.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0802.cnf")
}
//

///|
test "uf20-0914.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0914.cnf")
}
//

///|
test "uf20-0398.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0398.cnf")
}
//

///|
test "uf20-0656.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0656.cnf")
}
//

///|
test "uf20-0399.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0399.cnf")
}
//

///|
test "uf20-0937.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0937.cnf")
}
//

///|
test "uf20-0524.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0524.cnf")
}
//

///|
test "uf20-0754.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0754.cnf")
}

///|
test "uf20-089.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-089.cnf")
}

///|
test "uf20-0829.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0829.cnf")
}
//

///|
test "uf20-0543.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0543.cnf")
}

///|
test "uf20-0173.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0173.cnf")
}

///|
test "uf20-0788.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0788.cnf")
}
//

///|
test "uf20-0708.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0708.cnf")
}
//

///|
test "uf20-0706.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0706.cnf")
}
//

///|
test "uf20-0386.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0386.cnf")
}
//

///|
test "uf20-0851.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0851.cnf")
}
//

///|
test "uf20-0515.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0515.cnf")
}
//

///|
test "uf20-0123.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0123.cnf")
}
//

///|
test "uf20-0525.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0525.cnf")
}

///|
test "uf20-0177.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0177.cnf")
}

///|
test "uf20-0338.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0338.cnf")
}
//

///|
test "uf20-029.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-029.cnf")
}
//

///|
test "uf20-0140.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0140.cnf")
}
//

///|
test "uf20-0496.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0496.cnf")
}
//

///|
test "uf20-0198.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0198.cnf")
}
//

///|
test "uf20-0222.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0222.cnf")
}
//

///|
test "uf20-0303.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0303.cnf")
}
//

///|
test "uf20-0872.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0872.cnf")
}
//

///|
test "uf20-0405.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0405.cnf")
}
//

///|
test "uf20-0139.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0139.cnf")
}
//

///|
test "uf20-0637.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0637.cnf")
}
//

///|
test "uf20-0156.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0156.cnf")
}
//

///|
test "uf20-0997.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0997.cnf")
}
//

///|
test "uf20-0422.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0422.cnf")
}
//

///|
test "uf20-0296.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0296.cnf")
}
//

///|
test "uf20-0811.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0811.cnf")
}
//

///|
test "uf20-0776.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0776.cnf")
}
//

///|
test "uf20-0660.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0660.cnf")
}
//

///|
test "uf20-0334.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0334.cnf")
}
//

///|
test "uf20-0420.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0420.cnf")
}
//

///|
test "uf20-0220.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0220.cnf")
}
//

///|
test "uf20-0348.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0348.cnf")
}
//

///|
test "uf20-0893.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0893.cnf")
}
//

///|
test "uf20-0455.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0455.cnf")
}
//

///|
test "uf20-012.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-012.cnf")
}
//

///|
test "uf20-092.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-092.cnf")
}
//

///|
test "uf20-0990.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0990.cnf")
}
//

///|
test "uf20-0337.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0337.cnf")
}

///|
test "uf20-0985.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0985.cnf")
}

///|
test "uf20-0778.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0778.cnf")
}

///|
test "uf20-0626.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0626.cnf")
}

///|
test "uf20-0344.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0344.cnf")
}

///|
test "uf20-0443.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0443.cnf")
}

///|
test "uf20-0339.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0339.cnf")
}
//

///|
test "uf20-0541.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0541.cnf")
}
//

///|
test "uf20-0931.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0931.cnf")
}
//

///|
test "uf20-0274.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0274.cnf")
}
//

///|
test "uf20-0373.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0373.cnf")
}
//

///|
test "uf20-0980.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0980.cnf")
}
//

///|
test "uf20-0370.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0370.cnf")
}
//

///|
test "uf20-0755.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0755.cnf")
}
//

///|
test "uf20-0316.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0316.cnf")
}
//

///|
test "uf20-0213.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0213.cnf")
}
//

///|
test "uf20-0126.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0126.cnf")
}
//

///|
test "uf20-0313.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0313.cnf")
}

///|
test "uf20-0938.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0938.cnf")
}

///|
test "uf20-0678.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0678.cnf")
}
//

///|
test "uf20-0308.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0308.cnf")
}
//

///|
test "uf20-0434.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0434.cnf")
}
//

///|
test "uf20-0262.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0262.cnf")
}
//

///|
test "uf20-017.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-017.cnf")
}
//

///|
test "uf20-0116.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0116.cnf")
}
//

///|
test "uf20-0760.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0760.cnf")
}
//

///|
test "uf20-0846.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0846.cnf")
}
//

///|
test "uf20-0963.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0963.cnf")
}
//

///|
test "uf20-0447.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0447.cnf")
}
//

///|
test "uf20-0392.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0392.cnf")
}

///|
test "uf20-0442.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0442.cnf")
}

///|
test "uf20-0861.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0861.cnf")
}
//

///|
test "uf20-0247.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0247.cnf")
}

///|
test "uf20-0712.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0712.cnf")
}

///|
test "uf20-0825.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0825.cnf")
}

///|
test "uf20-0894.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0894.cnf")
}
//

///|
test "uf20-0667.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0667.cnf")
}
//

///|
test "uf20-0790.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0790.cnf")
}
//

///|
test "uf20-0615.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0615.cnf")
}
//

///|
test "uf20-0545.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0545.cnf")
}
//

///|
test "uf20-0727.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0727.cnf")
}
//

///|
test "uf20-0481.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0481.cnf")
}

///|
test "uf20-0403.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0403.cnf")
}

///|
test "uf20-021.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-021.cnf")
}

///|
test "uf20-0884.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0884.cnf")
}

///|
test "uf20-0623.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0623.cnf")
}

///|
test "uf20-0740.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0740.cnf")
}

///|
test "uf20-0164.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0164.cnf")
}

///|
test "uf20-0575.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0575.cnf")
}

///|
test "uf20-0270.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0270.cnf")
}

///|
test "uf20-0993.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0993.cnf")
}

///|
test "uf20-0741.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0741.cnf")
}

///|
test "uf20-0534.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0534.cnf")
}

///|
test "uf20-0837.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0837.cnf")
}

///|
test "uf20-0731.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0731.cnf")
}

///|
test "uf20-022.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-022.cnf")
}

///|
test "uf20-0510.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0510.cnf")
}

///|
test "uf20-0929.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0929.cnf")
}

///|
test "uf20-0847.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0847.cnf")
}

///|
test "uf20-0531.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0531.cnf")
}

///|
test "uf20-0901.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0901.cnf")
}

///|
test "uf20-06.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-06.cnf")
}

///|
test "uf20-0354.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0354.cnf")
}

///|
test "uf20-0976.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0976.cnf")
}

///|
test "uf20-059.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-059.cnf")
}

///|
test "uf20-0641.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0641.cnf")
}

///|
test "uf20-0124.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0124.cnf")
}

///|
test "uf20-0801.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0801.cnf")
}

///|
test "uf20-0831.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0831.cnf")
}

///|
test "uf20-0762.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0762.cnf")
}

///|
test "uf20-037.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-037.cnf")
}

///|
test "uf20-0738.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0738.cnf")
}

///|
test "uf20-0492.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0492.cnf")
}

///|
test "uf20-0393.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0393.cnf")
}

///|
test "uf20-0273.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0273.cnf")
}

///|
test "uf20-0484.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0484.cnf")
}

///|
test "uf20-0230.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0230.cnf")
}

///|
test "uf20-0956.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0956.cnf")
}

///|
test "uf20-0815.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0815.cnf")
}

///|
test "uf20-0192.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0192.cnf")
}

///|
test "uf20-0688.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0688.cnf")
}

///|
test "uf20-0599.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0599.cnf")
}

///|
test "uf20-0828.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0828.cnf")
}

///|
test "uf20-0226.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0226.cnf")
}

///|
test "uf20-0675.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0675.cnf")
}

///|
test "uf20-0628.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0628.cnf")
}

///|
test "uf20-05.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-05.cnf")
}

///|
test "uf20-0775.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0775.cnf")
}

///|
test "uf20-0981.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0981.cnf")
}

///|
test "uf20-0223.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0223.cnf")
}

///|
test "uf20-0282.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0282.cnf")
}

///|
test "uf20-0671.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0671.cnf")
}

///|
test "uf20-0709.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0709.cnf")
}

///|
test "uf20-0729.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0729.cnf")
}

///|
test "uf20-0452.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0452.cnf")
}

///|
test "uf20-0462.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0462.cnf")
}

///|
test "uf20-0983.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0983.cnf")
}

///|
test "uf20-0713.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0713.cnf")
}

///|
test "uf20-0470.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0470.cnf")
}

///|
test "uf20-0780.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0780.cnf")
}

///|
test "uf20-0591.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0591.cnf")
}

///|
test "uf20-0601.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0601.cnf")
}

///|
test "uf20-0908.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0908.cnf")
}

///|
test "uf20-0363.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0363.cnf")
}

///|
test "uf20-0360.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0360.cnf")
}

///|
test "uf20-0180.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0180.cnf")
}

///|
test "uf20-0566.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0566.cnf")
}

///|
test "uf20-063.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-063.cnf")
}

///|
test "uf20-0987.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0987.cnf")
}

///|
test "uf20-0318.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0318.cnf")
}

///|
test "uf20-0212.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0212.cnf")
}

///|
test "uf20-0133.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0133.cnf")
}

///|
test "uf20-0272.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0272.cnf")
}

///|
test "uf20-0387.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0387.cnf")
}

///|
test "uf20-0435.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0435.cnf")
}

///|
test "uf20-0966.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0966.cnf")
}

///|
test "uf20-0400.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0400.cnf")
}

///|
test "uf20-0717.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0717.cnf")
}

///|
test "uf20-045.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-045.cnf")
}

///|
test "uf20-0646.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0646.cnf")
}

///|
test "uf20-0521.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0521.cnf")
}

///|
test "uf20-0613.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0613.cnf")
}

///|
test "uf20-0668.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0668.cnf")
}

///|
test "uf20-0128.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0128.cnf")
}

///|
test "uf20-0539.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0539.cnf")
}

///|
test "uf20-0979.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0979.cnf")
}

///|
test "uf20-0683.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0683.cnf")
}

///|
test "uf20-0839.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0839.cnf")
}

///|
test "uf20-0621.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0621.cnf")
}

///|
test "uf20-0307.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0307.cnf")
}

///|
test "uf20-0785.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0785.cnf")
}

///|
test "uf20-0781.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0781.cnf")
}

///|
test "uf20-0909.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0909.cnf")
}

///|
test "uf20-0438.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0438.cnf")
}

///|
test "uf20-071.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-071.cnf")
}

///|
test "uf20-0352.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0352.cnf")
}

///|
test "uf20-0886.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0886.cnf")
}

///|
test "uf20-0793.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0793.cnf")
}

///|
test "uf20-080.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-080.cnf")
}

///|
test "uf20-0814.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0814.cnf")
}

///|
test "uf20-0813.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0813.cnf")
}

///|
test "uf20-0485.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0485.cnf")
}

///|
test "uf20-0996.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0996.cnf")
}

///|
test "uf20-0764.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0764.cnf")
}

///|
test "uf20-0798.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0798.cnf")
}

///|
test "uf20-0260.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0260.cnf")
}

///|
test "uf20-0603.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0603.cnf")
}

///|
test "uf20-0238.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0238.cnf")
}

///|
test "uf20-0877.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0877.cnf")
}

///|
test "uf20-0467.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0467.cnf")
}

///|
test "uf20-0335.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0335.cnf")
}

///|
test "uf20-0475.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0475.cnf")
}

///|
test "uf20-0104.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0104.cnf")
}

///|
test "uf20-0105.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0105.cnf")
}

///|
test "uf20-0991.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0991.cnf")
}

///|
test "uf20-0291.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0291.cnf")
}

///|
test "uf20-0205.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0205.cnf")
}

///|
test "uf20-0246.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0246.cnf")
}

///|
test "uf20-0695.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0695.cnf")
}

///|
test "uf20-0995.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0995.cnf")
}

///|
test "uf20-0295.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0295.cnf")
}

///|
test "uf20-0448.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0448.cnf")
}

///|
test "uf20-0283.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0283.cnf")
}

///|
test "uf20-0194.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0194.cnf")
}

///|
test "uf20-0221.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0221.cnf")
}

///|
test "uf20-0258.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0258.cnf")
}

///|
test "uf20-0488.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0488.cnf")
}

///|
test "uf20-0209.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0209.cnf")
}

///|
test "uf20-0112.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0112.cnf")
}

///|
test "uf20-0820.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0820.cnf")
}

///|
test "uf20-0881.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0881.cnf")
}

///|
test "uf20-0526.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0526.cnf")
}

///|
test "uf20-03.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-03.cnf")
}

///|
test "uf20-0240.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0240.cnf")
}

///|
test "uf20-0486.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0486.cnf")
}

///|
test "uf20-083.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-083.cnf")
}

///|
test "uf20-0349.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0349.cnf")
}

///|
test "uf20-035.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-035.cnf")
}

///|
test "uf20-0290.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0290.cnf")
}

///|
test "uf20-0752.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0752.cnf")
}

///|
test "uf20-0644.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0644.cnf")
}

///|
test "uf20-0535.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0535.cnf")
}

///|
test "uf20-0812.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0812.cnf")
}

///|
test "uf20-0888.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0888.cnf")
}

///|
test "uf20-0823.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0823.cnf")
}

///|
test "uf20-0614.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0614.cnf")
}

///|
test "uf20-0397.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0397.cnf")
}

///|
test "uf20-0278.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0278.cnf")
}

///|
test "uf20-0520.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0520.cnf")
}

///|
test "uf20-0659.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0659.cnf")
}

///|
test "uf20-0162.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0162.cnf")
}

///|
test "uf20-0907.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0907.cnf")
}

///|
test "uf20-0821.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0821.cnf")
}

///|
test "uf20-0612.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0612.cnf")
}

///|
test "uf20-0992.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0992.cnf")
}

///|
test "uf20-0122.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0122.cnf")
}

///|
test "uf20-0454.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0454.cnf")
}

///|
test "uf20-0367.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0367.cnf")
}

///|
test "uf20-0721.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0721.cnf")
}

///|
test "uf20-0988.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0988.cnf")
}

///|
test "uf20-0719.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0719.cnf")
}

///|
test "uf20-0404.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0404.cnf")
}

///|
test "uf20-0129.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0129.cnf")
}

///|
test "uf20-0233.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0233.cnf")
}

///|
test "uf20-0527.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0527.cnf")
}

///|
test "uf20-0809.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0809.cnf")
}

///|
test "uf20-0582.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0582.cnf")
}

///|
test "uf20-0948.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0948.cnf")
}

///|
test "uf20-0689.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0689.cnf")
}

///|
test "uf20-0742.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0742.cnf")
}

///|
test "uf20-0632.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0632.cnf")
}

///|
test "uf20-0449.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0449.cnf")
}

///|
test "uf20-0602.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0602.cnf")
}

///|
test "uf20-0351.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0351.cnf")
}

///|
test "uf20-0311.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0311.cnf")
}

///|
test "uf20-0761.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0761.cnf")
}

///|
test "uf20-0648.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0648.cnf")
}

///|
test "uf20-0952.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0952.cnf")
}

///|
test "uf20-0944.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0944.cnf")
}

///|
test "uf20-0277.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0277.cnf")
}

///|
test "uf20-0107.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0107.cnf")
}

///|
test "uf20-0158.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0158.cnf")
}

///|
test "uf20-0331.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0331.cnf")
}

///|
test "uf20-0905.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0905.cnf")
}

///|
test "uf20-0961.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0961.cnf")
}

///|
test "uf20-0101.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0101.cnf")
}

///|
test "uf20-010.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-010.cnf")
}

///|
test "uf20-0570.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0570.cnf")
}

///|
test "uf20-0969.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0969.cnf")
}

///|
test "uf20-0690.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0690.cnf")
}

///|
test "uf20-0456.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0456.cnf")
}

///|
test "uf20-0977.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0977.cnf")
}

///|
test "uf20-077.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-077.cnf")
}

///|
test "uf20-0687.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0687.cnf")
}

///|
test "uf20-0281.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0281.cnf")
}

///|
test "uf20-0895.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0895.cnf")
}

///|
test "uf20-0810.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0810.cnf")
}

///|
test "uf20-0664.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0664.cnf")
}

///|
test "uf20-0377.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0377.cnf")
}

///|
test "uf20-0546.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0546.cnf")
}

///|
test "uf20-0699.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0699.cnf")
}

///|
test "uf20-049.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-049.cnf")
}

///|
test "uf20-0110.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0110.cnf")
}

///|
test "uf20-016.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-016.cnf")
}

///|
test "uf20-0243.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0243.cnf")
}

///|
test "uf20-0576.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0576.cnf")
}

///|
test "uf20-067.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-067.cnf")
}

///|
test "uf20-0848.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0848.cnf")
}

///|
test "uf20-0544.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0544.cnf")
}

///|
test "uf20-0471.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0471.cnf")
}

///|
test "uf20-0746.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0746.cnf")
}

///|
test "uf20-0562.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0562.cnf")
}

///|
test "uf20-0309.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0309.cnf")
}

///|
test "uf20-0432.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0432.cnf")
}

///|
test "uf20-0109.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0109.cnf")
}

///|
test "uf20-0127.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0127.cnf")
}

///|
test "uf20-0558.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0558.cnf")
}

///|
test "uf20-0106.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0106.cnf")
}

///|
test "uf20-0293.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0293.cnf")
}

///|
test "uf20-0913.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0913.cnf")
}

///|
test "uf20-020.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-020.cnf")
}

///|
test "uf20-0341.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0341.cnf")
}

///|
test "uf20-0670.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0670.cnf")
}

///|
test "uf20-0661.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0661.cnf")
}

///|
test "uf20-082.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-082.cnf")
}

///|
test "uf20-0300.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0300.cnf")
}

///|
test "uf20-0353.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0353.cnf")
}

///|
test "uf20-0183.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0183.cnf")
}

///|
test "uf20-0427.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0427.cnf")
}

///|
test "uf20-0803.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0803.cnf")
}

///|
test "uf20-0100.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0100.cnf")
}

///|
test "uf20-0245.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0245.cnf")
}

///|
test "uf20-0113.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0113.cnf")
}

///|
test "uf20-0201.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0201.cnf")
}

///|
test "uf20-0559.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0559.cnf")
}

///|
test "uf20-0185.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0185.cnf")
}

///|
test "uf20-0975.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0975.cnf")
}

///|
test "uf20-0175.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0175.cnf")
}

///|
test "uf20-0871.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0871.cnf")
}

///|
test "uf20-088.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-088.cnf")
}

///|
test "uf20-0747.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0747.cnf")
}

///|
test "uf20-0193.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0193.cnf")
}

///|
test "uf20-0301.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0301.cnf")
}

///|
test "uf20-0577.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0577.cnf")
}

///|
test "uf20-0214.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0214.cnf")
}

///|
test "uf20-02.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-02.cnf")
}

///|
test "uf20-0477.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0477.cnf")
}

///|
test "uf20-0630.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0630.cnf")
}

///|
test "uf20-0302.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0302.cnf")
}

///|
test "uf20-0461.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0461.cnf")
}

///|
test "uf20-0885.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0885.cnf")
}

///|
test "uf20-0410.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0410.cnf")
}

///|
test "uf20-0751.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0751.cnf")
}

///|
test "uf20-0184.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0184.cnf")
}

///|
test "uf20-026.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-026.cnf")
}

///|
test "uf20-0342.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0342.cnf")
}

///|
test "uf20-0703.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0703.cnf")
}

///|
test "uf20-0859.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0859.cnf")
}

///|
test "uf20-0503.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0503.cnf")
}

///|
test "uf20-0618.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0618.cnf")
}

///|
test "uf20-0444.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0444.cnf")
}

///|
test "uf20-0178.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0178.cnf")
}

///|
test "uf20-0855.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0855.cnf")
}

///|
test "uf20-0658.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0658.cnf")
}

///|
test "uf20-0653.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0653.cnf")
}

///|
test "uf20-0827.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0827.cnf")
}

///|
test "uf20-0306.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0306.cnf")
}

///|
test "uf20-0537.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0537.cnf")
}

///|
test "uf20-0436.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0436.cnf")
}

///|
test "uf20-086.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-086.cnf")
}

///|
test "uf20-0947.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0947.cnf")
}

///|
test "uf20-0608.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0608.cnf")
}

///|
test "uf20-0770.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0770.cnf")
}

///|
test "uf20-062.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-062.cnf")
}

///|
test "uf20-094.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-094.cnf")
}

///|
test "uf20-031.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-031.cnf")
}

///|
test "uf20-0132.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0132.cnf")
}

///|
test "uf20-0584.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0584.cnf")
}

///|
test "uf20-0824.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0824.cnf")
}

///|
test "uf20-0171.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0171.cnf")
}

///|
test "uf20-0718.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0718.cnf")
}

///|
test "uf20-060.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-060.cnf")
}

///|
test "uf20-0936.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0936.cnf")
}

///|
test "uf20-0134.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0134.cnf")
}

///|
test "uf20-0343.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0343.cnf")
}

///|
test "uf20-0241.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0241.cnf")
}

///|
test "uf20-0536.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0536.cnf")
}

///|
test "uf20-0791.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0791.cnf")
}

///|
test "uf20-068.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-068.cnf")
}

///|
test "uf20-0597.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0597.cnf")
}

///|
test "uf20-0375.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0375.cnf")
}

///|
test "uf20-061.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-061.cnf")
}

///|
test "uf20-0429.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0429.cnf")
}

///|
test "uf20-0669.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0669.cnf")
}

///|
test "uf20-065.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-065.cnf")
}

///|
test "uf20-0590.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0590.cnf")
}

///|
test "uf20-0204.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0204.cnf")
}

///|
test "uf20-0264.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0264.cnf")
}

///|
test "uf20-066.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-066.cnf")
}

///|
test "uf20-0870.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0870.cnf")
}

///|
test "uf20-019.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-019.cnf")
}

///|
test "uf20-0928.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0928.cnf")
}

///|
test "uf20-034.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-034.cnf")
}

///|
test "uf20-0379.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0379.cnf")
}

///|
test "uf20-0195.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0195.cnf")
}

///|
test "uf20-047.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-047.cnf")
}

///|
test "uf20-0730.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0730.cnf")
}

///|
test "uf20-041.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-041.cnf")
}

///|
test "uf20-0777.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0777.cnf")
}

///|
test "uf20-0550.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0550.cnf")
}

///|
test "uf20-0693.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0693.cnf")
}

///|
test "uf20-0794.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0794.cnf")
}

///|
test "uf20-0692.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0692.cnf")
}

///|
test "uf20-0206.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0206.cnf")
}

///|
test "uf20-0819.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0819.cnf")
}

///|
test "uf20-0663.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0663.cnf")
}

///|
test "uf20-0483.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0483.cnf")
}

///|
test "uf20-0512.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0512.cnf")
}

///|
test "uf20-0563.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0563.cnf")
}

///|
test "uf20-0119.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0119.cnf")
}

///|
test "uf20-0554.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0554.cnf")
}

///|
test "uf20-0700.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0700.cnf")
}

///|
test "uf20-0701.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0701.cnf")
}

///|
test "uf20-0657.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0657.cnf")
}

///|
test "uf20-0389.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0389.cnf")
}

///|
test "uf20-0437.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0437.cnf")
}

///|
test "uf20-0673.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0673.cnf")
}

///|
test "uf20-0155.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0155.cnf")
}

///|
test "uf20-0662.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0662.cnf")
}

///|
test "uf20-0368.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0368.cnf")
}

///|
test "uf20-0111.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0111.cnf")
}

///|
test "uf20-0433.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0433.cnf")
}

///|
test "uf20-0186.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0186.cnf")
}

///|
test "uf20-0850.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0850.cnf")
}

///|
test "uf20-0197.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0197.cnf")
}

///|
test "uf20-0425.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0425.cnf")
}

///|
test "uf20-0540.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0540.cnf")
}

///|
test "uf20-0191.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0191.cnf")
}

///|
test "uf20-024.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-024.cnf")
}

///|
test "uf20-0753.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0753.cnf")
}

///|
test "uf20-0942.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0942.cnf")
}

///|
test "uf20-0491.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0491.cnf")
}

///|
test "uf20-0922.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0922.cnf")
}

///|
test "uf20-0504.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0504.cnf")
}

///|
test "uf20-0457.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0457.cnf")
}

///|
test "uf20-0231.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0231.cnf")
}

///|
test "uf20-0655.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0655.cnf")
}

///|
test "uf20-0860.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0860.cnf")
}

///|
test "uf20-0620.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0620.cnf")
}

///|
test "uf20-0845.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0845.cnf")
}

///|
test "uf20-0557.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0557.cnf")
}

///|
test "uf20-0509.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0509.cnf")
}

///|
test "uf20-0378.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0378.cnf")
}

///|
test "uf20-0161.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0161.cnf")
}

///|
test "uf20-0867.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0867.cnf")
}

///|
test "uf20-0684.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0684.cnf")
}

///|
test "uf20-0724.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0724.cnf")
}

///|
test "uf20-0916.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0916.cnf")
}

///|
test "uf20-0200.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0200.cnf")
}

///|
test "uf20-0217.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0217.cnf")
}

///|
test "uf20-0478.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0478.cnf")
}

///|
test "uf20-0796.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0796.cnf")
}

///|
test "uf20-0189.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0189.cnf")
}

///|
test "uf20-0117.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0117.cnf")
}

///|
test "uf20-0259.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0259.cnf")
}

///|
test "uf20-0406.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0406.cnf")
}

///|
test "uf20-0786.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0786.cnf")
}

///|
test "uf20-078.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-078.cnf")
}

///|
test "uf20-0292.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0292.cnf")
}

///|
test "uf20-0900.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0900.cnf")
}

///|
test "uf20-048.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-048.cnf")
}

///|
test "uf20-0625.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0625.cnf")
}

///|
test "uf20-0314.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0314.cnf")
}

///|
test "uf20-0190.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0190.cnf")
}

///|
test "uf20-0891.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0891.cnf")
}

///|
test "uf20-0402.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0402.cnf")
}

///|
test "uf20-0148.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0148.cnf")
}

///|
test "uf20-0453.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0453.cnf")
}

///|
test "uf20-081.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-081.cnf")
}

///|
test "uf20-0329.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0329.cnf")
}

///|
test "uf20-0647.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0647.cnf")
}

///|
test "uf20-0409.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0409.cnf")
}

///|
test "uf20-0380.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0380.cnf")
}

///|
test "uf20-0210.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0210.cnf")
}

///|
test "uf20-0507.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0507.cnf")
}

///|
test "uf20-0142.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0142.cnf")
}

///|
test "uf20-0714.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0714.cnf")
}

///|
test "uf20-0547.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0547.cnf")
}

///|
test "uf20-0350.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0350.cnf")
}

///|
test "uf20-0682.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0682.cnf")
}

///|
test "uf20-08.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-08.cnf")
}

///|
test "uf20-0121.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0121.cnf")
}

///|
test "uf20-0508.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0508.cnf")
}

///|
test "uf20-0237.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0237.cnf")
}

///|
test "uf20-0927.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0927.cnf")
}

///|
test "uf20-0391.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0391.cnf")
}

///|
test "uf20-0523.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0523.cnf")
}

///|
test "uf20-0182.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0182.cnf")
}

///|
test "uf20-0276.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0276.cnf")
}

///|
test "uf20-0890.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0890.cnf")
}

///|
test "uf20-0459.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0459.cnf")
}

///|
test "uf20-0843.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0843.cnf")
}

///|
test "uf20-0784.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0784.cnf")
}

///|
test "uf20-01000.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-01000.cnf")
}

///|
test "uf20-0445.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0445.cnf")
}

///|
test "uf20-0446.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0446.cnf")
}

///|
test "uf20-0251.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0251.cnf")
}

///|
test "uf20-0224.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0224.cnf")
}

///|
test "uf20-0517.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0517.cnf")
}

///|
test "uf20-0347.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0347.cnf")
}

///|
test "uf20-0940.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0940.cnf")
}

///|
test "uf20-064.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-064.cnf")
}

///|
test "uf20-0279.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0279.cnf")
}

///|
test "uf20-0954.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0954.cnf")
}

///|
test "uf20-0698.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0698.cnf")
}

///|
test "uf20-0868.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0868.cnf")
}

///|
test "uf20-0372.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0372.cnf")
}

///|
test "uf20-0464.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0464.cnf")
}

///|
test "uf20-0516.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0516.cnf")
}

///|
test "uf20-0362.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0362.cnf")
}

///|
test "uf20-0799.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0799.cnf")
}

///|
test "uf20-0685.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0685.cnf")
}

///|
test "uf20-0642.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0642.cnf")
}

///|
test "uf20-0275.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0275.cnf")
}

///|
test "uf20-0745.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0745.cnf")
}

///|
test "uf20-0627.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0627.cnf")
}

///|
test "uf20-097.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-097.cnf")
}

///|
test "uf20-0596.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0596.cnf")
}

///|
test "uf20-0502.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0502.cnf")
}

///|
test "uf20-0305.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0305.cnf")
}

///|
test "uf20-0159.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0159.cnf")
}

///|
test "uf20-051.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-051.cnf")
}

///|
test "uf20-098.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-098.cnf")
}

///|
test "uf20-0636.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0636.cnf")
}

///|
test "uf20-0261.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0261.cnf")
}

///|
test "uf20-0795.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0795.cnf")
}

///|
test "uf20-0925.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0925.cnf")
}

///|
test "uf20-0358.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0358.cnf")
}

///|
test "uf20-0600.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0600.cnf")
}

///|
test "uf20-0650.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0650.cnf")
}

///|
test "uf20-0376.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0376.cnf")
}

///|
test "uf20-0356.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0356.cnf")
}

///|
test "uf20-0766.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0766.cnf")
}

///|
test "uf20-0234.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0234.cnf")
}

///|
test "uf20-0364.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0364.cnf")
}

///|
test "uf20-0616.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0616.cnf")
}

///|
test "uf20-0381.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0381.cnf")
}

///|
test "uf20-0906.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0906.cnf")
}

///|
test "uf20-0236.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0236.cnf")
}

///|
test "uf20-0304.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0304.cnf")
}

///|
test "uf20-0573.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0573.cnf")
}

///|
test "uf20-014.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-014.cnf")
}

///|
test "uf20-0598.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0598.cnf")
}

///|
test "uf20-0482.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0482.cnf")
}

///|
test "uf20-0533.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0533.cnf")
}

///|
test "uf20-0167.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0167.cnf")
}

///|
test "uf20-0733.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0733.cnf")
}

///|
test "uf20-0844.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0844.cnf")
}

///|
test "uf20-0919.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0919.cnf")
}

///|
test "uf20-0299.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0299.cnf")
}

///|
test "uf20-0355.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0355.cnf")
}

///|
test "uf20-0806.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0806.cnf")
}

///|
test "uf20-0285.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0285.cnf")
}

///|
test "uf20-0984.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0984.cnf")
}

///|
test "uf20-0696.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0696.cnf")
}

///|
test "uf20-085.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-085.cnf")
}

///|
test "uf20-0423.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0423.cnf")
}

///|
test "uf20-0266.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0266.cnf")
}

///|
test "uf20-0592.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0592.cnf")
}

///|
test "uf20-0174.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0174.cnf")
}

///|
test "uf20-0408.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0408.cnf")
}

///|
test "uf20-0617.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0617.cnf")
}

///|
test "uf20-0366.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0366.cnf")
}

///|
test "uf20-0832.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0832.cnf")
}

///|
test "uf20-0567.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0567.cnf")
}

///|
test "uf20-0838.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0838.cnf")
}

///|
test "uf20-018.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-018.cnf")
}

///|
test "uf20-074.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-074.cnf")
}

///|
test "uf20-0863.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0863.cnf")
}

///|
test "uf20-040.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-040.cnf")
}

///|
test "uf20-0834.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0834.cnf")
}

///|
test "uf20-0982.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0982.cnf")
}

///|
test "uf20-033.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-033.cnf")
}

///|
test "uf20-0585.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0585.cnf")
}

///|
test "uf20-0808.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0808.cnf")
}

///|
test "uf20-0250.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0250.cnf")
}

///|
test "uf20-0920.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0920.cnf")
}

///|
test "uf20-0783.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0783.cnf")
}

///|
test "uf20-093.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-093.cnf")
}

///|
test "uf20-0225.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0225.cnf")
}

///|
test "uf20-0958.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0958.cnf")
}

///|
test "uf20-0542.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0542.cnf")
}

///|
test "uf20-0897.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0897.cnf")
}

///|
test "uf20-0792.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0792.cnf")
}

///|
test "uf20-0763.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0763.cnf")
}

///|
test "uf20-015.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-015.cnf")
}

///|
test "uf20-0560.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0560.cnf")
}

///|
test "uf20-0549.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0549.cnf")
}

///|
test "uf20-0327.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0327.cnf")
}

///|
test "uf20-0748.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0748.cnf")
}

///|
test "uf20-0633.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0633.cnf")
}

///|
test "uf20-0862.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0862.cnf")
}

///|
test "uf20-0498.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0498.cnf")
}

///|
test "uf20-0933.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0933.cnf")
}

///|
test "uf20-0873.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0873.cnf")
}

///|
test "uf20-055.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-055.cnf")
}

///|
test "uf20-0830.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0830.cnf")
}

///|
test "uf20-0571.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0571.cnf")
}

///|
test "uf20-0840.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0840.cnf")
}

///|
test "uf20-0289.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0289.cnf")
}

///|
test "uf20-0176.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0176.cnf")
}

///|
test "uf20-0972.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0972.cnf")
}

///|
test "uf20-0137.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0137.cnf")
}

///|
test "uf20-0312.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0312.cnf")
}

///|
test "uf20-076.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-076.cnf")
}

///|
test "uf20-0413.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0413.cnf")
}

///|
test "uf20-0424.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0424.cnf")
}

///|
test "uf20-0767.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0767.cnf")
}

///|
test "uf20-0774.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0774.cnf")
}

///|
test "uf20-0396.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0396.cnf")
}

///|
test "uf20-0469.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0469.cnf")
}

///|
test "uf20-0336.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0336.cnf")
}

///|
test "uf20-0665.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0665.cnf")
}

///|
test "uf20-0583.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0583.cnf")
}

///|
test "uf20-0939.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0939.cnf")
}

///|
test "uf20-0479.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0479.cnf")
}

///|
test "uf20-0912.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0912.cnf")
}

///|
test "uf20-0773.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0773.cnf")
}

///|
test "uf20-030.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-030.cnf")
}

///|
test "uf20-0465.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0465.cnf")
}

///|
test "uf20-0411.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0411.cnf")
}

///|
test "uf20-0826.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0826.cnf")
}

///|
test "uf20-0271.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0271.cnf")
}

///|
test "uf20-0118.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0118.cnf")
}

///|
test "uf20-0674.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0674.cnf")
}

///|
test "uf20-0704.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0704.cnf")
}

///|
test "uf20-0728.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0728.cnf")
}

///|
test "uf20-0622.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0622.cnf")
}

///|
test "uf20-0211.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0211.cnf")
}

///|
test "uf20-0551.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0551.cnf")
}

///|
test "uf20-0875.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0875.cnf")
}

///|
test "uf20-0989.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0989.cnf")
}

///|
test "uf20-0883.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0883.cnf")
}

///|
test "uf20-0734.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0734.cnf")
}

///|
test "uf20-0681.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0681.cnf")
}

///|
test "uf20-0286.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0286.cnf")
}

///|
test "uf20-0248.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0248.cnf")
}

///|
test "uf20-0787.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0787.cnf")
}

///|
test "uf20-0640.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0640.cnf")
}

///|
test "uf20-0518.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0518.cnf")
}

///|
test "uf20-0735.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0735.cnf")
}

///|
test "uf20-0579.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0579.cnf")
}

///|
test "uf20-0921.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0921.cnf")
}

///|
test "uf20-0346.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0346.cnf")
}

///|
test "uf20-0910.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0910.cnf")
}

///|
test "uf20-0949.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0949.cnf")
}

///|
test "uf20-0769.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0769.cnf")
}

///|
test "uf20-0725.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0725.cnf")
}

///|
test "uf20-0866.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0866.cnf")
}

///|
test "uf20-0756.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0756.cnf")
}

///|
test "uf20-0252.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0252.cnf")
}

///|
test "uf20-0605.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0605.cnf")
}

///|
test "uf20-0514.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0514.cnf")
}

///|
test "uf20-013.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-013.cnf")
}

///|
test "uf20-0319.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0319.cnf")
}

///|
test "uf20-057.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-057.cnf")
}

///|
test "uf20-0493.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0493.cnf")
}

///|
test "uf20-0759.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0759.cnf")
}

///|
test "uf20-0589.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0589.cnf")
}

///|
test "uf20-0320.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0320.cnf")
}

///|
test "uf20-0971.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0971.cnf")
}

///|
test "uf20-0951.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0951.cnf")
}

///|
test "uf20-0807.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0807.cnf")
}

///|
test "uf20-0772.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0772.cnf")
}

///|
test "uf20-0294.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0294.cnf")
}

///|
test "uf20-0974.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0974.cnf")
}

///|
test "uf20-0750.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0750.cnf")
}

///|
test "uf20-0505.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0505.cnf")
}

///|
test "uf20-0421.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0421.cnf")
}

///|
test "uf20-0511.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0511.cnf")
}

///|
test "uf20-0317.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0317.cnf")
}

///|
test "uf20-0244.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0244.cnf")
}

///|
test "uf20-0384.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0384.cnf")
}

///|
test "uf20-0970.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0970.cnf")
}

///|
test "uf20-0460.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0460.cnf")
}

///|
test "uf20-0412.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0412.cnf")
}

///|
test "uf20-0418.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0418.cnf")
}

///|
test "uf20-0986.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0986.cnf")
}

///|
test "uf20-0904.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0904.cnf")
}

///|
test "uf20-0371.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0371.cnf")
}

///|
test "uf20-0263.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0263.cnf")
}

///|
test "uf20-0805.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0805.cnf")
}

///|
test "uf20-0874.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0874.cnf")
}

///|
test "uf20-0188.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0188.cnf")
}

///|
test "uf20-0950.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0950.cnf")
}

///|
test "uf20-087.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-087.cnf")
}

///|
test "uf20-0474.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0474.cnf")
}

///|
test "uf20-0287.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0287.cnf")
}

///|
test "uf20-0463.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0463.cnf")
}

///|
test "uf20-0131.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0131.cnf")
}

///|
test "uf20-0430.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0430.cnf")
}

///|
test "uf20-0835.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0835.cnf")
}

///|
test "uf20-0946.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0946.cnf")
}

///|
test "uf20-046.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-046.cnf")
}

///|
test "uf20-0666.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0666.cnf")
}

///|
test "uf20-0943.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0943.cnf")
}

///|
test "uf20-0857.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0857.cnf")
}

///|
test "uf20-0606.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0606.cnf")
}

///|
test "uf20-0968.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0968.cnf")
}

///|
test "uf20-0476.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0476.cnf")
}

///|
test "uf20-0528.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0528.cnf")
}

///|
test "uf20-0955.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0955.cnf")
}

///|
test "uf20-0882.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0882.cnf")
}

///|
test "uf20-0707.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0707.cnf")
}

///|
test "uf20-0357.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0357.cnf")
}

///|
test "uf20-0686.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0686.cnf")
}

///|
test "uf20-0953.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0953.cnf")
}

///|
test "uf20-0147.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0147.cnf")
}

///|
test "uf20-0323.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0323.cnf")
}

///|
test "uf20-0538.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0538.cnf")
}

///|
test "uf20-0441.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0441.cnf")
}

///|
test "uf20-0649.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0649.cnf")
}

///|
test "uf20-023.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-023.cnf")
}

///|
test "uf20-038.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-038.cnf")
}

///|
test "uf20-0765.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0765.cnf")
}

///|
test "uf20-0858.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0858.cnf")
}

///|
test "uf20-0166.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0166.cnf")
}

///|
test "uf20-036.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-036.cnf")
}

///|
test "uf20-0934.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0934.cnf")
}

///|
test "uf20-0588.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0588.cnf")
}

///|
test "uf20-0782.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0782.cnf")
}

///|
test "uf20-0145.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0145.cnf")
}

///|
test "uf20-0219.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0219.cnf")
}

///|
test "uf20-052.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-052.cnf")
}

///|
test "uf20-0431.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0431.cnf")
}

///|
test "uf20-0440.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0440.cnf")
}

///|
test "uf20-0923.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0923.cnf")
}

///|
test "uf20-0841.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0841.cnf")
}

///|
test "uf20-0160.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0160.cnf")
}

///|
test "uf20-0960.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0960.cnf")
}

///|
test "uf20-0607.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0607.cnf")
}

///|
test "uf20-0672.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0672.cnf")
}

///|
test "uf20-0594.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0594.cnf")
}

///|
test "uf20-069.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-069.cnf")
}

///|
test "uf20-044.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-044.cnf")
}

///|
test "uf20-0280.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0280.cnf")
}

///|
test "uf20-0789.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0789.cnf")
}

///|
test "uf20-056.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-056.cnf")
}

///|
test "uf20-0473.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0473.cnf")
}

///|
test "uf20-043.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-043.cnf")
}

///|
test "uf20-0578.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0578.cnf")
}

///|
test "uf20-0593.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0593.cnf")
}

///|
test "uf20-09.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-09.cnf")
}

///|
test "uf20-0723.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0723.cnf")
}

///|
test "uf20-0239.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0239.cnf")
}

///|
test "uf20-0333.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0333.cnf")
}

///|
test "uf20-0926.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0926.cnf")
}

///|
test "uf20-0149.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0149.cnf")
}

///|
test "uf20-0298.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0298.cnf")
}

///|
test "uf20-0651.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0651.cnf")
}

///|
test "uf20-0501.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0501.cnf")
}

///|
test "uf20-0361.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0361.cnf")
}

///|
test "uf20-0506.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0506.cnf")
}

///|
test "uf20-0321.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0321.cnf")
}

///|
test "uf20-0256.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0256.cnf")
}

///|
test "uf20-0879.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0879.cnf")
}

///|
test "uf20-0439.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0439.cnf")
}

///|
test "uf20-0215.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0215.cnf")
}

///|
test "uf20-0887.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0887.cnf")
}

///|
test "uf20-0818.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0818.cnf")
}

///|
test "uf20-0207.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0207.cnf")
}

///|
test "uf20-0604.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0604.cnf")
}

///|
test "uf20-0385.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0385.cnf")
}

///|
test "uf20-0340.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0340.cnf")
}

///|
test "uf20-0419.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0419.cnf")
}

///|
test "uf20-0324.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0324.cnf")
}

///|
test "uf20-0800.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0800.cnf")
}

///|
test "uf20-0426.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0426.cnf")
}

///|
test "uf20-0744.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0744.cnf")
}

///|
test "uf20-0586.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0586.cnf")
}

///|
test "uf20-0915.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0915.cnf")
}

///|
test "uf20-0532.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0532.cnf")
}

///|
test "uf20-0522.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0522.cnf")
}

///|
test "uf20-0911.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0911.cnf")
}

///|
test "uf20-0268.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0268.cnf")
}

///|
test "uf20-0255.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0255.cnf")
}

///|
test "uf20-0395.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0395.cnf")
}

///|
test "uf20-0269.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0269.cnf")
}

///|
test "uf20-0973.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0973.cnf")
}

///|
test "uf20-0108.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0108.cnf")
}

///|
test "uf20-0836.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0836.cnf")
}

///|
test "uf20-0165.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0165.cnf")
}

///|
test "uf20-0930.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0930.cnf")
}

///|
test "uf20-0235.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0235.cnf")
}

///|
test "uf20-0499.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0499.cnf")
}

///|
test "uf20-091.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-091.cnf")
}

///|
test "uf20-0326.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0326.cnf")
}

///|
test "uf20-0144.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0144.cnf")
}

///|
test "uf20-0856.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0856.cnf")
}

///|
test "uf20-0853.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0853.cnf")
}

///|
test "uf20-0315.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0315.cnf")
}

///|
test "uf20-0878.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0878.cnf")
}

///|
test "uf20-0345.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0345.cnf")
}

///|
test "uf20-0876.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0876.cnf")
}

///|
test "uf20-0609.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0609.cnf")
}

///|
test "uf20-0722.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0722.cnf")
}

///|
test "uf20-0999.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0999.cnf")
}

///|
test "uf20-0227.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0227.cnf")
}

///|
test "uf20-0749.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0749.cnf")
}

///|
test "uf20-0556.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0556.cnf")
}

///|
test "uf20-0138.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0138.cnf")
}

///|
test "uf20-0638.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0638.cnf")
}

///|
test "uf20-0143.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0143.cnf")
}

///|
test "uf20-0822.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0822.cnf")
}

///|
test "uf20-0580.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0580.cnf")
}

///|
test "uf20-0631.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0631.cnf")
}

///|
test "uf20-0500.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0500.cnf")
}

///|
test "uf20-0330.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0330.cnf")
}

///|
test "uf20-0369.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0369.cnf")
}

///|
test "uf20-0359.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0359.cnf")
}

///|
test "uf20-011.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-011.cnf")
}

///|
test "uf20-0896.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0896.cnf")
}

///|
test "uf20-0998.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0998.cnf")
}

///|
test "uf20-07.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-07.cnf")
}

///|
test "uf20-070.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-070.cnf")
}

///|
test "uf20-0365.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0365.cnf")
}

///|
test "uf20-0388.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0388.cnf")
}

///|
test "uf20-0865.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0865.cnf")
}

///|
test "uf20-0639.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0639.cnf")
}

///|
test "uf20-0151.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0151.cnf")
}

///|
test "uf20-0218.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0218.cnf")
}

///|
test "uf20-0842.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0842.cnf")
}

///|
test "uf20-0383.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0383.cnf")
}

///|
test "uf20-0924.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0924.cnf")
}

///|
test "uf20-0451.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0451.cnf")
}

///|
test "uf20-0130.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0130.cnf")
}

///|
test "uf20-0694.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0694.cnf")
}

///|
test "uf20-0565.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0565.cnf")
}

///|
test "uf20-0152.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0152.cnf")
}

///|
test "uf20-0715.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0715.cnf")
}

///|
test "uf20-0228.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0228.cnf")
}

///|
test "uf20-0864.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0864.cnf")
}

///|
test "uf20-0572.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0572.cnf")
}

///|
test "uf20-0705.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0705.cnf")
}

///|
test "uf20-0635.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0635.cnf")
}

///|
test "uf20-0797.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0797.cnf")
}

///|
test "uf20-0941.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0941.cnf")
}

///|
test "uf20-0564.cnf" {
  test_sat("./dimacs/uf20v91c/uf20-0564.cnf")
}
