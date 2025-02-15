`timescale 1ns / 1ps

module HW_JPEGenc(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_enable,    // 入力イネーブル信号
    input  wire             output_enable,   // 出力イネーブル信号
    input  wire [7:0]       pix_data [0:63], // 64個の8ビットピクセル（行優先）
    output wire [7:0]       jpeg_out,        // 最終 JPEG 出力（8ビット）
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
    wire [DATA_WIDTH-1:0] quantim_buffer [0:DEPTH-1];

    // Zigzag バッファ出力（最終出力）
    wire [512-1:0] pix_data_out;

    // to Huffman enc
    wire [512-1:0] dc_matrix;
    wire [512-1:0] ac_matrix;

    // Huffmann enc out
    wire [23:0] dc_out;
    wire [23:0] ac_out;

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
        .output_enable      (output_enable),
        .pix_data           (pix_data),   // 64個のピクセル
        .buffer             (buffer)
    );
    
    // ---------------------------------------------------------------------
    // DCT_2D モジュール インスタンス (2D DCT 処理)
    // ---------------------------------------------------------------------
    DCT_2D mDCT_2D (
        .clock          (clock),
        .reset_n        (reset_n),
        .pix_data       (pix_data),   // 入力ピクセル（[0:63]）
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
        .input_enable       (input_enable),
        .output_enable      (output_enable),
        .pix_data           (dct2d_out),       // DCT_2D の出力を接続
        .buffer             (quantim_buffer)
    );

    // ---------------------------------------------------------------------
    // Quantize モジュール インスタンス
    // ※ 各ポートの接続は、今後の設計に合わせて調整してください。
    // ---------------------------------------------------------------------
    Quantize mQuantize (
        .clk                (clock),
        .dct_coeffs         (),  // 未接続（後で Quantize 用 DCT係数を接続）
        .matrix_row         (),  // 未接続
        .is_luminance       (),  // 未接続
        .out                ()   // 未接続
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
        .input_enable       (input_enable),
        .output_enable      (output_enable),
        .pix_data           (quantim_buffer),  // Quantize 後のバッファ（仮接続）
        .buffer             (buffer),          // 既存の buffer 信号を再利用
        .zigzag_pix_out     (pix_data_out)     // 最終 Zigzag 結果
    );

    // ---------------------------------------------------------------------
    // Huffman エンコード インスタンス
    // ---------------------------------------------------------------------
    Huffman_DCenc mHuffman_DCenc (
        .clk                (clock),
        .matrix             (dc_matrix),
        .is_luminance       (is_luminance),
        .out                (dc_out)
    );

    Huffman_ACenc mHuffman_ACenc (
        .clk                (clock),
        .matrix             (ac_matrix),
        .is_luminance       (is_luminance),
        .out                (ac_out)
    );

    // Huffman エンコード コントローラは TBD
    Huffman_enc_controller mHuffman_enc_controller (
        .clock              (clock),
        .reset_n            (reset_n),
        .zigzag_pix_in      (pix_data_out),
        .is_luminance       (is_luminance),
        .dc_matrix          (dc_matrix),
        .ac_matrix          (ac_matrix),
        .dc_out             (dc_out),
        .ac_out             (ac_out),
        .jpeg_out           (jpeg_out),
        .jpeg_data_bits     (jpeg_data_bits)
    );

endmodule
