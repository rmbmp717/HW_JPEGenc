// NISHIHARU

// DCT size (N = fixed 8)
pub const N = u32:8;

// Q8.8 fixed-point scale definitions (signed 16-bit: s16)
// The fixed-point representation consists of 8 bits for the integer part and 8 bits for the fractional part.
pub const FIXED_ONE: s16 = s16:256;          // Represents 1.0 (256 = 1<<8)
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;      // sqrt(1/8)*256 ≈ 0.35355*256 ≒ 91
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;     // sqrt(2/8)*256 = 0.5*256 = 128

// Fixed DCT coefficient LUT (Q8.8) (s16)
// LUT[k][n] = cos(π*(n+0.5)*k/8)*FIXED_ONE  (for k, n = 0,...,7)
// The following values are approximately rounded to the nearest integer.
pub const DCT_LUT: s16[N][N] = [
    [ s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256  ], // k=0
    [ s16:251,  s16:213,  s16:142,  s16:50,   s16:-50,  s16:-142, s16:-213, s16:-251 ], // k=1
    [ s16:236,  s16:98,   s16:-98,  s16:-236, s16:-236, s16:-98,  s16:98,   s16:236  ], // k=2
    [ s16:213,  s16:-50,  s16:-251, s16:-142, s16:142,  s16:251,  s16:50,   s16:-213 ], // k=3
    [ s16:181,  s16:-181, s16:-181, s16:181,  s16:181,  s16:-181, s16:-181, s16:181  ], // k=4
    [ s16:142,  s16:-251, s16:-50,  s16:213,  s16:213,  s16:-50,  s16:-251, s16:142  ], // k=5
    [ s16:98,   s16:-236, s16:98,   s16:236,  s16:236,  s16:98,   s16:-236, s16:98   ], // k=6
    [ s16:50,   s16:-142, s16:213,  s16:-251, s16:-251, s16:213,  s16:-142, s16:50   ]  // k=7
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
// The input and output are arrays in Q8.8 representation (s16[N]).
// For each k, the DCT calculation is performed as:
//     sum = Σₙ fixed_mul(x[n], DCT_LUT[k][n])
//     scaled_sum = (sum * α + 128) >> 8
// where α = FIXED_SQRT_1_OVER_N (for k==0) or FIXED_SQRT_2_OVER_N (for k≠0)
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
  // Step 1: Convert to s32
  let x_q88: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let x_in_s32: s32 = (x[i] as s32); 
      //trace!(x_in_s32);
      update(acc, i, x_in_s32)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  //trace!(x_q88);

  // Step 2: Compute the Q8.8 fixed-point DCT
  let y_q88: s32[N] = dct_1d_q88(x_q88);

  //trace!(y_q88);

  // Step 4: Convert back to the same scale as the manual calculation version
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
  // Step 1: Convert to s32
  let x_q88: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let shifted: s32 = (x[i] as s32);
      update(acc, i, shifted)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  // Step 2: Compute the Q8.8 fixed-point DCT
  let y_q88: s32[N] = dct_1d_q88(x_q88);

  // Step 3: Convert back to the same scale as the manual calculation version
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

// Helper function: 1D array of length N initialized with zeros (s10)
fn zeros_s10_1d() -> s10[N] {
    [ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ]
}

// Helper function: 1D array of length N initialized with zeros (s12)
fn zeros_s12_1d() -> s12[N] {
  [ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ]
}

// Helper function: 2D array of size N x N initialized with zeros (s10)
fn zeros_2d() -> s10[N][N] {
	[ s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
    s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
    s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
    s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
    s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
    s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
	  s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ],
	  s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ] ]
}

// Helper function: 2D array of size N x N initialized with zeros (s12)
fn zeros_2d_s12() -> s12[N][N] {
  [ s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ],
    s12[N]:[ s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0, s12:0 ] ]
}

