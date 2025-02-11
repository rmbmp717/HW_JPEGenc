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

// AC 成分（63 要素）のすべてが 0 かどうか判定する関数
fn is_all_zero(ac: u8[63]) -> bool {
    ac[0]  == u8:0 &&
    ac[1]  == u8:0 &&
    ac[2]  == u8:0 &&
    ac[3]  == u8:0 &&
    ac[4]  == u8:0 &&
    ac[5]  == u8:0 &&
    ac[6]  == u8:0 &&
    ac[7]  == u8:0 &&
    ac[8]  == u8:0 &&
    ac[9]  == u8:0 &&
    ac[10] == u8:0 &&
    ac[11] == u8:0 &&
    ac[12] == u8:0 &&
    ac[13] == u8:0 &&
    ac[14] == u8:0 &&
    ac[15] == u8:0 &&
    ac[16] == u8:0 &&
    ac[17] == u8:0 &&
    ac[18] == u8:0 &&
    ac[19] == u8:0 &&
    ac[20] == u8:0 &&
    ac[21] == u8:0 &&
    ac[22] == u8:0 &&
    ac[23] == u8:0 &&
    ac[24] == u8:0 &&
    ac[25] == u8:0 &&
    ac[26] == u8:0 &&
    ac[27] == u8:0 &&
    ac[28] == u8:0 &&
    ac[29] == u8:0 &&
    ac[30] == u8:0 &&
    ac[31] == u8:0 &&
    ac[32] == u8:0 &&
    ac[33] == u8:0 &&
    ac[34] == u8:0 &&
    ac[35] == u8:0 &&
    ac[36] == u8:0 &&
    ac[37] == u8:0 &&
    ac[38] == u8:0 &&
    ac[39] == u8:0 &&
    ac[40] == u8:0 &&
    ac[41] == u8:0 &&
    ac[42] == u8:0 &&
    ac[43] == u8:0 &&
    ac[44] == u8:0 &&
    ac[45] == u8:0 &&
    ac[46] == u8:0 &&
    ac[47] == u8:0 &&
    ac[48] == u8:0 &&
    ac[49] == u8:0 &&
    ac[50] == u8:0 &&
    ac[51] == u8:0 &&
    ac[52] == u8:0 &&
    ac[53] == u8:0 &&
    ac[54] == u8:0 &&
    ac[55] == u8:0 &&
    ac[56] == u8:0 &&
    ac[57] == u8:0 &&
    ac[58] == u8:0 &&
    ac[59] == u8:0 &&
    ac[60] == u8:0 &&
    ac[61] == u8:0 &&
    ac[62] == u8:0
  }
  

// AC 成分（63 要素）を取得する関数
fn get_ac(flat: u8[64]) -> u8[63] {
    let ac: u8[63] = [
        flat[1], flat[2], flat[3], flat[4], flat[5], flat[6], flat[7], flat[8],
        flat[9], flat[10], flat[11], flat[12], flat[13], flat[14], flat[15], flat[16],
        flat[17], flat[18], flat[19], flat[20], flat[21], flat[22], flat[23], flat[24],
        flat[25], flat[26], flat[27], flat[28], flat[29], flat[30], flat[31], flat[32],
        flat[33], flat[34], flat[35], flat[36], flat[37], flat[38], flat[39], flat[40],
        flat[41], flat[42], flat[43], flat[44], flat[45], flat[46], flat[47], flat[48],
        flat[49], flat[50], flat[51], flat[52], flat[53], flat[54], flat[55], flat[56],
        flat[57], flat[58], flat[59], flat[60], flat[61], flat[62], flat[63]
    ];
    ac
}

