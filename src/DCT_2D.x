// DCT サイズ (N = 8 固定)
pub const N = u32:8;

// Q8.8 固定小数点スケール定義 (符号付き16ビット: s16)
// 固定小数点表現は、整数部8bit＋小数部8bit
pub const FIXED_ONE: s16 = s16:256;          // 1.0 を表す (256 = 1<<8)
pub const FIXED_SQRT_1_OVER_N: s16 = s16:91;      // sqrt(1/8)*256 ≈ 0.35355*256 ≒ 91
pub const FIXED_SQRT_2_OVER_N: s16 = s16:128;     // sqrt(2/8)*256 = 0.5*256 = 128

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

//----------------------------------------------------------------------
// 固定小数点の乗算 (Q8.8)
fn fixed_mul(a: s32, b: s16) -> s32 {
  let prod: s32 = a * (b as s32);
  let result: s32 = (prod + (s32:128)) >> 8;
  result as s32
}

//----------------------------------------------------------------------
// DCT 係数ごとの内積（dot product）を計算するヘルパー関数
fn dot_product(k: u8, x: s32[N]) -> s32 {
  for (n, acc): (u8, s32) in range(u8:0, N as u8) {
    acc + (fixed_mul(x[n], DCT_LUT[k][n]) as s32)
  }(s32:0)
}


//----------------------------------------------------------------------
// 1D DCT 計算 (Q8.8 固定小数点)
// 入出力は Q8.8 表現 (s16[N]) の配列となる。
// ※ DCT 計算は、各 k について
//     sum = Σₙ fixed_mul(x[n], DCT_LUT[k][n])
//     scaled_sum = (sum * α + 128) >> 8
//   となっています。
//   ここで、α = FIXED_SQRT_1_OVER_N (k==0) あるいは FIXED_SQRT_2_OVER_N (k≠0)
pub fn dct_1d(x: s32[N]) -> s32[N] {
  for (k, result): (u8, s32[N]) in range(u8:0, N as u8) {
    let sum: s32 = dot_product(k, x);
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
// s10 型入力の 1D DCT 計算
pub fn dct_1d_s10(x: s10[N]) -> s10[N] {
  // 1. 入力のレベルシフト: Q8.8 表現にする
  let x_q88: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      // 入力から 128 を引いてゼロ中心化し、明示的に 256 を掛けて Q8.8 表現にする
      let shifted: s32 = ((x[i] as s32) - s32:128) * s32:256;
      update(acc, i, shifted)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  // 2. Q8.8 固定小数点 DCT を計算
  let y_q88: s32[N] = dct_1d(x_q88);

  // 3. Q8.8 表現から整数に変換（四捨五入: +128 して右シフト 8 ビット）
  let y_int32: s32[N] = for (i, acc): (u32, s32[N]) in range(u32:0, N) {
      let val: s32 = y_q88[i] as s32;
      let rounded: s32 = (val + s32:128) >> 8;
      update(acc, i, rounded)
  }(s32[N]:[s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0, s32:0]);

  // 4. 逆レベルシフト: 各値に +128 して、手計算版と同じスケールに復帰
  let result: s10[N] = for (i, acc): (u32, s10[N]) in range(u32:0, N) {
      let adjusted: s32 = (y_int32[i] + s32:128);
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

// ヘルパー関数: 長さ N のゼロで初期化された 1D 配列 (u8)
fn zeros_s10_1d() -> s10[N] {
    [ s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0 ]
}

// ヘルパー関数: 長さ N のゼロで初期化された 2D 配列 (u8)
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

// メイン関数
// 2D DCT 計算 (Q8.8) - u8 入出力版
// まず各行に対して 1D DCT を適用し、その後各列に対して 1D DCT を適用
pub fn dct_2d_s10(x: s10[N][N]) -> s10[N][N] {
    // ✅ 行方向 DCT
    let row_transformed: s10[N][N] =
        for (i, acc): (u32, s10[N][N]) in range(u32:0, N) {
            update(acc, i, dct_1d_s10(x[i]))  // ✅ 行ごとに DCT を適用
        }(zeros_2d());

    // ✅ 列方向 DCT
    let col_transformed: s10[N][N] =
        for (j, acc): (u32, s10[N][N]) in range(u32:0, N) {
            // ✅ `row_transformed` の各列を抽出
            let col: s10[N] =
                for (i, col_acc): (u32, s10[N]) in range(u32:0, N) {
                    update(col_acc, i, row_transformed[i][j])
                }(zeros_s10_1d());  // ✅ `zeros_1d()` → `zeros_u8_1d()` に修正

            // ✅ 1D DCT を適用
            let col_dct: s10[N] = dct_1d_s10(col);

            trace!(col_dct);

            // ✅ `col_dct` の結果を `col_transformed` に更新
            for (i, updated_mat): (u32, s10[N][N]) in range(u32:0, N) {
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
fn test1_dct_1d_allzero() {
    let x = s10[8]:[s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0]; // テスト用の入力データ
    let expected = s10[8]:[-236, 128, 128, 128, 128, 101, 30, 193];
    trace!(x);
  
    let result = dct_1d_s10(x); // 実際の計算結果
    trace!(expected);
    trace!(result);
    assert_eq(result, expected);
  }

#[test]
fn test2_dct_1d() {
    let x = s10[8]:[s10:4, s10:3, s10:20, s10:70, s10:12, s10:6, s10:12, s10:8]; // テスト用の入力データ
    let expected = s10[8]:[-188, 132, 94, 104, 147, 129, 68, 161];
    trace!(x);

    let result = dct_1d_s10(x); // 実際の計算結果
    trace!(expected);
    trace!(result);
    assert_eq(result, expected);
}

#[test]
fn test3_dct_1d() {
  let x = s10[8]:[s10:-48, s10:-48, s10:-48, s10:-48, s10:-128, s10:-128, s10:-128, s10:-128]; // テスト用の入力データ
  let expected = s10[8]:[-486, 231, 128, 92, 128, 82, -37, 238];
  trace!(x);

  let result = dct_1d_s10(x); // 実際の計算結果
  trace!(expected);
  trace!(result);
  assert_eq(result, expected);
}
  
// 2D DCTのテスト
#[test]
fn test2_dct_2d_s10_const() -> () {
    // 全て 80 の入力
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
    // 左上 4x4 が 80、残りが 0 の入力
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
    let result_row1: s10[8] = result[0];
    let exp_result_row1: s10[8] = [s10:-511, s10:274, s10:128, s10:77, s10:128, s10:-14, s10:-385, s10:469];
    let result_row2: s10[8] = result[1];
    let exp_result_row2: s10[8] = [s10:160, s10:260, s10:128, s10:82, s10:128, s10:138, s10:168, s10:102];
    trace!(result);
    assert_eq(result_row1, exp_result_row1);
    assert_eq(result_row2, exp_result_row2);
}
