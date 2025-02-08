// NISHIHARU

// DCT サイズ（N = 8 固定）
pub const N = u32:8;

// Q32.32 固定小数点スケール定義
pub const FIXED_ONE = u64:1 << 32;  // 1.0
pub const FIXED_SQRT_1_OVER_N = u64:3037000499; // sqrt(1/N) = sqrt(1/8) ≈ 0.353553 * 2^32
pub const FIXED_SQRT_2_OVER_N = u64:4294967296; // sqrt(2/N) = sqrt(2/8) ≈ 0.5 * 2^32

// **固定 DCT 係数 LUT (Q32.32)**
//   C[k][n] = cos(π (n + 0.5) k / N) を Q32.32 固定小数点で事前計算
pub const DCT_LUT: u64[N][N] = [
  [u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499], // k=0
  [u64:4265047728, u64:3518437209, u64:2160026241, u64:759250124, u64:759250124, u64:2160026241, u64:3518437209, u64:4265047728], // k=1
  [u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608], // k=2
  [u64:3518437209, u64:759250124, u64:4265047728, u64:2160026241, u64:2160026241, u64:4265047728, u64:759250124, u64:3518437209], // k=3
  [u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499], // k=4
  [u64:2160026241, u64:4265047728, u64:759250124, u64:3518437209, u64:3518437209, u64:759250124, u64:4265047728, u64:2160026241], // k=5
  [u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918], // k=6
  [u64:759250124, u64:2160026241, u64:3518437209, u64:4265047728, u64:4265047728, u64:3518437209, u64:2160026241, u64:759250124], // k=7
];

// **固定小数点の乗算 (Q32.32)**
fn fixed_mul(a: u64, b: u64) -> u64 {
  let result = ((a * b) + (u64:1 << 31)) >> 32;
  //trace!(a);
  //trace!(b);
  //trace!(result);
  result
}

// **1D DCT 計算**
pub fn dct_1d(x: u64[N]) -> u64[N] {
  for (k, result): (u32, u64[N]) in range(u32:0, N) {
    let sum = for (n, acc): (u32, u64) in range(u32:0, N) {
      let mul_result = fixed_mul(x[n], DCT_LUT[k][n]);
      let new_acc = acc + mul_result;
      new_acc
    }(u64:0);

    // **スケール係数の適用**
    let scaled_sum = if k == u32:0 {
      fixed_mul(sum, FIXED_SQRT_1_OVER_N)
    } else {
      fixed_mul(sum, FIXED_SQRT_2_OVER_N)
    };
    trace!(sum);

    let new_result = update(result, k, scaled_sum);
    new_result
  }(u64[N]:[u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0])
}

#[test]
fn test1_dct_1d() {
  let x = u64[8]:[1, 2, 3, 4, 5, 6, 7, 8]; // テスト用の入力データ
  let expected = u64[8]:[18, 24, 24, 23, 26, 23, 25, 22];

  let result = dct_1d(x); // 実際の計算結果
  assert_eq(result, expected);
}

#[test]
fn test2_dct_1d() {
  let x = u64[8]:[0, 0, 0, 0, 0, 0, 0, 0]; // テスト用の入力データ
  let expected = u64[8]:[0, 0, 0, 0, 0, 0, 0, 0];

  let result = dct_1d(x); // 実際の計算結果
  assert_eq(result, expected);
}

#[test]
fn test3_dct_1d() {
  let x = u64[8]:[10, 20, 30, 40, 50, 60, 70, 80]; // テスト用の入力データ
  let expected = u64[8]:[179,223, 239, 225, 253, 225, 240, 225];

  let result = dct_1d(x); // 実際の計算結果
  assert_eq(result, expected);
}

#[test]
fn test4_dct_1d() {
  let x = u64[8]:[8, 7, 6, 5, 4, 3, 2, 1]; // テスト用の入力データ
  let expected = u64[8]:[18, 24, 24, 23, 26, 23, 25, 22];

  let result = dct_1d(x); // 実際の計算結果
  assert_eq(result, expected);
}




