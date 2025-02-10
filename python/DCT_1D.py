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


def fixed_mul_q88(a: np.int16, b: np.int16) -> np.int16:
    """
    Q8.8 同士の乗算 → Q8.8 (int16)
    """
    prod = np.int32(a) * np.int32(b)
    prod = (prod + (1 << 7)) >> 8  # +128 で四捨五入
    return np.int16(np.clip(prod, -32768, 32767))  # オーバーフロー防止

def dct_1d_q88(x_q88: np.ndarray) -> np.ndarray:
    """
    Q8.8 (int16) 配列(長さ8) → Q8.8 (int16) の 1次元DCT
    """
    N = 8
    y_q88 = np.zeros(N, dtype=np.int16)
    for k in range(N):
        sum_val = np.int32(0)
        for n in range(N):
            sum_val += np.int32(fixed_mul_q88(x_q88[n], DCT_LUT[k, n]))

        alpha = np.int32(FIXED_SQRT_1_OVER_N if k == 0 else FIXED_SQRT_2_OVER_N)
        sum_val = (sum_val * alpha + (1 << 7)) >> 8  # ここもオーバーフロー対策
        y_q88[k] = np.int16(np.clip(sum_val, -32768, 32767))  # int16 に収める

    return y_q88

def dct_1d_u8(x_u8: np.ndarray) -> np.ndarray:
    """
    入出力: u8[8]
    """
    x_q88 = (x_u8.astype(np.int16) << 8)
    y_q88 = dct_1d_q88(x_q88)

    # (Q8.8) → 整数 (丸め) → clip → u8
    y_int32 = (y_q88.astype(np.int32) + (1 << 7)) >> 8
    return np.clip(y_int32, 0, 255).astype(np.uint8)

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

    return np.clip(np.rint(out_f), 0, 255).astype(np.uint8)

# =====================================
# (3) fftpack での DCT 計算 (JPEG 仕様)
# =====================================
def dct_1d_fftpack(x_u8: np.ndarray) -> np.ndarray:
    """
    SciPy fftpack を使用した DCT-II 計算 (JPEG スケールに合わせる)
    """
    x_f = x_u8.astype(np.float64)
    dct_raw = dct(x_f, type=2, norm='ortho')

    return np.clip(np.rint(dct_raw), 0, 255).astype(np.uint8)

# -------------------------------------
# テストコード: 比較 (Q8.8 vs Manual vs fftpack)
# -------------------------------------
if __name__ == "__main__":
    test_vectors = [
        (np.array([1,2,3,4,5,6,7,8], dtype=np.uint8),"通常入力"), 
        (np.array([10,20,30,40,50,60,70,80], dtype=np.uint8), "倍率10倍"),
        (np.array([0,0,0,0,0,0,0,0], dtype=np.uint8), "ゼロ入力"),
        (np.array([8,7,6,5,4,3,2,1], dtype=np.uint8), "逆順入力"),
        (np.array([8,70,6,5,4,3,25,12], dtype=np.uint8), "通常入力"), 
        (np.array([8,70,63,55,42,3,2,1], dtype=np.uint8), "通常入力"), 
        (np.array([80,0,80,0,80,0,80,0], dtype=np.uint8), "通常入力"), 
        (np.array([80,80,80,80,80,80,80,80], dtype=np.uint8), "通常入力"), 
        (np.array([8,70,6,56,43,3,120,1], dtype=np.uint8), "通常入力"), 
        (np.array([4,3,20,70,12,6,12,8], dtype=np.uint8), "異常入力")
    ]

    for x, label in test_vectors:
        y_q88   = dct_1d_u8(x)       
        y_manual= dct_1d_manual(x)   
        y_fftpack = dct_1d_fftpack(x)  
        
        diff_q88_manual = y_q88.astype(int) - y_manual.astype(int)
        diff_q88_fftpack = y_q88.astype(int) - y_fftpack.astype(int)
        diff_manual_fftpack = y_manual.astype(int) - y_fftpack.astype(int)

        print(f"\n【{label}】")
        print("Input u8       :", x)
        print("Q8.8 DCT       :", y_q88)
        print("Manual DCT     :", y_manual)
        print("fftpack DCT    :", y_fftpack)
        print("Diff (Q8.8 - Manual)  :", diff_q88_manual)
        print("Diff (Q8.8 - fftpack) :", diff_q88_fftpack)
        print("Diff (Manual - fftpack):", diff_manual_fftpack)
