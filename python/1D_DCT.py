import numpy as np

def fixed_mul(a, b):
    temp = int(a) * int(b)  # 128ビット相当の計算
    result = (temp + (1 << 29) + (1 << 31)) >> 32  # **丸め誤差調整**
    return np.uint64(result)  # `u64` の範囲を維持

def dct_1d_fixed(x):
    N = 8
    FIXED_SQRT_1_OVER_N = np.uint64(3037000505)
    FIXED_SQRT_2_OVER_N = np.uint64(4294967328)
    
    DCT_LUT = np.array([
        [3037000499] * 8,  # k=0
        [4265047728, 3518437209, 2160026241,  759250124,  759250124, 2160026241, 3518437209, 4265047728], # k=1
        [3996160608, 1717986918, 1717986918, 3996160608, 3996160608, 1717986918, 1717986918, 3996160608], # k=2
        [3518437209,  759250124, 4265047728, 2160026241, 2160026241, 4265047728,  759250124, 3518437209], # k=3
        [3037000499] * 8,  # k=4
        [2160026241, 4265047728,  759250124, 3518437209, 3518437209,  759250124, 4265047728, 2160026241], # k=5
        [1717986918, 3996160608, 3996160608, 1717986918, 1717986918, 3996160608, 3996160608, 1717986918], # k=6
        [ 759250124, 2160026241, 3518437209, 4265047728, 4265047728, 3518437209, 2160026241,  759250124]  # k=7
    ], dtype=np.uint64)  # `u64` に合わせる

    result = np.zeros(N, dtype=np.uint64)
    for k in range(N):
        sum_val = np.uint64(0)
        for n in range(N):
            mul_result = fixed_mul(x[n], DCT_LUT[k, n])
            sum_val += mul_result  # 加算処理 (`u64` の範囲で計算)
        result[k] = fixed_mul(sum_val, FIXED_SQRT_1_OVER_N if k == 0 else FIXED_SQRT_2_OVER_N)
    
    return result

# **異なる入力データを試す**
test_inputs = [
    ([1, 2, 3, 4, 5, 6, 7, 8], "通常の入力"),
    ([10, 20, 30, 40, 50, 60, 70, 80], "倍率10倍"),
    ([0, 0, 0, 0, 0, 0, 0, 0], "ゼロ入力"),
    ([8, 7, 6, 5, 4, 3, 2, 1], "逆順入力"),
]

for data, label in test_inputs:
    x_fixed = np.array(data, dtype=np.uint64) << 32
    dct_fixed_result = dct_1d_fixed(x_fixed)

    print(f"\n【{label}】")
    print("入力データ:", data)
    print("固定小数点 DCT (生データ):", dct_fixed_result)
    print("固定小数点 DCT (整数化):", dct_fixed_result >> 32)
