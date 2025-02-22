"""
NISHIHARU
JPEG HW Encoder Test
"""
import sys, os
import cocotb
import random
from cocotb.triggers import Timer, RisingEdge

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_test_JPEGenc

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../python/')))
import my_JPEG_dec

async def generate_clock(dut, period=10):
    """Generate a clock on dut.clock with the given period in ns."""
    while True:
        dut.clock.value = 0
        await Timer(period // 2, units="ns")
        dut.clock.value = 1
        await Timer(period // 2, units="ns")

@cocotb.test()
async def main_JPEGenc_top(dut):
    print("==========================================================================")
    # Start clock generation (if not already spawned by testbench)
    cocotb.start_soon(generate_clock(dut, period=10))

    # start
    await sub_test_JPEGenc.sub_test_JPEGenc(dut)

    for _ in range(20):
        await RisingEdge(dut.clock)

    '''
    print("==========================================================================")
    print("9: Decode JPEG final_output")
    # シミュレーションで得られた final_output（ビット列文字列）を一時ファイルに保存
    temp_filename = "final_output_temp.txt"
    with open(temp_filename, "w") as f:
        f.write(final_output)
    # my_JPEG_dec のメイン処理を --bitstream モードで呼び出す
    import my_JPEG_dec
    my_JPEG_dec.main("--bitstream", temp_filename)
    # Disable input_enable
    dut.input_enable.value = 0
    '''

    print("Main test End")