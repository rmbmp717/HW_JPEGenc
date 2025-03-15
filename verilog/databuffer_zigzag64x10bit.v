`timescale 1ns / 1ps
`define DEBUG

module databuffer_zigzag64x10bit #(
    parameter DATA_WIDTH = 10,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    output reg  [7:0]                    matrix_row,
    input  wire [80-1:0]                 row_data,     // 80ビット入力。
    input  wire                          input_data_enable,
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output reg  [80-1:0]                 buffer_80bit [0:7],
    output reg  [640-1:0]                zigzag_pix_out
);

    // Debug
`ifdef DEBUG
    // 各行を64ビットとしてまとめる（上位ビットに該当する buffer 要素を順に配置）
    // ※ここでは、各行のデータを「逆順」（例: buffer[7] が最上位ビット、buffer[0] が最下位ビット）に連結しています
    wire [79:0] debug_row0;
    wire [79:0] debug_row1;
    wire [79:0] debug_row2;
    wire [79:0] debug_row3;
    wire [79:0] debug_row4;
    wire [79:0] debug_row5;
    wire [79:0] debug_row6;
    wire [79:0] debug_row7;

    assign debug_row0 = { buffer[7],  buffer[6],  buffer[5],  buffer[4],  buffer[3],  buffer[2],  buffer[1],  buffer[0]  };
    assign debug_row1 = { buffer[15], buffer[14], buffer[13], buffer[12], buffer[11], buffer[10], buffer[9],  buffer[8]  };
    assign debug_row2 = { buffer[23], buffer[22], buffer[21], buffer[20], buffer[19], buffer[18], buffer[17], buffer[16] };
    assign debug_row3 = { buffer[31], buffer[30], buffer[29], buffer[28], buffer[27], buffer[26], buffer[25], buffer[24] };
    assign debug_row4 = { buffer[39], buffer[38], buffer[37], buffer[36], buffer[35], buffer[34], buffer[33], buffer[32] };
    assign debug_row5 = { buffer[47], buffer[46], buffer[45], buffer[44], buffer[43], buffer[42], buffer[41], buffer[40] };
    assign debug_row6 = { buffer[55], buffer[54], buffer[53], buffer[52], buffer[51], buffer[50], buffer[49], buffer[48] };
    assign debug_row7 = { buffer[63], buffer[62], buffer[61], buffer[60], buffer[59], buffer[58], buffer[57], buffer[56] };
`endif

    // row Address
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            matrix_row <= 0;
        end else begin
            if(input_enable) begin
                matrix_row <= 1;
            end else begin
                if(matrix_row == 11) begin
                    matrix_row <= 0;
                end else if(matrix_row != 0) begin
                    matrix_row <= matrix_row + 1;
                end
            end
        end
    end

    integer i;

    // バッファ更新プロセス
    // - input_enable が有効の場合は、pix_data から一括でバッファへロード（ここでは省略）
    // - input_data_enable が有効の場合は、matrix_row で指定した行に対して row_data のデータを
    //   順番に書き込む
    // Quantize PIPELINE = 2 と仮定
    wire    matrix_write_enb;
    assign  matrix_write_enb = (matrix_row > 2 && matrix_row < 11);

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // 非同期リセット：バッファ全体をゼロにクリア
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                buffer_80bit[i] <= 0;
            end
            for (i = 0; i < DEPTH; i = i + 1) begin
                buffer[i] <= 0;
            end
        end else begin
            if (matrix_write_enb) begin
                buffer_80bit[matrix_row - 3] <= row_data;
            end
        end
    end

    // ここで、buffer 配列（80×8ビット）を640ビットのベクトル matrix に再結合
    wire  [639:0]      zigzag_pix_in;
    assign  zigzag_pix_in = {
                    buffer_80bit[7], buffer_80bit[6], buffer_80bit[5], buffer_80bit[4],
                    buffer_80bit[3], buffer_80bit[2], buffer_80bit[1], buffer_80bit[0]
                };

    wire  [639:0]      fliped_zigzag_pix_in;

    // データの並び順を０〜64で逆にする
    Data_flip64 mData_flip64 (
        .clk                (clock),
        .data_in            (zigzag_pix_in),
        .is_flip            (1'b1),
        .out                (fliped_zigzag_pix_in)
    );
    
    wire  [639:0]    zigzag_pix_data; 

    // Zigzag 並べ替えモジュールのインスタンス化
    // 入力：640ビットの matrix、出力：640ビットの zigzag_pix_out
    Zigzag_reorder zigzag_inst (
        .clk        (clock),
        .matrix     (fliped_zigzag_pix_in),
        .is_enable  (1'b1),
        .out        (zigzag_pix_data)
    );

    // 1 CLK
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            zigzag_pix_out <= 0;
        end else begin
            zigzag_pix_out <= zigzag_pix_data;
        end
    end

`ifdef DEBUG
    wire [9:0] row_data_0 = row_data[9 : 0];
    wire [9:0] row_data_1 = row_data[19:10];
    wire [9:0] row_data_2 = row_data[29:20];
    wire [9:0] row_data_3 = row_data[39:30];
    wire [9:0] row_data_4 = row_data[49:40];
    wire [9:0] row_data_5 = row_data[59:50];
    wire [9:0] row_data_6 = row_data[69:60];
    wire [9:0] row_data_7 = row_data[79:70];

    wire [79:0] buffer_80bit_0 = buffer_80bit[0];
    wire [79:0] buffer_80bit_1 = buffer_80bit[1];
    wire [79:0] buffer_80bit_2 = buffer_80bit[2];
    wire [79:0] buffer_80bit_3 = buffer_80bit[3];
    wire [79:0] buffer_80bit_4 = buffer_80bit[4];
    wire [79:0] buffer_80bit_5 = buffer_80bit[5];
    wire [79:0] buffer_80bit_6 = buffer_80bit[6];
    wire [79:0] buffer_80bit_7 = buffer_80bit[7];

    wire [9:0] buffer_80bit_0_0 = buffer_80bit_0[9:0];

    wire [79:0] zigzag_pix_in_0 = zigzag_pix_in[79:0];
    wire [79:0] zigzag_pix_in_1 = zigzag_pix_in[159:80];

    wire [9:0] zigzag_pix_in_0_0 =  zigzag_pix_in_0[9:0];
    wire [9:0] zigzag_pix_in_0_1 =  zigzag_pix_in_0[19:10];
    wire [9:0] zigzag_pix_in_0_2 =  zigzag_pix_in_0[29:20];
    wire [9:0] zigzag_pix_in_0_3 =  zigzag_pix_in_0[39:30];
    wire [9:0] zigzag_pix_in_0_4 =  zigzag_pix_in_0[49:40];
    wire [9:0] zigzag_pix_in_0_5 =  zigzag_pix_in_0[59:50];
    wire [9:0] zigzag_pix_in_0_6 =  zigzag_pix_in_0[69:60];
    wire [9:0] zigzag_pix_in_0_7 =  zigzag_pix_in_0[79:70];

`endif

endmodule