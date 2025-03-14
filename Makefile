#================================================================
# JPEG HW Encoder Test - Makefile
#================================================================

# Top-level module & source settings
#TOP              := dct_2d_s12
#TOP              := dct_1d_s12
#TOP              := Huffman_DCenc
#TOP              := Huffman_ACenc
TOP              := Quantize
#TOP		  	  := Data_flip64

#INPUT_FILE 	:= ./src/Huffman_DCenc.x # PIPE_LINE_STAGE = 1
#INPUT_FILE     := ./src/Huffman_ACenc.x   # PIPE_LINE_STAGE = 4
#INPUT_FILE 	:= ./src/RGB_YCbCr.x
INPUT_FILE 	:= ./src/Quantize.x			# PIPE_LINE_STAGE = 2
#INPUT_FILE 	:= ./src/DCT_1D.x		# PIPE_LINE_STAGE = 3
#INPUT_FILE 	:= ./src/DCT_2D.x
#INPUT_FILE 	:= ./src/Zigzag_scan.x
#INPUT_FILE 	:= ./src/Data_flip64.x

IR_DIR           := ./ir_dir
IR_FILE          := $(IR_DIR)/$(TOP).ir
OPT_IR_FILE      := $(IR_DIR)/$(TOP)_opt.ir
OUTPUT_FILE      := ./verilog/$(TOP).v

PIPE_LINE_STAGE  := 2
SIM              := icarus
COCOTB_DIR       := /home/haruhiko/Program/GoogleXLS_test-main/Crc32_Proc/cocotb

# Tool paths
TOOL_DIR         := /home/haruhiko/xls/bazel-bin
INTERPRETER      := $(TOOL_DIR)/xls/dslx/interpreter_main
IR_CONVERTER     := $(TOOL_DIR)/xls/dslx/ir_convert/ir_converter_main
OPT_MAIN         := $(TOOL_DIR)/xls/tools/opt_main
CODEGEN_MAIN     := $(TOOL_DIR)/xls/tools/codegen_main

# Verilog source files
VERILOG_DIR      := ./verilog
VERILOG_FILES    := $(VERILOG_DIR)/HW_JPEGenc_top.v \
                    $(VERILOG_DIR)/RGB_to_YCbCr.v \
                    $(VERILOG_DIR)/HW_JPEGenc.v \
                    $(VERILOG_DIR)/databuffer_64x12bit.v \
                    $(VERILOG_DIR)/DCT_2D.v \
                    $(VERILOG_DIR)/dct_1d_s12.v \
                    $(VERILOG_DIR)/databuffer_zigzag64x10bit.v \
                    $(VERILOG_DIR)/Zigzag_reorder.v \
                    $(VERILOG_DIR)/Quantize_rapper.v \
                    $(VERILOG_DIR)/Quantize.v \
                    $(VERILOG_DIR)/Data_flip64.v \
                    $(VERILOG_DIR)/Huffman_DCenc.v \
                    $(VERILOG_DIR)/Huffman_ACenc.v \
                    $(VERILOG_DIR)/Huffman_enc_controller.v

#COCOTB_FILE      := cocotb_sim.main_JPEGenc_top
COCOTB_FILE      := cocotb_sim.main_BMP_to_JPEG_top

# Phony targets
.PHONY: all interpret ir_convert optimize codegen simulate activate gowin_copy

#----------------------------------------------------------------
# Default target
#----------------------------------------------------------------
all: codegen

#----------------------------------------------------------------
# DSLX processing targets
#----------------------------------------------------------------
interpret:
	$(INTERPRETER) --alsologtostderr $(INPUT_FILE)

ir_convert: interpret
	$(IR_CONVERTER) --top=$(TOP) $(INPUT_FILE) > $(IR_FILE)

optimize: ir_convert
	$(OPT_MAIN) $(IR_FILE) > $(OPT_IR_FILE)

codegen: optimize
	$(CODEGEN_MAIN) \
	  --generator=pipeline \
	  --module_name=$(TOP) \
	  --pipeline_stages=$(PIPE_LINE_STAGE) \
	  --delay_model=unit \
	  --use_system_verilog=false \
	  $(OPT_IR_FILE) > $(OUTPUT_FILE)

#----------------------------------------------------------------
# Cocotb simulation target
#----------------------------------------------------------------
simulate:
	iverilog -o sim.vvp -D COCOTB_SIM=1 -g2012 $(VERILOG_FILES)
	MODULE=$(COCOTB_FILE) TOPLEVEL=HW_JPEGenc_top TOPLEVEL_LANG=verilog \
	  SIM=$(SIM) PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])") \
	  vvp -M $$(cocotb-config --lib-dir) -m libcocotbvpi_icarus sim.vvp

#----------------------------------------------------------------
# Huffman AC test
AC_TEST_COCOTB_FILE		:= cocotb_sim.Huffman_ac_test
AC_VERILOG_FILES		:= $(VERILOG_DIR)/Huffman_ACenc_tb.v $(VERILOG_DIR)/Huffman_ACenc.v

huffman_ac_simulate:
	iverilog -o sim.vvp -D COCOTB_SIM=1 -g2012 $(AC_VERILOG_FILES)
	MODULE=$(AC_TEST_COCOTB_FILE) TOPLEVEL=Huffman_ACenc_tb TOPLEVEL_LANG=verilog \
	  SIM=$(SIM) PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])") \
	  vvp -M $$(cocotb-config --lib-dir) -m libcocotbvpi_icarus sim.vvp

#----------------------------------------------------------------
# Quantize test
QUANTIZE_TEST_COCOTB_FILE	:= cocotb_sim.quantize_test
QUANTIZE_VERILOG_FILES		:= $(VERILOG_DIR)/Quantize_rapper.v $(VERILOG_DIR)/Quantize.v

quantize_simulate:
	iverilog -o sim.vvp -D COCOTB_SIM=1 -g2012 $(QUANTIZE_VERILOG_FILES)
	MODULE=$(QUANTIZE_TEST_COCOTB_FILE) TOPLEVEL=Quantize_rapper TOPLEVEL_LANG=verilog \
	  SIM=$(SIM) PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])") \
	  vvp -M $$(cocotb-config --lib-dir) -m libcocotbvpi_icarus sim.vvp

#----------------------------------------------------------------
# Python 仮想環境作成用ターゲット
#----------------------------------------------------------------
activate:
	@echo "Run: python3 -m venv myenv"
	@echo "Run: source ./myenv/bin/activate"

#----------------------------------------------------------------
# Gowin EDA 用ファイルコピーターゲット
#----------------------------------------------------------------
gowin_copy:
	@cp $(VERILOG_FILES) /home/haruhiko/gowin/IDE/bin/HW_JPEGenc/src/