// Main function
// 2D DCT calculation (Q8.8) - u8 version for input and output
// First, apply 1D DCT to each row, and then apply 1D DCT to each column.
pub fn dct_2d_s10(x_in: s10[N][N]) -> s10[N][N] {
    // ✅ Apply DCT in the row direction
    let row_transformed: s10[N][N] =
        for (i, acc): (u32, s10[N][N]) in range(u32:0, N) {
            //trace!(i);
            //trace!(x_in[i]);
            update(acc, i, dct_1d_s10(x_in[i]))  // ✅ Apply 1D DCT on each row
        }(zeros_2d());

    trace!(row_transformed);

    // ✅ Apply DCT in the column direction
    let col_transformed: s10[N][N] =
        for (j, acc): (u32, s10[N][N]) in range(u32:0, N) {
            // ✅ Extract each column from `row_transformed`
            let col: s10[N] =
                for (i, col_acc): (u32, s10[N]) in range(u32:0, N) {
                    update(col_acc, i, row_transformed[i][j])
                }(zeros_s10_1d());  // ✅ Use zeros_s10_1d() for initialization

            // ✅ Apply 1D DCT on the column
            let col_dct: s10[N] = dct_1d_s10(col);

            trace!(col_dct);

            // ✅ Update `col_transformed` with the result from `col_dct`
            for (i, updated_mat): (u32, s10[N][N]) in range(u32:0, N) {
                let updated_row = update(updated_mat[i], j, col_dct[i]);
                update(updated_mat, i, updated_row)
            }(acc)
        }(row_transformed);

    //trace!(col_transformed);  // ✅ Check the result of the column-wise DCT

    col_transformed
}

//----------------------------------------------------------------------
// 2D DCT calculation for s12 type input
pub fn dct_2d_s12(x: s12[N][N]) -> s12[N][N] {
    // ✅ Apply DCT in the row direction
    let row_transformed: s12[N][N] =
        for (i, acc): (u32, s12[N][N]) in range(u32:0, N) {
            //trace!(x[i]);
            //trace!(dct_1d_s12(x[i]));
            update(acc, i, dct_1d_s12(x[i]))  // ✅ Apply 1D DCT on each row
        }(zeros_2d_s12());

    // ✅ Apply DCT in the column direction
    let col_transformed: s12[N][N] =
        for (j, acc): (u32, s12[N][N]) in range(u32:0, N) {
            // ✅ Extract each column from `row_transformed`
            let col: s12[N] =
                for (i, col_acc): (u32, s12[N]) in range(u32:0, N) {
                    update(col_acc, i, row_transformed[i][j])
                }(zeros_s12_1d());  // ✅ Use zeros_s12_1d() for initialization

            // ✅ Apply 1D DCT on the column
            let col_dct: s12[N] = dct_1d_s12(col);

            //trace!(col_dct);

            // ✅ Update `col_transformed` with the result from `col_dct`
            for (i, updated_mat): (u32, s12[N][N]) in range(u32:0, N) {
                let updated_row = update(updated_mat[i], j, col_dct[i]);
                update(updated_mat, i, updated_row)
            }(acc)
        }(row_transformed);

    //trace!(col_transformed);  // ✅ Check the result of the column-wise DCT

    col_transformed
}


// ---------------------------
// Tests
// ---------------------------
// Tests for s12

#[test]
fn test0_dct_1d_s12() {
  // Test input data for s12 1D DCT
  let x = s12[8]:[8, 70, 6, 5, 4, 3, 25, 12];
  let expected = s12[8]:[47, 17, 22, -8, -26, -39, -34, -25];
  trace!(x);

  let result = dct_1d_s12(x); // Compute the 1D DCT result
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}

