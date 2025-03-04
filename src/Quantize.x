// NISHIHARU

//if(quality < 50):
//qualityScale = 5000 / quality

pub const N: u32 = u32:8;
pub const QUALITY: u8 = u8:25;      // JPEG Quality
//pub const QUALITY_SCALE: s16 = s16:200 - s16:2 * QUALITY as s16;
pub const QUALITY_SCALE: s16 = s16:5000 / QUALITY as s16;

// JPEG 標準の輝度量子化テーブル (s16)
// 標準の輝度量子化テーブル (s16)
pub const STD_LUMINANCE_QUANT_TBL: s16[N][N] = [
    [s16:16, s16:11, s16:10, s16:16, s16:24, s16:40, s16:51, s16:61],
    [s16:12, s16:12, s16:14, s16:19, s16:26, s16:58, s16:60, s16:55],
    [s16:14, s16:13, s16:16, s16:24, s16:40, s16:57, s16:69, s16:56],
    [s16:14, s16:17, s16:22, s16:29, s16:51, s16:87, s16:80, s16:62],
    [s16:18, s16:22, s16:37, s16:56, s16:68, s16:109, s16:103, s16:77],
    [s16:24, s16:35, s16:55, s16:64, s16:81, s16:104, s16:113, s16:92],
    [s16:49, s16:64, s16:78, s16:87, s16:103, s16:121, s16:120, s16:101],
    [s16:72, s16:92, s16:95, s16:98, s16:112, s16:100, s16:103, s16:99]
];

// 標準の色差（クロマ）量子化テーブル (s16)
pub const STD_CHROMINANCE_QUANT_TBL: s16[N][N] = [
    [s16:17, s16:18, s16:24, s16:47, s16:99, s16:99, s16:99, s16:99],
    [s16:18, s16:21, s16:26, s16:66, s16:99, s16:99, s16:99, s16:99],
    [s16:24, s16:26, s16:56, s16:99, s16:99, s16:99, s16:99, s16:99],
    [s16:47, s16:66, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99],
    [s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99],
    [s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99],
    [s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99],
    [s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99, s16:99]
];

pub fn scale_quant_tbl(std_tbl: s16[N][N], quality_scale: s16) -> s16[N][N] {
    for (i, scaled): (u32, s16[N][N]) in range(u32:0, N) {
      let new_row: s16[N] =
        for (j, row): (u32, s16[N]) in range(u32:0, N) {
           // 積算と加算を s32 で計算し、100 で割る（整数除算なので floor と同等）
           let prod: s32 = (std_tbl[i][j] as s32 * quality_scale as s32 + s32:50);
           let new_val: s16 = (prod / s32:100) as s16;
           update(row, j, new_val)
        }(std_tbl[i]);
      update(scaled, i, new_row)
    }(std_tbl)
  }


// スケール後の輝度量子化テーブル (s16)
pub const LUMINANCE_QUANT_TBL: s16[N][N] =
    scale_quant_tbl(STD_LUMINANCE_QUANT_TBL, QUALITY_SCALE);

// スケール後の色差（クロマ）量子化テーブル (s16)
pub const CHROMINANCE_QUANT_TBL: s16[N][N] =
    scale_quant_tbl(STD_CHROMINANCE_QUANT_TBL, QUALITY_SCALE);

// ヘルパー関数: s12[N] の行を s16[N] に変換
pub fn convert_row(row: s12[N]) -> s16[N] {
  // 初期値として全要素ゼロの s16[N] を指定し、for 内包表記で各要素を更新
  for (j, result): (u32, s16[N]) in range(u32:0, N) {
    update(result, j, row[j] as s16)
  }(s16[N]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ])
}

//----------------------------------------------------------------------
// s12 型入力のメイン関数
pub fn Quantize(dct_coeffs: s12[N][N], matrix_row: u8, is_luminance: bool, quantize_off: bool) -> s10[N] {
  let row_idx: u32 = matrix_row as u32;
  // 対象行の s12 値を s16 に変換して初期行を生成
  let initial_row: s16[N] = convert_row(dct_coeffs[row_idx]);
  // 各要素について量子化処理を実施
  for (j, processed): (u32, s10[N]) in range(u32:0, N) {
    let q_value: s16 = if is_luminance {
      LUMINANCE_QUANT_TBL[row_idx][j]
    } else {
      CHROMINANCE_QUANT_TBL[row_idx][j]
    };
    // 四捨五入: (initial_row[j] + (q_value/2)) / q_value
    let divided: s32 = if quantize_off == false {
      (initial_row[j] as s32) / (q_value as s32)
    } else {
      initial_row[j] as s32
    };
    let clipped: s10 = if divided > s32:255 {
      s10:255
    } else if divided < s32:-255 {
      s10:0
    } else {
      divided as s10
    };
    update(processed, j, clipped)
  }(s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ])
}

