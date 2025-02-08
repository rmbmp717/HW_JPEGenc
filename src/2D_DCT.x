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
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;    // ≈ sqrt(1/8)*256 (0.35355*256 ≒ 90.5 → 91)
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;   // 0.5*256 = 128

// 入力（0～255）の整数値を固定小数点 (Q8.8) に変換
fn to_fixed(x: s16) -> s16 {
	x * FIXED_ONE
}

// 固定小数点 (Q8.8) から整数へ変換（上位8ビットを取り出す）
fn from_fixed(x: s16) -> s16 {
	x >> 8
}

// 固定 DCT 係数 LUT (Q8.8)  (s16)
// LUT[k][n] = cos(π*(n+0.5)*k/8)*FIXED_ONE  (k, n = 0,...,7)
// 以下は概ね四捨五入した整数値
pub const DCT_LUT: s16[N][N] = [
	[ s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256,  s16:256  ], // k = 0
	[ s16:251,  s16:213,  s16:142,  s16:50,   s16:-50,  s16:-142, s16:-213, s16:-251 ], // k = 1
	[ s16:236,  s16:98,   s16:-98,  s16:-236, s16:-236, s16:-98,  s16:98,   s16:236  ], // k = 2
	[ s16:213,  s16:-50,  s16:-251, s16:-142, s16:142,  s16:251,  s16:50,   s16:-213 ], // k = 3
	[ s16:181,  s16:-181, s16:-181, s16:181,  s16:181,  s16:-181, s16:-181, s16:181  ], // k = 4
	[ s16:142,  s16:-251, s16:-50,  s16:213,  s16:213,  s16:-50,  s16:-251, s16:142  ], // k = 5
	[ s16:98,   s16:-236, s16:98,   s16:236,  s16:236,  s16:98,   s16:-236, s16:98   ], // k = 6
	[ s16:50,   s16:-142, s16:213,  s16:-251, s16:-251, s16:213,  s16:-142, s16:50   ]  // k = 7
];

// 固定小数点乗算 (Q8.8)
// 乗算後、丸め処理として半分の値 (128) を加えて右シフト8ビット
fn fixed_mul(a: s16, b: s16) -> s16 {
	let prod = a * b;
	let result = (prod + (s16:1 << 7)) >> 8;
	result
}

// 1D DCT 計算 (Q8.8)
// 入力: s16[N] の固定小数点値、出力: s16[N]
pub fn dct_1d(x: s16[N]) -> s16[N] {
	for (k, result): (u32, s16[N]) in range(u32:0, N) {
		let sum = for (n, acc): (u32, s16) in range(u32:0, N) {
			acc + fixed_mul(x[n], DCT_LUT[k][n])
		}(s16:0);
		let scaled_sum = if k == u32:0 {
			fixed_mul(sum, FIXED_SQRT_1_OVER_N)
		} else {
			fixed_mul(sum, FIXED_SQRT_2_OVER_N)
		};
		update(result, k, scaled_sum)
	}(s16[N]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0])
}

// ヘルパー：長さ N のゼロで初期化された1次元配列 (s16)
fn zeros_1d() -> s16[N] {
	[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]
}

// 2D DCT 計算 (Q8.8)
// まず各行に対して1D DCT を適用し、その後各列に対して1D DCT を適用する
pub fn dct_2d(x: s16[N][N]) -> s16[N][N] {
	let row_transformed: s16[N][N] =
		for (i, acc): (u32, s16[N][N]) in range(u32:0, N) {
			update(acc, i, dct_1d(x[i]))
		}(s16[N][N]:[ zeros_1d(), zeros_1d(), zeros_1d(), zeros_1d(),
		              zeros_1d(), zeros_1d(), zeros_1d(), zeros_1d() ]);
	let col_transformed: s16[N][N] =
		for (j, acc): (u32, s16[N][N]) in range(u32:0, N) {
			let col: s16[N] =
				for (i, col_acc): (u32, s16[N]) in range(u32:0, N) {
					update(col_acc, i, row_transformed[i][j])
				}(s16[N]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]);
			let col_dct = dct_1d(col);
			for (i, acc_updated): (u32, s16[N][N]) in range(u32:0, N) {
				update(acc_updated, i, update(acc[i], j, col_dct[i]))
			}(acc)
		}(row_transformed);
	col_transformed
}

