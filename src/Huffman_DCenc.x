// NISHIHARU

const EOB_LUM_EXT: bits[16] = bits[16]:0b1010;      // 仮の値
const EOB_CHR_EXT: bits[16] = bits[16]:0b00;        // 仮の値

// 8×8 の u8 行列を平坦化して 64 要素の u8 配列にする関数
fn flatten(matrix: u8[8][8]) -> u8[64] {
    let row0: u8[8] = matrix[0];
    let row1: u8[8] = matrix[1];
    let row2: u8[8] = matrix[2];
    let row3: u8[8] = matrix[3];
    let row4: u8[8] = matrix[4];
    let row5: u8[8] = matrix[5];
    let row6: u8[8] = matrix[6];
    let row7: u8[8] = matrix[7];

    let flat: u8[64] = row0 ++ row1 ++ row2 ++ row3 ++ row4 ++ row5 ++ row6 ++ row7;
    flat
}
  
// ビット数を求める関数
fn bit_length(x: u8) -> u8 {
    if x == u8:0 {
        u8:0
    } else if x >= u8:128 {
        u8:8
    } else if x >= u8:64 {
        u8:7
    } else if x >= u8:32 {
        u8:6
    } else if x >= u8:16 {
        u8:5
    } else if x >= u8:8 {
        u8:4
    } else if x >= u8:4 {
        u8:3
    } else if x >= u8:2 {
        u8:2
    } else {
        u8:1
    }
}

#[test]
fn bit_length_test () {
    let bit_value :u8 = u8: 33;
    let bit_length_out = bit_length(bit_value);
    trace!(bit_length_out);
}

// 0〜15 の整数を 16 進数の文字 (0-9, A-F) に変換
fn to_hex_digit(x: u32) -> u8 {
    if x < u32:10 {
        u8:48 + (x as u8)  // '0' (48) 〜 '9' (57)
    } else {
        u8:55 + (x as u8)  // 'A' (65) 〜 'F' (70)
    }
}

// run_size_str を符号化
fn encode_run_size(run: u32, size: u32) -> u8[2] {
    [to_hex_digit(run), to_hex_digit(size)]
}

// JPEG 標準の DCLuminance 用 Huffman 符号表（全エントリ版）
fn lookup_DCLuminanceSizeToCode(index: u8) -> (bits[8], u8) {
    trace!(index);
    match index {
      u8:0x00 => (bits[8]:0b11000000, u8:3),  // インデックス 0: [1,1,0] → 3ビット
      u8:0x01 => (bits[8]:0b10100000, u8:3),  // インデックス 1: [1,0,1] → 3ビット
      u8:0x02 => (bits[8]:0b01100000, u8:3),  // インデックス 2: [0,1,1] → 3ビット
      u8:0x03 => (bits[8]:0b01000000, u8:3),  // インデックス 3: [0,1,0] → 3ビット
      u8:0x04 => (bits[8]:0b00000000, u8:3),  // インデックス 4: [0,0,0] → 3ビット
      u8:0x05 => (bits[8]:0b00100000, u8:3),  // インデックス 5: [0,0,1] → 3ビット
      u8:0x06 => (bits[8]:0b10000000, u8:3),  // インデックス 6: [1,0,0] → 3ビット
      u8:0x07 => (bits[8]:0b11100000, u8:4),  // インデックス 7: [1,1,1,0] → 4ビット
      u8:0x08 => (bits[8]:0b11110000, u8:5),  // インデックス 8: [1,1,1,1,0] → 5ビット
      u8:0x09 => (bits[8]:0b11111000, u8:6),  // インデックス 9: [1,1,1,1,1,0] → 6ビット
      u8:0x0A => (bits[8]:0b11111100, u8:7),  // インデックス 10: [1,1,1,1,1,1,0] → 7ビット
      u8:0x0B => (bits[8]:0b11111110, u8:8),  // インデックス 11: [1,1,1,1,1,1,1,0] → 8ビット
      _       => (bits[8]:0, u8:0),
    }
}

#[test]
fn lookup_DCLuminanceSizeToCode_test() {
    let (code, length): (bits[8], u8) = lookup_DCLuminanceSizeToCode(u8:1);
    trace!(code);
    trace!(length);
    assert_eq(code, bits[8]:0b10100000);
    assert_eq(length, u8:3);
}

