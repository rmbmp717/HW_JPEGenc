"""
NISHIHARU
JPEG HW Encoder Test
"""
import cocotb
import random
from cocotb.triggers import First, Timer, RisingEdge, FallingEdge
from cocotb.utils import get_sim_time

import sys, os
import math

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_Debug_func

# ---------------------------------------------------
# sub DC 関数
async def run_huffman_dc(module, name, debug_flag, final_dc_container, clock):
    # 各モジュールの DC 部分の処理を行う関数
    # モジュールの state が 6 になるまで待機
    while True:
        await RisingEdge(clock)
        if int(module.state.value) == 6:
            break

    # DC コード関連の信号を取得
    huffman_dc_code_bin = str(module.jpeg_dc_out.value)
    huffman_dc_code_length = int(module.jpeg_dc_out_length.value)
    huffman_dc_code_list = str(module.jpeg_dc_code_list.value)
    huffman_dc_code_list_size = int(module.dc_out_code_size.value)

    if debug_flag:
        print(f"{name} huffman_dc_code_bin(bin) =", huffman_dc_code_bin)
        print(f"{name} huffman_dc_code_list(bin) =", huffman_dc_code_list)

    # 余分な 0 を除去し、リストサイズ分を取り出す
    trimmed_huffman_dc_code_list = huffman_dc_code_list.lstrip('0')
    
    if huffman_dc_code_list_size == 0:
        trimmed_huffman_dc_code_list = []
    else:
        trimmed_huffman_dc_code_list = trimmed_huffman_dc_code_list[-huffman_dc_code_list_size:]

    # DC コード本体は先頭部分から取り出す
    trimmed_huffman_dc_code = huffman_dc_code_bin[-huffman_dc_code_length:]

    if debug_flag:
        print(f"{name} huffman_dc_code(bin) =", trimmed_huffman_dc_code)
        print(f"{name} huffman_dc_code_length =", huffman_dc_code_length)
        print(f"{name} trimmed_huffman_dc_code_list =", trimmed_huffman_dc_code_list)
        print(f"{name} huffman_dc_code_list_size =", huffman_dc_code_list_size)

    # 連結して最終出力とする
    if huffman_dc_code_list_size == 0:
        final_dc = trimmed_huffman_dc_code
    else:
        final_dc = trimmed_huffman_dc_code + trimmed_huffman_dc_code_list

    print(f"{name} dc final_output =", final_dc)
    final_dc_container[name] = final_dc
    print("--------------")


# ---------------------------------------------------
# sub AC 関数
async def run_huffman_ac(module, name, debug_flag, final_output_container, clock):
    num_detected = 0
    done = False
    local_output = ""
    print("==========================================================================")
    print("6.2: Huffman AC Code")
    while num_detected < 48 and not done:
        # jpeg_out_enable の立ち上がりを待機
        await RisingEdge(module.jpeg_out_enable)
        print(f"{get_sim_time('ns')} ns:")
        await FallingEdge(clock)

        huffman_code_bin = str(module.ac_out.value)
        huffman_code_length = int(module.length.value)
        trimmed_huffman_code = huffman_code_bin[-huffman_code_length:]
        code_out = str(module.code_out.value)
        code_size_out = int(module.code_size_out.value)
        code_out_bin = code_out[-code_size_out:]
        
        if debug_flag:
            print("huffman_code(bin) =", trimmed_huffman_code)
            print("huffman_code_length =", huffman_code_length)
            print("code_out(bin) =", code_out_bin)
            print("code_size_out =", code_size_out)
        
        # ビット列を最終出力に連結
        if int(module.Huffmanenc_active.value) == 1:
            if int(module.jpeg_out_end.value) == 1:
                print("final bit")
                local_output += trimmed_huffman_code 
            else:
                local_output += trimmed_huffman_code + code_out_bin 

        num_detected += 1

        print("now_JPEG_output=", local_output)
        print("--------------")

        # jpeg_out_enable が Low になる（立ち下がり）を待機する
        await FallingEdge(module.jpeg_out_enable)
        await RisingEdge(clock)
    
        # デバッグ用：Huffmanenc_active の値を表示
        print("Huffmanenc_active=", int(module.Huffmanenc_active.value))
        
        # 状態が 0 になったら終了
        if int(module.Huffmanenc_active.value) == 0:
            print(f"{get_sim_time('ns')} ns:")
            print("Loop End")
            done = True

    final_output_container[name] = local_output

# ---------------------------------------------------
# sub メイン関数

