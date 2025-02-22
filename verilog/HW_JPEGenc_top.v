`timescale 1ns / 1ps
`define DEBUG

module HW_JPEGenc_top(
    input  wire             clock,
    input  wire             reset_n,
    input  wire             input_1pix_enable,  
    input  wire [9:0]       pix_1pix_data,      // s10
    input  wire [7:0]       Red,
    input  wire [7:0]       Green,
    input  wire [7:0]       Blue,
    // 設計段階での制御端子
    input  wire             input_enable,  
    //output wire [7:0]       pix_data [0:63], // 64個の16ビット入力：インデックス 0～63
    input  wire             dct_enable,
    input  wire             dct_end_enable,
    input  wire             zigzag_input_enable,
    input  wire             zigag_enable,
    input  wire [7:0]       matrix_row, 
    input  wire             Huffman_start,
    // JPEG Data 
    output wire             jpeg_out_enable,  
    output wire [7:0]       jpeg_dc_out,          // 最終 JPEG 出力 DC
    output reg  [7:0]       jpeg_dc_out_length,   // 最終 JPEG 出力 DC
    output reg  [7:0]       jpeg_dc_code_list,    // 最終 JPEG 出力 DC
    output wire [15:0]      huffman_code,         // 最終 JPEG 出力（16ビット）
    output wire [7:0]       huffman_code_length,  // 最終 JPEG 出力のビット幅
    output wire [7:0]       code_out              // 最終 JPEG 出力 CODE
);

    // VCD ダンプ用ブロック
    initial begin
        $dumpfile("./vcd/hw_jpeg_top.vcd");
        $dumpvars(0, HW_JPEGenc_top);
    end

    // CLK数カウンタ
    `ifdef DEBUG
    reg  [3:0]  main_state;
    reg  [11:0]  counter;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            main_state <= 0;
            counter   <= 0;
        end else begin
            case(main_state)
                0: begin
                    if(input_enable | input_1pix_enable) begin
                        main_state <= 1;
                        counter   <= 0;
                    end 
                end
                1: begin
                    counter   <= counter + 1;
                end
            endcase
        end
    end
    `endif

    wire [9:0]  Y_data, Cb_data, Cr_data;

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
        //.pix_1pix_data          (pix_1pix_data), 
        .dct_enable             (dct_enable),
        .dct_end_enable         (dct_end_enable),
        .zigzag_input_enable    (zigzag_input_enable),
        .zigag_enable           (zigag_enable),
        .matrix_row             (matrix_row),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b1),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_dc_out            (jpeg_dc_out),
        .jpeg_dc_out_length     (jpeg_dc_out_length),
        .huffman_code           (huffman_code),
        .huffman_code_length    (huffman_code_length),
        .code_out               (code_out)
    );

    // Cb, Cr module
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
        .zigag_enable           (zigag_enable),
        .matrix_row             (matrix_row),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b1),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_dc_out            (),
        .jpeg_dc_out_length     (),
        .huffman_code           (),
        .huffman_code_length    (),
        .code_out               ()
    );

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
        .zigag_enable           (zigag_enable),
        .matrix_row             (matrix_row),
        .Huffman_start          (Huffman_start),
        //.pix_data               (pix_data),      // pix_data 配列の接続（[0:63] と一致）
        .is_luminance           (1'b1),
        .jpeg_out_enable        (jpeg_out_enable),
        .jpeg_dc_out            (),
        .jpeg_dc_out_length     (),
        .huffman_code           (),
        .huffman_code_length    (),
        .code_out               ()
    );
    
endmodule
