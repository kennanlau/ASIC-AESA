SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../src/spi_master.v
VERILOG_SOURCES += $(PWD)/../src/aesa_brain.v
VERILOG_SOURCES += $(PWD)/../src/tt_um_aesa_brain.v

TOPLEVEL = tt_um_aesa_brain
MODULE = test_tt_wrapper

include $(shell cocotb-config --makefiles)/Makefile.sim
