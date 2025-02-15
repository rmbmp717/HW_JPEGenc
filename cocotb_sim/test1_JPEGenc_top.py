'''
NISHIHARU
'''
import cocotb
import struct
import random
from cocotb.triggers import Timer, RisingEdge

async def generate_clock(dut, period=10):
    """Generate a clock on dut.clk with the given period in ns."""
    while True:
        dut.clk.value = 0
        await Timer(period // 2, units="ns")
        dut.clk.value = 1
        await Timer(period // 2, units="ns")

@cocotb.test()
async def test1_JPEGenc_top(dut):
    """Test FP16 multiplier with memory dump at the end."""
    print("==========================================================================")   

    await Timer(100, units="ns") 

    # Further tests can be added here with different input values and checks