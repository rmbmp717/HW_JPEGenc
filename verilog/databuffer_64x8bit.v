`timescale 1ns / 1ps

module databuffer_64x8bit #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          output_enable,
    input  wire [DATA_WIDTH-1:0]         pix_data [0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output wire [511:0]                  buffer_512bits
);

    integer i;

    // バッファ更新プロセス
    // - input_enable が有効の場合は、pix_data から一括でバッファへロード
    // - それ以外で input_data_enable が有効の場合は、指定アドレスへ個別書き込み
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // 非同期リセット：バッファを全要素ゼロにクリア
            for (i = 0; i < DEPTH; i = i + 1) begin
                buffer[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            if (input_enable) begin
                for (i = 0; i < DEPTH; i = i + 1) begin
                    buffer[i] <= pix_data[i];
                end
            end 
        end
    end

    // 64個の8ビットデータ（unpacked array: buffer）を512ビットにパックする
    genvar idx;
    generate
      for (idx = 0; idx < DEPTH; idx = idx + 1) begin : pack_gen
        // buffer[idx] を 8 ビットずつ、最上位に buffer[0]、最下位に buffer[63] を配置
        assign buffer_512bits[511 - idx*8 -: 8] = buffer[idx];
      end
    endgenerate

endmodule

