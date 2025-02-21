// NISHIHARU

// Q8.8 固定小数点版 DCT (サイズ=8)
// ※ この例では s16 型 (16ビット符号付き整数) を用いて Q8.8 表現を実現します。
// 　（Q8.8 では 1.0 == 256 (= 1 << 8) となります）

// DCT サイズ（固定: 8）
pub const N: u32 = u32:8;

// Q8.8 固定小数点スケール定義
pub const FIXED_ONE: s16 = s16:256;             // 1.0 = 256 (Q8.8)
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;      // sqrt(1/8)*256 ≈ 91
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;     // sqrt(2/8)*256 = 128

// 固定 DCT 係数 LUT (Q8.8 表現)
// 各係数は C[k][n] = cos(π*(n+0.5)*k/8) を Q8.8 に変換した値です。
pub const DCT_LUT: s16[N][N] = [
  // k = 0 : 全要素 1.0 → 256
  [s16:256, s16:256, s16:256, s16:256, s16:256, s16:256, s16:256, s16:256],
  [s16:251, s16:213, s16:142, s16:50,  s16:-50, s16:-142, s16:-213, s16:-251],
  [s16:236, s16:98,  s16:-98, s16:-236, s16:-236, s16:-98, s16:98,  s16:236],
  [s16:213, s16:-50, s16:-251, s16:-142, s16:142, s16:251, s16:50,  s16:-213],
  [s16:181, s16:-181, s16:-181, s16:181,  s16:181, s16:-181, s16:-181, s16:181],
  [s16:142, s16:-251, s16:-50, s16:213,  s16:213, s16:-50, s16:-251, s16:142],
  [s16:98,  s16:-236, s16:98,  s16:236,  s16:236, s16:98,  s16:-236, s16:98],
  [s16:50,  s16:-142, s16:213, s16:-251, s16:-251, s16:213, s16:-142, s16:50],
];

//----------------------------------------------------------------------
// 固定小数点の乗算 (Q8.8)
fn fixed_mul(a: s16, b: s16) -> s16 {
  let prod: s32 = (a as s32) * (b as s32);
  let result: s32 = (prod + (s32:128)) >> 8;
  result as s16
}

//----------------------------------------------------------------------
// DCT 係数ごとの内積（dot product）を計算するヘルパー関数
fn dot_product(k: u8, x: s16[N]) -> s32 {
  for (n, acc): (u8, s32) in range(u8:0, N as u8) {
    acc + (fixed_mul(x[n], DCT_LUT[k][n]) as s32)
  }(s32:0)
}

//----------------------------------------------------------------------
// 1D DCT 計算 (Q8.8 固定小数点)
// 入出力は Q8.8 表現 (s16[N]) の配列となる。
// ※ DCT 計算は、各 k について
//     sum = Σₙ fixed_mul(x[n], DCT_LUT[k][n])
//     scaled_sum = (sum * α + 128) >> 8
//   となっています。
//   ここで、α = FIXED_SQRT_1_OVER_N (k==0) あるいは FIXED_SQRT_2_OVER_N (k≠0)
pub fn dct_1d(x: s16[N]) -> s32[N] {
  for (k, result): (u8, s32[N]) in range(u8:0, N as u8) {
    let sum: s32 = dot_product(k, x);
    let alpha: s32 = if k == u8:0 {
      FIXED_SQRT_1_OVER_N as s32
    } else {
      FIXED_SQRT_2_OVER_N as s32
    };
    let sum_scaled: s32 = (sum * alpha + (s32:128)) >> 8;
    let clipped: s32 = if sum_scaled < s32:-2147483648 {
      s32:-2147483648
    } else if sum_scaled > s32:2147483647 {
      s32:2147483647
    } else {
      sum_scaled as s32
    };
    update(result, k, clipped)
  }(s32[N]:[ s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0])
}

//----------------------------------------------------------------------
// s10 型入力の 1D DCT 計算
pub fn dct_1d_s10(x: s10[N]) -> s10[N] {
  // 1. 入力のレベルシフト: u8 値 (0～255) を -128～127 に変換し、Q8.8 表現にする
  let x_q88: s16[N] = for (i, acc): (u32, s16[N]) in range(u32:0, N) {
      // 入力から 128 を引いてゼロ中心化し、明示的に 256 を掛けて Q8.8 表現にする
      let shifted: s16 = ((x[i] as s16) - s16:128) * s16:256;
      update(acc, i, shifted)
  }(s16[N]:[s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0]);

  // 2. Q8.8 固定小数点 DCT を計算
  let y_q88: s32[N] = dct_1d(x_q88);
  trace!(y_q88);

  // 3. Q8.8 表現から整数に変換（四捨五入: +128 して右シフト 8 ビット）
  let y_int32: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let val: s32 = y_q88[i] as s32;
      let rounded: s32 = (val + s32:128) >> 8;
      update(acc, i, rounded)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);
  trace!(y_int32);

  // 4. 逆レベルシフト: 各値に +128 して、手計算版と同じスケールに復帰
  let result: s10[N] = for (i, acc): (u32, s10[N]) in range(u32:0, N) {
      let adjusted: s32 = (y_int32[i] + s32:128);
      let clipped: s10 = if adjusted < s32:-511 {
          s10:-511
      } else if adjusted > s32:511 {
          s10:511
      } else {
          adjusted as s10
      };
      update(acc, i, clipped)
  }(s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ]);

  result
}

//----------------------------------------------------------------------
// テスト関数
#[test]
fn test0_dct_1d() {
  let x = s10[8]:[8, 70, 6, 5, 4, 3, 25, 12]; // テスト用の入力データ
  let expected = s10[8]:[0, 146, 150, 120, 101, 63, 0, 168];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test1_dct_1d_allzero() {
  let x = s10[8]:[0, 0, 0, 0, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = s10[8]:[-236, 128, 128, 128, 128, 101, 30, 193];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test1_dct_1d() {
  let x = s10[8]:[80, 0, 80, 0, 80, 0, 80, 0]; // テスト用の入力データ
  let expected = s10[8]:[0, 148, 128, 152, 128, 109, 61, 173];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test2_dct_1d() {
  let x = s10[8]:[8, 70, 63, 55, 42, 3, 2, 1]; // テスト用の入力データ
  let expected = s10[8]:[0, 178, 89, 91, 117, 102, 56, 154];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test3_dct_1d() {
  let x = s10[8]:[80, 80, 80, 80, 80, 80, 80, 80]; // テスト用の入力データ
  let expected = s10[8]:[0, 128, 128, 128, 128, 118, 91, 152];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test4_dct_1d() {
  let x = s10[8]:[80, 80, 80, 80, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = s10[8]:[0, 231, 128, 92, 128, 109, 61, 173];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test5_dct_1d() {
  let x = s10[8]:[114, 114, 114, 114, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = s10[8]:[0, 255, 128, 77, 128, 113, 74, 164];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test6_dct_1d() {
  let x = s10[8]:[8, 70, 6, 56, 43, 3, 120, 1]; // テスト用の入力データ
  let expected = s10[8]:[0, 255, 128, 77, 128, 113, 74, 164];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test7_dct_1d() {
  let x = s10[8]:[4, 3, 20, 70, 12, 6, 12, 8]; // テスト用の入力データ
  let expected = s10[8]:[-188, 132, 94, 104, 147, 129, 68, 161];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test8_dct_1d() {
  let x = s10[8]:[-48, -48, -48, -48, -128, -128, -128, -128]; // テスト用の入力データ
  let expected = s10[8]:[242, 231, 128, 92, 128, 136, 159, 108];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}
