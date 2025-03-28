// NISHIHARU

// Function to clip the input s10 value to the range -511 to 511
fn clip_s12(input: s12) -> s12 {
    let output: s12 = if input > s12:511 {
        s12:511
    } else if input < s12:-511 {
        s12:-511
    } else {
        input
    };
    output
}

// Multiply two s16 values, extend the product to a 32-bit integer, and return the result as s32
fn mul_s16x2(a_in: s16, b_in: s16) -> s32 {
    // Extend a_in * b_in to 32 bits before calculating
    let outdata: s32 = (a_in as s32 * b_in as s32);
    outdata
}

// Function to convert 8-bit RGB values (r, g, b) to the YCbCr color space (s10 type)
//
// Conversion formulas (approximate values, integer arithmetic):
//   Y  = (77 * R + 150 * G + 29 * B) >> 8  (then subtract 128 to center)
//   Cb = (-43 * R - 85 * G + 128 * B) >> 8 
//   Cr = (128 * R - 107 * G - 21 * B) >> 8 
//
// ※ Each component is clipped to the range -511 to 511 using clip_s12
fn RGB_to_YCbCr(r: u8, g: u8, b: u8) -> (s12, s12, s12) {
    // Convert 8-bit RGB values to s16
    let r_16bit = r as s16;
    let g_16bit = g as s16;
    let b_16bit = b as s16;
    
    // Compute luminance Y
    let y_16: s16 = ((mul_s16x2(s16:77, r_16bit) +
                      mul_s16x2(s16:150, g_16bit) +
                      mul_s16x2(s16:29, b_16bit)) / s32:255 ) as s16;
    // Level shift: subtract 128 to center before DCT
    let y = clip_s12((y_16 as s12 - s12:128) as s12);
    
    // Compute blue-difference chroma component Cb
    let cb_16: s16 = ((mul_s16x2(s16:-43, r_16bit) +
                       mul_s16x2(s16:-85, g_16bit) +
                       mul_s16x2(s16:128, b_16bit)) / s32:255 ) as s16 ;
    // No level shifting
    let cb = clip_s12(cb_16 as s12);

    // Compute red-difference chroma component Cr
    let cr_16: s16 = ((mul_s16x2(s16:128, r_16bit) +
                       mul_s16x2(s16:-107, g_16bit) +
                       mul_s16x2(s16:-21, b_16bit)) / s32:255 ) as s16;
    // No level shifting
    let cr = clip_s12(cr_16 as s12);

    trace!(y);
    trace!(cb);
    trace!(cr);

    // Return the converted Y, Cb, Cr values
    (y, cb, cr)
}

// --- Test Code ---
//
// Each test verifies that the conversion result from RGB to YCbCr is as expected.
#[test]
fn test1_rgb_to_ycbcr() {
    // Test: Pure red (255, 0, 0)
    let r = u8:255;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // Expected values are based on the respective calculation results (set as an example here)
    assert_eq(y, s12:-51);
    assert_eq(cb, s12:-43);
    assert_eq(cr, s12:128);
}

#[test]
fn test2_rgb_to_ycbcr() {
    // Test: Black (0, 0, 0)
    let r = u8:0;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // In the case of black, Y, Cb, and Cr are all -128 (after level shift)
    assert_eq(y, s12:-128);
    assert_eq(cb, s12:0);
    assert_eq(cr, s12:0);
}

#[test]
fn test3_rgb_to_ycbcr() {
    // Test: White (255, 255, 255)
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // For white, Y becomes 128 (after centering), and Cb, Cr become -128 (after centering)
    assert_eq(y, s12:128);
    assert_eq(cb, s12:0);
    assert_eq(cr, s12:0);
}

#[test]
fn test4_rgb_to_ycbcr() {
    // Test: Pure green (0, 255, 0)
    let r = u8:0;
    let g = u8:255;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // Expected values depend on the calculation results. Set as an example here (adjust as necessary)
    assert_eq(y, s12:22);
    assert_eq(cb, s12:-85);
    assert_eq(cr, s12:-107);
}

#[test]
fn test5_rgb_to_ycbcr() {
    // Test: Recheck white (255, 255, 255)
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    assert_eq(y, s12:128);
    assert_eq(cb, s12:0);
    assert_eq(cr, s12:0);
}

#[test]
fn test6_rgb_to_ycbcr() {
    // Test: Gray (80, 80, 80)
    let r = u8:80;
    let g = u8:80;
    let b = u8:80;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    assert_eq(y, s12:-48);
    assert_eq(cb, s12:0);
    assert_eq(cr, s12:0);
}
