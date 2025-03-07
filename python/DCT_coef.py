import numpy as np
import math

np.set_printoptions(precision=2, suppress=True, linewidth=1000)

def calc_dct_lut_q12():
    N = 8
    lut = np.zeros((N, N), dtype=np.float32)
    for k in range(N):
        # k==0なら sqrt(1/8)、それ以外は sqrt(2/8)
        alpha = math.sqrt(1/8) if k == 0 else math.sqrt(2/8)
        for n in range(N):
            coef = math.cos((math.pi / N) * (n + 0.5) * k)
            lut[k, n] = alpha * coef * 4096
    return lut

DCT_LUT_Q12 = calc_dct_lut_q12()
formatted = np.array2string(
    DCT_LUT_Q12,
    separator=", ",
    formatter={'float_kind': lambda x: f"{x:12.4f}"}
)
print("DCT_LUT_Q12 =\n", formatted)
