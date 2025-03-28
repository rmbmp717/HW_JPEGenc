"""
NISHIHARU
"""
import cocotb
import random
import numpy as np
from cocotb.triggers import Timer, RisingEdge
from cocotb.binary import BinaryValue

import sys, os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../HW_python_model/')))
import huffmanEncode

from bitstring import BitStream

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
    dut.is_luminance.value  = 0     # Y mode

    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value       = 1


    print("==========================================================================")
    print("[Test Start]")
    # Set input_enable high and initialize pix_data with 1's
    #dut.input_enable.value = 1

    # ここでHuffman符号化するデータを設定
    # input ac 
    input_ac_matrix = [
        [-1,  0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0],
        [0,   0,  0,  0,  0, 0, 0, 0]
    ]

    # flat 
    #flat_data = tuple(input_ac_matrix[i][j] for i in reversed(range(8)) for j in reversed(range(8)))
    flat_data = tuple(input_ac_matrix[i][j] for i in range(8) for j in range(8))

    # 各要素を10ビットのバイナリ文字列に変換して連結
    bit_str = "".join(format(val & 0x3FF, "010b") for val in flat_data)

    await RisingEdge(dut.clock)

    # ac_matrix data set
    dut.ac_matrix.value = BinaryValue(value=bit_str, n_bits=640)
    dut.start_pix.value = 1
    dut.pre_start_pix.value = 0

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
    
    final_huffman_ac_code = ""

    for _ in range(63):
        huffman_code = str(dut.ac_out)
        length = int(dut.length.value)
        code_value = str(dut.code.value)
        code_length = int(dut.code_size.value)
        print("------------------------------")
        print("Huffman AC Output Cycle : ", _)
        print("start_pix : ", int(dut.start_pix.value))
        print("ac_out : ", dut.ac_out.value)
        print("length : ", int(dut.length.value))
        print("code : ", dut.code.value)
        print("code_size : ", int(dut.code_size.value))
        print("next_pix : ", int(dut.next_pix.value))
        print("run : ", int(dut.run.value))
        print("now_pix_data : ", convert_s10(int(dut.now_pix_data.value)))

        # Huffman AC code のBit切り出し
        trimmed_huffman_code = huffman_code[-length:]
        code_out_bin = "" if code_length == 0 else code_value[-code_length:]
        huffman_ac_out_bit = trimmed_huffman_code + code_out_bin
        # 表示
        print(f"huffman_code(bin) = {trimmed_huffman_code}")
        print(f"code_out(bin) = {code_out_bin}")
        print(f"huffman_ac_code(bin) = {huffman_ac_out_bit}")

        # 追加してく
        final_huffman_ac_code += huffman_ac_out_bit

        await RisingEdge(dut.clock)
        dut.start_pix.value =  int(dut.start_pix.value) + int(dut.next_pix.value)
        await RisingEdge(dut.clock)
        if int(dut.start_pix.value) > 63:
            print("------------------------------")
            print("start_pix : ", int(dut.start_pix.value))
            break

        for _ in range(5):
            await RisingEdge(dut.clock)

    print("------------------------------")
    print(f"final huffman code= {final_huffman_ac_code}")

    # ここに追加の検証コードを記述する
    print("------------------------------")
    if int(dut.is_luminance.value) == 1 :
        luminance = 1
    else :
        luminance = 0

    refmodel_input_data = np.array(input_ac_matrix, dtype=np.int32).flatten()
    print(refmodel_input_data)

    # DC
    dc_code = huffmanEncode.encodeDCToBoolList(flat_data[63],luminance, 1)
    print("dc_input :", flat_data[63])
    print("dc_code :", dc_code)

    # AC
    sosBitStream = BitStream()
    huffmanEncode.encodeACBlock(sosBitStream, refmodel_input_data[1:], luminance, 1)

    print(sosBitStream.bin)

    # リファレンスと比較
    print("------------------------------")
    if final_huffman_ac_code == sosBitStream.bin:
        print("HW Output data match with Ref data !!")
        print("Test completed.")
    else :
        print("Data dont match Err !!")

    print("------------------------------")