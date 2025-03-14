/*
NISHIHARU
JPEG HW Encorder
*/
`timescale 1ns / 1ps

module Huffman_ACenc_tb(
    input  wire             clock,
    input  wire             reset_n,
    input  wire [639:0]     ac_matrix,
    input  wire [7:0]       start_pix,  
    input  wire [7:0]       pre_start_pix,  
    output wire [15:0]      ac_out,
    output wire [7:0]       length,
    output wire [7:0]       code,
    output wire [7:0]       code_size,
    output wire [7:0]       next_pix,
    output wire [7:0]       run,
    output wire [9:0]       now_pix_data
);

    // VCD ダンプ用ブロック
    initial begin
        $dumpfile("./vcd/huffman_ac_tb.vcd");
        $dumpvars(1, Huffman_ACenc_tb);
        $dumpvars(1, mHuffman_ACenc);
    end

    // ---------------------------------------------------------------------
    // Huffman エンコード インスタンス
    // ---------------------------------------------------------------------

    // PIPE_LINE_STAGE = 4 と仮定
    Huffman_ACenc mHuffman_ACenc (
        .clk                (clock),
        .matrix             (ac_matrix),
        .start_pix          (start_pix),
        .pre_start_pix      (pre_start_pix),
        .is_luminance       (is_luminance),
        .out                ({ac_out, length, code, code_size, next_pix, run, now_pix_data})
    );

    // Debug
    wire  [9:0] ac_matrix0 = ac_matrix[9:0];
    wire  [9:0] ac_matrix1 = ac_matrix[19:10];

endmodule