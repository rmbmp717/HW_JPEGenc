"""
NISHIHARU
"""
import cocotb
import random
from cocotb.triggers import Timer, RisingEdge

import sys, os

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

def convert_s12(raw: int) -> int:
    """
    12ビットの符号付き整数（符号付き12bit値）として解釈する。
    入力 raw は 0～4095 の範囲の整数と仮定し、
    2048以上の場合は 4096 を引いて負の値に変換する。
    """
    if raw >= 2048:
        return raw - 4096
    else:
        return raw

async def dump_Input_Y(dut):
    print("==========================================================================")
    # buffer は 64 要素の配列と仮定
    matrix = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Y.m0_databuffer_64x12bit.buffer[index].value.integer))
        matrix.append(row)
    
    print("Y Buffer (8x8 matrix):")
    for row in matrix:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)

async def dump_Input_Cb(dut):
    print("==========================================================================")
    # buffer は 64 要素の配列と仮定
    matrix = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Cb.m0_databuffer_64x12bit.buffer[index].value.integer))
        matrix.append(row)
    
    print("Cb Buffer (8x8 matrix):")
    for row in matrix:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)

async def dump_Input_Cr(dut):
    print("==========================================================================")
    # buffer は 64 要素の配列と仮定
    matrix = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Cr.m0_databuffer_64x12bit.buffer[index].value.integer))
        matrix.append(row)
    
    print("Cb Buffer (8x8 matrix):")
    for row in matrix:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)

        
async def dump_Dct_Y_input(dut):
    print("==========================================================================")
    print("1.1: DCT 2D Input Data")
    # buffer は 64 要素の配列と仮定
    matrix_dctin = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Y.mDCT_2D.pix_data[index].value.integer))
        matrix_dctin.append(row)
    
    print("DCT Y Input Buffer (8x8 matrix):")
    for row in matrix_dctin:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)

async def dump_Dct_Cb_input(dut):
    print("==========================================================================")
    print("1.1: DCT 2D Input Data")
    # buffer は 64 要素の配列と仮定
    matrix_dctin = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Cb.mDCT_2D.pix_data[index].value.integer))
        matrix_dctin.append(row)
    
    print("DCT Cb Input Buffer (8x8 matrix):")
    for row in matrix_dctin:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)

async def dump_Dct_Cr_input(dut):
    print("==========================================================================")
    print("1.1: DCT 2D Input Data")
    # buffer は 64 要素の配列と仮定
    matrix_dctin = []
    for i in range(8):
        row = []
        for j in range(8):
            index = i * 8 + j
            row.append(convert_s12(dut.HW_JPEGenc_Cr.mDCT_2D.pix_data[index].value.integer))
        matrix_dctin.append(row)
    
    print("DCT Cr Input Buffer (8x8 matrix):")
    for row in matrix_dctin:
        # 各値を幅4で右寄せして整形して出力
        line = " ".join(f"{val:4d}" for val in row)
        print(line)


async def dump_Dct_Y_output(dut):
    print("==========================================================================")

    # 例: dct2d_out を 8x8 の行列として表示
    dct2d_data = []
    for d in dut.HW_JPEGenc_Y.dct2d_out.value:
        # 各要素を 10 進数に変換してリストに追加
        dct2d_data.append(convert_s12(int(d.binstr, 2)))

    print("DCT2D Y Output (8x8 matrix):")
    for row in range(8):
        # 8個ずつ取り出して表示
        row_data = dct2d_data[row*8:(row+1)*8]
        # 各値を 4 桁（例）で整形して表示
        print(" ".join(f"{val:4d}" for val in row_data))

