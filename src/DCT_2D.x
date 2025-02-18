// ---------------------------
// メッセージ定数（"assertion failed"）
// ---------------------------
pub const ASSERT_FAIL_MSG: u8[16] = [
	u8:97,  // 'a'
	u8:115, // 's'
	u8:115, // 's'
	u8:101, // 'e'
	u8:114, // 'r'
	u8:116, // 't'
	u8:105, // 'i'
	u8:111, // 'o'
	u8:110, // 'n'
	u8:32,  // ' '
	u8:102, // 'f'
	u8:97,  // 'a'
	u8:105, // 'i'
	u8:108, // 'l'
	u8:101, // 'e'
	u8:100  // 'd'
];

// ---------------------------
// fail 関数の定義
// ---------------------------
fn discard_u32(x: u32) -> () { () }

fn fail(msg: u8[16]) -> () {
	trace!(msg);
	discard_u32(u32:1 / (u32:0));
}

// ---------------------------
// assert 関数の定義
// ---------------------------
fn assert(cond: bool) -> () {
	if cond {
		()
	} else {
		fail(ASSERT_FAIL_MSG)
	}
}

// DCT サイズ (N = 8 固定)
pub const N = u32:8;

// Q8.8 固定小数点スケール定義 (符号付き16ビット: s16)
// 固定小数点表現は、整数部8bit＋小数部8bit
pub const FIXED_ONE: s16 = s16:256;          // 1.0 を表す (256 = 1<<8)
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;      // sqrt(1/8)*256 ≈ 0.35355*256 ≒ 91
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;     // sqrt(2/8)*256 = 0.5*256 = 128

// 入力（0～255）の整数値を固定小数点 (Q8.8) に変換
fn to_fixed(x: s16) -> s16 {
	x * FIXED_ONE
}

// 固定小数点 (Q8.8) から整数へ変換（上位8ビットを取り出す）
fn from_fixed(x: s16) -> s16 {
	(x + (s16:1 << 7)) >> 8
}

// 固定 DCT 係数 LUT (Q8.8)  (s16)
// LUT[k][n] = cos(π*(n+0.5)*k/8)*FIXED_ONE  (k, n = 0,...,7)
// 以下は概ね四捨五入した整数値
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

// 固定小数点乗算 (Q8.8)
// 乗算後、丸め処理として半分の値 (80) を加えて右シフト8ビット
// 固定小数点乗算 (Q8.8)
fn fixed_mul(a: s16, b: s16) -> s16 {
    let prod: s32 = (a as s32) * (b as s32);
    let result: s32 = (prod + (s32:1 << 7)) >> 8;  // 2倍補正を削除
    if result > s32:32767 {
        s16:32767
    } else if result < s32:-32768 {
        s16:-32768
    } else {
        result as s16
    }
}

// 1D DCT 計算 (Q8.8)
// 入力: s16[N] の固定小数点値、出力: s16[N]
pub fn dct_1d(x: s16[N]) -> s16[N] {
	for (k, result): (u32, s16[N]) in range(u32:0, N) {
	  let sum: s32 = for (n, acc): (u32, s32) in range(u32:0, N) {
		acc + (fixed_mul(x[n], DCT_LUT[k][n]) as s32)  // ← 修正
	  }(s32:0);
  
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

  

// ヘルパー関数: 長さ N のゼロで初期化された 1D 配列 (u8)
fn zeros_u8_1d() -> u8[N] {
    [ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ]
}

// ヘルパー関数: 長さ N のゼロで初期化された 2D 配列 (u8)
fn zeros_2d() -> u8[N][N] {
	[ u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ],
	  u8[N]:[ u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0 ] ]
}

// メイン関数
// 2D DCT 計算 (Q8.8) - u8 入出力版
// まず各行に対して 1D DCT を適用し、その後各列に対して 1D DCT を適用
pub fn dct_2d_u8(x: u8[N][N]) -> u8[N][N] {
    // ✅ 行方向 DCT
    let row_transformed: u8[N][N] =
        for (i, acc): (u32, u8[N][N]) in range(u32:0, N) {
            update(acc, i, dct_1d_u8(x[i]))  // ✅ 行ごとに DCT を適用
        }(zeros_2d());

    trace!(row_transformed);  // ✅ 行方向 DCT の結果を確認

    // ✅ 列方向 DCT
    let col_transformed: u8[N][N] =
        for (j, acc): (u32, u8[N][N]) in range(u32:0, N) {
            // ✅ `row_transformed` の各列を抽出
            let col: u8[N] =
                for (i, col_acc): (u32, u8[N]) in range(u32:0, N) {
                    update(col_acc, i, row_transformed[i][j])
                }(zeros_u8_1d());  // ✅ `zeros_1d()` → `zeros_u8_1d()` に修正

            // ✅ 1D DCT を適用
            let col_dct: u8[N] = dct_1d_u8(col);

            trace!(col_dct);

            // ✅ `col_dct` の結果を `col_transformed` に更新
            for (i, updated_mat): (u32, u8[N][N]) in range(u32:0, N) {
                let updated_row = update(updated_mat[i], j, col_dct[i]);
                update(updated_mat, i, updated_row)
            }(acc)
        }(row_transformed);

    //trace!(col_transformed);  // ✅ 列方向 DCT の結果を確認

    col_transformed
}


// ---------------------------
// テスト
// ---------------------------

// 1D DCTのテスト
#[test]
fn test1_dct_1d_zero() -> () {
	// すべてゼロの入力に対して出力もゼロ
	let x: s16[8] = [ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ];
	let result = dct_1d(x);
    for (i, _): (u32, ()) in range(u32:0, u32:8) {
        assert_eq(result[i], s16:0)
    } (())
}

// 2D DCTのテスト
#[test]
fn test2_dct_2d_u8_const() -> () {
    // 全て 80 の入力
    let x: u8[8][8] = [
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80, u8:80]
    ];

    let result = dct_2d_u8(x);
	//trace!(result);
    assert(result[0][0] == u8:0);
}

#[test]
fn test3_dct_2d_u8_top_left_4x4_80() -> () {
    // 左上 4x4 が 80、残りが 0 の入力
    let x: u8[8][8] = [
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:80, u8:80, u8:80, u8:80, u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0 ],
        u8[8]:[u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0 ]
    ];

    let expected: u8[8][8] = [
        u8[8]:[u8:0,   u8:255, u8:128, u8:77,  u8:128, u8:63,  u8:0,   u8:255 ],
        u8[8]:[u8:128, u8:255, u8:128, u8:82,  u8:128, u8:138, u8:168, u8:102 ],
        u8[8]:[u8:128, u8:128, u8:128, u8:128, u8:128, u8:128, u8:128, u8:128 ],
        u8[8]:[u8:128, u8:82,  u8:128, u8:144, u8:128, u8:124, u8:114, u8:137 ],
        u8[8]:[u8:128, u8:128, u8:128, u8:128, u8:128, u8:128, u8:128, u8:128 ],
        u8[8]:[u8:101, u8:139, u8:128, u8:124, u8:128, u8:123, u8:111, u8:140 ],
        u8[8]:[u8:30,  u8:167, u8:128, u8:114, u8:128, u8:110, u8:65,  u8:170 ],
        u8[8]:[u8:193, u8:102, u8:128, u8:137, u8:128, u8:140, u8:170, u8:100 ]
    ];

    let result = dct_2d_u8(x);
    trace!(result);

    // 期待されるリファレンスの出力と一致するか確認
    assert_eq(result, expected);
}
