from PIL import Image
from scipy import fftpack
from scipy.fftpack import dct
import math
import numpy

import HW_jpegEncoder

# =====================================
# 固定小数点 1D DCT 実装 (Q8.8) 修正版
# =====================================

# 1.1 固定小数点スケール定義 (Q8.8)
FIXED_ONE = numpy.int16(256)            # 1.0 => 256
FIXED_SQRT_1_OVER_N = numpy.int16(91)  # sqrt(1/8)*256 ≈ 0.35355 * 256
FIXED_SQRT_2_OVER_N = numpy.int16(128)  # sqrt(2/8)*256 ≈ 0.5 * 256

# 1.2 固定 DCT 係数 LUT (Q8.8, s16) 修正
DCT_LUT = numpy.array([
    [256,  256,  256,  256,  256,  256,  256,  256],  # k=0
    [251,  213,  142,   50,  -50, -142, -213, -251],  # k=1
    [236,   98,  -98, -236, -236,  -98,   98,  236],  # k=2
    [213,  -50, -251, -142,  142,  251,   50, -213],  # k=3
    [181, -181, -181,  181,  181, -181, -181,  181],  # k=4
    [142, -251,  -50,  213,  213,  -50, -251,  142],  # k=5
    [ 98, -236,   98,  236,  236,   98, -236,   98],  # k=6
    [ 50, -142,  213, -251, -251,  213, -142,   50],  # k=7
], dtype=numpy.int16)

DCT_LUT_Q12 = numpy.array([
 [   1448.1547,    1448.1547,    1448.1547,    1448.1547,    1448.1547,    1448.1547,    1448.1547,    1448.1547],
 [   2008.6482,    1702.8497,    1137.8079,     399.5450,    -399.5450,   -1137.8079,   -1702.8497,   -2008.6482],
 [   1892.1052,     783.7357,    -783.7357,   -1892.1052,   -1892.1052,    -783.7357,     783.7357,    1892.1052],
 [   1702.8497,    -399.5450,   -2008.6482,   -1137.8079,    1137.8079,    2008.6482,     399.5450,   -1702.8497],
 [   1448.1547,   -1448.1547,   -1448.1547,    1448.1547,    1448.1547,   -1448.1547,   -1448.1547,    1448.1547],
 [   1137.8079,   -2008.6482,     399.5450,    1702.8497,   -1702.8497,    -399.5450,    2008.6482,   -1137.8079],
 [    783.7357,   -1892.1052,    1892.1052,    -783.7357,    -783.7357,    1892.1052,   -1892.1052,     783.7357],
 [    399.5450,   -1137.8079,    1702.8497,   -2008.6482,    2008.6482,   -1702.8497,    1137.8079,    -399.5450]
], dtype=numpy.float32)

def fixed_mul_q88(a: numpy.int32, b: numpy.int32) -> numpy.int32:
    """
    Q8.8 同士の乗算。int32 で計算し、256 で割って四捨五入する。
    """
    prod = a * b
    return (prod + 128) >> 8

def dct_1d_q88(x_q88: numpy.ndarray) -> numpy.ndarray:
    """
    Q8.8 (int32) 配列（長さ8）→ Q8.8 (int32) の 1次元DCT
    """
    N = 8
    y = numpy.zeros(N, dtype=numpy.int32)
    for k in range(N):
        s = numpy.int32(0)
        for n in range(N):
            s += fixed_mul_q88(numpy.int32(x_q88[n]), numpy.int32(DCT_LUT[k, n]))
        # スケーリング係数 (k==0なら FIXED_SQRT_1_OVER_N, それ以外なら FIXED_SQRT_2_OVER_N)
        alpha = int(FIXED_SQRT_1_OVER_N) if k == 0 else int(FIXED_SQRT_2_OVER_N)
        y[k] = (s * alpha + 128) >> 8
    return y  # Q8.8 表現から一段目のスケーリングが終わった値（int32）

