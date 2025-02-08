// NISHIHARU

fn rgb_to_ycbcr(r: u8, g: u8, b: u8) -> (u8, u8, u8) {
    let r_16bit = (bits[8]:0 ++ r) as s16;
    let g_16bit = (bits[8]:0 ++ g) as s16;
    let b_16bit = (bits[8]:0 ++ b) as s16;
    
    // Y
    let y_16= (s16:77 * r_16bit + s16:150 * g_16bit + s16:29 * b_16bit) >> 8;
    let y = y_16 as bits[8];
    
    // Cb
    let cb_16= (s16:-43 * r_16bit + s16:-85 * g_16bit + s16:128 * b_16bit) >> 8;
    let cb = cb_16 as bits[8];
    let cb = cb + u8:128;

    // Cr
    let cr_16= (s16:128 * r_16bit + s16:-107 * g_16bit + s16:-21 * b_16bit) >> 8;
    let cr = cr_16 as bits[8];
    let cr = cr + u8:128;

    trace!(y);
    trace!(cb);
    trace!(cr);

    (y, cb, cr)
}

// テスト関数
#[test]
fn test1_rgb_to_ycbcr() {
    let r = bits[8]:255;
    let g = bits[8]:0;
    let b = bits[8]:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    assert_eq(y, bits[8]:76);
    assert_eq(cb, bits[8]:85);
    assert_eq(cr, bits[8]:255);
}

#[test]
fn test2_rgb_to_ycbcr() {
    let r = bits[8]:0;
    let g = bits[8]:0;
    let b = bits[8]:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    assert_eq(y, bits[8]:0);
    assert_eq(cb, bits[8]:128);
    assert_eq(cr, bits[8]:128);
}

#[test]
fn test3_rgb_to_ycbcr() {
    let r = bits[8]:255;
    let g = bits[8]:255;
    let b = bits[8]:255;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    assert_eq(y, bits[8]:255);
    assert_eq(cb, bits[8]:128);
    assert_eq(cr, bits[8]:128);
}

#[test]
fn test4_rgb_to_ycbcr() {
    let r = bits[8]:0;
    let g = bits[8]:255;
    let b = bits[8]:0;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    assert_eq(y, bits[8]:149);
    assert_eq(cb, bits[8]:43);
    assert_eq(cr, bits[8]:21);
}

#[test]
fn test5_rgb_to_ycbcr() {
    let r = bits[8]:255;
    let g = bits[8]:255;
    let b = bits[8]:255;
    let (y, cb, cr) = rgb_to_ycbcr(r, g, b);
    assert_eq(y, bits[8]:255);
    assert_eq(cb, bits[8]:128);
    assert_eq(cr, bits[8]:128);
}