# Debug 8x8 matrix out
matrix_debug_out = 1

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

    # 左上が80
    input_matrix_r = [[250 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    input_matrix_g = [[250 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    input_matrix_b = [[250 if (i < 4 and j < 4) else 0 for j in range(8)] for i in range(8)]
    # 左上からインクリメント
    #input_matrix_r = [[j + 14 for j in range(8)] for i in range(8)]
    #input_matrix_g = [[j + 14 for j in range(8)] for i in range(8)]
    #input_matrix_b = [[j + 14 for j in range(8)] for i in range(8)]
    # 赤チャネル: 255、他は0
    #input_matrix_r = [[255 for j in range(8)] for i in range(8)]
    #input_matrix_g = [[0 for j in range(8)] for i in range(8)]
    #input_matrix_b = [[0 for j in range(8)] for i in range(8)]
    # 各チャネルで左上から右下に向かって 0～255 のグラデーションを生成
    #input_matrix_r = [[int((i + j) / 14 * 255) for j in range(8)] for i in range(8)]
    #input_matrix_g = [[int((i + j) / 14 * 255) for j in range(8)] for i in range(8)]
    #input_matrix_b = [[int((i + j) / 14 * 255) for j in range(8)] for i in range(8)]
    # 右上から左下へインクリメント
    #input_matrix_r = [[int((i + (7 - j)) / 14 * 255) for j in range(8)] for i in range(8)]
    #input_matrix_g = [[0 for j in range(8)] for i in range(8)]
    #input_matrix_b = [[0 for j in range(8)] for i in range(8)]
    # math.sin() の出力は -1～1 なので、(sin + 1)/2 で 0～1 に正規化し、255 をかけます。
    '''
    width = 8
    height = 8
    input_matrix_r = [
        [int((math.sin(1 * math.pi * (i + j) / (width + height - 2)) + 1) / 2 * 255) for j in range(width)]
        for i in range(height)
    ]
    input_matrix_g = [[0 for j in range(8)] for i in range(8)]
    input_matrix_b = [[0 for j in range(8)] for i in range(8)]
    '''

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

    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Dct_Y_input(dut)
        #await sub_Debug_func.dump_Dct_Cb_input(dut)
        #await sub_Debug_func.dump_Dct_Cr_input(dut)

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
    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Dct_Y_output(dut)
        #await sub_Debug_func.dump_Dct_Cb_output(dut)
        #await sub_Debug_func.dump_Dct_Cr_output(dut)

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

    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Quantized_Y_output(dut)
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
    
    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Zigzag_Y_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cb_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cr_Input(dut)

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("5: Zigzaged Data (8x8 matrix):")

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Zigzag_Y_output(dut)
        await sub_Debug_func.dump_Zigzag_Cb_output(dut)
        await sub_Debug_func.dump_Zigzag_Cr_output(dut)

    print("==========================================================================")
    print("6: Huffman enc Start")
    print("6.1: Huffman DC Code")
    # Huffman start
    dut.Huffman_start.value = 1
    await RisingEdge(dut.clock)
    dut.Huffman_start.value = 0

    # Debug on
    Huffman_debug = 1

    print("6.1: Huffman DC Code")
    # DC コード部分を各モジュールで並列に実行
    dc_debug = 1
    final_dc_container = {}
    task_dc_y = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Y.mHuffman_enc_controller, "Y", True, final_dc_container, dut.clock))
    task_dc_cb = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Cb.mHuffman_enc_controller, "Cb", True, final_dc_container, dut.clock))
    task_dc_cr = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Cr.mHuffman_enc_controller, "Cr", True, final_dc_container, dut.clock))

    # 並列タスクの終了を待機
    await task_dc_y.join()
    await task_dc_cb.join()
    await task_dc_cr.join()

    # 各モジュールの DC コード出力を個別に表示
    print("Y dc final_output =", final_dc_container.get("Y", ""))
    print("Cb dc final_output =", final_dc_container.get("Cb", ""))
    print("Cr dc final_output =", final_dc_container.get("Cr", ""))

    print("==========================================================================")
    # 例えば36回検出するか、state が 0 になったらループ終了
    print("6.2: Huffman AC Code")

    # 出力を格納するための辞書
    final_output_container = {}

    # 並列に各モジュールの Huffman AC Code 部分を実行（共通のクロック信号を渡す）
    task_y = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Y.mHuffman_enc_controller, "Y", False, final_output_container, dut.clock))
    task_cb = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Cb.mHuffman_enc_controller, "Cb", True, final_output_container, dut.clock))
    task_cr = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Cr.mHuffman_enc_controller, "Cr", False, final_output_container, dut.clock))

    # 並列タスクの終了を待機
    await task_y.join()
    await task_cb.join()
    await task_cr.join()

    # 各モジュールの結果を個別に表示する
    print("Y final_output =", final_output_container.get("Y", ""))
    print("Cb final_output =", final_output_container.get("Cb", ""))
    print("Cr final_output =", final_output_container.get("Cr", ""))

    #print("jpeg_dc_out =", dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_out.value)

    final_Y_output = final_dc_container.get("Y", "") + final_output_container.get("Y", "")
    final_Cb_output = final_dc_container.get("Cb", "") + final_output_container.get("Cb", "")
    final_Cr_output = final_dc_container.get("Cr", "") + final_output_container.get("Cr", "")

    print("==========================================================================")
    print("7: Huffman enc End")
    print("count =", int(dut.counter.value), "clk")

    print("==========================================================================")
    print("8: Final Output")
    # とりあえずの出力ビット処理 #
    # 追加処理：final_output の最後の4ビットを削除する
    #final_output = final_output + "1100"

    # 最終出力が8ビットの倍数でない場合、末尾に'0'を追加して調整する
    '''
    if len(final_Y_output) % 8 != 0:
        padding = 8 - (len(final_Y_output) % 8)
        final_Y_output += '0' * padding
    '''

    '''
    formatted_output = '_'.join([final_output[i:i+8] for i in range(0, len(final_output), 8)])
    print(formatted_output)
    if Huffman_debug == 1:
        print("Total Bits:", len(final_output))
        print("Compression Rate:", 100*len(final_output)/512, "%")
    '''

    return (final_Y_output, final_Cb_output, final_Cr_output)

    print("==========================================================================")
    for _ in range(100):
        await RisingEdge(dut.clock)

    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    print("Test completed.")
