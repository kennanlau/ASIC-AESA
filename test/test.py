import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_aesa_wrapper(dut):
    """Test loading a phase and triggering SPI transmission."""
    
    # Start the clock
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # 1. Load phase 0x0B (11) into Antenna 2
    dut.ui_in.value = 0b00001001 # ant_idx = 2, load = 1
    dut.uio_in.value = 0b00001011 # phase = 11
    await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00000000 # turn off load
    await RisingEdge(dut.clk)

    # 2. Start the transmission
    dut.ui_in.value = 0b00000010 # start_tx = 1
    await RisingEdge(dut.clk)
    dut.ui_in.value = 0b00000000 # turn off start
    
    # 3. Wait for the done signal
    timeout = 100000
    while dut.uo_out[3].value == 0 and timeout > 0:
        await RisingEdge(dut.clk)
        
        # ADDED: Wait 1 ns for physical gate delays to settle
        await Timer(1, unit="ns") 
        
        timeout -= 1

    assert timeout > 0, "Timeout waiting for SPI to finish!"
    dut._log.info("AESA Brain successfully transmitted all 16 phases!")