// JPEG 標準の DCChrominance 用 Huffman 符号表
// 各タプルは (code, length) で、code は 8 ビットのビット列（上位に有効ビット、下位はパディング）
// length は実際に有効なビット数を表します。
fn lookup_ChrominanceSizeToCode(index: u8) -> (bits[8], u8) {
    trace!(index);
    match index {
      u8:0x00 => (bits[8]:0b00000010, u8:2), // インデックス 0: [0,1] → 2ビット (EOB)
      u8:0x01 => (bits[8]:0b00000000, u8:2), // インデックス 1: [0,0] → 2ビット
      u8:0x02 => (bits[8]:0b00100000, u8:3), // インデックス 2: [1,0,0] → 3ビット
      u8:0x03 => (bits[8]:0b00101000, u8:3), // インデックス 3: [1,0,1] → 3ビット
      u8:0x04 => (bits[8]:0b01100000, u8:4), // インデックス 4: [1,1,0,0] → 4ビット
      u8:0x05 => (bits[8]:0b01101000, u8:4), // インデックス 5: [1,1,0,1] → 4ビット
      u8:0x06 => (bits[8]:0b01110000, u8:4), // インデックス 6: [1,1,1,0] → 4ビット
      u8:0x07 => (bits[8]:0b01111000, u8:5), // インデックス 7: [1,1,1,1,0] → 5ビット
      u8:0x08 => (bits[8]:0b01111100, u8:6), // インデックス 8: [1,1,1,1,1,0] → 6ビット
      u8:0x09 => (bits[8]:0b01111110, u8:7), // インデックス 9: [1,1,1,1,1,1,0] → 7ビット
      u8:0x0A => (bits[8]:0b01111111, u8:8), // インデックス 10: [1,1,1,1,1,1,1,0] → 8ビット
      u8:0x0B => (bits[8]:0b11111110, u8:9), // インデックス 11: [1,1,1,1,1,1,1,1,0] → 9ビット
      _       => (bits[8]:0, u8:0),
    }
}

#[test]
fn lookup_ChrominanceSizeToCode_test() {
    let (code, length): (bits[8], u8) = lookup_ChrominanceSizeToCode(u8:6);
    trace!(code);
    trace!(length);
    assert_eq(code, bits[8]:0b01110000);
    assert_eq(length, u8:4);
}

// Luminance 用の Huffman 符号を取得（符号 + ビット長を返す）
fn lookup_huffman_lum(run_size: u8[2]) -> (bits[16], u8) {
    if run_size == [u8:48, u8:48] {  // "00" → EOB
        (bits[16]:0b1010, u8:4)
    } else if run_size == [u8:48, u8:49] {  // "01"
        (bits[16]:0b00, u8:2)
    } else if run_size == [u8:48, u8:50] {  // "02"
        (bits[16]:0b01, u8:2)
    } else if run_size == [u8:48, u8:51] {  // "03"
        (bits[16]:0b100, u8:3)
    } else if run_size == [u8:48, u8:52] {  // "04"
        (bits[16]:0b1011, u8:4)
    } else if run_size == [u8:48, u8:53] {  // "05"
        (bits[16]:0b11010, u8:5)
    } else if run_size == [u8:48, u8:54] {  // "06"
        (bits[16]:0b1111000, u8:7)
    } else if run_size == [u8:48, u8:55] {  // "07"
        (bits[16]:0b11111000, u8:8)
    } else if run_size == [u8:48, u8:56] {  // "08"
        (bits[16]:0b1111110110, u8:10)
    } else if run_size == [u8:48, u8:57] {  // "09"
        (bits[16]:0b1111111110000010, u8:16)
    } else if run_size == [u8:48, u8:65] {  // "0A"
        (bits[16]:0b1111111110000011, u8:16)
    } else if run_size == [u8:49, u8:49] {  // "11"
        (bits[16]:0b1100, u8:4)
    } else if run_size == [u8:49, u8:50] {  // "12"
        (bits[16]:0b11011, u8:5)
    } else if run_size == [u8:49, u8:51] {  // "13"
        (bits[16]:0b1111001, u8:7)
    } else if run_size == [u8:49, u8:52] {  // "14"
        (bits[16]:0b111110110, u8:9)
    } else if run_size == [u8:49, u8:53] {  // "15"
        (bits[16]:0b11111110110, u8:11)
    } else if run_size == [u8:49, u8:54] {  // "16"
        (bits[16]:0b1111111110000100, u8:16)
    } else if run_size == [u8:49, u8:55] {  // "17"
        (bits[16]:0b1111111110000101, u8:16)
    } else if run_size == [u8:49, u8:56] {  // "18"
        (bits[16]:0b1111111110000110, u8:16)
    } else if run_size == [u8:49, u8:57] {  // "19"
        (bits[16]:0b1111111110000111, u8:16)
    } else if run_size == [u8:49, u8:65] {  // "1A"
        (bits[16]:0b1111111110001000, u8:16)
    } else {
        (bits[16]:0b0011, u8:4)  // 仮のエンコード結果（未登録）
    }
}

