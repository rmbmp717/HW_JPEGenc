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

// AC 配列 ac のうち、インデックス start から連続する 0 の数をカウントする関数
// 最大で15個までカウントし、途中で0以外の値が出たらそこで打ち切る
fn count_run(ac: u8[63], start: u32) -> u32 {
    if start >= u32:63 {
      u32:0
    } else if ac[start] != u8:0 {
      u32:0
    } else if start + u32:1 >= u32:63 || ac[start + u32:1] != u8:0 {
      u32:1
    } else if start + u32:2 >= u32:63 || ac[start + u32:2] != u8:0 {
      u32:2
    } else if start + u32:3 >= u32:63 || ac[start + u32:3] != u8:0 {
      u32:3
    } else if start + u32:4 >= u32:63 || ac[start + u32:4] != u8:0 {
      u32:4
    } else if start + u32:5 >= u32:63 || ac[start + u32:5] != u8:0 {
      u32:5
    } else if start + u32:6 >= u32:63 || ac[start + u32:6] != u8:0 {
      u32:6
    } else if start + u32:7 >= u32:63 || ac[start + u32:7] != u8:0 {
      u32:7
    } else if start + u32:8 >= u32:63 || ac[start + u32:8] != u8:0 {
      u32:8
    } else if start + u32:9 >= u32:63 || ac[start + u32:9] != u8:0 {
      u32:9
    } else if start + u32:10 >= u32:63 || ac[start + u32:10] != u8:0 {
      u32:10
    } else if start + u32:11 >= u32:63 || ac[start + u32:11] != u8:0 {
      u32:11
    } else if start + u32:12 >= u32:63 || ac[start + u32:12] != u8:0 {
      u32:12
    } else if start + u32:13 >= u32:63 || ac[start + u32:13] != u8:0 {
      u32:13
    } else if start + u32:14 >= u32:63 || ac[start + u32:14] != u8:0 {
      u32:14
    } else {
      u32:15
    }
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

// JPEG 標準の DCLuminance 用 Huffman 符号表
// 各タプルは (code, length) で、code は 8 ビットのビット列（上位に有効ビット、下位はパディング）
// length は実際に有効なビット数を表します。
const DC_LUMINANCE_SIZE_TO_CODE: (bits[8], u8)[12] = [
  (bits[8]:0b11000000, u8:3),  // [1,1,0] → 3ビット
  (bits[8]:0b10100000, u8:3),  // [1,0,1] → 3ビット
  (bits[8]:0b01100000, u8:3),  // [0,1,1] → 3ビット
  (bits[8]:0b01000000, u8:3),  // [0,1,0] → 3ビット
  (bits[8]:0b00000000, u8:3),  // [0,0,0] → 3ビット
  (bits[8]:0b00100000, u8:3),  // [0,0,1] → 3ビット
  (bits[8]:0b10000000, u8:3),  // [1,0,0] → 3ビット
  (bits[8]:0b11100000, u8:4),  // [1,1,1,0] → 4ビット
  (bits[8]:0b11110000, u8:5),  // [1,1,1,1,0] → 5ビット
  (bits[8]:0b11111000, u8:6),  // [1,1,1,1,1,0] → 6ビット
  (bits[8]:0b11111100, u8:7),  // [1,1,1,1,1,1,0] → 7ビット
  (bits[8]:0b11111110, u8:8)   // [1,1,1,1,1,1,1,0] → 8ビット
];

// lookup 関数：与えられたインデックス (u8) に対応する Huffman コードとビット長を返す
fn lookup_DCLuminanceSizeToCode(index: u8) -> (bits[8], u8) {
    DC_LUMINANCE_SIZE_TO_CODE[index]
}

// JPEG 標準の DCChrominance 用 Huffman 符号表
// 各タプルは (code, length) で、code は 8 ビットのビット列（上位に有効ビット、下位はパディング）
// length は実際に有効なビット数を表します。
const DC_CHROMINANCE_SIZE_TO_CODE: (bits[8], u8)[12] = [
  (bits[8]:0b00000010, u8:2),  // [0,1] → 2ビット (EOB)
  (bits[8]:0b00000000, u8:2),  // [0,0] → 2ビット
  (bits[8]:0b00100000, u8:3),  // [1,0,0] → 3ビット
  (bits[8]:0b00101000, u8:3),  // [1,0,1] → 3ビット
  (bits[8]:0b01100000, u8:4),  // [1,1,0,0] → 4ビット
  (bits[8]:0b01101000, u8:4),  // [1,1,0,1] → 4ビット
  (bits[8]:0b01110000, u8:4),  // [1,1,1,0] → 4ビット
  (bits[8]:0b01111000, u8:5),  // [1,1,1,1,0] → 5ビット
  (bits[8]:0b01111100, u8:6),  // [1,1,1,1,1,0] → 6ビット
  (bits[8]:0b01111110, u8:7),  // [1,1,1,1,1,1,0] → 7ビット
  (bits[8]:0b01111111, u8:8),  // [1,1,1,1,1,1,1,0] → 8ビット
  (bits[8]:0b11111110, u8:9)   // [1,1,1,1,1,1,1,1,0] → 9ビット
];

// lookup 関数：与えられたインデックス (u8) に対応する Huffman コードとビット長を返す
fn lookup_ChrominanceSizeToCode(index: u8) -> (bits[8], u8) {
    DC_CHROMINANCE_SIZE_TO_CODE[index]
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

// AC 成分（63 要素）を取得する関数
fn get_dc(flat: u8[64]) -> u8 {
    let dc: u8 = flat[0];
    dc
}


// DC 成分の Huffman 符号化（ループなし）
fn encode_dc(dc_value: u8, is_luminance: bool) -> (bits[8], u8, bits[8]) {

    let size: u8 = bit_length(dc_value);

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
        [u8:1, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bits[8] = bits[8]:0b1010_0000;     
    let expected_length: u8 = u8:3;  
    let expected_code: bits[8] = bits[8]:1;                
    let (BooList, Length, CodeList): (bits[8], u8, bits[8]) = Huffman_DCenc(test_matrix, true);  

    assert_eq(BooList, expected_output);
    assert_eq(Length, expected_length);
    assert_eq(CodeList, expected_code);
}

#[test]
fn test_lookup_DCLuminanceSizeToCode() {
  let (code1, length1): (bits[8], u8) = lookup_DCLuminanceSizeToCode(u8:0);
  let (code2, length2): (bits[8], u8) = lookup_DCLuminanceSizeToCode(u8:9);

  trace!(code1);    // 0b11000000
  trace!(length1);  // 3

  trace!(code2);    // 0b11111000
  trace!(length2);  // 6

  assert_eq(length1, u8:3);
  assert_eq(length2, u8:6);
}