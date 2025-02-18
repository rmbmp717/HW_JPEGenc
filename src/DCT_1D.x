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
  let result: s32 = (prod + (s32:1 << 7)) >> 8;
  result as s16
}

//----------------------------------------------------------------------
// DCT 係数ごとの内積（dot product）を計算するヘルパー関数
fn dot_product(k: u32, x: s16[N]) -> s32 {
  for (n, acc): (u32, s32) in range(u32:0, N) {
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
pub fn dct_1d(x: s16[N]) -> s16[N] {
  for (k, result): (u32, s16[N]) in range(u32:0, N) {
    let sum: s32 = dot_product(k, x);

    let alpha: s32 = if k == u32:0 {
      FIXED_SQRT_1_OVER_N as s32
    } else {
      FIXED_SQRT_2_OVER_N as s32
    };
    let sum_scaled: s32 = (sum * alpha + (s32:1 << 7)) >> 8;

    let clipped: s16 = if sum_scaled < s32:-32768 {
      s16:-32768
    } else if sum_scaled > s32:32767 {
      s16:32767
    } else {
      sum_scaled as s16
    };
    update(result, k, clipped)
  }(s16[N]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0])
}

//----------------------------------------------------------------------
// 全要素が 0 の配列を返すヘルパー関数（各型ごと）
fn zero_array_s16() -> s16[N] {
  [ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]
}
fn zero_array_s32() -> s32[N] {
  [ s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0 ]
}
fn zero_array_u8() -> u8[N] {
  [ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ]
}

//----------------------------------------------------------------------
// u8 型入力の 1D DCT 計算
pub fn dct_1d_u8(x: u8[N]) -> u8[N] {
  let x_q88: s16[N] = for (i, acc): (u32, s16[N]) in range(u32:0, N) {
      let shifted: s16 = ((x[i] as s16) - s16:128) << 8;  // ✅ レベルシフト (-128)
      update(acc, i, shifted)
  }(s16[N]:[s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0]);

  let y_q88: s16[N] = dct_1d(x_q88);

  let y_int32: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let val: s32 = y_q88[i] as s32;
      let rounded: s32 = (val + (s32:1 << 7)) >> 8;
      update(acc, i, rounded)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  let result: u8[N] = for (i, acc): (u32, u8[N]) in range(u32:0, N) {
      let adjusted: s32 = (y_int32[i] + s32:128);  // ✅ レベルシフト
      let clipped: u8 = if adjusted < s32:0 {
          u8:0
      } else if adjusted > s32:255 {
          u8:255
      } else {
          adjusted as u8
      };
      update(acc, i, clipped)
  }(u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ]);	

  result
}

//----------------------------------------------------------------------
// テスト関数
#[test]
fn test1_dct_1d_allzero() {
  let x = u8[8]:[0, 0, 0, 0, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = u8[8]:[0, 128, 128, 128, 128, 101, 30, 193];

  let result = dct_1d_u8(x); // 実際の計算結果
  trace!(x);
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test4_dct_1d() {
  let x = u8[8]:[80, 80, 80, 80, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = u8[8]:[0, 231, 128, 92, 128, 109, 61, 173];

  let result = dct_1d_u8(x); // 実際の計算結果
  trace!(x);
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

