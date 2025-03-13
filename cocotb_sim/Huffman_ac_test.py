"""
NISHIHARU
"""
import cocotb
import random
from cocotb.triggers import Timer, RisingEdge
from cocotb.binary import BinaryValue

import sys, os

#sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../python/')))
#import my_JPEG_dec

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
    dut.ac_matrix.value     = 0
    dut.start_pix.value     = 0
    dut.pre_start_pix.value = 0
    dut.is_luminance.value  = 0

    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value       = 1


    print("==========================================================================")
    print("[Test Start]")
    # Set input_enable high and initialize pix_data with 1's
    #dut.input_enable.value = 1

    # input ac 
    input_ac_matrix = [
        [9, 0, 0, 0, 0, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 3, 4],
        [0, 0, 0, 1, 1, 0, 3, 4],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
    ]

    # flat 
    flat_data = tuple(input_ac_matrix[i][j] for i in reversed(range(8)) for j in reversed(range(8)))

    # 各要素を10ビットのバイナリ文字列に変換して連結
    bit_str = "".join(format(val, "010b") for val in flat_data)

    await RisingEdge(dut.clock)

    # ac_matrix data set
    dut.ac_matrix.value = BinaryValue(value=bit_str, n_bits=640)
    dut.start_pix.value = 1
    dut.pre_start_pix.value = 0
    dut.is_luminance.value = 1

    await RisingEdge(dut.clock)
    print("start_pix : ", int(dut.start_pix.value))
    
    # wait
    for _ in range(10):
        await RisingEdge(dut.clock)
    
    print("------------------------------")
    print("Input_ac_matrix (flat index: value):")
    for i, row in enumerate(input_ac_matrix):
        # 各要素のフラットインデックスは i*8 + j
        row_str = " ".join(f"({i*8+j:2d}:{x:3d})" for j, x in enumerate(row))
        print(row_str)

    for _ in range(20):
        print("------------------------------")
        print("Huffman AC Output Cycle : ", _)
        print("start_pix : ", int(dut.start_pix.value))
        print("ac_out : ", dut.ac_out.value)
        print("length : ", int(dut.length.value))
        print("code : ", dut.code.value)
        print("code_size : ", int(dut.code_size.value))
        print("next_pix : ", int(dut.next_pix.value))
        print("run : ", int(dut.run.value))
        print("now_pix_data : ", int(dut.now_pix_data.value))

        # Huffman AC code

        await RisingEdge(dut.clock)
        dut.start_pix.value =  int(dut.start_pix.value) + int(dut.next_pix.value)
        await RisingEdge(dut.clock)
        if int(dut.start_pix.value) > 63:
            print("------------------------------")
            print("start_pix : ", int(dut.start_pix.value))
            break

        for _ in range(5):
            await RisingEdge(dut.clock)

    # ここに追加の検証コードを記述する
    print("Test completed.")
