`timescale 1ns / 1ps
`define DEBUG

module databuffer_zigzag64x8bit #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 64
)(
    input  wire                          clock,
    input  wire                          reset_n,
    input  wire                          input_enable,
    input  wire                          zigag_enable,
    input  wire [7:0]                    matrix_row,   // 書き込み対象の行 (0～7)
    input  wire [64-1:0]                 row_data,     // 128ビット入力。下位64ビットを使用
    input  wire                          input_data_enable,
    output reg  [DATA_WIDTH-1:0]         buffer   [0:DEPTH-1],
    output reg  [511:0]                  zigzag_pix_out 
);

    // Debug
`ifdef DEBUG
    // 各行を64ビットとしてまとめる（上位ビットに該当する buffer 要素を順に配置）
    // ※ここでは、各行のデータを「逆順」（例: buffer[7] が最上位ビット、buffer[0] が最下位ビット）に連結しています
    wire [63:0] debug_row0;
    wire [63:0] debug_row1;
    wire [63:0] debug_row2;
    wire [63:0] debug_row3;
    wire [63:0] debug_row4;
    wire [63:0] debug_row5;
    wire [63:0] debug_row6;
    wire [63:0] debug_row7;

    assign debug_row0 = { buffer[7],  buffer[6],  buffer[5],  buffer[4],  buffer[3],  buffer[2],  buffer[1],  buffer[0]  };
    assign debug_row1 = { buffer[15], buffer[14], buffer[13], buffer[12], buffer[11], buffer[10], buffer[9],  buffer[8]  };
    assign debug_row2 = { buffer[23], buffer[22], buffer[21], buffer[20], buffer[19], buffer[18], buffer[17], buffer[16] };
    assign debug_row3 = { buffer[31], buffer[30], buffer[29], buffer[28], buffer[27], buffer[26], buffer[25], buffer[24] };
    assign debug_row4 = { buffer[39], buffer[38], buffer[37], buffer[36], buffer[35], buffer[34], buffer[33], buffer[32] };
    assign debug_row5 = { buffer[47], buffer[46], buffer[45], buffer[44], buffer[43], buffer[42], buffer[41], buffer[40] };
    assign debug_row6 = { buffer[55], buffer[54], buffer[53], buffer[52], buffer[51], buffer[50], buffer[49], buffer[48] };
    assign debug_row7 = { buffer[63], buffer[62], buffer[61], buffer[60], buffer[59], buffer[58], buffer[57], buffer[56] };
`endif

    // Address Delay
    reg [7:0]   matrix_row_d1;
    reg [7:0]   matrix_row_d2;
    reg [7:0]   matrix_row_d3;

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            matrix_row_d1 <= 0;
            matrix_row_d2 <= 0;
            matrix_row_d3 <= 0;
        end else begin
            matrix_row_d1 <= matrix_row;
            matrix_row_d2 <= matrix_row_d1;
            matrix_row_d3 <= matrix_row_d2;
        end
    end

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
                    buffer[matrix_row_d3  * 8 + i] <= row_data[63 - i*8 -: 8];
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

    wire  [511:0]    zigzag_pix_data; 

    // Zigzag 並べ替えモジュールのインスタンス化
    // 入力：512ビットの matrix、出力：512ビットの zigzag_pix_out
    Zigzag_reorder zigzag_inst (
        .clk        (clock),
        .matrix     (matrix),
        .is_enable  (zigag_enable),
        .out        (zigzag_pix_data)
    );

    reg zigag_enable_d1;
    reg zigag_enable_d2;

    // 1 CLK
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            zigag_enable_d1 <= 0;
            zigag_enable_d2 <= 0;
            zigzag_pix_out <= 0;
        end else begin
            zigag_enable_d1 <= zigag_enable;
            zigag_enable_d2 <= zigag_enable_d1;
            if(zigag_enable_d2) begin
                zigzag_pix_out <= zigzag_pix_data;
            end
        end
    end

endmodule
