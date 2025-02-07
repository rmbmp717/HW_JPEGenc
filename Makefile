# Variables
TOP = rgb_to_ycbcr
INPUT_FILE = ./src/rgb_ycbcr.x
IR_FILE = $(TOP).ir
OPT_IR_FILE = $(TOP)_opt.ir
TOOL_DIR = /home/haruhiko/xls/bazel-bin
OUTPUT_FILE = rgb_ycbcr.v

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
	--pipeline_stages=36 \
	--delay_model=unit \
	--use_system_verilog=false \
	$(OPT_IR_FILE) > $(OUTPUT_FILE)