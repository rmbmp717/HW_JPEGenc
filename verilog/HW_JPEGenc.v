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
    input  wire [7:0]       pix_1pix_data, 
    input  wire             dct_enable,
    input  wire             dct_end_enable,
    input  wire             zigzag_input_enable,
    input  wire             zigag_enable,
    input  wire [7:0]       matrix_row, 
    input  wire             Huffman_start,
    input  wire [7:0]       pix_data [0:63], // 64個の8ビットピクセル（行優先）
    input  wire             is_luminance,
    output wire [15:0]      jpeg_out,        // 最終 JPEG 出力（8ビット）
    output wire [3:0]       jpeg_data_bits   // 最終 JPEG 出力のビット幅
);

    // パラメータ定義
    localparam DATA_WIDTH = 8;
    localparam DEPTH      = 64;
    
    // 内部信号の宣言
    // 入力データバッファ（databuffer_64x8bit の出力）
    wire [DATA_WIDTH-1:0] buffer [0:DEPTH-1];

    // 2D DCT の出力
    wire [7:0] dct2d_out [0:63];

    // Quantize 用のバッファ（DCT2D 出力を Quantize 用にバッファリング）
    wire [512-1:0]          quantim_buffer;
    wire [64-1:0]           quantim_out;

    // Zigzag バッファ出力（最終出力）
    wire [512-1:0] pix_data_out;

    // to Huffman enc
    wire [512-1:0] dc_matrix;
    wire [512-1:0] ac_matrix;

    // Huffmann enc out
    wire [23:0] dc_out;
    wire [15:0] ac_out;

    // ---------------------------------------------------------------------
    // databuffer_64x8bit インスタンス (入力データのバッファ)
    // ---------------------------------------------------------------------
    databuffer_64x8bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m0_databuffer_64x8bit (
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (input_enable),
        .input_1pix_enable  (input_1pix_enable),
        .pix_1pix_data      (pix_1pix_data),     
        .pix_data           (pix_data),   // 64個のピクセル
        .buffer             (buffer),
        .buffer_512bits     ()
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
    // databuffer_64x8bit インスタンス (DCT2D 結果のバッファ)
    // ---------------------------------------------------------------------
    databuffer_64x8bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m1_databuffer_64x8bit (
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (dct_end_enable),
        .input_1pix_enable  (1'b0),
        .pix_1pix_data      (8'd0),     
        .pix_data           (dct2d_out),       // DCT_2D の出力を接続
        .buffer             (),
        .buffer_512bits     (quantim_buffer)
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
    // databuffer_zigzag64x8bit インスタンス (Zigzag スキャン)
    // ---------------------------------------------------------------------
    databuffer_zigzag64x8bit #(
        .DATA_WIDTH         (DATA_WIDTH),
        .DEPTH              (DEPTH)
    ) m_databuffer_zigzag64x8bit (
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
    wire [7:0]  length;
    wire [7:0]  code;
    wire [3:0]  run;

    Huffman_DCenc mHuffman_DCenc (
        .clk                (clock),
        .matrix             (dc_matrix),
        .is_luminance       (is_luminance),
        .out                (dc_out)
    );

    Huffman_ACenc mHuffman_ACenc (
        .clk                (clock),
        .matrix             (ac_matrix),
        .start_pix          (start_pix),
        .is_luminance       (is_luminance),
        .out                ({ac_out, length, code, run})
    );

    // Huffman エンコード コントローラ
    Huffman_enc_controller mHuffman_enc_controller (
        .clock              (clock),
        .reset_n            (reset_n),
        .Huffman_start      (Huffman_start),
        .zigzag_pix_in      (pix_data_out),
        .dc_matrix          (dc_matrix),
        .ac_matrix          (ac_matrix),
        .start_pix          (start_pix),
        .dc_out             (dc_out),
        .ac_out             (ac_out),
        .length             (length),
        .code               (code),
        .run                (run),
        // JPEG Code Output
        .jpeg_out_enable    (),
        .jpeg_out           (jpeg_out),
        .jpeg_data_bits     (jpeg_data_bits)
    );

endmodule
