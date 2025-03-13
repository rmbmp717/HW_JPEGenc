"""
NISHIHARU
JPEG HW Encoder Test
"""
import cocotb
import random
import logging
from cocotb.triggers import First, Timer, RisingEdge, FallingEdge
from cocotb.utils import get_sim_time

import sys, os
import math

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_Debug_func

# ---------------------------------------------------
# sub DC 関数
async def run_huffman_dc(module, name, final_dc_container, clock):

    # ログ設定: level を DEBUG にすれば詳細なログが出る
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)  # 明示的にレベルを DEBUG に設定

    # モジュールの state が 6 になるまで待機
    while True:
        await RisingEdge(clock)
        if int(module.state.value) == 7:
            break

    # DC コード関連の信号を取得
    huffman_dc_code_bin = str(module.jpeg_dc_out.value)
    huffman_dc_code_length = int(module.jpeg_dc_out_length.value)
    huffman_dc_code_list = str(module.jpeg_dc_code_list.value)
    huffman_dc_code_list_size = int(module.dc_out_code_size.value)

    logger.debug(f"{name} huffman_dc_code_bin(bin) = {huffman_dc_code_bin}")
    logger.debug(f"{name} huffman_dc_code_list(bin) = {huffman_dc_code_list}")

    # 余分な 0 を除去し、リストサイズ分を取り出す
    trimmed_huffman_dc_code_list = huffman_dc_code_list.lstrip('0')
    
    if huffman_dc_code_list_size == 0:
        trimmed_huffman_dc_code_list = []
    else:
        trimmed_huffman_dc_code_list = trimmed_huffman_dc_code_list[-huffman_dc_code_list_size:]

    # DC コード本体は先頭部分から取り出す
    trimmed_huffman_dc_code = huffman_dc_code_bin[-huffman_dc_code_length:]

    logger.debug(f"{name} huffman_dc_code(bin) = {trimmed_huffman_dc_code}")
    logger.debug(f"{name} huffman_dc_code_length = {huffman_dc_code_length}")
    logger.debug(f"{name} trimmed_huffman_dc_code_list = {trimmed_huffman_dc_code_list}")
    logger.debug(f"{name} huffman_dc_code_list_size = {huffman_dc_code_list_size}")

    # 連結して最終出力とする
    if huffman_dc_code_list_size == 0:
        final_dc = trimmed_huffman_dc_code
    else:
        final_dc = trimmed_huffman_dc_code + trimmed_huffman_dc_code_list

    logger.debug(f"{name} dc final_output = {final_dc}")
    final_dc_container[name] = final_dc
    logger.debug("--------------")

