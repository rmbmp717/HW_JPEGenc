"""
NISHIHARU
JPEG HW Encoder Test
"""
import cocotb
import random
from cocotb.triggers import Timer, RisingEdge

import sys, os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_Debug_func

# Debug 8x8 matrix out
matrix_debug_out = 1

# ---------------------------------------------------
# sub メイン関数
async def sub_test_JPEGenc(dut):
    print("==========================================================================")

    # initialize
    dut.reset_n.value = 0  
    dut.Red.value = 0
    dut.Green.value = 0
    dut.Blue.value = 0
    dut.input_1pix_enable.value = 0
    dut.pix_1pix_data.value = 0
    dut.input_enable.value = 0

    dut.dct_enable.value = 0
    dut.dct_end_enable.value = 0
    dut.zigzag_input_enable.value = 0
    dut.zigag_enable.value = 0
    dut.matrix_row.value = 0
    dut.Huffman_start.value = 0


    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value = 1      
    
    for _ in range(10):
        await RisingEdge(dut.clock)    

    print("==========================================================================")
    print("0: Input Data")
    # Set input_enable high and initialize pix_data with 1's
    #dut.input_enable.value = 1

    # 0〜63のならび
    #dut.pix_data.value = list(range(1, 65))
    # すべて0
    #dut.pix_data.value = [0] * 64
    # すべて255
    #dut.pix_data.value = [255] * 64
    # 左上が80
    #dut.pix_data.value = [80 if (i < 4 and j < 4) else 0 for i in range(8) for j in range(8)]
    input_matrix_r = [[80 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    input_matrix_g = [[80 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    input_matrix_b = [[80 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    #input_matrix_r = [[j + 1 for j in range(8)] for i in range(8)]
    #input_matrix_g = [[j + 1 for j in range(8)] for i in range(8)]
    #input_matrix_b = [[j + 1 for j in range(8)] for i in range(8)]

    # 80, 0, 80, 0 ...
    #dut.pix_data.value = [80, 0] * 32
    # ランダムパターン
    #input_matrix = [[random.randint(0, 255) for _ in range(8)] for _ in range(8)]

    # flat化
    flat_data_r = [input_matrix_r[i][j] for i in range(8) for j in range(8)]
    flat_data_g = [input_matrix_g[i][j] for i in range(8) for j in range(8)]
    flat_data_b = [input_matrix_b[i][j] for i in range(8) for j in range(8)]

    #await RisingEdge(dut.clock)
    #dut.input_enable.value = 0
    # pix_data の各要素を 10 進数に変換してリストに格納
    #pix_data_list = [int(p.binstr, 2) for p in dut.pix_data.value]

    for pix in range(64):
        if pix > 1 :
            dut.input_1pix_enable.value = 1
        dut.Red.value   = flat_data_r[pix]
        dut.Green.value = flat_data_g[pix]
        dut.Blue.value  = flat_data_b[pix]
        await RisingEdge(dut.clock)
    
    dut.Red.value = 0
    dut.Green.value = 0
    dut.Blue.value = 0
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    dut.input_1pix_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Input_Y(dut)
        await sub_Debug_func.dump_Input_Cb(dut)
        await sub_Debug_func.dump_Input_Cr(dut)

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("1: DCT 2D Start")

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Dct_Y_input(dut)
        await sub_Debug_func.dump_Dct_Cb_input(dut)
        await sub_Debug_func.dump_Dct_Cr_input(dut)

    # DCT 2D Start
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 1
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 0

    # DCT 2D Endまで待つ
    for _ in range(50):
        if dut.HW_JPEGenc_Y.mDCT_2D.state_v_end.value == 1:
            break
        await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)

    print("1.2: DCT 2D Output Data")
    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Dct_Y_output(dut)
        await sub_Debug_func.dump_Dct_Cb_output(dut)
        await sub_Debug_func.dump_Dct_Cr_output(dut)

    print("==========================================================================")
    print("2: Quantize Start")
    # Quantize buffer
    dut.dct_end_enable.value = 1
    await RisingEdge(dut.clock)
    dut.dct_end_enable.value = 0

    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)

    dut.zigzag_input_enable.value = 1
    for _ in range(8):
        dut.matrix_row.value = _
        await RisingEdge(dut.clock)
    dut.zigzag_input_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)
    print("2: Quantize End")

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Quantized_Y_output(dut)
        #await sub_Debug_func.dump_Quantized_Cb_output(dut)
        #await sub_Debug_func.dump_Quantized_Cr_output(dut)

    print("==========================================================================")
    print("3: Zigzag scan Start")


    dut.zigag_enable.value = 1
    await RisingEdge(dut.clock)
    dut.zigag_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("4: Zigzag Input Data (8x8 matrix):")
    
    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Zigzag_Y_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cb_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cr_Input(dut)

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("5: Zigzaged Data (8x8 matrix):")

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Zigzag_Y_output(dut)
        #await sub_Debug_func.dump_Zigzag_Cb_output(dut)
        #await sub_Debug_func.dump_Zigzag_Cr_output(dut)

    await sub_Debug_func.dump_Zigzag_Y_output(dut)

    print("==========================================================================")
    print("6: Huffman enc Start")
    # Huffman start
    dut.Huffman_start.value = 1
    await RisingEdge(dut.clock)
    dut.Huffman_start.value = 0

    num_detected = 0
    done = False  # ここで done を初期化
    final_output = ""  # 最終出力となるビット列を格納

    for _ in range(16):
        await RisingEdge(dut.clock)

    # Debug on
    Huffman_debug = 1
        
    print("6.1: Huffman DC Code")
    huffman_dc_code_bin = str(dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_out.value)
    huffman_dc_code_length = int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_out_length.value)
    huffman_dc_code_list = str(dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_code_list.value)
    if Huffman_debug == 1:
        print("huffman_dc_code_bin(bin) =", huffman_dc_code_bin)
        print("huffman_dc_code_list(bin) =", huffman_dc_code_list)
    trimmed_huffman_dc_code_list = huffman_dc_code_list.lstrip('0')

    trimmed_huffman_dc_code = huffman_dc_code_bin[:huffman_dc_code_length]
    if Huffman_debug == 1:
        print("huffman_dc_code(bin) =", trimmed_huffman_dc_code)
        print("huffman_dc_code_length =", huffman_dc_code_length)
        
    # ビット列を最終出力に連結
    final_output += trimmed_huffman_dc_code + trimmed_huffman_dc_code_list
    print("dc final_output=", final_output)

    print("==========================================================================")
    # 例えば36回検出するか、state が 0 になったらループ終了
    print("6.2: Huffman AC Code")
    while num_detected < 64 and not done:
        # jpeg_out_enable の立ち上がりを待機
        await RisingEdge(dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_out_enable)
        #print("code count = {} ".format(num_detected))

        huffman_code_bin = str(dut.HW_JPEGenc_Y.mHuffman_enc_controller.ac_out.value)
        huffman_code_length = int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.length.value)
        trimmed_huffman_code = huffman_code_bin[-huffman_code_length:]
        # 左の連続するゼロを削除した code_out の出力
        code_out_bin = str(dut.HW_JPEGenc_Y.mHuffman_enc_controller.code_out.value).lstrip('0') or '0'
        
        if Huffman_debug == 1:
            print("huffman_code(bin) =", trimmed_huffman_code)
            print("huffman_code_length =", huffman_code_length)
            print("code_out(bin) =", code_out_bin)
        
        # ビット列を最終出力に連結
        final_output += trimmed_huffman_code + code_out_bin
        
        num_detected += 1

        # 同じ High 状態の重複検出を防ぐため、jpeg_out_enable が Low になるまで待機する
        while dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_out_enable.value == 1:
            # state が 0 になった場合、外側のループも抜ける
            if int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.state.value) == 0:
                done = True
                break
            await RisingEdge(dut.clock)
    print("jpeg_dc_out =", dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_out.value)

    print("==========================================================================")
    print("7: Huffman enc End")
    print("count =", int(dut.counter.value), "clk")

    print("==========================================================================")
    print("8: Final Output")
    # 最終出力が8ビットの倍数でない場合、末尾に'0'を追加して調整する
    if len(final_output) % 8 != 0:
        padding = 8 - (len(final_output) % 8)
        final_output += '0' * padding

    formatted_output = '_'.join([final_output[i:i+8] for i in range(0, len(final_output), 8)])
    print(formatted_output)
    if Huffman_debug == 1:
        print("Total Bits:", len(final_output))
        print("Compression Rate:", 100*len(final_output)/512, "%")

    print("==========================================================================")
    for _ in range(100):
        await RisingEdge(dut.clock)

    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    print("Test completed.")
