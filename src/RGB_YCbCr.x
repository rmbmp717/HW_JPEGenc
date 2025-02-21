// NISHIHARU

// 入力された s10 型の値を -511 ～ 511 の範囲にクリップする関数
fn clip_s10(input: s10) -> s10 {
    let output: s10 = if input > s10:511 {
        s10:511
    } else if input < s10:-511 {
        s10:-511
    } else {
        input
    };
    output
}

// 2 つの s16 値の乗算を行い、255 で除算して結果を s16 で返す（スケーリング付き乗算）
fn mul_s16x2(a_in: s16, b_in: s16) -> s16 {
    // a_in * b_in を 32 ビット整数に拡張してから計算し、255 で割る
    let outdata: s32 = (a_in as s32 * b_in as s32) / s32:255;
    outdata as s16
}

// RGB 8bit 値 (r, g, b) を YCbCr 色空間 (s10 型) に変換する関数
//
// 変換式（近似値、整数演算）:
//   Y  = (77 * R + 150 * G + 29 * B) >> 8  (計算後、128 を引いて中心化)
//   Cb = (-43 * R - 85 * G + 128 * B) >> 8  (計算後、128 を引いて中心化)
//   Cr = (128 * R - 107 * G - 21 * B) >> 8  (計算後、128 を引いて中心化)
//
// ※各成分は clip_s10 で -511～511 にクリップされる
fn RGB_to_YCbCr(r: u8, g: u8, b: u8) -> (s10, s10, s10) {
    // 8bit の RGB 値を s16 に変換
    let r_16bit = r as s16;
    let g_16bit = g as s16;
    let b_16bit = b as s16;
    
    // 輝度 Y の計算
    let y_16: s16 = (mul_s16x2(s16:77, r_16bit) +
                     mul_s16x2(s16:150, g_16bit) +
                     mul_s16x2(s16:29, b_16bit)) as s16;
    // レベルシフト：DCT前に中心化するために128を引く
    let y = clip_s10((y_16 as s10 - s10:128) as s10);
    
    // 青色差成分 Cb の計算
    let cb_16: s16 = (mul_s16x2(s16:-43, r_16bit) +
                      mul_s16x2(s16:-85, g_16bit) +
                      mul_s16x2(s16:128, b_16bit)) as s16;
    // レベルシフトしない
    let cb = clip_s10(cb_16 as s10 - s10:0);

    // 赤色差成分 Cr の計算
    let cr_16: s16 = (mul_s16x2(s16:128, r_16bit) +
                      mul_s16x2(s16:-107, g_16bit) +
                      mul_s16x2(s16:-21, b_16bit)) as s16;
    // レベルシフトしない
    let cr = clip_s10(cr_16 as s10 - s10:0);

    trace!(y);
    trace!(cb);
    trace!(cr);

    // 変換後の Y, Cb, Cr 値を返す
    (y, cb, cr)
}

// --- テストコード ---
//
// 各テストは RGB 値から YCbCr への変換結果が期待通りであるかを検証します。
#[test]
fn test1_rgb_to_ycbcr() {
    // テスト：純粋な赤 (255, 0, 0)
    let r = u8:255;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // 期待値はそれぞれの計算結果に基づく（ここでは例として設定）
    assert_eq(y, s10:-51);
    assert_eq(cb, s10:-43);
    assert_eq(cr, s10:128);
}

#[test]
fn test2_rgb_to_ycbcr() {
    // テスト：黒 (0, 0, 0)
    let r = u8:0;
    let g = u8:0;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // 黒の場合、Y, Cb, Cr それぞれ -128 となる（レベルシフト後）
    assert_eq(y, s10:-128);
    assert_eq(cb, s10:0);
    assert_eq(cr, s10:0);
}

#[test]
fn test3_rgb_to_ycbcr() {
    // テスト：白 (255, 255, 255)
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // 白の場合、Y は 128 (中心化後) となり、Cb, Cr は -128（中心化後）となる
    assert_eq(y, s10:128);
    assert_eq(cb, s10:0);
    assert_eq(cr, s10:0);
}

#[test]
fn test4_rgb_to_ycbcr() {
    // テスト：純粋な緑 (0, 255, 0)
    let r = u8:0;
    let g = u8:255;
    let b = u8:0;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    // 期待値は計算結果に依存します。ここでは例として設定（適宜調整してください）
    assert_eq(y, s10:22);
    assert_eq(cb, s10:-85);
    assert_eq(cr, s10:-107);
}

#[test]
fn test5_rgb_to_ycbcr() {
    // テスト：白 (255, 255, 255) の再確認
    let r = u8:255;
    let g = u8:255;
    let b = u8:255;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    assert_eq(y, s10:128);
    assert_eq(cb, s10:0);
    assert_eq(cr, s10:0);
}

#[test]
fn test6_rgb_to_ycbcr() {
    // テスト：白 (255, 255, 255) の再確認
    let r = u8:80;
    let g = u8:80;
    let b = u8:80;
    let (y, cb, cr) = RGB_to_YCbCr(r, g, b);
    assert_eq(y, s10:-48);
    assert_eq(cb, s10:1);
    assert_eq(cr, s10:1);
}