// ---------------------------
// テスト
// ---------------------------

#[test]
fn test1_dct_1d_zero() -> () {
	// すべてゼロの入力に対して出力もゼロ
	let x: s16[8] = [ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ];
	let result = dct_1d(x);
    for (i, _): (u32, ()) in range(u32:0, u32:8) {
        assert_eq(result[i], s16:0)
    } (())
}

#[test]
fn test2_dct_1d_const() -> () {
	// 定常な入力 (すべて100) に対して、DC成分が支配的であることを確認
	let x_int: s16[8] = [ s16:100, s16:100, s16:100, s16:100, s16:100, s16:100, s16:100, s16:100 ];
	let x_fixed: s16[8] = {
		for (i, acc): (u32, s16[8]) in range(u32:0, u32:8) {
			update(acc, i, to_fixed(x_int[i]))
		}(s16[8]:[ to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0),
		             to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0) ])
	};
	let result_fixed = dct_1d(x_fixed);
	let result_int: s16[8] = {
		for (i, acc): (u32, s16[8]) in range(u32:0, u32:8) {
			update(acc, i, from_fixed(result_fixed[i]))
		}(s16[8]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ])
	};
	// 定常入力なら DC 成分が他の成分より大きいはず
	let dc = result_int[0];
	for (i, _): (u32, ()) in range(u32:0, u32:8) {
		if i != u32:0 {
			assert(dc >= result_int[i])
		} else {
			()
		}
	} (())
}

#[test]
fn test3_dct_2d_const() -> () {
	// 2D DCT のテスト：定常な 8×8 入力 (すべて128) に対して DC 成分のみ有意で、他は丸め誤差 (±1) となるはず
	let value: s16 = s16:128;
	let row: s16[8] = [ value, value, value, value, value, value, value, value ];
	let x_int: s16[8][8] = [ row, row, row, row, row, row, row, row ];
	
	// 入力を固定小数点 (Q8.8) に変換
	let x_fixed: s16[8][8] = {
		for (i, acc): (u32, s16[8][8]) in range(u32:0, u32:8) {
			// 内側の for ループ結果を inner_arr に代入
			let inner_arr: s16[8] =
				for (j, inner): (u32, s16[8]) in range(u32:0, u32:8) {
					update(inner, j, to_fixed(x_int[i][j]))
				}(s16[8]:[
					to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0),
					to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0), to_fixed(s16:0)
				]);
			update(acc, i, inner_arr)
		}(s16[8][8]:[
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]
		])
	};
	
	// 2D DCT の計算（固定小数点値）
	let result_fixed: s16[8][8] = dct_2d(x_fixed);
	// 計算結果を整数に変換
	let result_int: s16[8][8] = {
		for (i, acc): (u32, s16[8][8]) in range(u32:0, u32:8) {
			let inner_arr: s16[8] =
				for (j, inner): (u32, s16[8]) in range(u32:0, u32:8) {
					update(inner, j, from_fixed(result_fixed[i][j]))
				}(s16[8]:[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]);
			update(acc, i, inner_arr)
		}(s16[8][8]:[
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ],
			[ s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0, s16:0 ]
		])
	};
	
	// 定常入力なら、DC 成分 (result_int[0][0]) は正で、他は丸め誤差として -1～1 の範囲であることを確認
	let dc = result_int[0][0];
	assert(dc > s16:0);
	for (i, _): (u32, ()) in range(u32:0, u32:8) {
		for (j, _): (u32, ()) in range(u32:0, u32:8) {
			if i == u32:0 && j == u32:0 {
				()  // DC 成分はチェック済み
			} else {
				assert((result_int[i][j] >= -s16:1) && (result_int[i][j] <= s16:1))
			}
		} (())
	} (())
}
