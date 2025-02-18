"""
NISHIHARU
JPEG HW Encoder Test
"""
import cocotb
from cocotb.triggers import Timer, RisingEdge

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
    dut.reset_n.value = 0  
    dut.Red.value = 0
    dut.Green.value = 0
    dut.Blue.value = 0
    dut.input_1pix_enable.value = 0
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
    dut.input_enable.value = 1

    # 0〜63のならび
    #dut.pix_data.value = list(range(1, 65))
    # すべて0
    #dut.pix_data.value = [0] * 64
    # すべて255
    #dut.pix_data.value = [255] * 64
    # 左上が80
    dut.pix_data.value = [80 if (i < 4 and j < 4) else 0 for i in range(8) for j in range(8)]
    # 80, 0, 80, 0 ...
    #dut.pix_data.value = [80, 0] * 32

    await RisingEdge(dut.clock)
    dut.input_enable.value = 0
    # pix_data の各要素を 10 進数に変換してリストに格納
    pix_data_list = [int(p.binstr, 2) for p in dut.pix_data.value]

    print("Input Data (8x8 matrix):")
    for row in range(8):
        # 8 個ずつ取り出して表示（各行）
        row_data = pix_data_list[row*8:(row+1)*8]
        print(" ".join(f"{val:3d}" for val in row_data))

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("1: DCT 2D Start")
    # DCT 2D Start
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 1
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 0

    for _ in range(20):
        await RisingEdge(dut.clock)

    # Debug
    '''
    matrix = []
    for i in range(8):
        # dut.row_buffer is an array; 各要素は 64 ビットの値
        row_val = dut.HW_JPEGenc_Y.mDCT_2D.row_buffer[i].value.integer  # 整数値として取得
        #row_val = dut.HW_JPEGenc_Y.mDCT_2D.col_vector[i].value.integer  # 整数値として取得
        row_bytes = []
        # 上位バイトから下位バイトへ取り出す (例: row_val[63:56] から row_val[7:0])
        for j in reversed(range(8)):
            byte = (row_val >> (8 * j)) & 0xFF
            row_bytes.append(byte)
        matrix.append(row_bytes)

    dut._log.info("row_buffer (8x8 matrix):")
    #dut._log.info("col_vector (8x8 matrix):")

    for row in matrix:
        # 各バイトを 10 進数 3 桁で表示
        row_str = " ".join(f"{val:3d}" for val in row)
        dut._log.info(row_str)
    '''

    # 例: dct2d_out を 8x8 の行列として表示
    dct2d_data = []
    for d in dut.HW_JPEGenc_Y.dct2d_out.value:
        # 各要素を 10 進数に変換してリストに追加
        dct2d_data.append(int(d.binstr, 2))

    print("DCT2D Output (8x8 matrix):")
    for row in range(8):
        # 8個ずつ取り出して表示
        row_data = dct2d_data[row*8:(row+1)*8]
        # 各値を 3 桁（例）で整形して表示
        print(" ".join(f"{val:3d}" for val in row_data))

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

    print("==========================================================================")
    print("3: Zigzag scan Start")
    print("Quantized Data (8x8 matrix):")
    for row in range(8):
        # 各行の64ビットデータをビット文字列として取得
        binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x8bit.buffer_64bit[row].value.binstr
        # 未定義 'x' を '0' に置換
        binstr = binstr.replace("x", "0")
        # ビット幅が64でない場合は、先頭にゼロを埋める
        if len(binstr) < 64:
            binstr = binstr.zfill(64)
        # 64ビットを8ビットずつに分割して整数のリストに変換
        row_vals = [int(binstr[i:i+8], 2) for i in range(0, 64, 8)]
        # 8ビットごとのデータの順序を左右逆にして表示（reversed）
        print(" ".join("{:3d}".format(val) for val in reversed(row_vals)))

    dut.zigag_enable.value = 1
    await RisingEdge(dut.clock)
    dut.zigag_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("4: Zigzag Input Data (8x8 matrix):")
    # matrix.value は 512ビットのシグナルオブジェクトと仮定する
    matrix_val = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x8bit.zigzag_pix_in.value.binstr  # ビット文字列として取得
    # matrix_val の長さが 512 であることを確認
    if len(matrix_val) != 512:
        print("警告: 取得したビット長が512ではありません:", len(matrix_val))
    
    # 8ビット毎にスライスしてリストにする（LSB側から8ビットずつ：末尾から逆順に取得）
    Zigzan_list = [int(matrix_val[i:i+8], 2) for i in range(512-8, -1, -8)]

    # 8x8のマトリックスに整形して出力
    for i in range(8):
        row = Zigzan_list[i*8:(i+1)*8]
        print(" ".join("{:3d}".format(x) for x in row))

    for _ in range(4):
        await RisingEdge(dut.clock)
        
    print("==========================================================================")
    print("5: Zigzaged Data (8x8 matrix):")
    # zigzag_pix_out の値を 512 ビットのビット文字列として取得する
    zigzag_binstr = dut.HW_JPEGenc_Y.m_databuffer_zigzag64x8bit.zigzag_pix_out.value.binstr
    print("zigzag_binstr length:", len(zigzag_binstr))

    # LSB側から8ビットずつ取り出す：末尾から逆順にスライス
    Zigzaned_list = [int(zigzag_binstr[i:i+8], 2) for i in range(len(zigzag_binstr)-8, -1, -8)]

    # 8x8 のマトリックスに整形して出力
    for i in range(8):
        row = Zigzaned_list[i*8:(i+1)*8]
        print(" ".join("{:3d}".format(x) for x in row))

    print("==========================================================================")
    print("6: Huffman enc Start")
    # Huffman start
    dut.Huffman_start.value = 1
    await RisingEdge(dut.clock)
    dut.Huffman_start.value = 0

    num_detected = 0
    done = False  # ここで done を初期化

    # 例えば36回検出するか、state が 0 になったらループ終了
    while num_detected < 36 and not done:
        # jpeg_out_enable の立ち上がりを待機
        await RisingEdge(dut.HW_JPEGenc_Y.mHuffman_enc_controller.jpeg_out_enable)
        print("start_pix =", int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.start_pix.value))
        print("run =", int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.run.value))
        print("code count = {} ".format(num_detected))
        print("huffman_code =", dut.HW_JPEGenc_Y.mHuffman_enc_controller.huffman_code.value)
        print("huffman_code_length =", int(dut.HW_JPEGenc_Y.mHuffman_enc_controller.huffman_code_length.value))
        print("code_out =", dut.HW_JPEGenc_Y.mHuffman_enc_controller.code_out.value)
        print("--------")
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

    for _ in range(100):
        await RisingEdge(dut.clock)

    # Disable input_enable
    dut.input_enable.value = 0
    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    print("Test completed.")
