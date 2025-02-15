`timescale 1ns / 1ps

module databuffer_zigzag64x8bit #(
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


    // ここで、buffer 配列（64×8ビット）を 512 ビットのベクトル matrix に再結合
    wire [511:0] matrix;
    genvar idx;
    generate
        for (idx = 0; idx < DEPTH; idx = idx + 1) begin : concat_buffer
            // matrix[511:504] に buffer[0]、matrix[503:496] に buffer[1]、… とする例
            assign matrix[511 - idx*8 -: 8] = buffer[idx];
        end
    endgenerate

    // Zigzag 並べ替えモジュールのインスタンス化
    // 入力：512ビットの matrix、出力：512ビットの zigzag_out
    wire [511:0] zigzag_out;
    Zigzag_reorder zigzag_inst (
        .clk        (clock),
        .matrix     (matrix),
        .is_enable  (output_enable),
        .out        (zigzag_out)
    );

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
