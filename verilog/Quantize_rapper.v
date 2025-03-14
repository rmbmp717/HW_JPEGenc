/*
NISHIHARU
*/
`timescale 1ns / 1ps

module Quantize_rapper(
    input  wire             clock,
    input  wire             reset_n,
    input  wire [7:0]       matrix_row,
    input  wire             is_luminance,
    input  wire             quantize_off,
    input  wire [12*8-1:0]  dct_coeffs0,
    input  wire [12*8-1:0]  dct_coeffs1,
    input  wire [12*8-1:0]  dct_coeffs2,
    input  wire [12*8-1:0]  dct_coeffs3,
    input  wire [12*8-1:0]  dct_coeffs4,
    input  wire [12*8-1:0]  dct_coeffs5,
    input  wire [12*8-1:0]  dct_coeffs6,
    input  wire [12*8-1:0]  dct_coeffs7,
    /*
    input  wire [11:0]      quantim_input_0,
    input  wire [11:0]      quantim_input_1,
    input  wire [11:0]      quantim_input_2,
    input  wire [11:0]      quantim_input_3,
    input  wire [11:0]      quantim_input_4,
    input  wire [11:0]      quantim_input_5,
    input  wire [11:0]      quantim_input_6,
    input  wire [11:0]      quantim_input_7,
    */
    output wire [79:0]      quantized_out,
    output wire [7:0]       quality
);
/*
    // VCD ダンプ用ブロック
    initial begin
        $dumpfile("./vcd/Quantize_tb.vcd");
        $dumpvars(1, Quantize_rapper);
        $dumpvars(1, mQuantize);
    end
*/
    // ---------------------------------------------------------------------
    // Quantize モジュール インスタンス
    // ※ 各ポートの接続は、今後の設計に合わせて調整してください。
    // ---------------------------------------------------------------------

    Quantize mQuantize (
        .clk                (clock),
        .dct_coeffs         ({dct_coeffs7, dct_coeffs6, dct_coeffs5, dct_coeffs4, dct_coeffs3, dct_coeffs2, dct_coeffs1, dct_coeffs0}),  
        .matrix_row         (matrix_row),  
        .is_luminance       (is_luminance),  
        .quantize_off       (quantize_off),
        .out                ({quality, quantized_out})  
    );

    wire [11:0]   input_data_0  = dct_coeffs0[11:0];
    wire [11:0]   input_data_1  = dct_coeffs0[23:12];
    wire [11:0]   input_data_2  = dct_coeffs0[35:24];
    wire [11:0]   input_data_3  = dct_coeffs0[47:36];
    wire [11:0]   input_data_4  = dct_coeffs0[59:48];
    wire [11:0]   input_data_5  = dct_coeffs0[71:60];
    wire [11:0]   input_data_6  = dct_coeffs0[83:72];
    wire [11:0]   input_data_7  = dct_coeffs0[95:84];


    wire [11:0]   input_data_56  = dct_coeffs7[11:0];
    wire [11:0]   input_data_57  = dct_coeffs7[23:12];
    wire [11:0]   input_data_58  = dct_coeffs7[35:24];
    wire [11:0]   input_data_59  = dct_coeffs7[47:36];
    wire [11:0]   input_data_60  = dct_coeffs7[59:48];
    wire [11:0]   input_data_61  = dct_coeffs7[71:60];
    wire [11:0]   input_data_62  = dct_coeffs7[83:72];
    wire [11:0]   input_data_63  = dct_coeffs7[95:84];

    wire  [9:0]   output_data_0 = quantized_out[9:0];
    wire  [9:0]   output_data_1 = quantized_out[19:10];
    wire  [9:0]   output_data_2 = quantized_out[29:20];
    wire  [9:0]   output_data_3 = quantized_out[39:30];
    wire  [9:0]   output_data_4 = quantized_out[49:40];
    wire  [9:0]   output_data_5 = quantized_out[59:50];
    wire  [9:0]   output_data_6 = quantized_out[69:60];
    wire  [9:0]   output_data_7 = quantized_out[79:70];

endmodule