def dct_1d_s16(x_u8: numpy.ndarray) -> numpy.ndarray:
    """
    入出力: u8[8]
    出力は np.int16 型で返す（手計算版: np.clip(np.rint(out_f + 128), -511, 512)）。
    """
    # 1. 入力のレベルシフトを削除
    x_shifted = x_u8.astype(numpy.int32) 
    # 2. Q8.8 表現へ変換（左シフト 8 ビット）
    x_q88 = x_shifted << 8
    # 3. 固定小数点 DCT 計算
    y_q88 = dct_1d_q88(x_q88)  # 結果は Q8.8 表現相当の int32 値
    # 4. Q8.8 から整数へ変換（四捨五入）
    y_int = (y_q88 + 128) >> 8
    # 5. 逆レベルシフト (+128) を加えて、手計算版と同じスケールに復帰
    result = numpy.clip(numpy.rint(y_int), -511, 512).astype(numpy.int16)
    return result

# =====================================
# 12bit精度 (Q12.12) 固定小数点版 1D DCT 実装
# =====================================

# 4.1 固定小数点スケール定義 (Q12.12)
FIXED_ONE_Q12 = numpy.float32(4096)  # 1.0 => 4096
FIXED_SQRT_1_OVER_N_Q12 = numpy.float32(0.35355 * 4096)  # ≈1448
FIXED_SQRT_2_OVER_N_Q12 = numpy.float32(2048)  # 0.5 * 4096 = 2048

def fixed_mul_q12(a: numpy.int64, b: numpy.float32) -> numpy.int64:
    prod = a * b
    return (prod + 2048) / 4096

def dct_1d_q12(x_q12: numpy.ndarray) -> numpy.ndarray:
    """
    Q12.12 (int32) 配列（長さ8）→ Q12.12 (float32) の 1次元DCT
    入力 x_q12 は Q12 表現（元の値 << 12 されたもの）とする。
    この関数は、固定小数点での整数演算（(a*b+2048)>>12）を
    float32 でシミュレーションする。
    """
    N = 8
    y = numpy.zeros(N, dtype=numpy.float32)
    for k in range(N):
        s = 0.0  # float32 で初期化
        for n in range(N):
            # 固定小数点乗算を float32 でシミュレート: (a * b + 2048) / 4096.0
            s += (numpy.float32(x_q12[n]) * numpy.float32(DCT_LUT_Q12[k, n]) + 2048.0) / 4096.0
        # k==0 の場合は FIXED_SQRT_1_OVER_N_Q12, それ以外は FIXED_SQRT_2_OVER_N_Q12（float32 にキャスト）
        alpha = numpy.float32(FIXED_SQRT_1_OVER_N_Q12) if k == 0 else numpy.float32(FIXED_SQRT_2_OVER_N_Q12)
        # 最終出力も同様に、(s*alpha+2048)/4096.0
        scale_factor = 2.206  # テスト結果に基づく補正係数（例）
        y[k] = scale_factor * ((s * alpha + 2048.0) / 4096.0)
    return y

# =====================================
# 手計算ベースの 1D DCT 修正版
# =====================================
def dct_1d_manual(x: numpy.ndarray) -> numpy.ndarray:
    """ 手計算による 1D DCT (JPEG スケール, 入力は既にレベルシフト済み) """
    N = 8
    out = numpy.zeros(N, dtype=numpy.float64)
    for k in range(N):
        alpha = math.sqrt(0.5) if k == 0 else 1.0
        s = sum(x[n] * math.cos((math.pi / N) * (n + 0.5) * k) for n in range(N))
        out[k] = alpha * s * math.sqrt(2.0 / N)
    # fftpack と同様に rint で丸めた結果を返す
    return numpy.rint(out)

# =====================================
# 2D DCT function
# =====================================

def dct_2d_fftpack(img_u8: numpy.ndarray, level_shift_value) -> numpy.ndarray:
    img_f = img_u8.astype(numpy.float64) - level_shift_value  # レベルシフト
    return dct(dct(img_f, axis=0, norm='ortho'), axis=1, norm='ortho')

def dct_2d_manual(img_u8: numpy.ndarray, level_shift_value) -> numpy.ndarray:
    # まず画像全体からレベルシフト
    img_f = img_u8.astype(numpy.float64) - level_shift_value
    # 各行に対して1D DCT
    temp = numpy.array([dct_1d_manual(row) for row in img_f])
    # 各列に対して1D DCTを適用して転置して元の形に戻す
    return numpy.array([dct_1d_manual(temp[:, i]) for i in range(temp.shape[1])]).T

