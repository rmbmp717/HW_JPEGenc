`timescale 1ns / 1ps
`define DEBUG

module HW_JPEGenc_top(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_1pix_enable,  
    input  wire [7:0]       Red,
    input  wire [7:0]       Green,
    input  wire [7:0]       Blue,
    // 設計段階での制御端子
    input  wire             input_enable,  
    output wire [7:0]       pix_data [0:63], // 64個の16ビット入力：インデックス 0～63
    input  wire             dct_enable,
    input  wire             dct_end_enable,
    input  wire             zigzag_input_enable,
    input  wire             zigag_enable,
    input  wire [7:0]       matrix_row, 
    input  wire             Huffman_start,
    // End
    output wire             jpeg_out_enable,  
    output wire [23:0]      jpeg_dc_out,
    output wire [15:0]      jpeg_out,        // 最終 JPEG 出力（8ビット）
    output wire [3:0]       jpeg_data_bits   // 最終 JPEG 出力のビット幅
    // JPEG Data 
);

    // VCD ダンプ用ブロック
    initial begin
        $dumpfile("./vcd/hw_jpeg_top.vcd");
        $dumpvars(0, HW_JPEGenc_top);
    end

    `ifdef DEBUG
    reg  [3:0]  main_state;
    reg  [7:0]  counter;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            main_state <= 0;
            counter   <= 0;
        end else begin
            if(input_enable) begin
                main_state <= 1;
                counter   <= 0;
            end else begin
                if(main_state==1) begin
                    counter   <= counter + 1;
                end
            end
        end
    end
    `endif

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
        .clock                  (clock),
        .reset_n                (reset_n),
        .input_enable           (input_enable),
        .input_1pix_enable      (input_1pix_enable),  
        .pix_1pix_data          (Y_data), 
        .dct_enable             (dct_enable),
        .dct_end_enable         (dct_end_enable),
        .zigzag_input_enable    (zigzag_input_enable),
        .zigag_enable           (zigag_enable),
        .matrix_row             (matrix_row),
        .Huffman_start          (Huffman_start),
        .pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b1),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_dc_out            (jpeg_dc_out),
        .jpeg_out               (jpeg_out),
        .jpeg_data_length       (jpeg_data_length)
    );

    // Cb, Cr module
    //HW_JPEGenc HW_JPEGenc_Cb(

    //HW_JPEGenc HW_JPEGenc_Cr(
    
endmodule
