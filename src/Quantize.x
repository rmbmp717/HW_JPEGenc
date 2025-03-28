// NISHIHARU

pub const N: u32 = u32:8;
pub const QUALITY: u8 = u8:25;      // JPEG Quality

// quality >= 50 or quality < 50
pub const QUALITY_SCALE = if QUALITY < u8:50 { s16:5000 / QUALITY as s16 }
else if QUALITY >= u8:50 { s16:200 - s16:2 * QUALITY as s16 }
else { s16:255 };

// Standard JPEG luminance quantization table (s16)
// Standard luminance quantization table (s16)
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

// Standard chrominance (color difference) quantization table (s16)
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
           // Multiply and add in s32 and then divide by 100 (integer division is equivalent to floor)
           let prod: s32 = (std_tbl[i][j] as s32 * quality_scale as s32 + s32:50);
           let new_val: s16 = (prod / s32:100) as s16;
           update(row, j, new_val)
        }(std_tbl[i]);
      update(scaled, i, new_row)
    }(std_tbl)
}

// Scaled luminance quantization table (s16)
pub const LUMINANCE_QUANT_TBL: s16[N][N] =
    scale_quant_tbl(STD_LUMINANCE_QUANT_TBL, QUALITY_SCALE);

// Scaled chrominance quantization table (s16)
pub const CHROMINANCE_QUANT_TBL: s16[N][N] =
    scale_quant_tbl(STD_CHROMINANCE_QUANT_TBL, QUALITY_SCALE);

// Helper function: Convert a row of type s12[N] to s16[N]
pub fn convert_row(row: s12[N]) -> s16[N] {
  // Initialize an s16[N] array with all zeros and update each element using a for comprehension
  for (j, result): (u32, s16[N]) in range(u32:0, N) {
    update(result, j, row[j] as s16)
  }(s16[N]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ])
}

// Helper function: Convert a row of type s12[N] to s10[N]
pub fn convert_row_s10(row: s12[N]) -> s10[N] {
  // Initialize an s10[N] array with all zeros and update each element using a for comprehension
  for (j, result): (u32, s10[N]) in range(u32:0, N) {
    update(result, j, row[j] as s10)
  }(s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ])
}

//----------------------------------------------------------------------
// Main function for s12 input
pub fn Quantize_s10(dct_coeffs: s12[N][N], matrix_row: u8, is_luminance: bool, quantize_off: bool) -> (s10[N], u8) {
  let row_idx: u32 = matrix_row as u32;
  // Convert the s12 values of the target row to s16 to generate the initial row
  let initial_row: s16[N] = convert_row(dct_coeffs[row_idx]);
  let output_row: s10[N] = [initial_row[0] as s10, initial_row[1] as s10, initial_row[2] as s10, initial_row[3] as s10,
                            initial_row[4] as s10, initial_row[5] as s10, initial_row[6] as s10, initial_row[7] as s10];
  // Output
  (output_row, QUALITY)
}

//----------------------------------------------------------------------
// Main function for s12 input
pub fn Quantize(dct_coeffs: s12[N][N], matrix_row: u8, is_luminance: bool, quantize_off: bool) -> (u8, s10[N]) {
  let row_idx: u32 = matrix_row as u32;
  // Convert the s12 values of the target row to s16 to generate the initial row
  let initial_row: s16[N] = convert_row(dct_coeffs[row_idx]);
  // Perform quantization on each element
  let quantized: s10[N] = for (j, processed): (u32, s10[N]) in range(u32:0, N) {
    let q_value: s16 = if is_luminance {
      LUMINANCE_QUANT_TBL[row_idx][j]
    } else {
      CHROMINANCE_QUANT_TBL[row_idx][j]
    };
    // Rounding: (initial_row[j] + (q_value/2)) / q_value
    let divided: s32 = if quantize_off == false {
      ((initial_row[j] as s32 + (q_value as s32 / s32:2)) / (q_value as s32))
    } else {
      initial_row[j] as s32
    };
    let clipped: s10 = if divided > s32:255 {
      s10:255
    } else if divided < s32:-255 {
      s10:-255
    } else {
      divided as s10
    };
    update(processed, j, clipped)
  }(s10[N]:[ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ]);
  // Output
  (QUALITY, quantized)
}


//----------------------------------------------------------------------
// Test
#[test]
fn test_data100_quantize_block() -> () {
  // Use only row 0 of test_block; fill the rest with 0.
  let test_block: s12[8][8] = [
    s12[8]:[s12:200, s12:200, s12:200, s12:200, s12:200, s12:200, s12:200, s12:200],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,   s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0]
  ];

  // In this test, assume the luminance case (is_luminance == true)
  let expected_result_85: (u8, s10[8]) = ( u8:85, [
    s10:40, s10:67, s10:67, s10:40, s10:29, s10:17, s10:13, s10:11
  ] );
  let expected_result_25: (u8, s10[8]) = ( u8:25, [
    s10:6, s10:9, s10:10, s10:6, s10:4, s10:3, s10:2, s10:2
  ] );
  trace!(expected_result_85);
  trace!(expected_result_25);

  let result = Quantize(test_block, u8:0, true, false);
  trace!(result);
  if QUALITY == u8:85 {
    assert_eq(result, expected_result_85)
  } else if QUALITY == u8:85 {
    assert_eq(result, expected_result_25)
  } else { }
}

#[test]
fn test_imaga8x8_quantize_block() -> () {
  // Use only row 0 of test_block; fill the rest with 0.
  let test_block: s12[8][8] = [
    s12[8]:[s12:0,   s12:-671, s12:3,   s12:-68, s12:3,  s12:3,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,    s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,    s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,    s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:0,    s12:0,   s12:0,   s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:-50,  s12:1,   s12:-4,  s12:1,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:-180, s12:0,   s12:-18, s12:0,  s12:0,  s12:0,   s12:0],
    s12[8]:[s12:0,   s12:120,  s12:-1,  s12:12,  s12:-1, s12:-1, s12:0,   s12:0]
  ];

  // In this test, assume the luminance case (is_luminance == true)
  // The quantization result for row0 is based on manual calculation examples (e.g., (200 + 7)/15 = 13, etc.)
  let expected_result_85: (u8, s10[8]) = ( u8:85, [
    s10:0, s10:-223, s10:1, s10:-13, s10:0, s10:0, s10:0, s10:0
  ] );
  let expected_result_25: (u8, s10[8]) = ( u8:25, [
    s10:6, s10:9, s10:10, s10:6, s10:4, s10:3, s10:2, s10:2
  ] );
  trace!(expected_result_85);
  trace!(expected_result_25);

  let result = Quantize(test_block, u8:0, true, false);
  trace!(result);
  if QUALITY == u8:85 {
    assert_eq(result, expected_result_85)
  } else if QUALITY == u8:85 {
    assert_eq(result, expected_result_25)
  } else { }
}
