`timescale 1ns / 1ps

module HW_JPEGenc(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_enable,   // 追加: 入力イネーブル信号
    input  wire             output_enable,  // 追加: 出力イネーブル信号
    input  wire [7:0]       pix_data [0:63] // 64個の16ビット入力：インデックス 0～63
);

    localparam DATA_WIDTH = 8;
    localparam DEPTH      = 64;
    
    // 配列宣言：インデックスは 0 から DEPTH-1 まで統一
    wire [DATA_WIDTH-1:0] buffer      [0:DEPTH-1];
    wire [DATA_WIDTH-1:0] pix_data_out[0:DEPTH-1];

    // databuffer_64x8bit のインスタンス化
    databuffer_64x8bit #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) mdatabuffer_64x8bit (
        .clock         (clock),
        .reset_n       (reset_n),
        .input_enable  (input_enable),
        .output_enable (output_enable),
        .pix_data      (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .buffer        (buffer),
        .pix_data_out  (pix_data_out)
    );

    // DCT 1D
    dct_1d_u8 mdct_1d_u8(
        .clk           (clock),
        .x             (),
        .out           ()
    );

    // databuffer_zigzag64x8bit のインスタンス化
    databuffer_zigzag64x8bit #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) mdatabuffer_zigzag64x8bit (
        .clock         (clock),
        .reset_n       (reset_n),
        .input_enable  (input_enable),
        .output_enable (output_enable),
        .pix_data      (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .buffer        (buffer),
        .pix_data_out  (pix_data_out)
    );
    
endmodule

