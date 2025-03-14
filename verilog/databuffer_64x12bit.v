`timescale 1ns / 1ps
//`define TEST_MODE

module databuffer_64x12bit #(
    parameter DATA_WIDTH = 12,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          input_1pix_enable,      // 1ピクセル書き込みイネーブル
    input  wire [DATA_WIDTH-1:0]         pix_1pix_data,          // 1ピクセルのデータ
    input  wire [DATA_WIDTH-1:0]         pix_data [0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output wire [767:0]                  buffer_768bits
);

    integer i;
    // sequential write index for 1ピクセルモード
    reg [5:0] write_index;

    // バッファ更新プロセス
    // - input_enable が有効の場合は、pix_data から一括でバッファへロード
    // - それ以外で input_1pix_enable が有効の場合は、pix_1pix_data の値を
    //   write_index のアドレスに書き込み、write_index を 64CLK順に更新
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                buffer[i] <= {DATA_WIDTH{1'b0}};
            end
            write_index <= 0;
        end else begin
            if (input_enable) begin
                for (i = 0; i < DEPTH; i = i + 1) begin
                    buffer[i] <= pix_data[i];
                end
            end else if (input_1pix_enable) begin
                buffer[write_index] <= pix_1pix_data;
                if (write_index == DEPTH-1)
                    write_index <= 0;
                else
                    write_index <= write_index + 1;
            end
        end
    end

`ifndef TEST_MODE
    // 64個の12ビットデータ（unpacked array: buffer）を768ビットにパックする
    genvar idx;
    generate
      for (idx = 0; idx < DEPTH; idx = idx + 1) begin : pack_gen
        // buffer[idx] を 12 ビットずつ、最下位に buffer[0]、最上位に buffer[63] を配置
        assign buffer_768bits[767 - idx*12 -: 12] = buffer[63-idx];
      end
    endgenerate
`else 
    // 64個の12ビットデータ（unpacked array: buffer）を768ビットにパックする
    genvar idx;
    generate
      for (idx = 0; idx < DEPTH; idx = idx + 1) begin : pack_gen
        // buffer[idx] を 12 ビットずつ、最下位に buffer[0]、最上位に buffer[63] を配置
        if (idx < 64) begin
            assign buffer_768bits[767 - idx*12 -: 12] = idx;
        end else begin
            assign buffer_768bits[767 - idx*12 -: 12] = 0;
        end
      end
    endgenerate
`endif

endmodule
