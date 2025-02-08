	// 2D DCT の DSLX 実装 (Q32.32 固定小数点)

	// DCT サイズ (N = 8 固定)
	pub const N = u32:8;

	// Q32.32 固定小数点スケール定義
	pub const FIXED_ONE = u64:1 << 32;  // 1.0
	pub const FIXED_SQRT_1_OVER_N = u64:3037000499; // sqrt(1/8) ≈ 0.353553 * 2^32
	pub const FIXED_SQRT_2_OVER_N = u64:4294967296; // sqrt(2/8) ≈ 0.5 * 2^32

	// **固定 DCT 係数 LUT (Q32.32)**
	//   C[k][n] = cos(π (n + 0.5) k / N) を Q32.32 固定小数点で事前計算
	pub const DCT_LUT: u64[N][N] = [
		[u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499], // k=0
		[u64:4265047728, u64:3518437209, u64:2160026241, u64:759250124, u64:759250124, u64:2160026241, u64:3518437209, u64:4265047728], // k=1
		[u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608], // k=2
		[u64:3518437209, u64:759250124, u64:4265047728, u64:2160026241, u64:2160026241, u64:4265047728, u64:759250124, u64:3518437209], // k=3
		[u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499, u64:3037000499], // k=4
		[u64:2160026241, u64:4265047728, u64:759250124, u64:3518437209, u64:3518437209, u64:759250124, u64:4265047728, u64:2160026241], // k=5
		[u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918, u64:1717986918, u64:3996160608, u64:3996160608, u64:1717986918], // k=6
		[u64:759250124, u64:2160026241, u64:3518437209, u64:4265047728, u64:4265047728, u64:3518437209, u64:2160026241, u64:759250124], // k=7
	];

	// **固定小数点の乗算 (Q32.32)**
	fn fixed_mul(a: u64, b: u64) -> u64 {
		let result = ((a * b) + (u64:1 << 31)) >> 32;
		result
	}

	// **1D DCT 計算**
	pub fn dct_1d(x: u64[N]) -> u64[N] {
		for (k, result): (u32, u64[N]) in range(u32:0, N) {
			let sum = for (n, acc): (u32, u64) in range(u32:0, N) {
				let mul_result = fixed_mul(x[n], DCT_LUT[k][n]);
				acc + mul_result
			}(u64:0);

			// スケール係数の適用
			let scaled_sum = if k == u32:0 {
				fixed_mul(sum, FIXED_SQRT_1_OVER_N)
			} else {
				fixed_mul(sum, FIXED_SQRT_2_OVER_N)
			};

			update(result, k, scaled_sum)
		}(u64[N]:[u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0])
	}

	// 1 次元の長さ N のゼロ配列を生成するヘルパー関数
	fn zeros() -> u64[N] {
		[u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0, u64:0]
	}

	// **2D DCT 計算**
	pub fn dct_2d(x: u64[N][N]) -> u64[N][N] {
		// 各行に対して 1D DCT を適用
		let row_transformed: u64[N][N] =
			for (i, acc): (u32, u64[N][N]) in range(u32:0, N) {
				let transformed_row = dct_1d(x[i]);
				update(acc, i, transformed_row)
			} (
				// 初期値：各行は zeros() で初期化した 2D 配列（リテラルで 8 回書く）
				[ zeros(), zeros(), zeros(), zeros(),
				  zeros(), zeros(), zeros(), zeros() ]
			);

		// 各列に対して 1D DCT を適用
		let col_transformed: u64[N][N] =
			for (j, acc): (u32, u64[N][N]) in range(u32:0, N) {
				// 各列 j を取り出すための 1 次元配列を作成
				let col: u64[N] =
					for (i, col_acc): (u32, u64[N]) in range(u32:0, N) {
						update(col_acc, i, row_transformed[i][j])
					} (
						// 初期値：1 次元のゼロ配列（リテラルで 8 個の 0）
						[ u64:0, u64:0, u64:0, u64:0,
						  u64:0, u64:0, u64:0, u64:0 ]
					);

				let transformed_col: u64[N] = dct_1d(col);

				// 各行の j 番目の要素を更新
				for (i, acc_updated): (u32, u64[N][N]) in range(u32:0, N) {
					update(acc_updated, i, update(acc[i], j, transformed_col[i]))
				} (acc)
			} (row_transformed);

		col_transformed
	}

	// 2D DCT でも、全ゼロの入力の場合、出力も全ゼロになるはず
	#[test]
	fn test_dct2d_zero() -> () {
		let input: u64[N][N] = [
			zeros(), zeros(), zeros(), zeros(),
			zeros(), zeros(), zeros(), zeros()
		];
		trace!(input);
		let output: u64[N][N] = dct_2d(input);
		for (i, _outer): (u32, ()) in range(u32:0, N) {
			for (j, _inner): (u32, ()) in range(u32:0, N) {
				trace!(output[i][j]);
				assert_eq(output[i][j], u64:0)
			} (())
		} (())
	}