# ---------------------------------------------------
# sub AC 関数
async def run_huffman_ac(module, name, final_output_container, clock):

    # ログ設定: level を DEBUG にすれば詳細なログが出る
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)  # 明示的にレベルを DEBUG に設定

    num_detected = 0
    done = False
    local_output = ""
    logger.debug("==========================================================================")
    logger.debug("6.2: Huffman AC Code")
    start_pix = int(module.start_pix.value)
    while num_detected < 63 and not done:
        # jpeg_out_enable の立ち上がりを待機
        await RisingEdge(module.jpeg_out_enable)
        await FallingEdge(clock)

        logger.debug(f"{get_sim_time('ns')} ns:")
        huffman_code_bin = str(module.ac_out.value)
        huffman_code_length = int(module.length.value)
        trimmed_huffman_code = huffman_code_bin[-huffman_code_length:]
        code_out = str(module.code_out.value)
        code_size_out = int(module.code_size_out.value)
        #code_out_bin = code_out[-code_size_out:]
        code_out_bin = "" if code_size_out == 0 else code_out[-code_size_out:]
        now_pix_data = sub_Debug_func.convert_s10(int(module.now_pix_data.value))
        
        logger.debug(module)
        logger.debug(f"start_pix = {start_pix}")
        logger.debug(f"huffman_code(bin) = {trimmed_huffman_code}")
        logger.debug(f"huffman_code(int) = {int(module.ac_out.value)}")
        logger.debug(f"huffman_code_length = {huffman_code_length}")
        logger.debug(f"code_out(bin) = {code_out_bin}")
        logger.debug(f"code_size_out = {code_size_out}")
        logger.debug(f"now_pix_data = {now_pix_data}")
        
        # ビット列を最終出力に連結
        if int(module.Huffmanenc_active.value) == 1:
            if int(module.jpeg_out_end.value) == 1:
                logger.debug("final bit")
                local_output += trimmed_huffman_code 
            else:
                local_output += trimmed_huffman_code + code_out_bin 

        num_detected += 1

        logger.debug(f"now_JPEG_output = {local_output}")
        logger.debug("--------------")

        # jpeg_out_enable が Low になる（立ち下がり）を待機する
        await FallingEdge(module.jpeg_out_enable)
        await RisingEdge(clock)
        start_pix = int(module.start_pix.value)
    
        # デバッグ用：Huffmanenc_active の値を表示
        #logger.debug(f"Huffmanenc_active = {int(module.Huffmanenc_active.value)}")
        
        # 状態が 0 になったら終了
        if int(module.Huffmanenc_active.value) == 0:
            logger.debug(f"{get_sim_time('ns')} ns:")
            logger.debug("Loop End")
            done = True

    final_output_container[name] = local_output

# ---------------------------------------------------
# sub メイン関数

# Debug 8x8 matrix out
matrix_debug_out = 1

