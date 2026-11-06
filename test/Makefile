SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../src/spi_master.v
VERILOG_SOURCES += $(PWD)/../src/aesa_brain.v
VERILOG_SOURCES += $(PWD)/../src/tt_um_aesa_brain.v

TOPLEVEL = tt_um_aesa_brain
COCOTB_TEST_MODULES = test

include $(shell cocotb-config --makefiles)/Makefile.sim