// 2D DCT test
#[test]
fn test0_dct_2d_s12_const() -> () {
  // Input: all elements are 80
  let x_in: s12[8][8] = [
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80],
      s12[8]:[s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80, s12:80]
  ];

  let y_exp: s12[8][8] = [
      s12[8]:[s12:648,  s12:0,   s12:0,  s12:0,  s12:0,  s12:48,  s12:176,  s12:-111],
      s12[8]:[s12:0,    s12:0,   s12:0,  s12:0,  s12:0,  s12:0,   s12:0,    s12:0   ],
      s12[8]:[s12:0,    s12:0,   s12:0,  s12:0,  s12:0,  s12:0,   s12:0,    s12:0   ],
      s12[8]:[s12:0,    s12:0,   s12:0,  s12:0,  s12:0,  s12:0,   s12:0,    s12:0   ],
      s12[8]:[s12:0,    s12:0,   s12:0,  s12:0,  s12:0,  s12:0,   s12:0,    s12:0   ],
      s12[8]:[s12:47,   s12:0,   s12:0,  s12:0,  s12:0,  s12:3,   s12:13,   s12:-8  ],
      s12[8]:[s12:174,  s12:0,   s12:0,  s12:0,  s12:0,  s12:14,  s12:48,   s12:-30 ],
      s12[8]:[s12:-115, s12:0,   s12:0,  s12:0,  s12:0,  s12:-9,  s12:-31,  s12:20  ],
  ];

  let result = dct_2d_s12(x_in);
  trace!(result);
  assert_eq(result, y_exp);
}

#[test]
fn test1_dct_2d_s12_const() -> () {
    let x: s12[8][8] = [
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51],
        s12[8]:[s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51, s12:-51]
    ];

  let result = dct_2d_s12(x);
  trace!(result);
}

#[test]
fn test3_dct_2d_s12_top_left_4x4_m80() -> () {
    // Input: top-left 4x4 block is 80, the rest are 0
    let x: s12[8][8] = [
        s12[8]:[s12:-48,  s12:-48,  s12:-48,  s12:-48,  s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-48,  s12:-48,  s12:-48,  s12:-48,  s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-48,  s12:-48,  s12:-48,  s12:-48,  s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-48,  s12:-48,  s12:-48,  s12:-48,  s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128],
        s12[8]:[s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128, s12:-128]
    ];
    
    let result = dct_2d_s12(x);
    trace!(result);
}

// ---------------------------
// Tests for s10

// 1D DCT tests
#[test]
fn test1_dct_1d_allzero() {
    // Test input data: all zeros for s10 1D DCT
    let x = s10[8]:[s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0];
    let expected = s10[8]:[-236, 128, 128, 128, 128, 101, 30, 193];
    trace!(x);
  
    let result = dct_1d_s10(x); // Compute the 1D DCT result
    trace!(expected);
    trace!(result);
    //assert_eq(result, expected);
}

#[test]
fn test2_dct_1d() {
    // Test input data for s10 1D DCT
    let x = s10[8]:[s10:4, s10:3, s10:20, s10:70, s10:12, s10:6, s10:12, s10:8];
    let expected = s10[8]:[-188, 132, 94, 104, 147, 129, 68, 161];
    trace!(x);

    let result = dct_1d_s10(x); // Compute the 1D DCT result
    trace!(expected);
    trace!(result);
    //assert_eq(result, expected);
}

#[test]
fn test3_dct_1d() {
  // Test input data for s10 1D DCT with negative values
  let x = s10[8]:[s10:-48, s10:-48, s10:-48, s10:-48, s10:-128, s10:-128, s10:-128, s10:-128];
  let expected = s10[8]:[-486, 231, 128, 92, 128, 82, -37, 238];
  trace!(x);

  let result = dct_1d_s10(x); // Compute the 1D DCT result
  trace!(expected);
  trace!(result);
  //assert_eq(result, expected);
}
  
// 2D DCT tests
#[test]
fn test2_dct_2d_s10_const() -> () {
    // Input: all elements are 80
    let x: s10[8][8] = [
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80],
        s10[8]:[s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80, s10:80]
    ];
    
  let result = dct_2d_s10(x);
  trace!(result);
}

#[test]
fn test3_dct_2d_s10_top_left_4x4_m80() -> () {
    // Input: top-left 4x4 block is 80, the rest are 0
    let x: s10[8][8] = [
        s10[8]:[s10:-48,  s10:-48,  s10:-48,  s10:-48,  s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-48,  s10:-48,  s10:-48,  s10:-48,  s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-48,  s10:-48,  s10:-48,  s10:-48,  s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-48,  s10:-48,  s10:-48,  s10:-48,  s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128],
        s10[8]:[s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128, s10:-128]
    ];
    
    let result = dct_2d_s10(x);
    trace!(result);
    // You may add assert_eq comparisons here if desired.
}