// AC 配列 ac のうち、インデックス start から連続する 0 の数をカウントする
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
fn bit_length(x: u8) -> u32 {
    if x == u8:0 {
        u32:0
    } else if x >= u8:128 {
        u32:8
    } else if x >= u8:64 {
        u32:7
    } else if x >= u8:32 {
        u32:6
    } else if x >= u8:16 {
        u32:5
    } else if x >= u8:8 {
        u32:4
    } else if x >= u8:4 {
        u32:3
    } else if x >= u8:2 {
        u32:2
    } else {
        u32:1
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

// AC 成分の Huffman 符号化（ループなし）
fn encode_ac(ac: u8[63], is_luminance: bool) -> (bits[16], u8) {
    let run: u32 = count_run(ac, u32:0);
    trace!(ac);
    trace!(run);

    // すべて 0 なら EOB を返す
    if run == u32:63 {
        (EOB_LUM_EXT, bits[8]:4)
    } else {
        let value: u8 = ac[run];  // `run` の次の非ゼロ値
        let size: u32 = bit_length(value);
        let run_size_str: u8[2] = encode_run_size(run, size);

        trace!(value);
        trace!(size);
        trace!(run_size_str);

        // Huffman テーブルを参照
        let (huffman_code_full, huffman_length): (bits[16], u8) =
            if is_luminance {
                lookup_huffman_lum(run_size_str)
            } else {
                lookup_huffman_chrom(run_size_str)
            };

        trace!(huffman_code_full);
        trace!(huffman_length);        

        (huffman_code_full, huffman_length)
    }
}
 
// メイン関数
fn Huffman_enc(matrix: u8[8][8]) -> (bits[16], u8) {
    let flat: u8[64] = flatten(matrix);
    let ac: u8[63] = get_ac(flat);

    if is_all_zero(ac) {
        (bits[16]:0b1100, u8:4)  // EOB（ルミナンス用）
    } else {
        encode_ac(ac, true)  // Luminance 用 Huffman 符号化
    }
}

// =======================
// 以下はテストケース
// =======================

#[test]
fn test_encode_run_size() {
  let run: u32 = u32:10;
  let size: u32 = u32:2;
  let result: u8[2] = encode_run_size(run, size);
  // 期待される結果は ['A', '2'] つまり [u8:65, u8:50]
  let expected: u8[2] = [u8:65, u8:50];
  assert_eq(result, expected);
}

#[test]
fn test0_Huffman_enc() {
    let test_matrix: u8[8][8] = [
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bits[16] = bits[16]:0b1100;     
    let expected_length: u8 = u8:4;             
    let (actual_output, actual_length): (bits[16], u8) = Huffman_enc(test_matrix);  

    trace!(actual_output);
    trace!(actual_length);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
}

#[test]
fn test1_Huffman_enc() {
    let test_matrix: u8[8][8] = [
        [u8:2, u8:0, u8:0, u8:8, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bits[16] = bits[16]:0b0011;  
    let expected_length: u8 = u8:4;         
    let (actual_output, actual_length): (bits[16], u8) = Huffman_enc(test_matrix);  

    trace!(actual_output);
    trace!(actual_length);

    assert_eq(actual_output, expected_output);
    assert_eq(actual_length, expected_length);
}

// =======================
// 過去のテストケース
// =======================
#[test]
fn test_count_run() {
    let ac1: u8[63] = [ // 先頭 10 個が 0
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:5, u8:6, u8:7, u8:8, u8:9, u8:10, u8:11, u8:12, u8:13, u8:14,
        u8:15, u8:16, u8:17, u8:18, u8:19, u8:20, u8:21, u8:22, u8:23, u8:24,
        u8:25, u8:26, u8:27, u8:28, u8:29, u8:30, u8:31, u8:32, u8:33, u8:34,
        u8:35, u8:36, u8:37, u8:38, u8:39, u8:40, u8:41, u8:42, u8:43, u8:44,
        u8:45, u8:46, u8:47, u8:48, u8:49, u8:50, u8:51, u8:52, u8:53, u8:3,
        u8:45, u8:46, u8:47
    ];
    
    let ac2: u8[63] = [ // 先頭 15 個が 0
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:1, u8:2, u8:3, u8:4, u8:5, u8:6, u8:7, u8:8, u8:9, u8:10,
        u8:11, u8:12, u8:13, u8:14, u8:15, u8:16, u8:17, u8:18, u8:19, u8:20,
        u8:21, u8:22, u8:23, u8:24, u8:25, u8:26, u8:27, u8:28, u8:29, u8:30,
        u8:31, u8:32, u8:33, u8:34, u8:35, u8:36, u8:37, u8:38, u8:39, u8:40,
        u8:41, u8:42, u8:43, u8:44, u8:45, u8:43, u8:44, u8:45
    ];

    let ac3: u8[63] = [ // すべて 0
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:43, u8:44, u8:45, u8:5
    ];
    
    let ac4: u8[63] = [ // すべて 0 ではない
        u8:1, u8:2, u8:3, u8:4, u8:5, u8:6, u8:7, u8:8, u8:9, u8:10,
        u8:11, u8:12, u8:13, u8:14, u8:15, u8:16, u8:17, u8:18, u8:19, u8:20,
        u8:21, u8:22, u8:23, u8:24, u8:25, u8:26, u8:27, u8:28, u8:29, u8:30,
        u8:31, u8:32, u8:33, u8:34, u8:35, u8:36, u8:37, u8:38, u8:39, u8:40,
        u8:41, u8:42, u8:43, u8:44, u8:45, u8:46, u8:47, u8:48, u8:49, u8:50,
        u8:51, u8:52, u8:53, u8:54, u8:55, u8:56, u8:57, u8:58, u8:59, u8:5,
        u8:51, u8:52, u8:53
    ];

    let ac5: u8[63] = [ // 先頭 2個が 0
        u8:0, u8:0, u8:1, u8:1, u8:1, u8:0, u8:0, u8:0, u8:0, u8:0,
        u8:5, u8:6, u8:7, u8:8, u8:9, u8:10, u8:11, u8:12, u8:13, u8:14,
        u8:15, u8:16, u8:17, u8:18, u8:19, u8:20, u8:21, u8:22, u8:23, u8:24,
        u8:25, u8:26, u8:27, u8:28, u8:29, u8:30, u8:31, u8:32, u8:33, u8:34,
        u8:35, u8:36, u8:37, u8:38, u8:39, u8:40, u8:41, u8:42, u8:43, u8:44,
        u8:45, u8:46, u8:47, u8:48, u8:49, u8:50, u8:51, u8:52, u8:53, u8:3,
        u8:45, u8:46, u8:47
    ];

    // 各テストケース
    let result1: u32 = count_run(ac1, u32:0);
    let result2: u32 = count_run(ac2, u32:0);
    let result3: u32 = count_run(ac3, u32:0);
    let result4: u32 = count_run(ac4, u32:0);
    let result5: u32 = count_run(ac5, u32:0);

    trace!(result1);
    trace!(result2);
    trace!(result3);
    trace!(result4);
    trace!(result5);

    // 期待値と比較
    assert_eq(result1, u32:10); // 最初の 10 個が 0
    assert_eq(result2, u32:15); // 最初の 15 個が 0
    assert_eq(result3, u32:15); // すべて 0 でも最大 15 まで
    assert_eq(result4, u32:0);  // すべて 0 でない
    assert_eq(result5, u32:2);  
}
