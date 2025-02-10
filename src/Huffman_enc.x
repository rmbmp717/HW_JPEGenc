// NISHIHARU

// ここではビットは bool で表す（true:1, false:0）。
// ルミナンス用 EOB コード（"00" に対応するコード）として [true, true, false, false] を定義
const EOB_LUM: bool[4] = [true, true, false, false];

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


fn Huffman_enc(matrix: u8[8][8]) -> bool[4] {
    let flat: u8[64] = flatten(matrix);
    let ac: u8[63] = get_ac(flat);

    if is_all_zero(ac) {
        EOB_LUM
    } else {
        // 実際の Huffman エンコード処理は未実装なので仮の値
        EOB_LUM
    }
}

#[test]
fn test_Huffman_enc() {
    let test_matrix: u8[8][8] = [
        [u8:2, u8:2, u8:1, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0],
        [u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0]
    ];

    let expected_output: bool[4] = EOB_LUM;
    let actual_output: bool[4] = Huffman_enc(test_matrix);

    trace!(actual_output);

    assert_eq(actual_output, expected_output);
}