async def dump_Dct_Cb_output(dut):
    print("==========================================================================")

    # 例: dct2d_out を 8x8 の行列として表示
    dct2d_data = []
    for d in dut.HW_JPEGenc_Cb.dct2d_out.value:
        # 各要素を 10 進数に変換してリストに追加
        dct2d_data.append(convert_s12(int(d.binstr, 2)))

    print("DCT2D Cb Output (8x8 matrix):")
    for row in range(8):
        # 8個ずつ取り出して表示
        row_data = dct2d_data[row*8:(row+1)*8]
        # 各値を 4 桁（例）で整形して表示
        print(" ".join(f"{val:4d}" for val in row_data))

async def dump_Dct_Cr_output(dut):
    print("==========================================================================")

    # 例: dct2d_out を 8x8 の行列として表示
    dct2d_data = []
    for d in dut.HW_JPEGenc_Cr.dct2d_out.value:
        # 各要素を 10 進数に変換してリストに追加
        dct2d_data.append(convert_s12(int(d.binstr, 2)))

    print("DCT2D Cr Output (8x8 matrix):")
    for row in range(8):
        # 8個ずつ取り出して表示
        row_data = dct2d_data[row*8:(row+1)*8]
        # 各値を 4 桁（例）で整形して表示
        print(" ".join(f"{val:4d}" for val in row_data))


async def dump_Quantized_Y_output(dut):
    print("==========================================================================")
    print("Quantized Y Data (8x8 matrix):")
    for row in range(8):
        # 各行の80ビットデータをビット文字列として取得
        binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x10bit.buffer_80bit[row].value.binstr
        # 未定義 'x' を '0' に置換
        binstr = binstr.replace("x", "0")
        # ビット幅が80でない場合は、先頭にゼロを埋める
        if len(binstr) < 80:
            binstr = binstr.zfill(80)
        # 80ビットを10ビットずつに分割して整数のリストに変換し、convert_s10で符号付き整数に変換
        row_vals = [convert_s10(int(binstr[i:i+10], 2)) for i in range(0, 80, 10)]
        # 10ビットごとのデータの順序を左右逆にして表示（reversed）
        print(" ".join("{:4d}".format(val) for val in reversed(row_vals)))

async def dump_Quantized_Cb_output(dut):
    print("==========================================================================")
    print("Quantized Cb Data (8x8 matrix):")
    for row in range(8):
        # 各行の80ビットデータをビット文字列として取得
        binstr = dut.HW_JPEGenc_Cb.m_databuffer_zigzag64x10bit.buffer_80bit[row].value.binstr
        # 未定義 'x' を '0' に置換
        binstr = binstr.replace("x", "0")
        # ビット幅が80でない場合は、先頭にゼロを埋める
        if len(binstr) < 80:
            binstr = binstr.zfill(80)
        # 80ビットを10ビットずつに分割して整数のリストに変換し、convert_s10で符号付き整数に変換
        row_vals = [convert_s10(int(binstr[i:i+10], 2)) for i in range(0, 80, 10)]
        # 10ビットごとのデータの順序を左右逆にして表示（reversed）
        print(" ".join("{:4d}".format(val) for val in reversed(row_vals)))

async def dump_Quantized_Cr_output(dut):
    print("==========================================================================")
    print("Quantized Cr Data (8x8 matrix):")
    for row in range(8):
        # 各行の80ビットデータをビット文字列として取得
        binstr = dut.HW_JPEGenc_Cr.m_databuffer_zigzag64x10bit.buffer_80bit[row].value.binstr
        # 未定義 'x' を '0' に置換
        binstr = binstr.replace("x", "0")
        # ビット幅が80でない場合は、先頭にゼロを埋める
        if len(binstr) < 80:
            binstr = binstr.zfill(80)
        # 80ビットを10ビットずつに分割して整数のリストに変換し、convert_s10で符号付き整数に変換
        row_vals = [convert_s10(int(binstr[i:i+10], 2)) for i in range(0, 80, 10)]
        # 10ビットごとのデータの順序を左右逆にして表示（reversed）
        print(" ".join("{:4d}".format(val) for val in reversed(row_vals)))

