#[test]
fn test0_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-1,  s10:-28,  s10:0,  s10:0,  s10:0,  s10:-2, s10:0,  s10:5],
      [s10:0,   s10:0,    s10:0,  s10:7,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0]
    ];
    
    let start_pix = u8:12;
    let pre_start_pix = u8:0;
    let expected_output: bits[16] = bits[16]:0b111111110011;     
    let expected_length: u8 = u8:12;
    let expected_code: bits[8] = bits[8]:0;  
    let expected_code_size: u8 = u8:0;  
    let expected_next_pix: u8 = u8:13;   
    let expected_value: s10 = s10:0;            
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, actual_value): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, start_pix, pre_start_pix, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(actual_value);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(expected_value, actual_value);
}

  

#[test]
fn test0_gray8x8_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-1,  s10:-28,  s10:0,  s10:0,  s10:0,  s10:-2, s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:-1, s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0]
    ];
    
    let start_pix = u8:1;
    let pre_start_pix = u8:0;
    let expected_output: bits[16] = bits[16]:0b11010;     
    let expected_length: u8 = u8:5;
    let expected_code: bits[8] = bits[8]:227;  
    let expected_code_size: u8 = u8:5;  
    let expected_next_pix: u8 = u8:1;   
    let expected_value: s10 = s10:-28;            
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, actual_value): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, start_pix, pre_start_pix, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(actual_value);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(expected_value, actual_value);
}



#[test]
fn test1_gray8x8_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-1,  s10:-28,  s10:0,  s10:0,  s10:0,  s10:-2, s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:-1, s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,   s10:0,    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0]
    ];
    
    let start_pix = u8:2;
    let pre_start_pix = u8:1;
    let expected_output: bits[16] = bits[16]:0b111110110;     
    let expected_length: u8 = u8:9;
    let expected_code: bits[8] = bits[8]:253;  
    let expected_code_size: u8 = u8:2;  
    let expected_next_pix: u8 = u8:4;   
    let expected_value: s10 = s10:0;            
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, actual_value): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, start_pix, pre_start_pix, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(actual_value);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(expected_value, actual_value);
}


  
  
  
  