#[test]
fn test_gra8x16_dct_2d_s10() -> () {
    // Test on image_gra8x16.bmp: Y channel
    let yInMatrix: s10[8][8] = [
        s10[8]:[s10:-35, s10:-23, s10:-12, s10:0,  s10:12,  s10:22,  s10:35,  s10:46],
        s10[8]:[s10:-23, s10:-12, s10:0,  s10:12, s10:22,  s10:35, s10:46,  s10:58],
        s10[8]:[s10:-12, s10:0,   s10:12, s10:22, s10:35,  s10:46, s10:58,  s10:70],
        s10[8]:[s10:0,   s10:12,  s10:22, s10:35, s10:46,  s10:58, s10:70,  s10:81],
        s10[8]:[s10:12,  s10:22,  s10:35, s10:46, s10:58,  s10:70, s10:81,  s10:93],
        s10[8]:[s10:22,  s10:35,  s10:46, s10:58, s10:70,  s10:81, s10:93,  s10:103],
        s10[8]:[s10:35,  s10:46,  s10:58, s10:70, s10:81,  s10:93, s10:103, s10:116],
        s10[8]:[s10:46,  s10:58,  s10:70, s10:81, s10:93,  s10:103, s10:116, s10:128]
    ];    

    let y_exp: s10[8][8] = [
        s10[8]:[s10:374,  s10:-212, s10:1,   s10:-21, s10:1,   s10:28,  s10:101, s10:-67],
        s10[8]:[s10:-212, s10:0,    s10:2,   s10:1,   s10:0,   s10:-15, s10:-58, s10:38],
        s10[8]:[s10:1,    s10:1,    s10:-1,  s10:0,   s10:0,   s10:2,   s10:1,   s10:-1],
        s10[8]:[s10:-23,  s10:0,    s10:-1,  s10:0,   s10:-1,  s10:0,   s10:-6,  s10:4],
        s10[8]:[s10:0,    s10:1,    s10:1,   s10:2,   s10:2,   s10:0,   s10:0,   s10:0],
        s10[8]:[s10:28,   s10:-15,  s10:2,   s10:1,   s10:2,   s10:2,   s10:7,   s10:-5],
        s10[8]:[s10:101,  s10:-56,  s10:2,   s10:-5,  s10:1,   s10:7,   s10:27,  s10:-19],
        s10[8]:[s10:-67,  s10:39,   s10:-1,  s10:2,   s10:-1,  s10:-5,  s10:-18, s10:11],
    ];
    
    let result = dct_2d_s10(yInMatrix);
    trace!(result);
    assert_eq(result, y_exp);
}

#[test]
fn test_gra8x16_u_dct_2d_s10() -> () {
    // Test on image_gra8x16.bmp: U channel
    let uInMatrix: s10[8][8] = [
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
        s10[8]:[s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1, s10:1],
    ];
    
    let y_exp: s10[8][8] = [
        s10[8]:[s10:9,  s10:0, s10:0, s10:0, s10:0, s10:3, s10:0,  s10:-3],
        s10[8]:[s10:0,  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,  s10:0],
        s10[8]:[s10:0,  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,  s10:0],
        s10[8]:[s10:0,  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,  s10:0],
        s10[8]:[s10:0,  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,  s10:0],
        s10[8]:[s10:0,  s10:0, s10:0, s10:0, s10:0, s10:1, s10:0,  s10:-1],
        s10[8]:[s10:2,  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,  s10:0],
        s10[8]:[s10:-2, s10:0, s10:0, s10:0, s10:0, s10:-1, s10:0, s10:1],
    ];    
    
    let result = dct_2d_s10(uInMatrix);
    trace!(result);
    assert_eq(result, y_exp);
}
