/*
NISHIHARU
JPEG HW Encorder
*/
`timescale 1ns / 1ps

module HW_JPEGenc(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_enable,  
    input  wire             input_1pix_enable,  
    input  wire [11:0]      pix_1pix_data,  // s12
    input  wire             dct_enable,
    input  wire             dct_end_enable,
    input  wire             zigzag_input_enable,
    input  wire             Huffman_start,
    input  wire [11:0]      pix_data [0:63], // 64個の12ビットピクセル（行優先）
    input  wire             is_luminance,
    // JPEG Output
    output wire             jpeg_out_enable,
    output wire [8:0]       jpeg_dc_out,
    output wire [7:0]       jpeg_dc_out_length,
    output wire [7:0]       jpeg_dc_code_list,
    output wire [7:0]       jpeg_dc_code_size,
    output wire [15:0]      huffman_code,           // 最終 JPEG 出力（16ビット）
    output wire [7:0]       huffman_code_length,    // 最終 JPEG 出力のビット幅
    output wire [7:0]       code_out,
    output wire [7:0]       code_size_out
);

    // パラメータ定義
    localparam DATA_WIDTH = 12;
    localparam DEPTH      = 64;
    
    // 内部信号の宣言
    // 入力データバッファ（databuffer_64x8bit の出力）
    wire [DATA_WIDTH-1:0] buffer [0:DEPTH-1];

    // 2D DCT の出力
    wire [11:0] dct2d_out [0:63];

    // Quantize 用のバッファ（DCT2D 出力を Quantize 用にバッファリング）
    wire [768-1:0]          quantim_buffer;
    wire [80-1:0]           quantized_out;

    // Zigzag バッファ出力（最終出力）
    wire [640-1:0] pix_data_out;

    // to Huffman enc
    wire [640-1:0] dc_matrix;
    wire [640-1:0] ac_matrix;

    // Huffmann enc out
    wire [8:0]  dc_out;             // 9 bits
    wire [7:0]  dc_out_length;
    wire [7:0]  dc_out_code_list;
    wire [7:0]  dc_out_code_size;
    wire [15:0] ac_out;
    wire [7:0]  length;
    wire [7:0]  code;
    wire [7:0]  code_size;
    wire [7:0]  next_pix;

    // ---------------------------------------------------------------------
    // databuffer_64x120bit インスタンス (入力データのバッファ)
    // ---------------------------------------------------------------------
    databuffer_64x12bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m0_databuffer_64x12bit (
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (input_enable),
        .input_1pix_enable  (input_1pix_enable),
        .pix_1pix_data      (pix_1pix_data),     
        .pix_data           (pix_data),   // 64個のピクセル 一括書き込み用
        .buffer             (buffer),
        .buffer_768bits     ()
    );
    
    // ---------------------------------------------------------------------
    // DCT_2D モジュール インスタンス (2D DCT 処理)
    // ---------------------------------------------------------------------
    DCT_2D mDCT_2D (
        .clock          (clock),
        .reset_n        (reset_n),
        .dct_enable     (dct_enable),   
        .pix_data       (buffer),   // 入力ピクセル（[0:63]）
        .out            (dct2d_out)   // 2D DCT 結果
    );

    // ---------------------------------------------------------------------
    // databuffer_64x12bit インスタンス (DCT2D 結果のバッファ)
    // ---------------------------------------------------------------------
    databuffer_64x12bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m1_databuffer_64x12bit (
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (dct_end_enable),
        .input_1pix_enable  (1'b0),
        .pix_1pix_data      (12'd0),     
        .pix_data           (dct2d_out),       // DCT_2D の出力を接続
        .buffer             (),
        .buffer_768bits     (quantim_buffer)
    );

    // ---------------------------------------------------------------------
    // Quantize モジュール インスタンス
    // ※ 各ポートの接続は、今後の設計に合わせて調整してください。
    // ---------------------------------------------------------------------
    wire  [7:0]      matrix_row;
    wire  [7:0]      quality;
    wire  [95:0]     dct_coeffs0, dct_coeffs1, dct_coeffs2, dct_coeffs3;
    wire  [95:0]     dct_coeffs4, dct_coeffs5, dct_coeffs6, dct_coeffs7;

    assign dct_coeffs0 = quantim_buffer[96*1-1: 96*0];
    assign dct_coeffs1 = quantim_buffer[96*2-1: 96*1];
    assign dct_coeffs2 = quantim_buffer[96*3-1: 96*2];
    assign dct_coeffs3 = quantim_buffer[96*4-1: 96*3];
    assign dct_coeffs4 = quantim_buffer[96*5-1: 96*4];
    assign dct_coeffs5 = quantim_buffer[96*6-1: 96*5];
    assign dct_coeffs6 = quantim_buffer[96*7-1: 96*6];
    assign dct_coeffs7 = quantim_buffer[96*8-1: 96*7];

    Quantize_rapper mQuantize_rapper(
        .clock              (clock),
        .reset_n            (reset_n),
        .matrix_row         (matrix_row),  
        .is_luminance       (is_luminance),  
        .quantize_off       (1'b0),
        .dct_coeffs0        (dct_coeffs0),
        .dct_coeffs1        (dct_coeffs1),
        .dct_coeffs2        (dct_coeffs2),
        .dct_coeffs3        (dct_coeffs3),
        .dct_coeffs4        (dct_coeffs4),
        .dct_coeffs5        (dct_coeffs5),
        .dct_coeffs6        (dct_coeffs6),
        .dct_coeffs7        (dct_coeffs7),
        // output 
        .quantized_out      (quantized_out),
        .quality            (quality)
);

    // ---------------------------------------------------------------------
    // databuffer_zigzag64x10bit インスタンス (Zigzag スキャン)
    // ---------------------------------------------------------------------
    databuffer_zigzag64x10bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m_databuffer_zigzag64x10bit (
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (zigzag_input_enable),
        .row_data           (quantized_out),
        .input_data_enable  (1'b0),
        .matrix_row         (matrix_row),
        .buffer             (),    
        .zigzag_pix_out     (pix_data_out)     // 最終 Zigzag 結果
    );

    // ---------------------------------------------------------------------
    // Huffman エンコード インスタンス
    // ---------------------------------------------------------------------
    wire [7:0]  start_pix;
    wire [7:0]  pre_start_pix;
    wire [7:0]  run;
    wire [9:0]  now_pix_data;

    // PIPE_LINE_STAGE = 1 と仮定
    Huffman_DCenc mHuffman_DCenc (
        .clk                (clock),
        .matrix             (dc_matrix),
        .is_luminance       (is_luminance),
        .out                ({dc_out, dc_out_length, dc_out_code_list, dc_out_code_size})
    );

    // PIPE_LINE_STAGE = 4 と仮定
    Huffman_ACenc mHuffman_ACenc (
        .clk                (clock),
        .matrix             (ac_matrix),
        .start_pix          (start_pix),
        .pre_start_pix      (pre_start_pix),
        .is_luminance       (is_luminance),
        .out                ({ac_out, length, code, code_size, next_pix, run, now_pix_data})
    );

    // Huffman エンコード コントローラ
    Huffman_enc_controller mHuffman_enc_controller (
        .clock              (clock),
        .reset_n            (reset_n),
        .is_luminance       (is_luminance),
        .Huffman_start      (Huffman_start),
        .zigzag_pix_in      (pix_data_out),
        .dc_matrix          (dc_matrix),
        .ac_matrix          (ac_matrix),
        .start_pix          (start_pix),
        .pre_start_pix      (pre_start_pix),
        .dc_out             (dc_out),
        .dc_out_length      (dc_out_length),
        .dc_out_code_list   (dc_out_code_list),
        .dc_out_code_size   (dc_out_code_size),
        .ac_out             (ac_out),
        .length             (length),
        .code               (code),
        .code_size          (code_size),
        .now_pix_data       (now_pix_data),
        .next_pix           (next_pix),
        // JPEG Code Output
        .Huffmanenc_active      (),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_out_end           (),
        .jpeg_dc_out            (jpeg_dc_out),
        .jpeg_dc_out_length     (jpeg_dc_out_length),
        .jpeg_dc_code_list      (jpeg_dc_code_list),
        .jpeg_dc_code_size      (jpeg_dc_code_size),
        .huffman_code           (huffman_code),
        .huffman_code_length    (huffman_code_length),
        .code_out               (code_out),
        .code_size_out          (code_size_out)
    );

endmodule