async def sub_test_JPEGenc(dut, input_matrix_r, input_matrix_g, input_matrix_b):

    # ログ設定: level を DEBUG にすれば詳細なログが出る
    logging.basicConfig(
        level=logging.INFO,  # ここを DEBUG にすれば詳細なログが出る
        format='%(asctime)s [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)  # 明示的にログレベルを DEBUG に設定

    logger.debug("==========================================================================")
   
    for _ in range(10):
        await RisingEdge(dut.clock)    

    logger.debug("==========================================================================")
    logger.debug("0: Input Data")

    # flat化
    flat_data_r = [input_matrix_r[i][j] for i in range(8) for j in range(8)]
    flat_data_g = [input_matrix_g[i][j] for i in range(8) for j in range(8)]
    flat_data_b = [input_matrix_b[i][j] for i in range(8) for j in range(8)]

    #await RisingEdge(dut.clock)
    #dut.input_enable.value = 0
    # pix_data の各要素を 10 進数に変換してリストに格納
    #pix_data_list = [int(p.binstr, 2) for p in dut.pix_data.value]

    for pix in range(64):
        if pix > 1:
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

    logger.debug("==========================================================================")
    logger.debug("1: DCT 2D Start")

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

    logger.debug("1.2: DCT 2D Output Data")
    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Dct_Y_output(dut)
        await sub_Debug_func.dump_Dct_Cb_output(dut)
        await sub_Debug_func.dump_Dct_Cr_output(dut)

    logger.debug("==========================================================================")
    logger.debug("2: Quantize Start")
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
    logger.debug("2: Quantize End")

    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Quantized_Y_output(dut)
        #await sub_Debug_func.dump_Quantized_Cb_output(dut)
        #await sub_Debug_func.dump_Quantized_Cr_output(dut)

    logger.debug("==========================================================================")
    logger.debug("3: Zigzag scan Start")

    await RisingEdge(dut.clock)

    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Zigzag_Y_output_pre(dut)

    dut.zigag_enable.value = 1
    await RisingEdge(dut.clock)
    dut.zigag_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    await RisingEdge(dut.clock)
    #if matrix_debug_out == 1:
        #await sub_Debug_func.dump_Zigzag_Y_output(dut)
        #await sub_Debug_func.dump_Zigzag_Cb_output_pre(dut)
        #await sub_Debug_func.dump_Zigzag_Cr_output_pre(dut)

    logger.debug("==========================================================================")
    logger.debug("4: Zigzag Input Data (8x8 matrix):")
    
    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Zigzag_Y_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cb_Input(dut)
        #await sub_Debug_func.dump_Zigzag_Cr_Input(dut)

    for _ in range(4):
        await RisingEdge(dut.clock)

    logger.debug("==========================================================================")
    logger.debug("5: Zigzaged Data (8x8 matrix):")

    if matrix_debug_out == 1:
        await sub_Debug_func.dump_Zigzag_Y_output(dut)
        await sub_Debug_func.dump_Zigzag_Cb_output(dut)
        await sub_Debug_func.dump_Zigzag_Cr_output(dut)

    logger.debug("==========================================================================")
    logger.debug("6: Huffman enc Start")
    logger.debug("6.1: Huffman DC Code")
    # Huffman start
    dut.Huffman_start.value = 1
    await RisingEdge(dut.clock)
    dut.Huffman_start.value = 0

    # Debug on
    Huffman_debug = 1

    logger.debug("6.1: Huffman DC Code")
    # DC コード部分を各モジュールで並列に実行
    dc_debug = 1
    final_dc_container = {}
    task_dc_y = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Y.mHuffman_enc_controller, "Y", final_dc_container, dut.clock))
    task_dc_cb = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Cb.mHuffman_enc_controller, "Cb", final_dc_container, dut.clock))
    task_dc_cr = cocotb.start_soon(run_huffman_dc(dut.HW_JPEGenc_Cr.mHuffman_enc_controller, "Cr", final_dc_container, dut.clock))

    # 並列タスクの終了を待機
    await task_dc_y
    await task_dc_cb
    await task_dc_cr

    # 各モジュールの DC コード出力を個別に表示
    logger.debug(f"Y dc final_output = {final_dc_container.get('Y', '')}")
    logger.debug(f"Cb dc final_output = {final_dc_container.get('Cb', '')}")
    logger.debug(f"Cr dc final_output = {final_dc_container.get('Cr', '')}")

    logger.debug("==========================================================================")
    # 例えば36回検出するか、state が 0 になったらループ終了
    logger.debug("6.2: Huffman AC Code")

    # 出力を格納するための辞書
    final_output_container = {}

    # 並列に各モジュールの Huffman AC Code 部分を実行（共通のクロック信号を渡す）
    task_y = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Y.mHuffman_enc_controller, "Y", final_output_container, dut.clock))
    task_cb = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Cb.mHuffman_enc_controller, "Cb", final_output_container, dut.clock))
    task_cr = cocotb.start_soon(run_huffman_ac(dut.HW_JPEGenc_Cr.mHuffman_enc_controller, "Cr", final_output_container, dut.clock))

    # 並列タスクの終了を待機
    await task_y
    await task_cb
    await task_cr

    # 各モジュールの結果を個別に表示する
    #print("Y final_output =", final_output_container.get("Y", ""))
    #print("Cb final_output =", final_output_container.get("Cb", ""))
    #print("Cr final_output =", final_output_container.get("Cr", ""))

    #print("jpeg_dc_out =", dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_dc_out.value)

    final_Y_output = final_dc_container.get("Y", "") + final_output_container.get("Y", "")
    final_Cb_output = final_dc_container.get("Cb", "") + final_output_container.get("Cb", "")
    final_Cr_output = final_dc_container.get("Cr", "") + final_output_container.get("Cr", "")

    logger.debug("==========================================================================")
    logger.debug("7: Huffman enc End")
    logger.debug(f"count = {int(dut.counter.value)} clk")

    logger.debug("==========================================================================")
    logger.debug("8: Final Output")
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

    print(f"Y = {final_Y_output}")
    print(f"Cb = {final_Cb_output}")
    print(f"Cr = {final_Cr_output}")

    return (final_Y_output, final_Cb_output, final_Cr_output)

    logger.debug("==========================================================================")
    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    logger.debug("Test completed.")
