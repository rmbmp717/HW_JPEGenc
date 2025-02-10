# Variables
TOP = zigzag_reorder
#INPUT_FILE = ./src/rgb_ycbcr.x
#INPUT_FILE = ./src/JPEG_quantize.x
#INPUT_FILE = ./src/DCT_1D.x
#INPUT_FILE = ./src/DCT_2D.x
#INPUT_FILE = ./src/Zigzag_scan.x
INPUT_FILE = ./src/Huffman_enc.x
IR_FILE = ./ir_dir/$(TOP).ir
OPT_IR_FILE = ./ir_dir/$(TOP)_opt.ir
TOOL_DIR = /home/haruhiko/xls/bazel-bin
OUTPUT_FILE = ./verilog/zigzag_reorder.v

SIM = icarus
COCOTB_DIR = /home/haruhiko/Program/GoogleXLS_test-main/Crc32_Proc/cocotb

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
	--module_name=$(TOP) \
	--multi_proc \
	--pipeline_stages=1 \
	--delay_model=unit \
	--use_system_verilog=false \
	$(OPT_IR_FILE) > $(OUTPUT_FILE)