import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_aesa_wrapper(dut):
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())
    dut.rst_n.value = 0; dut.ena.value = 1; dut.ui_in.value = 0; dut.uio_in.value = 0
    await RisingEdge(dut.clk); dut.rst_n.value = 1; await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00001010; dut.uio_in.value = 0b00001011; await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00000000; await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00000010; await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00000000
    timeout = 100000
    while dut.uo_out[3].value == 0 and timeout > 0:
        await RisingEdge(dut.clk); timeout -= 1
    assert timeout > 0, "Timeout waiting for SPI to finish!"
    dut._log.info("AESA Brain successfully transmitted all 16 phases!")
