import numpy as np
import math
from scipy.fftpack import dct

# =====================================
# (1) Q8.8 固定小数点実装 (サイズ=8)
# =====================================

# 1.1 固定小数点スケール定義 (Q8.8)
FIXED_ONE = np.int16(256)            # 1.0 => 256
FIXED_SQRT_1_OVER_N = np.int16(91)   # sqrt(1/8)*256 ≈ 0.35355 * 256
FIXED_SQRT_2_OVER_N = np.int16(128)  # sqrt(2/8)*256 = 0.5 * 256

# 1.2 厳密な固定 DCT 係数 LUT (Q8.8, s16)
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
# (2) 直接数式で DCT-II (JPEG 仕様)
# =====================================
def dct_1d_manual(x_u8: np.ndarray) -> np.ndarray:
    """
    1) x_u8 => float64
    2) DCT-II (size=8) の式を直接計算 (DC= sqrt(1/8), AC= sqrt(2/8))
    3) 四捨五入 => clip(0..255) => u8
    """
    N = 8
    x_f = x_u8.astype(np.float64)
    out_f = np.zeros(N, dtype=np.float64)

    for k in range(N):
        alpha = (1.0 / math.sqrt(8.0)) if k == 0 else (math.sqrt(2.0 / 8.0))
        s = sum(x_f[n] * math.cos(math.pi * (n + 0.5) * k / N) for n in range(N))
        out_f[k] = alpha * s

    return np.clip(np.rint(out_f), -511, 512).astype(np.int16) + 128

# =====================================
# (3) fftpack での DCT 計算 (JPEG 仕様)
# =====================================
def dct_1d_fftpack(x_u8: np.ndarray) -> np.ndarray:
    """
    SciPy fftpack を使用した DCT-II 計算 (JPEG スケールに合わせる)
    """
    x_f = x_u8.astype(np.float64)
    dct_raw = dct(x_f, type=2, norm='ortho')

    return np.clip(np.rint(dct_raw), -511, 512).astype(np.int16) + 128

# -------------------------------------
# テストコード: 比較 (Q8.8 vs Manual vs fftpack)
# -------------------------------------
if __name__ == "__main__":
    test_vectors = [
        (np.array([1,2,3,4,5,6,7,8], dtype=np.int16),"通常入力"), 
        (np.array([10,20,30,40,50,60,70,80], dtype=np.int16), "倍率10倍"),
        (np.array([0,0,0,0,0,0,0,0], dtype=np.int16), "ゼロ入力"),
        (np.array([8,7,6,5,4,3,2,1], dtype=np.int16), "逆順入力"),
        (np.array([8,70,6,5,4,3,25,12], dtype=np.int16), "通常入力"), 
        (np.array([8,70,63,55,42,3,2,1], dtype=np.int16), "通常入力"), 
        (np.array([-80,-123,-80,0,-80,0,80,0], dtype=np.int16), "通常入力"), 
        (np.array([80,80,80,80,80,80,80,80], dtype=np.int16), "通常入力"), 
        (np.array([8,70,6,56,43,3,120,1], dtype=np.int16), "通常入力"), 
        (np.array([4,3,20,70,12,6,12,8], dtype=np.int16), "異常入力"),
        (np.array([-48,-48,-48,-48,-128,-128,-128,-128], dtype=np.int16), "通常入力"), 
    ]

    for x, label in test_vectors:
        y_q88   = dct_1d_s16(x)       
        y_manual= dct_1d_manual(x - 128)   
        y_fftpack = dct_1d_fftpack(x - 128)  
        
        diff_q88_manual = y_q88.astype(int) - y_manual.astype(int)
        diff_q88_fftpack = y_q88.astype(int) - y_fftpack.astype(int)
        diff_manual_fftpack = y_manual.astype(int) - y_fftpack.astype(int)

        print(f"\n【{label}】")
        print("Input s16      :", x)
        print("Q8.8 DCT       :", y_q88)
        print("Manual DCT     :", y_manual)
        print("fftpack DCT    :", y_fftpack)
        #print("Diff (Q8.8 - Manual)  :", diff_q88_manual)
        #print("Diff (Q8.8 - fftpack) :", diff_q88_fftpack)
        #rint("Diff (Manual - fftpack):", diff_manual_fftpack)