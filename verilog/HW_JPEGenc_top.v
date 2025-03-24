/*
NISHIHARU
HW JPEC encorder
*/

`timescale 1ns / 1ps
//`define DUMP_VCD

module HW_JPEGenc_top(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_1pix_enable,  
    input  wire [7:0]       Red,
    input  wire [7:0]       Green,
    input  wire [7:0]       Blue,
    // 設計段階での制御端子
    input  wire             input_enable,  
    //output wire [7:0]       pix_data [0:63], // 64個の16ビット入力：インデックス 0～63
    input  wire             dct_enable,
    input  wire             dct_end_enable,
    input  wire             zigzag_input_enable,
    input  wire             Huffman_start,
    // JPEG encoded Data 
    // Y
    output wire             jpeg_out_enable,  
    output wire [8:0]       jpeg_dc_out,          // 最終 JPEG 出力 DC
    output reg  [7:0]       jpeg_dc_out_length,   // 最終 JPEG 出力 DC
    output reg  [7:0]       jpeg_dc_code_list,    // 最終 JPEG 出力 DC
    output reg  [7:0]       jpeg_dc_code_size,
    output wire [15:0]      huffman_code,         // 最終 JPEG 出力（16ビット）
    output wire [7:0]       huffman_code_length,  // 最終 JPEG 出力のビット幅
    output wire [7:0]       code_out,             // 最終 JPEG 出力 CODE
    output wire [7:0]       code_size_out,        // 最終 JPEG 出力 CODE
    // Cb
    output wire             Cb_jpeg_out_enable,  
    output wire [8:0]       Cb_jpeg_dc_out,          // 最終 JPEG 出力 DC
    output reg  [7:0]       Cb_jpeg_dc_out_length,   // 最終 JPEG 出力 DC
    output reg  [7:0]       Cb_jpeg_dc_code_list,    // 最終 JPEG 出力 DC
    output reg  [7:0]       Cb_jpeg_dc_code_size,
    output wire [15:0]      Cb_huffman_code,         // 最終 JPEG 出力（16ビット）
    output wire [7:0]       Cb_huffman_code_length,  // 最終 JPEG 出力のビット幅
    output wire [7:0]       Cb_code_out,             // 最終 JPEG 出力 CODE
    output wire [7:0]       Cb_code_size_out,        // 最終 JPEG 出力 CODE
    // Cr
    output wire             Cr_jpeg_out_enable, 
    output wire [8:0]       Cr_jpeg_dc_out,           // 最終 JPEG 出力 DC
    output reg  [7:0]       Cr_jpeg_dc_out_length,   // 最終 JPEG 出力 DC
    output reg  [7:0]       Cr_jpeg_dc_code_list,    // 最終 JPEG 出力 DC
    output reg  [7:0]       Cr_jpeg_dc_code_size,
    output wire [15:0]      Cr_huffman_code,         // 最終 JPEG 出力（16ビット）
    output wire [7:0]       Cr_huffman_code_length,  // 最終 JPEG 出力のビット幅
    output wire [7:0]       Cr_code_out,             // 最終 JPEG 出力 CODE
    output wire [7:0]       Cr_code_size_out         // 最終 JPEG 出力 CODE
);

    // VCD ダンプ用ブロック
    `ifdef DUMP_VCD
    initial begin
        $dumpfile("./vcd/hw_jpeg_top.vcd");
        $dumpvars(0, HW_JPEGenc_top);
    end
    `endif

    // RGB -> YCbCr 変換
    wire [11:0]  Y_data, Cb_data, Cr_data;   // s12

    RGB_to_YCbCr mRGB_to_YCbCr(
        .clk           (clock),
        .r             (Red),
        .g             (Green),
        .b             (Blue),
        .out           ({{Y_data}, {Cb_data}, {Cr_data}})
    );

    // Y JPEGenc module
    HW_JPEGenc HW_JPEGenc_Y(
        .clock                  (clock),
        .reset_n                (reset_n),
        .input_enable           (input_enable),
        .input_1pix_enable      (input_1pix_enable),  
        .pix_1pix_data          (Y_data), 
        //.pix_1pix_data          (pix_1pix_data), 
        .dct_enable             (dct_enable),
        .dct_end_enable         (dct_end_enable),
        .zigzag_input_enable    (zigzag_input_enable),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b1),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_dc_out            (jpeg_dc_out),
        .jpeg_dc_out_length     (jpeg_dc_out_length),
        .jpeg_dc_code_size      (jpeg_dc_code_size),
        .huffman_code           (huffman_code),
        .huffman_code_length    (huffman_code_length),
        .code_out               (code_out),
        .code_size_out          (code_size_out)
    );

    // Cb JPEGenc module
    HW_JPEGenc HW_JPEGenc_Cb(
        .clock                  (clock),
        .reset_n                (reset_n),
        .input_enable           (input_enable),
        .input_1pix_enable      (input_1pix_enable),  
        .pix_1pix_data          (Cb_data), 
        //.pix_1pix_data          (pix_1pix_data), 
        .dct_enable             (dct_enable),
        .dct_end_enable         (dct_end_enable),
        .zigzag_input_enable    (zigzag_input_enable),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b0),
        .jpeg_out_enable        (Cb_jpeg_out_enable),
        .jpeg_dc_out            (Cb_jpeg_dc_out),
        .jpeg_dc_out_length     (Cb_jpeg_dc_out_length),
        .jpeg_dc_code_size      (Cb_jpeg_dc_code_size),
        .huffman_code           (Cb_huffman_code),
        .huffman_code_length    (Cb_huffman_code_length),
        .code_out               (Cb_code_out),
        .code_size_out          (Cb_code_size_out)
    );

    // Cr JPEGenc module
    HW_JPEGenc HW_JPEGenc_Cr(
        .clock                  (clock),
        .reset_n                (reset_n),
        .input_enable           (input_enable),
        .input_1pix_enable      (input_1pix_enable),  
        .pix_1pix_data          (Cr_data), 
        //.pix_1pix_data          (pix_1pix_data), 
        .dct_enable             (dct_enable),
        .dct_end_enable         (dct_end_enable),
        .zigzag_input_enable    (zigzag_input_enable),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b0),
        .jpeg_out_enable        (Cr_jpeg_out_enable),
        .jpeg_dc_out            (Cr_jpeg_dc_out),
        .jpeg_dc_out_length     (Cr_jpeg_dc_out_length),
        .jpeg_dc_code_size      (Cr_jpeg_dc_code_size),
        .huffman_code           (Cr_huffman_code),
        .huffman_code_length    (Cr_huffman_code_length),
        .code_out               (Cr_code_out),
        .code_size_out          (Cr_code_size_out)
    );
    
endmodule
