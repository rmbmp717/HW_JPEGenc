`timescale 1ns / 1ps

module databuffer_zigzag64x8bit #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          output_enable,
    input  wire                          zigag_enable,
    input  wire [7:0]                    matrix_row,   // 書き込み対象の行 (0～7)
    input  wire [127:0]                  row_data,     // 128ビット入力。下位64ビットを使用
    input  wire                          input_data_enable,
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output reg  [511:0]                  zigzag_pix_out 
);

    integer i;

    // バッファ更新プロセス
    // - input_enable が有効の場合は、pix_data から一括でバッファへロード（ここでは省略）
    // - input_data_enable が有効の場合は、matrix_row で指定した行に対して row_data のデータを
    //   64クロック（8要素）順番に書き込む
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // 非同期リセット：バッファ全体をゼロにクリア
            for (i = 0; i < DEPTH; i = i + 1) begin
                buffer[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            if (input_enable) begin
                // ※ pix_data からの一括ロードの処理が必要な場合はここに記述
            end else if (input_data_enable) begin
                // matrix_row で指定された行に、row_data の下位 64 ビットを 8 ビットずつ書き込む
                // ここでは、row_data の上位 64 ビットは無視し、下位 64ビット (row_data[63:0]) を使用
                // 書き込み対象は、行番号 matrix_row に対応するバッファ領域: 
                // インデックス (matrix_row*8) ～ (matrix_row*8+7)
                for (i = 0; i < 8; i = i + 1) begin
                    buffer[matrix_row  * 8 + i] <= row_data[63 - i*8 -: 8];
                end
            end
        end
    end

    // ここで、buffer 配列（64×8ビット）を512ビットのベクトル matrix に再結合
    wire [511:0] matrix;
    genvar idx;
    generate
        for (idx = 0; idx < DEPTH; idx = idx + 1) begin : concat_buffer
            // matrix[511:504] に buffer[0]、matrix[503:496] に buffer[1]、… とする例
            assign matrix[511 - idx*8 -: 8] = buffer[idx];
        end
    endgenerate

    // Zigzag 並べ替えモジュールのインスタンス化
    // 入力：512ビットの matrix、出力：512ビットの zigzag_pix_out
    Zigzag_reorder zigzag_inst (
        .clk        (clock),
        .matrix     (matrix),
        .is_enable  (zigag_enable),
        .out        (zigzag_pix_out)
    );

endmodule
