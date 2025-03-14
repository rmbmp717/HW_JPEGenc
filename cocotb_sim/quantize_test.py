"""
NISHIHARU
"""
import cocotb
import random
import numpy as np
from cocotb.triggers import Timer, RisingEdge
from cocotb.binary import BinaryValue

import sys, os

#sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../HW_python_model/')))
#import huffmanEncode

def convert_s10(raw: int) -> int:
    """
    10ビットの符号付き整数（符号付き10bit値）として解釈する。
    入力 raw は 0～1023 の範囲の整数と仮定し、
    512以上の場合は 1024 を引いて負の値に変換する。
    """
    if raw >= 512:
        return raw - 1024
    else:
        return raw

def value_int96bit(data_chunks):
    # data
    #data_chunks = [ 100, 100, 100, 100, 100, 100, 104, 105]
    reversed_data = data_chunks[::-1]
    #print(reversed_data)

    # 各データを12ビットの2進数文字列に変換（ゼロ埋め）
    bin_segments = [format(chunk if chunk >= 0 else (chunk + (1 << 12)) & 0xFFF, "012b") for chunk in reversed_data]
    #print(bin_segments)

    # 2進数文字列を作成
    bin_str = "".join(bin_segments)
    #print("連結した12*8ビットの2進数文字列:", bin_str)

    # 2進数文字列を整数に変換
    value_int = int(bin_str, 2)
    return value_int

async def generate_clock(dut, period=10):
    """Generate a clock on dut.clock with the given period in ns."""
    while True:
        dut.clock.value = 0
        await Timer(period // 2, units="ns")
        dut.clock.value = 1
        await Timer(period // 2, units="ns")

@cocotb.test()
async def test1_JPEGenc_top(dut):
    print("==========================================================================")

    # Start clock generation (if not already spawned by testbench)
    cocotb.start_soon(generate_clock(dut, period=10))

    # initialize
    dut.reset_n.value       = 0
    dut.matrix_row.value     = 0
    dut.is_luminance.value   = 1     # Y mode
    dut.quantize_off.value   = 0     # threw mode


    dut.dct_coeffs0.value     = 0
    dut.dct_coeffs1.value     = 0
    dut.dct_coeffs2.value     = 0
    dut.dct_coeffs3.value     = 0
    dut.dct_coeffs4.value     = 0
    dut.dct_coeffs5.value     = 0
    dut.dct_coeffs6.value     = 0
    dut.dct_coeffs7.value     = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    dut.reset_n.value       = 1

    for _ in range(10):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("[Test Start]")
    # Set input_enable high and initialize pix_data with 1's
    #dut.input_enable.value = 1

    #dut.dct_coeffs0.value = value_int96bit([ 108, 100, 100, 100, 100, 100, 104, 101])
    #dut.dct_coeffs0.value = value_int96bit([ 200, 200, 200, 200, 200, 200, 200, 200])
    dut.dct_coeffs0.value = value_int96bit([  0, -671,   3, -68,   3,   3,   0,   0])
    dut.dct_coeffs1.value = value_int96bit([ 118, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs2.value = value_int96bit([ 128, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs3.value = value_int96bit([ 138, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs4.value = value_int96bit([ 148, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs5.value = value_int96bit([ 158, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs6.value = value_int96bit([ 168, 100, 100, 100, 100, 100, 104, 105])
    dut.dct_coeffs7.value = value_int96bit([ 178, 100, 100, 100, 100, 100, 104, 105])

    print("==========================================================================")
    print("[Output]")
    for _ in range(10):
        await RisingEdge(dut.clock)

    # Quality
    out_bin = dut.quality.value.binstr
    print("total out bit = ", out_bin)

    # Output 80bit
    out_bin = dut.quantized_out.value.binstr
    print("total out bit = ", out_bin)

    bit_count = len(out_bin)
    print("out_bin のビット数 = ", bit_count)

    # data 0
    out_bin_0 = out_bin[-10:]
    print("out_0 10bit = ", out_bin_0)

    for _ in range(10):
        await RisingEdge(dut.clock)
