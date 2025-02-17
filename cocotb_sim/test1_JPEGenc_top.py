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
    dut.dct_input_enable.value = 0
    dut.zigzag_input_enable.value = 0
    dut.zigag_enable.value = 0
    dut.matrix_row.value = 0
    dut.Huffman_start.value = 0
    dut.output_enable.value = 0


    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value = 1      
    
    for _ in range(10):
        await RisingEdge(dut.clock)    

    print("==========================================================================")
    print("Input Data")
    # Set input_enable high and initialize pix_data with 1's
    dut.input_enable.value = 1
    dut.pix_data.value = list(range(1, 65))
    await RisingEdge(dut.clock)
    dut.input_enable.value = 0
    # pix_data の各要素を 10 進数に変換してリストに格納
    pix_data_list = [int(p.binstr, 2) for p in dut.pix_data.value]

    print("Input Data (8x8 matrix):")
    for row in range(8):
        # 8 個ずつ取り出して表示（各行）
        row_data = pix_data_list[row*8:(row+1)*8]
        print(" ".join(f"{val:3d}" for val in row_data))

    print("==========================================================================")
    print("DCT 2D Start")
    # DCT 2D Start
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 1
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 0

    for _ in range(28):
        await RisingEdge(dut.clock)

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
    print("Quantize Start")
    # Quantize buffer
    dut.dct_input_enable.value = 1
    await RisingEdge(dut.clock)
    dut.dct_input_enable.value = 0

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
    print("Zigzag scan Start")
    # Zigag scan
    print("Quantized Data (8x8 matrix):")
    # 各要素を 10 進数に変換してリストに格納
    quantized_list = [int(d.binstr, 2) for d in dut.HW_JPEGenc_Y.m_databuffer_zigzag64x8bit.buffer.value]
    for row in range(8):
        # 8 個ずつ取り出して表示（各行）
        row_data = quantized_list[row*8:(row+1)*8]
        print(" ".join(f"{val:3d}" for val in row_data))

    dut.zigag_enable.value = 1
    await RisingEdge(dut.clock)
    dut.zigag_enable.value = 0

    for _ in range(4):
        await RisingEdge(dut.clock)

    print("==========================================================================")
    print("Huffman enc Start")
    # Huffman start
    dut.Huffman_start.value = 1
    await RisingEdge(dut.clock)
    dut.Huffman_start.value = 0

    for _ in range(100):
        await RisingEdge(dut.clock)

    # Disable input_enable
    dut.input_enable.value = 0
    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    print("Test completed.")