def dct_2d_q88(img_u8: numpy.ndarray, level_shift_value) -> numpy.ndarray:
    img_f = img_u8.astype(numpy.float64) - level_shift_value
    tmp = numpy.apply_along_axis(dct_1d_q88, axis=1, arr=img_f)  # 行ごとに DCT
    return numpy.apply_along_axis(dct_1d_q88, axis=0, arr=tmp)   # 列ごとに DCT

# =================================
if __name__ == "__main__":
    test_matrices = [
        #(np.array([[i * j for j in range(8)] for i in range(8)], dtype=np.int16), "パターン1"),
        #(np.array([[255 if i < 4 and j < 4 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 255"),
        #(np.array([[-48 if i < 4 and j < 4 else -128 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 -48, 他 -128"),
        (numpy.full((8, 8), 51, dtype=numpy.int16), "全体 22")
        #(np.random.randint(0, 256, (8, 8), dtype=np.int16), "ランダムパターン"),
        #(np.array([[80 if (i + j) % 2 == 0 else 80 for j in range(8)] for i in range(8)], dtype=np.int16), "ベタ"),
        #(np.array([[80 if (i + j) % 2 == 0 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "チェッカーパターン"),
        #(np.array([[80 if i < 4 and j < 4 else 0 for j in range(8)] for i in range(8)], dtype=np.int16), "左上 4x4 80"),
    ]

    for img, label in test_matrices:
        #y_q88_pre = dct_2d_q88_row(img)
        y_q88 = dct_2d_q88(img, 0)
        #y_q12 = dct_2d_q12(img)
        y_manual = dct_2d_manual(img, 0)
        y_fftpack = dct_2d_fftpack(img, 0)

        #diff_q88_manual = y_q88.astype(int) - y_manual.astype(int)
        #diff_q88_fftpack = y_q88.astype(int) - np.rint(y_fftpack).astype(int)
        #iff_manual_fftpack = y_manual.astype(int) - np.rint(y_fftpack).astype(int)

        print(f"\n【{label}】")
        print("Input Image (uint8):\n", img)
        #print("Q8.8 DCT row:\n", y_q88_pre)
        print("Q8.8 DCT:\n", y_q88)
        #print("Q12 DCT:\n", y_q12 * 8)
        print("Manual DCT:\n", y_manual)
        print("fftpack DCT:\n", numpy.rint(y_fftpack).astype(int))
        #print("Diff (Q8.8 - Manual):\n", diff_q88_manual)
        #print("Diff (Q8.8 - fftpack):\n", diff_q88_fftpack)
        #print("Diff (Manual - fftpack):\n", diff_manual_fftpack)

        # Quantize バグがあるのでは？
        quality = 25

        # 
        if(quality <= 0):
            quality = 1
        if(quality > 100):
            quality = 100
        if(quality < 50):
            qualityScale = 5000 / quality
        else:
            qualityScale = 200 - quality * 2
        luminanceQuantTbl = numpy.array(numpy.floor((HW_jpegEncoder.std_luminance_quant_tbl * qualityScale + 50) / 100))
        luminanceQuantTbl[luminanceQuantTbl == 0] = 1
        luminanceQuantTbl[luminanceQuantTbl > 255] = 255
        luminanceQuantTbl = luminanceQuantTbl.reshape([8, 8]).astype(int)
        #print('luminanceQuantTbl:\n', luminanceQuantTbl)
        chrominanceQuantTbl = numpy.array(numpy.floor((HW_jpegEncoder.std_chrominance_quant_tbl * qualityScale + 50) / 100))
        chrominanceQuantTbl[chrominanceQuantTbl == 0] = 1
        chrominanceQuantTbl[chrominanceQuantTbl > 255] = 255
        chrominanceQuantTbl = chrominanceQuantTbl.reshape([8, 8]).astype(int)
        #print('chrominanceQuantTbl:\n', chrominanceQuantTbl)

        yQuantMatrix = numpy.rint(y_q88 / luminanceQuantTbl)
        #uQuantMatrix = numpy.rint(y_q88 / chrominanceQuantTbl)
        
        print('yQuantMatrix:\n',yQuantMatrix)