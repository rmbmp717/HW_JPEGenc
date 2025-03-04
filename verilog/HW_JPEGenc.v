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
    input  wire             zigag_enable,
    input  wire [7:0]       matrix_row, 
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
    wire [80-1:0]           quantim_out;

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
    wire [3:0]  run;

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
    Quantize mQuantize (
        .clk                (clock),
        .dct_coeffs         (quantim_buffer),  
        .matrix_row         (matrix_row),  
        .is_luminance       (is_luminance),  
        .quantize_off       (1'b0),
        .out                (quantim_out)  
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
        .input_enable       (1'b0),
        .zigag_enable       (zigag_enable),
        .matrix_row         (matrix_row),  
        .row_data           (quantim_out),
        .input_data_enable  (zigzag_input_enable),
        .buffer             (),    
        .zigzag_pix_out     (pix_data_out)     // 最終 Zigzag 結果
    );

    // ---------------------------------------------------------------------
    // Huffman エンコード インスタンス
    // ---------------------------------------------------------------------
    wire [7:0]  start_pix;

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
        .is_luminance       (is_luminance),
        .out                ({ac_out, length, code, code_size, run})
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
        .dc_out             (dc_out),
        .dc_out_length      (dc_out_length),
        .dc_out_code_list   (dc_out_code_list),
        .dc_out_code_size   (dc_out_code_size),
        .ac_out             (ac_out),
        .length             (length),
        .code               (code),
        .code_size          (code_size),
        .run                (run),
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
