// NISHIHARU
// DSLX function to conditionally reverse an array of 64 elements, each 10 bits wide

// Helper constant: Initialize a 64-element array with all zeros
const ZERO64: s10[64] = [
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
];
  
fn Data_flip64(data_in: s10[64], is_flip: bool) -> s10[64] {
  // Use a zero-initialized array as an accumulator for the for-loop
  let result: s10[64] = for (i, acc): (u32, s10[64]) in range(u32:0, u32:64) {
    // If the flip flag is set, reverse the index
    let src_index: u32 = if is_flip { u32:63 - i } else { i };
    // Use the global function update(acc, i, new_val) to update the array
    update(acc, i, data_in[src_index])
  }(ZERO64);
  result
}
  
#[test]
fn test0() -> () {
    let input_data: s10[64] = [
      s10:1, s10:2, s10:3, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:63, s10:64
    ];
    let exp_data: s10[64] = [
      s10:64,s10:63,s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:3, s10:2, s10:1
    ];
    
    
    let result = Data_flip64(input_data, true);
    trace!(result);
    assert_eq(result, exp_data);
}
