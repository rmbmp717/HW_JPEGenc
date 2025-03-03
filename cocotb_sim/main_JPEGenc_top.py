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

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_test_JPEG_write

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
    final_Y_output, final_Cb_output, final_Cr_output = await sub_test_JPEGenc.sub_test_JPEGenc(dut)

    for _ in range(20):
        await RisingEdge(dut.clock)

    #formatted_output = '_'.join([final_Y_output[i:i+8] for i in range(0, len(final_Y_output), 8)])
    formatted_output = final_Y_output
    print("final Y output : ", formatted_output)
    #formatted_output = '_'.join([final_Cb_output[i:i+8] for i in range(0, len(final_Cb_output), 8)])
    formatted_output = final_Cb_output
    print("final Cb output : ", formatted_output)
    #formatted_output = '_'.join([final_Cr_output[i:i+8] for i in range(0, len(final_Cr_output), 8)])
    formatted_output = final_Cr_output
    print("final Cr output : ", formatted_output)

    print("Total Bits:", len(final_Y_output + final_Cb_output + final_Cr_output))
    print("Compression Rate:", 100*len((final_Y_output + final_Cb_output + final_Cr_output))/(512*3), "%")

    print("==========================================================================")
    print("Main test End")


    print("==========================================================================")
    print("JPEG File Write")
    
    await sub_test_JPEG_write.file_write(dut, final_Y_output, final_Cb_output, final_Cr_output)
