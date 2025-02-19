# Variables
TOP = Huffman_ACenc
#INPUT_FILE = ./src/RGB_YCbCr.x
#INPUT_FILE = ./src/Quantize.x
#INPUT_FILE = ./src/DCT_1D.x		# PIPE_LINE_STAGE = 3
#INPUT_FILE = ./src/DCT_2D.x
#INPUT_FILE = ./src/Zigzag_scan.x
INPUT_FILE = ./src/Huffman_ACenc.x # PIPE_LINE_STAGE = 3
#INPUT_FILE = ./src/Huffman_DCenc.x # PIPE_LINE_STAGE = 1
IR_FILE = ./ir_dir/$(TOP).ir
OPT_IR_FILE = ./ir_dir/$(TOP)_opt.ir
TOOL_DIR = /home/haruhiko/xls/bazel-bin
OUTPUT_FILE = ./verilog/$(TOP).v

PIPE_LINE_STAGE = 4

SIM = icarus
COCOTB_DIR = /home/haruhiko/Program/GoogleXLS_test-main/Crc32_Proc/cocotb

VERILOG_DIR = ./verilog
VERILOG_FILE = $(VERILOG_DIR)/HW_JPEGenc_top.v
VERILOG_FILE += $(VERILOG_DIR)/RGB_to_YCbCr.v
VERILOG_FILE += $(VERILOG_DIR)/HW_JPEGenc.v
VERILOG_FILE += $(VERILOG_DIR)/databuffer_64x8bit.v
VERILOG_FILE += $(VERILOG_DIR)/DCT_2D.v
VERILOG_FILE += $(VERILOG_DIR)/dct_1d_u8.v
VERILOG_FILE += $(VERILOG_DIR)/databuffer_zigzag64x8bit.v
VERILOG_FILE += $(VERILOG_DIR)/Zigzag_reorder.v
VERILOG_FILE += $(VERILOG_DIR)/Quantize.v
VERILOG_FILE += $(VERILOG_DIR)/Huffman_DCenc.v
VERILOG_FILE += $(VERILOG_DIR)/Huffman_ACenc.v
VERILOG_FILE += $(VERILOG_DIR)/Huffman_enc_controller.v

COCOTB_FILE = cocotb_sim.test1_JPEGenc_top

# Tools
INTERPRETER = $(TOOL_DIR)/xls/dslx/interpreter_main
IR_CONVERTER = $(TOOL_DIR)/xls/dslx/ir_convert/ir_converter_main
OPT_MAIN = $(TOOL_DIR)/xls/tools/opt_main
CODEGEN_MAIN = $(TOOL_DIR)/xls/tools/codegen_main

# Default target
all: codegen

# Targets with dependencies
interpret:
	$(INTERPRETER) --alsologtostderr $(INPUT_FILE)

ir_convert: interpret
	$(IR_CONVERTER) --top=$(TOP) $(INPUT_FILE) > $(IR_FILE)

optimize: ir_convert
	$(OPT_MAIN) \
	$(IR_FILE) > $(OPT_IR_FILE)

codegen: optimize
	$(CODEGEN_MAIN) \
  	--generator=pipeline \
	--module_name=$(TOP) \
	--pipeline_stages=$(PIPE_LINE_STAGE) \
	--delay_model=unit \
	--use_system_verilog=false \
	$(OPT_IR_FILE) > $(OUTPUT_FILE)

# Cocotb simulation
simulate: 
	iverilog -o sim.vvp -D COCOTB_SIM=1 -g2012 $(VERILOG_FILE)
	MODULE=$(COCOTB_FILE) TOPLEVEL=HW_JPEGenc_top TOPLEVEL_LANG=verilog \
	SIM=$(SIM) PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])") vvp -M $$(cocotb-config --lib-dir) \
		-m libcocotbvpi_icarus sim.vvp

# Python activate
activate:
	@echo "Run: python3 -m venv myenv"
	@echo "Run: source ./myenv/bin/activate"

# Copy to Gowin EDA Folder
gowin_copy:
	@cp $(VERILOG_FILE) /home/haruhiko/gowin/IDE/bin/HW_JPEGenc/src/