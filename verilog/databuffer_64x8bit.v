`timescale 1ns / 1ps

module databuffer_64x8bit #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          output_enable,
    input  wire                          input_data_enable,
    input  wire [7:0]                    input_data_address,
    input  wire [DATA_WIDTH-1:0]         input_data_address_data,
    input  wire [DATA_WIDTH-1:0]         pix_data [0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0]         pix_data_out [0:DEPTH-1]
);

    integer i;

    // バッファ更新プロセス
    // ・input_enable が有効の場合は、pix_data から一括でバッファへロード
    // ・それ以外で input_data_enable が有効の場合は、指定アドレスへ個別書き込み
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
            end else if (input_data_enable) begin
                buffer[input_data_address] <= input_data_address_data;
            end
        end
    end

    // 出力更新プロセス
    // ・output_enable が有効の場合、バッファ内容を pix_data_out へ一括出力
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // 非同期リセット：出力レジスタを全要素ゼロにクリア
            for (i = 0; i < DEPTH; i = i + 1) begin
                pix_data_out[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            if (output_enable) begin
                for (i = 0; i < DEPTH; i = i + 1) begin
                    pix_data_out[i] <= buffer[i];
                end
            end
        end
    end

endmodule