// Chrominance 用の Huffman 符号を取得
fn lookup_huffman_chrom(run_size: u8[2]) -> (bits[16], u8) {
    if run_size[0] == u8:48 && run_size[1] == u8:48 {
        (bits[16]:0b1110, u8:4)  // "00" → EOB
    } else {
        (bits[16]:0b0000, u8:4)  // 仮のエンコード結果
    }
}

// value を符号反転して符号化
fn encode_value(value: u8) -> bits[8] {
    let bit_0: bits[1] = ((value >> u8:7) & u8:1) as bits[1];
    let bit_1: bits[1] = ((value >> u8:6) & u8:1) as bits[1];
    let bit_2: bits[1] = ((value >> u8:5) & u8:1) as bits[1];
    let bit_3: bits[1] = ((value >> u8:4) & u8:1) as bits[1];
    let bit_4: bits[1] = ((value >> u8:3) & u8:1) as bits[1];
    let bit_5: bits[1] = ((value >> u8:2) & u8:1) as bits[1];
    let bit_6: bits[1] = ((value >> u8:1) & u8:1) as bits[1];
    let bit_7: bits[1] = ((value >> u8:0) & u8:1) as bits[1];

    let bits_value: bits[8] =
        (bit_0 as bits[8] << bits[8]:7) |
        (bit_1 as bits[8] << bits[8]:6) |
        (bit_2 as bits[8] << bits[8]:5) |
        (bit_3 as bits[8] << bits[8]:4) |
        (bit_4 as bits[8] << bits[8]:3) |
        (bit_5 as bits[8] << bits[8]:2) |
        (bit_6 as bits[8] << bits[8]:1) |
        (bit_7 as bits[8]);

    bits_value
}

// AC成分（64 要素）からDC成分を取得する関数
fn get_dc(flat: u8[64]) -> u8 {
    let dc: u8 = flat[0];
    dc
}

#[test]
fn test_get_dc() {
    let test_matrix: u8[8][8] = [
        [u8:7, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];
    let flat: u8[64] = flatten(test_matrix);
    let dc: u8 = get_dc(flat);
    trace!(dc);
    assert_eq(dc, u8:7);

}

// DC 成分の Huffman 符号化（ループなし）
fn encode_dc(dc_value: u8, is_luminance: bool) -> (bits[8], u8, bits[8]) {

    let size: u8 = bit_length(dc_value);
    trace!(dc_value);
    trace!(size);

    let (BoolList, length): (bits[8], u8) =
        if is_luminance {
            lookup_DCLuminanceSizeToCode(size)
        } else {
            lookup_ChrominanceSizeToCode(size)
        };

    trace!(BoolList);
    trace!(length);

    let dc_value_s16 = dc_value as s16;

    let code_list: bits[8] =
    if dc_value_s16 <= s16:0 {
        let bin_value: bits[8] = dc_value as bits[8];
        let flipped: bits[8] = !bin_value; // 反転
        flipped
    } else {
        let bin_value: bits[8] = dc_value as bits[8];
        bin_value
    };

    trace!(code_list);

    (BoolList, length, code_list)
}
 
// メイン関数
fn Huffman_DCenc(matrix: u8[8][8], is_luminance: bool) -> (bits[8], bits[8], u8) {
    let flat: u8[64] = flatten(matrix);
    let dc: u8 = get_dc(flat);

    trace!(dc);

    encode_dc(dc, is_luminance) 
}

// =======================
// 以下はテストケース
// =======================
// テストケース
#[test]
fn test0_Huffman_DCenc() {
    let test_matrix: u8[8][8] = [
        [u8:7, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bits[8] = bits[8]:0b01000000;     
    let expected_length: u8 = u8:3;  
    let expected_code: bits[8] = bits[8]:7;                
    let (BooList, Length, CodeList): (bits[8], u8, bits[8]) = Huffman_DCenc(test_matrix, true);  

    assert_eq(BooList, expected_output);
    assert_eq(Length, expected_length);
    assert_eq(CodeList, expected_code);
}

#[test]
fn test1_Huffman_DCenc() {
    let test_matrix: u8[8][8] = [
        [u8:33, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bits[8] = bits[8]:0b10000000;     
    let expected_length: u8 = u8:3;  
    let expected_code: bits[8] = bits[8]:33;                
    let (BooList, Length, CodeList): (bits[8], u8, bits[8]) = Huffman_DCenc(test_matrix, true);  

    assert_eq(BooList, expected_output);
    assert_eq(Length, expected_length);
    assert_eq(CodeList, expected_code);
}
