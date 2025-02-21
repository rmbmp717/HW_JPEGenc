import numpy as np
import math
from scipy.fftpack import dct

# =====================================
# (1) 固定小数点 1D DCT 実装 (Q8.8) 修正版
# =====================================

# 1.1 固定小数点スケール定義 (Q8.8)
FIXED_ONE = np.int16(256)            # 1.0 => 256
FIXED_SQRT_1_OVER_N = np.int16(91)  # sqrt(1/8)*256 ≈ 0.35355 * 256
FIXED_SQRT_2_OVER_N = np.int16(128)  # sqrt(2/8)*256 ≈ 0.5 * 256

# 1.2 固定 DCT 係数 LUT (Q8.8, s16) 修正
DCT_LUT = np.array([
    [256,  256,  256,  256,  256,  256,  256,  256],  # k=0
    [251,  213,  142,   50,  -50, -142, -213, -251],  # k=1
    [236,   98,  -98, -236, -236,  -98,   98,  236],  # k=2
    [213,  -50, -251, -142,  142,  251,   50, -213],  # k=3
    [181, -181, -181,  181,  181, -181, -181,  181],  # k=4
    [142, -251,  -50,  213,  213,  -50, -251,  142],  # k=5
    [ 98, -236,   98,  236,  236,   98, -236,   98],  # k=6
    [ 50, -142,  213, -251, -251,  213, -142,   50],  # k=7
], dtype=np.int16)

def fixed_mul_q88(a: np.int32, b: np.int32) -> np.int32:
    """
    Q8.8 同士の乗算。int32 で計算し、256 で割って四捨五入する。
    """
    prod = a * b
    return (prod + 128) >> 8

def dct_1d_q88(x_q88: np.ndarray) -> np.ndarray:
    """
    Q8.8 (int32) 配列（長さ8）→ Q8.8 (int32) の 1次元DCT
    """
    N = 8
    y = np.zeros(N, dtype=np.int32)
    for k in range(N):
        s = np.int32(0)
        for n in range(N):
            s += fixed_mul_q88(np.int32(x_q88[n]), np.int32(DCT_LUT[k, n]))
        # スケーリング係数 (k==0なら FIXED_SQRT_1_OVER_N, それ以外なら FIXED_SQRT_2_OVER_N)
        alpha = int(FIXED_SQRT_1_OVER_N) if k == 0 else int(FIXED_SQRT_2_OVER_N)
        y[k] = (s * alpha + 128) >> 8
    return y  # Q8.8 表現から一段目のスケーリングが終わった値（int32）

def dct_1d_s16(x_u8: np.ndarray) -> np.ndarray:
    """
    入出力: u8[8]
    手計算版と同じく、入力に対してレベルシフト (-128) し、DCT計算後に逆レベルシフト (+128) を行う。
    出力は np.int16 型で返す（手計算版: np.clip(np.rint(out_f + 128), -511, 512)）。
    """
    # 1. 入力のレベルシフト: 0～255 -> -128～127
    x_shifted = x_u8.astype(np.int32) - 128
    # 2. Q8.8 表現へ変換（左シフト 8 ビット）
    x_q88 = x_shifted << 8
    # 3. 固定小数点 DCT 計算
    y_q88 = dct_1d_q88(x_q88)  # 結果は Q8.8 表現相当の int32 値
    # 4. Q8.8 から整数へ変換（四捨五入）
    y_int = (y_q88 + 128) >> 8
    # 5. 逆レベルシフト (+128) を加えて、手計算版と同じスケールに復帰
    result = np.clip(np.rint(y_int + 128), -511, 512).astype(np.int16)
    return result

# =====================================
# (2) 手計算ベースの 1D DCT 修正版
# =====================================
def dct_1d_manual(x_u8: np.ndarray) -> np.ndarray:
    """ 手計算による 1D DCT (JPEG スケール) """
    N = 8
    x_f = x_u8.astype(np.float64) - 128  # レベルシフト
    out_f = np.zeros(N, dtype=np.float64)

    for k in range(N):
        alpha = math.sqrt(0.5) if k == 0 else 1.0
        s = sum(x_f[n] * math.cos((math.pi / N) * (n + 0.5) * k) for n in range(N))
        out_f[k] = alpha * s * math.sqrt(2.0 / N)

    return np.clip(np.rint(out_f + 128), -511, 512).astype(np.int16)  # レベルシフト復帰

# =====================================
# (3) 2D DCT の実装 (変更なし)
# =====================================
def dct_2d_q88(img_u8: np.ndarray) -> np.ndarray:
    tmp = np.apply_along_axis(dct_1d_s16, axis=1, arr=img_u8)  # 行ごとに DCT
    return np.apply_along_axis(dct_1d_s16, axis=0, arr=tmp)   # 列ごとに DCT

def dct_2d_manual(img_u8: np.ndarray) -> np.ndarray:
    tmp = np.array([dct_1d_manual(row) for row in img_u8])
    return np.array([dct_1d_manual(tmp[:, i]) for i in range(8)]).T

def dct_2d_fftpack(img_u8: np.ndarray) -> np.ndarray:
    img_f = img_u8.astype(np.float64) - 128  # レベルシフト
    return dct(dct(img_f, axis=0, norm='ortho'), axis=1, norm='ortho') + 128

# rowのみ
def dct_2d_q88_row(img_u8: np.ndarray) -> np.ndarray:
    return np.apply_along_axis(dct_1d_s16, axis=1, arr=img_u8)  # 行ごとに DCT

# =====================================
# (4) テストコード (変更なし)
# =====================================
if __name__ == "__main__":
    test_matrices = [
        #(np.array([[i * j for j in range(8)] for i in range(8)], dtype=np.int16), "パターン1"),
        #(np.array([[255 if i < 4 and j < 4 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 255"),
        (np.array([[-48 if i < 4 and j < 4 else -128 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 -48, 他 -128"),
        #(np.random.randint(0, 256, (8, 8), dtype=np.int16), "ランダムパターン"),
        #(np.array([[80 if (i + j) % 2 == 0 else 80 for j in range(8)] for i in range(8)], dtype=np.int16), "ベタ"),
        #(np.array([[80 if (i + j) % 2 == 0 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "チェッカーパターン"),
        (np.array([[80 if i < 4 and j < 4 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 80"),
    ]

    for img, label in test_matrices:
        y_q88_pre = dct_2d_q88_row(img)
        y_q88 = dct_2d_q88(img)
        y_manual = dct_2d_manual(img)
        y_fftpack = dct_2d_fftpack(img)

        diff_q88_manual = y_q88.astype(int) - y_manual.astype(int)
        diff_q88_fftpack = y_q88.astype(int) - np.rint(y_fftpack).astype(int)
        diff_manual_fftpack = y_manual.astype(int) - np.rint(y_fftpack).astype(int)

        print(f"\n【{label}】")
        print("Input Image (uint8):\n", img)
        print("Q8.8 DCT row:\n", y_q88_pre)
        print("Q8.8 DCT:\n", y_q88)
        print("Manual DCT:\n", y_manual)
        print("fftpack DCT:\n", np.rint(y_fftpack).astype(int))
        #print("Diff (Q8.8 - Manual):\n", diff_q88_manual)
        #print("Diff (Q8.8 - fftpack):\n", diff_q88_fftpack)
        #print("Diff (Manual - fftpack):\n", diff_manual_fftpack)