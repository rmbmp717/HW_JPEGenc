
// =======================
// 以下はHuffman_ACenc.x テストケース
// =======================
#[test]
fn test_v0_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:0,  s10:11, s10:5,  s10:4,  s10:10, s10:6,  s10:2,  s10:4],
      [s10:4,  s10:4,  s10:3,  s10:2,  s10:4,  s10:2,  s10:2,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0]
    ];

    let expected_output: bits[16] = bits[16]:501;     
    let expected_length: u8 = u8:9;             
    let expected_code: bits[8] = bits[8]:11;  
    let expected_code_size: u8 = u8:4;  
    let expected_next_pix: u8 = u8:1;                 
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:1, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(actual_code_size, expected_code_size);
}

#[test]
fn test_v1_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:0,  s10:11, s10:5,  s10:4,  s10:10, s10:6,  s10:2,  s10:4],
      [s10:4,  s10:4,  s10:3,  s10:2,  s10:4,  s10:2,  s10:2,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0],
      [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0]
    ];

    let expected_output: bits[16] = bits[16]:0b100;     
    let expected_length: u8 = u8:3;             
    let expected_code: bits[8] = bits[8]:0b101;  
    let expected_code_size: u8 = u8:3;  
    let expected_next_pix: u8 = u8:1;                        
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:2, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(actual_code_size, expected_code_size);
}

#[test]
fn test0_Huffman_ACenc_allzero() {
    let test_matrix: s10[8][8] = [
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0]
    ];

    let expected_output: bits[16] = bits[16]:0b01;     
    let expected_length: u8 = u8:2;             
    let expected_code: bits[8] = bits[8]:0b1111_1111;  
    let expected_code_size: u8 = u8:0;  
    let expected_next_pix: u8 = u8:63;               
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:1, false);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(expected_next_pix, actual_next_pix);
    assert_eq(actual_code_size, expected_code_size);
}

#[test]
fn test1_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:0, s10:0, s10:1, s10:1, s10:2, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0]
    ];

    let expected_output: bits[16] = bits[16]:0b11011;  
    let expected_length: u8 = u8:5;         
    let expected_code: bits[8] = bits[8]:1;   
    let expected_code_size: u8 = u8:1;    
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:2, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
}

#[test]
fn test2_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:5, s10:0, s10:0, s10:1, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0]
    ];

    let expected_output: bits[16] = bits[16]:0b1111111110010001;
    let expected_length: u8 = u8:16;         
    let expected_code: bits[8] = bits[8]:0b000_0101;    
    let expected_code_size: u8 = u8:3;         
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:9, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
}

#[test]
fn test3_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-15, s10:6,  s10:6, s10:0,  s10:5,  s10:0,  s10:-1, s10:0],
      [s10:0,   s10:-1, s10:0, s10:-1, s10:0,  s10:-1, s10:0,  s10:0],
      [s10:0,   s10:0,  s10:0, s10:0,  s10:-1, s10:-2, s10:0,  s10:0],
      [s10:0,   s10:0,  s10:0, s10:14, s10:0, s10:0, s10:0, s10:0],
      [s10:0,   s10:0,  s10:0, s10:1,  s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0],
      [s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0]
    ];
    // No.1
    trace!("No.1");
    let expected_output: bits[16] = bits[16]:0b0100;  
    let expected_length: u8 = u8:3;         
    let expected_code: bits[8] = bits[8]:6;
    let expected_code_size: u8 = u8:3;               
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:1, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);

    // No.2
    trace!("No.2");
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:2, true);  

    let expected_output: bits[16] = bits[16]:4;  
    let expected_length: u8 = u8:3;         
    let expected_code: bits[8] = bits[8]:6;
    let expected_code_size: u8 = u8:3;  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);

    // No.3
    trace!("No.3");
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:27, true);   

    let expected_output: bits[16] = bits[16]:65430;  
    let expected_length: u8 = u8:16;         
    let expected_code: bits[8] = bits[8]:14;
    let expected_code_size: u8 = u8:4;  
    let expected_next_pix: u8 = u8:8;              

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
}


#[test]
fn test4_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-17, s10:-13, s10:-1,   s10:0, s10:0,  s10:-1, s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:-1, s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:15, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0]
    ];
    let expected_output: bits[16] = bits[16]:27;  
    let expected_length: u8 = u8:5;         
    let expected_code: bits[8] = bits[8]:254;
    let expected_code_size: u8 = u8:1;    
    let expected_next_pix: u8 = u8:16;          
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:5, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
}

#[test]
fn test5_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:24,  s10:0,   s10:14,  s10:-9, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:4,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:2,  s10:3,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0]
    ];
    let expected_output: bits[16] = bits[16]:0b111110101;  
    let expected_length: u8 = u8:9;         
    let expected_code: bits[8] = bits[8]:14;
    let expected_code_size: u8 = u8:4;    
    let expected_next_pix: u8 = u8:2;          
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:1, true);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
}

#[test]
fn test6_Huffman_ACenc() {
    let test_matrix: s10[8][8] = [
      [s10:-12, s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:-1, s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:15, s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0],
      [s10:0,   s10:0,   s10:0,   s10:0,  s10:0,  s10:0,  s10:0, s10:0]
    ];
    let expected_output: bits[16] = bits[16]:0b01;  
    let expected_length: u8 = u8:2;         
    let expected_code: bits[8] = bits[8]:255;
    let expected_code_size: u8 = u8:0;    
    let expected_next_pix: u8 = u8:63;          
    let (actual_output, actual_length, actual_code, actual_code_size, actual_next_pix, now_pix_data): (bits[16], u8, bits[8], u8, u8, s10) 
                = Huffman_ACenc(test_matrix, u8:1, false);  

    trace!(actual_output);
    trace!(actual_length);
    trace!(actual_code);
    trace!(actual_code_size);
    trace!(actual_next_pix);
    trace!(now_pix_data);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
    assert_eq(actual_code, expected_code);
    assert_eq(actual_code_size, expected_code_size);
    assert_eq(expected_next_pix, actual_next_pix);
}




// =======================
// 過去のテストケース
// =======================
#[test]
fn test1_count_run() {
  let ac1: s10[63] = 
    [s10:-13, s10:0,   s10:0, s10:0,  s10:-1, s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:-1, s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:15, s10:0,  s10:0,  s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0,
     s10:0,   s10:0,   s10:0,   s10:0, s10:0,  s10:0,  s10:0, s10:0];

  // 各テストケース
  let result1: u8 = count_run(ac1, u32:4);

  // 期待値と比較
  assert_eq(result1, u8:3); 

}