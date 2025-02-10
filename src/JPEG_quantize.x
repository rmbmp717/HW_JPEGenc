pub const N: u32 = u32:8;

// JPEG 標準の輝度量子化テーブル (s16)
pub const LUMINANCE_QUANT_TBL: s16[N][N] = [
    [s16:16, s16:11, s16:10, s16:16, s16:24, s16:40, s16:51, s16:61],
    [s16:12, s16:12, s16:14, s16:19, s16:26, s16:58, s16:60, s16:55],
    [s16:14, s16:13, s16:16, s16:24, s16:40, s16:57, s16:69, s16:56],
    [s16:14, s16:17, s16:22, s16:29, s16:51, s16:87, s16:80, s16:62],
    [s16:18, s16:22, s16:37, s16:56, s16:68, s16:109, s16:103, s16:77],
    [s16:24, s16:35, s16:55, s16:64, s16:81, s16:104, s16:113, s16:92],
    [s16:49, s16:64, s16:78, s16:87, s16:103, s16:121, s16:120, s16:101],
    [s16:72, s16:92, s16:95, s16:98, s16:112, s16:100, s16:103, s16:99]
];

// 量子化処理 (DCT 係数を JPEG 標準量子化テーブルでスケール)
pub fn quantize_block(dct_coeffs: s16[N][N]) -> s16[N][N] {
    for (i, quantized): (u32, s16[N][N]) in range(u32:0, N) {
        let updated_row: s16[N] =
            for (j, row): (u32, s16[N]) in range(u32:0, N) {
                let q_value: s16 = LUMINANCE_QUANT_TBL[i][j];  // 型エラー解決
                let divided: s32 = (dct_coeffs[i][j] as s32 + q_value as s32 / s32:2) / q_value as s32;
                let clipped: s16 = if divided > s32:32767 {
                    s16:32767
                } else if divided < s32:-32768 {
                    s16:-32768
                } else {
                    divided as s16
                };
                update(row, j, clipped)
            }(quantized[i]);  // `quantized[i]` に `update` 適用

        update(quantized, i, updated_row)  // `quantized` の `i` 行目を更新
    }(dct_coeffs)
}

  
#[test]
fn test_quantize_block() -> () {
  let test_block: s16[8][8] = [
    s16[8]:[s16:400, s16:300, s16:200, s16:100, s16:50, s16:25, s16:10, s16:5],
    s16[8]:[s16:300, s16:250, s16:150, s16:75, s16:30, s16:20, s16:10, s16:5],
    s16[8]:[s16:200, s16:150, s16:100, s16:50, s16:25, s16:15, s16:10, s16:5],
    s16[8]:[s16:100, s16:75, s16:50, s16:30, s16:20, s16:10, s16:5, s16:3],
    s16[8]:[s16:50, s16:30, s16:25, s16:20, s16:15, s16:10, s16:5, s16:3],
    s16[8]:[s16:25, s16:20, s16:15, s16:10, s16:8, s16:5, s16:3, s16:2],
    s16[8]:[s16:10, s16:10, s16:10, s16:8, s16:5, s16:3, s16:2, s16:1],
    s16[8]:[s16:5, s16:5, s16:5, s16:3, s16:2, s16:2, s16:1, s16:1]
  ];

  let expected_result: s16[8][8] = [
    s16[8]:[s16:25, s16:27, s16:20, s16:6, s16:2, s16:1, s16:0, s16:0],
    s16[8]:[s16:25, s16:21, s16:11, s16:4, s16:1, s16:0, s16:0, s16:0],
    s16[8]:[s16:14, s16:12, s16:6, s16:2, s16:1, s16:0, s16:0, s16:0],
    s16[8]:[s16:7, s16:4, s16:2, s16:1, s16:0, s16:0, s16:0, s16:0],
    s16[8]:[s16:3, s16:1, s16:1, s16:0, s16:0, s16:0, s16:0, s16:0],
    s16[8]:[s16:1, s16:1, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0],
    s16[8]:[s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0],
    s16[8]:[s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0]
];

  let result = quantize_block(test_block);
  //trace!(result);
  assert_eq(result, expected_result);
}
