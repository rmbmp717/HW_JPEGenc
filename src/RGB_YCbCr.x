// NISHIHARU

// Converts an RGB pixel value into YCbCr format.
fn rgb_to_ycbcr(r: u8, g: u8, b: u8) -> (u8, u8, u8) {
    // Convert r, g, b to 16-bit signed integers for calculation.
    let r_16bit = (u8:0 ++ r) as s16;
    let g_16bit = (u8:0 ++ g) as s16;
    let b_16bit = (u8:0 ++ b) as s16;
    
    // Calculate the Y (luminance) component.
    // Y is derived as a weighted sum of the red, green, and blue components.
    let y_16 = (s16:77 * r_16bit + s16:150 * g_16bit + s16:29 * b_16bit) >> 8;
    let y = y_16 as u8;
    
    // Calculate the Cb (blue-difference chroma) component.
    let cb_16 = (s16:-43 * r_16bit + s16:-85 * g_16bit + s16:128 * b_16bit) >> 8;
    let cb = cb_16 as u8;
    // Adjust Cb range by adding 128.
    let cb = cb + u8:128;

    // Calculate the Cr (red-difference chroma) component.
    let cr_16 = (s16:128 * r_16bit + s16:-107 * g_16bit + s16:-21 * b_16bit) >> 8;
    let cr = cr_16 as u8;
    // Adjust Cr range by adding 128.
    let cr = cr + u8:128;

    // Output Y, Cb, Cr values for debugging purposes.
    //trace!(y);
    //trace!(cb);
    //trace!(cr);

    // Return the converted YCbCr values.
    (y, cb, cr)
}

// Test functions to validate the rgb_to_ycbcr conversion.
// These functions test various RGB inputs and verify the returned YCbCr values.

#[test]
fn test1_rgb_to_ycbcr() {
    // Test with pure red (255, 0, 0).
    let r = u8:255;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    // Expect a specific YCbCr result for pure red.
    assert_eq(y, u8:76);
    assert_eq(cb, u8:85);
    assert_eq(cr, u8:255);
}

#[test]
fn test2_rgb_to_ycbcr() {
    // Test with black (0, 0, 0).
    let r = u8:0;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    // Black should yield (Y=0, Cb=128, Cr=128).
    assert_eq(y, u8:0);
    assert_eq(cb, u8:128);
    assert_eq(cr, u8:128);
}

#[test]
fn test3_rgb_to_ycbcr() {
    // Test with white (255, 255, 255).
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    // White should yield (Y=255, Cb=128, Cr=128).
    assert_eq(y, u8:255);
    assert_eq(cb, u8:128);
    assert_eq(cr, u8:128);
}

#[test]
fn test4_rgb_to_ycbcr() {
    // Test with pure green (0, 255, 0).
    let r = u8:0;
    let g = u8:255;
    let b = u8:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    // Expect specific YCbCr values for pure green.
    assert_eq(y, u8:149);
    assert_eq(cb, u8:43);
    assert_eq(cr, u8:21);
}

#[test]
fn test5_rgb_to_ycbcr() {
    // Test with white (255, 255, 255) again.
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    // Confirm that white yields (Y=255, Cb=128, Cr=128).
    assert_eq(y, u8:255);
    assert_eq(cb, u8:128);
    assert_eq(cr, u8:128);
}