async def dump_Zigzag_Y_Input(dut):
    print("==========================================================================")
    print("4: Zigzag Y Input Data (8x8 matrix):")
    # matrix.value は 640ビットのシグナルオブジェクトと仮定する
    matrix_val = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x10bit.zigzag_pix_in.value.binstr  # ビット文字列として取得

    # matrix_val の長さが 640 であることを確認
    if len(matrix_val) != 640:
        print("警告: 取得したビット長が640ではありません:", len(matrix_val))

    # 10ビット毎にスライスしてリストにする（LSB側から8ビットずつ：末尾から逆順に取得）
    Zigzan_list = [convert_s10(int(matrix_val[i:i+10], 2)) for i in range(640-10, -1, -10)]

    # 8x8のマトリックスに整形して出力
    for i in range(8):
        row = Zigzan_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cb_Input(dut):
    print("==========================================================================")
    print("4: Zigzag Cb Input Data (8x8 matrix):")
    # matrix.value は 640ビットのシグナルオブジェクトと仮定する
    matrix_val = dut.HW_JPEGenc_Cb.m_databuffer_zigzag64x10bit.zigzag_pix_in.value.binstr  # ビット文字列として取得

    # matrix_val の長さが 640 であることを確認
    if len(matrix_val) != 640:
        print("警告: 取得したビット長が640ではありません:", len(matrix_val))

    # 10ビット毎にスライスしてリストにする（LSB側から8ビットずつ：末尾から逆順に取得）
    Zigzan_list = [convert_s10(int(matrix_val[i:i+10], 2)) for i in range(640-10, -1, -10)]

    # 8x8のマトリックスに整形して出力
    for i in range(8):
        row = Zigzan_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cr_Input(dut):
    print("==========================================================================")
    print("4: Zigzag Cr Input Data (8x8 matrix):")
    # matrix.value は 640ビットのシグナルオブジェクトと仮定する
    matrix_val = dut.HW_JPEGenc_Cr.m_databuffer_zigzag64x10bit.zigzag_pix_in.value.binstr  # ビット文字列として取得

    # matrix_val の長さが 640 であることを確認
    if len(matrix_val) != 640:
        print("警告: 取得したビット長が640ではありません:", len(matrix_val))

    # 10ビット毎にスライスしてリストにする（LSB側から8ビットずつ：末尾から逆順に取得）
    Zigzan_list = [convert_s10(int(matrix_val[i:i+10], 2)) for i in range(640-10, -1, -10)]

    # 8x8のマトリックスに整形して出力
    for i in range(8):
        row = Zigzan_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Y_output(dut):
    print("==========================================================================")
    print("5: Zigzaged Y Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x10bit.zigzag_pix_out_tmp.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x10bit.zigzag_pix_out.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cb_output(dut):
    print("==========================================================================")
    print("5: Zigzaged Cb Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Cb.m_databuffer_zigzag64x10bit.zigzag_pix_out.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cr_output(dut):
    print("==========================================================================")
    print("5: Zigzaged Cr Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Cr.m_databuffer_zigzag64x10bit.zigzag_pix_out.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Y_output_pre(dut):
    print("==========================================================================")
    print("5: Pre Data : Zigzaged Y Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x10bit.zigzag_pix_out_pre.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cb_output_pre(dut):
    print("==========================================================================")
    print("5: Pre Data : Zigzaged Cb Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Cb.m_databuffer_zigzag64x10bit.zigzag_pix_out_pre.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))

async def dump_Zigzag_Cr_output_pre(dut):
    print("==========================================================================")
    print("5: Pre Data : Zigzaged Cr Output Data (8x8 matrix):")
    # zigzag_pix_out の値を 640 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Cr.m_databuffer_zigzag64x10bit.zigzag_pix_out_pre.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から10ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [convert_s10(int(zigzag_binstr[i:i+10], 2))
                    for i in range(len(zigzag_binstr)-10, -1, -10)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:4d}".format(x) for x in row))