// =======================
// 以下はテストケース（u8 型入力版）
// =======================
#[test]
fn test0_quantize_block() -> () {
  // test_block の行0のみ使用。その他は 0 で埋める。
  let test_block: s12[8][8] = [
    s12[8]:[s12:200, s12:150, s12:100, s12:-50, s12:30, s12:20, s12:10, s12:5],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0]
  ];

  // ※ 本テストでは、輝度の場合 (is_luminance == true)
  // row0 の量子化処理結果は、以下の計算例に基づく（例：(200 + 7)/15 = 13, etc.）
  let expected_result: s10[8] = [
    s10:6, s10:6, s10:5, s10:-1, s10:0, s10:0, s10:0, s10:0
  ];

  let result = Quantize(test_block, u8:0, true, false);
  trace!(result);
  assert_eq(result, expected_result);
}

#[test]
fn test1_quantize_block() -> () {
  // test_block の行5に対してテスト（色差の場合: is_luminance == false）
  let test_block: s12[8][8] = [
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:234, s12:0,   s12:-200,s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:111, s12:0,   s12:300, s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:122, s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:25,  s12:-400,s12:15,  s12:10, s12:8,  s12:88, s12:3,  s12:2],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0,  s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,  s12:0,  s12:0]
  ];

  // 色差の場合、標準色差量子化テーブル（scaled）が全要素 94 になると仮定した場合、
  // (value + (94/2))/94 で計算すると、どの要素も 0 になると期待
  let expected_result: s10[8] = [
    s10:1, s10:0, s10:1, s10:0, s10:0, s10:0, s10:0, s10:0
  ];

  let result = Quantize(test_block, u8:3, false, false);
  trace!(result);
  assert_eq(result, expected_result);
}

#[test]
fn test2_quantize_block() -> () {
  // test_block の行5に対してテスト（色差の場合: is_luminance == true）
  let test_block: s12[8][8] = [
    s12[8]:[s12:128,   s12:0,   s12:0,   s12:51,  s12:0,  s12:11,  s12:44,  s12:0],
    s12[8]:[s12:128,   s12:0,   s12:33,  s12:46,  s12:0,  s12:10,  s12:40,  s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:25,    s12:20,  s12:15,  s12:10,  s12:8,  s12:5,   s12:3,   s12:2],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0]
  ];

  let expected_result: s10[8] = [s10:4, s10:0, s10:0, s10:1, s10:0, s10:0, s10:0, s10:0];
  let result = Quantize(test_block, u8:0, true, false);
  trace!(result);
  assert_eq(result, expected_result);

  let expected_result: s10[8] = [s10:5, s10:0, s10:1, s10:1, s10:0, s10:0, s10:0, s10:0];
  let result = Quantize(test_block, u8:1, true, false);
  trace!(result);
  assert_eq(result, expected_result);
}

#[test]
fn test3_quantize_block() -> () {
  // test_block の行5に対してテスト（色差の場合: is_luminance == false）
  let test_block: s12[8][8] = [
    s12[8]:[s12:128,   s12:0,   s12:0,   s12:51,  s12:0,  s12:11,  s12:44,  s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:25,    s12:20,  s12:15,  s12:10,  s12:8,  s12:5,   s12:3,   s12:2],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0],
    s12[8]:[s12:0,     s12:0,   s12:0,   s12:0,   s12:0,  s12:0,   s12:0,   s12:0]
  ];

  // 色差の場合、標準色差量子化テーブル（scaled）が全要素 94 になると仮定した場合、
  // (value + (94/2))/94 で計算すると、どの要素も 0 になると期待
  let expected_result: s10[8] = [
    s10:128,   s10:0,   s10:0,   s10:51,  s10:0,  s10:11,  s10:44,  s10:0
  ];

  let result = Quantize(test_block, u8:0, false, true);
  //trace!(result);
  assert_eq(result, expected_result);
}