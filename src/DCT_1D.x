// NISHIHARU

// Q8.8 Fixed-point DCT (Size = 8)
// ※ In this example, the Q8.8 representation is implemented using the s16 type (16-bit signed integer).
//  (In Q8.8, 1.0 is represented as 256 (1 << 8))

// DCT size (fixed: 8)
pub const N: u32 = u32:8;

// Q8.8 fixed-point scale definitions
pub const FIXED_ONE: s16 = s16:256;             // 1.0 = 256 (Q8.8)
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;      // sqrt(1/8)*256 ≈ 91
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;     // sqrt(2/8)*256 = 128

// Fixed DCT coefficient LUT (Q8.8 representation)
// Each coefficient is C[k][n] = cos(π*(n+0.5)*k/8) converted to Q8.8.
pub const DCT_LUT: s16[N][N] = [
  // k = 0: all elements are 1.0 → 256
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
// Fixed-point multiplication (Q8.8)
fn fixed_mul(a: s32, b: s16) -> s32 {
  let prod: s32 = a * (b as s32);
  let result: s32 = (prod + (s32:128)) >> 8;
  result as s32
}

//----------------------------------------------------------------------
// Helper function to compute the dot product for each DCT coefficient
fn dot_product(k: u8, x: s32[N]) -> s32 {
  for (n, acc): (u8, s32) in range(u8:0, N as u8) {
    acc + (fixed_mul(x[n], DCT_LUT[k][n]) as s32)
  }(s32:0)
}

//----------------------------------------------------------------------
// 1D DCT calculation (Q8.8 fixed-point)
// The input and output are arrays of Q8.8 representation (s16[N]).
// ※ The DCT calculation for each k is defined as:
//     sum = Σₙ fixed_mul(x[n], DCT_LUT[k][n])
//     scaled_sum = (sum * α + 128) >> 8
//   where α = FIXED_SQRT_1_OVER_N (for k==0) or FIXED_SQRT_2_OVER_N (for k≠0)
pub fn dct_1d_q88(x_in: s32[N]) -> s32[N] {
  for (k, result): (u8, s32[N]) in range(u8:0, N as u8) {
    //trace!(k);
    let sum: s32 = dot_product(k, x_in);
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
// 1D DCT calculation for s10 type input
pub fn dct_1d_s10(x: s10[N]) -> s10[N] {
  // 1. Convert to s32
  let x_q88: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let x_in_s32: s32 = (x[i] as s32); 
      //trace!(x_in_s32);
      update(acc, i, x_in_s32)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  //trace!(x_q88);

  // 2. Compute the Q8.8 fixed-point DCT
  let y_q88: s32[N] = dct_1d_q88(x_q88);

  //trace!(y_q88);

  // 4. Restore the scale to match the manual calculation version
  let result: s10[N] = for (i, acc): (u32, s10[N]) in range(u32:0, N) {
      let adjusted: s32 = y_q88[i];
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
// 1D DCT calculation for s12 type input
pub fn dct_1d_s12(x: s12[N]) -> s12[N] {
  // 1. Convert to s32
  let x_q88: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let shifted: s32 = (x[i] as s32);
      update(acc, i, shifted)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  // 2. Compute the Q8.8 fixed-point DCT
  let y_q88: s32[N] = dct_1d_q88(x_q88);

  // 3. Restore the scale to match the manual calculation version
  let result: s12[N] = for (i, acc): (u32, s12[N]) in range(u32:0, N) {
      let adjusted: s32 = y_q88[i];
      let clipped: s12 = if adjusted < s32:-2048 {
          s12:-2048
      } else if adjusted > s32:2047 {
          s12:2047
      } else {
          adjusted as s12
      };
      update(acc, i, clipped)
  }(s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ]);

  result
}

//----------------------------------------------------------------------
// Test functions
#[test]
fn test0_dct_s12() {
  // Test input data for s12 DCT
  let x = s12[8]:[8, 70, 6, 5, 4, 3, 25, 12];
  let expected = s12[8]:[47, 17, 22, -8, -26, -39, -34, -25];
  trace!(x);

  let result = dct_1d_s12(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

//----------------------------------------------------------------------
// Test function for s10 DCT
#[test]
fn test0_dct_1d() {
  // Test input data for s10 DCT
  let x = s10[8]:[8, 70, 6, 5, 4, 3, 25, 12];
  let expected = s10[8]:[0, 146, 150, 120, 101, 63, 0, 168];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test1_dct_1d_allzero() {
  // Test input data: all zeros for s10 DCT
  let x = s10[8]:[0, 0, 0, 0, 0, 0, 0, 0];
  let expected = s10[8]:[0, 0, 0, 0, 0, 0, 0, 0];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test1_dct_1d() {
  // Test input data: alternating pattern for s10 DCT
  let x = s10[8]:[80, 0, 80, 0, 80, 0, 80, 0];
  let expected = s10[8]:[0, 148, 128, 152, 128, 109, 61, 173];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test2_dct_1d() {
  // Test input data for s10 DCT
  let x = s10[8]:[8, 70, 63, 55, 42, 3, 2, 1];
  let expected = s10[8]:[0, 178, 89, 91, 117, 102, 56, 154];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test3_dct_1d() {
  // Test input data: all same values for s10 DCT
  let x = s10[8]:[80, 80, 80, 80, 80, 80, 80, 80];
  let expected = s10[8]:[0, 128, 128, 128, 128, 118, 91, 152];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test4_dct_1d() {
  // Test input data for s10 DCT: first half non-zero, second half zeros
  let x = s10[8]:[80, 80, 80, 80, 0, 0, 0, 0];
  let expected = s10[8]:[0, 231, 128, 92, 128, 109, 61, 173];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test5_dct_1d() {
  // Test input data for s10 DCT: uniform non-zero values for the first half
  let x = s10[8]:[114, 114, 114, 114, 0, 0, 0, 0];
  let expected = s10[8]:[0, 255, 128, 77, 128, 113, 74, 164];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test6_dct_1d() {
  // Test input data for s10 DCT: varied input values
  let x = s10[8]:[8, 70, 6, 56, 43, 3, 120, 1];
  let expected = s10[8]:[0, 255, 128, 77, 128, 113, 74, 164];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}

#[test]
fn test7_dct_1d() {
  // Test input data for s10 DCT: mixed small and medium values
  let x = s10[8]:[4, 3, 20, 70, 12, 6, 12, 8];
  let expected = s10[8]:[48, 4, -34, -24, 19, 27, 39, -32];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test8_dct_1d() {
  // Test input data for s10 DCT: negative values
  let x = s10[8]:[-48, -48, -48, -48, -128, -128, -128, -128];
  let expected = s10[8]:[-250, 103, 0, -35, 1, -18, -67, 46];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

#[test]
fn test9_dct_1d() {
  // Test input data for s10 DCT: negative values explicitly typed as s10
  let x = s10[8]:[s10:-48, s10:-48, s10:-48, s10:-48, s10:-128, s10:-128, s10:-128, s10:-128];
  let expected = s10[8]:[-250, 103, 0, -35, 1, -18, -67, 46];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}