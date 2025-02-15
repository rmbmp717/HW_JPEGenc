`timescale 1ns / 1ps

module HW_JPEGenc_top(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_enable,  
    input  wire [7:0]       Red,
    input  wire [7:0]       Green,
    input  wire [7:0]       Blue,
    input  wire             output_enable,  // 追加: 出力イネーブル信号
    input  wire             input_1pix_enable,  
    output wire [7:0]       pix_data [0:63] // 64個の16ビット入力：インデックス 0～63
);

    // VCD ダンプ用ブロック
    initial begin
        $dumpfile("./vcd/hw_jpeg_top.vcd");
        $dumpvars(0, HW_JPEGenc_top);
    end

    wire [7:0]      Y_data, Cb_data, Cr_data;

    // RGB -> YCbCr
    RGB_to_YCbCr mRGB_to_YCbCr(
        .clk           (clock),
        .r             (Red),
        .g             (Green),
        .b             (Blue),
        .out           ({{Y_data}, {Cb_data}, {Cr_data}})
    );

    // Y module
    HW_JPEGenc HW_JPEGenc_Y(
        .clock              (clock),
        .reset_n            (reset_n),
        .input_enable       (input_enable),
        .input_1pix_enable  (input_1pix_enable),  
        .pix_1pix_data      (Y_data), 
        .pix_data           (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance       (1'b1),
        .jpeg_out           (),
        .jpeg_data_bits     ()
    );

    // Cb, Cr module
    //HW_JPEGenc HW_JPEGenc_Cb(

    //HW_JPEGenc HW_JPEGenc_Cr(
    
endmodule
