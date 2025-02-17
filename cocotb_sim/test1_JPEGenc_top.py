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
    dut.matrix_row.value = 0
    dut.Huffman_start.value = 0
    dut.output_enable.value = 0


    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value = 1      
    
    for _ in range(10):
        await RisingEdge(dut.clock)    

    # Set input_enable high and initialize pix_data with 1's
    dut.input_enable.value = 1
    dut.pix_data.value = list(range(1, 65))
    await RisingEdge(dut.clock)
    dut.input_enable.value = 0

    await RisingEdge(dut.clock)
    dut.dct_enable.value = 1



    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    dut.dct_enable.value = 0
    
    # Disable input_enable
    dut.input_enable.value = 0
    
    # Wait additional time for processing
    for _ in range(100):
        await RisingEdge(dut.clock)
    
    # ここに追加の検証コードを記述する
    print("Test completed.")
