`timescale 1ns / 1ps

module databuffer_64x8bit #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          input_1pix_enable,      // 1ピクセル書き込みイネーブル
    input  wire [DATA_WIDTH-1:0]         pix_1pix_data,          // 1ピクセルのデータ
    input  wire [DATA_WIDTH-1:0]         pix_data [0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output wire [511:0]                  buffer_512bits
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

    // 64個の8ビットデータ（unpacked array: buffer）を512ビットにパックする
    genvar idx;
    generate
      for (idx = 0; idx < DEPTH; idx = idx + 1) begin : pack_gen
        // buffer[idx] を 8 ビットずつ、最上位に buffer[0]、最下位に buffer[63] を配置
        assign buffer_512bits[511 - idx*8 -: 8] = buffer[(DEPTH-1) - idx];
      end
    endgenerate

endmodule
