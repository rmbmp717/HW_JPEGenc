`timescale 1ns / 1ps

module DCT_2D(
  input  wire             clock,
  input  wire             reset_n,
  input  wire             dct_enable,       // DCT 動作のON/OFF制御信号
  input  wire [7:0]       pix_data [0:63],  // 8x8 の 8ビットピクセル（行優先）
  output reg  [7:0]       out      [0:63]   // 最終 2D DCT 結果（行優先）
);

  // Debug 
  wire [511:0] pix_data_flat;
  genvar idx;
  generate
    for (idx = 0; idx < 64; idx = idx + 1) begin : flatten
      // pix_data_flat の最上位8ビットに pix_data[0]、その次に pix_data[1]、…、最下位に pix_data[63]
      assign pix_data_flat[511 - idx*8 -: 8] = pix_data[idx];
    end
  endgenerate

  wire [63:0] row_buffer0;
  wire [63:0] row_buffer1;
  wire [63:0] row_buffer2;
  wire [63:0] row_buffer3;
  wire [63:0] row_buffer4;
  wire [63:0] row_buffer5;
  wire [63:0] row_buffer6;
  wire [63:0] row_buffer7;

  assign row_buffer0 = row_buffer[0];
  assign row_buffer1 = row_buffer[1];
  assign row_buffer2 = row_buffer[2];
  assign row_buffer3 = row_buffer[3];
  assign row_buffer4 = row_buffer[4];
  assign row_buffer5 = row_buffer[5];
  assign row_buffer6 = row_buffer[6];
  assign row_buffer7 = row_buffer[7];

  // FSM 用の状態カウンタ：0～7: 行処理, 8～15: 列処理, 16: 出力再構成
  reg [4:0] state;
  reg [2:0] row_idx;
  reg [2:0] col_idx;

  // row_buffer: 各行の DCT 出力を保持（各行は 64 ビット）
  reg [63:0] row_buffer [0:7];
  // col_buffer: 各列の DCT 出力を保持（各列は 64 ビット）
  reg [63:0] col_buffer [0:7];

  // dct_1d_u8 用の入力・出力（1回分の 64 ビットベクトル）
  reg [63:0] dct_in;
  wire [63:0] dct_out;

  // dct_1d_u8 のインスタンス（1クロックレイテンシで結果が得られると仮定）
  dct_1d_u8 dct_inst(
    .clk(clock),
    .x(dct_in),
    .out(dct_out)
  );

  // 入力 pix_data を行単位でまとめる（行 i は row_in[i] とする）
  wire [63:0] row_in [0:7];
  genvar i, j;
  generate
    for(i = 0; i < 8; i = i + 1) begin: build_rows
      // 各行は、pix_data[ i*8 + 0 ] ～ pix_data[ i*8 + 7 ]
      assign row_in[i] = { pix_data[i*8+7],
                           pix_data[i*8+6],
                           pix_data[i*8+5],
                           pix_data[i*8+4],
                           pix_data[i*8+3],
                           pix_data[i*8+2],
                           pix_data[i*8+1],
                           pix_data[i*8+0] };
    end
  endgenerate

  // FSM：16 クロックで処理完了（dct_enable==1 の場合）
  // dct_enable が 0 の場合は、FSM をリセットし、出力に pix_data をパススルー
  integer r, j_local, k;
  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      state   <= 0;
      row_idx <= 0;
      col_idx <= 0;
      // 初期化：出力に入力をパス
      for (k = 0; k < 64; k = k + 1) begin
         out[k] <= pix_data[k];
      end
    end else if (!dct_enable) begin
      // dct_enable がオフの場合、FSM をリセットして出力に pix_data をパス
      state   <= 0;
      row_idx <= 0;
      col_idx <= 0;
      for (k = 0; k < 64; k = k + 1) begin
         out[k] <= pix_data[k];
      end
    end else begin
      // dct_enable がオンの場合、通常の FSM 処理を実施
      if (state < 8) begin
        // [0～7] 行処理段階：行 row_idx の 1D DCT を実施
        dct_in <= row_in[row_idx];    // 入力をセット
        row_buffer[row_idx] <= dct_out; // 1クロック遅れの結果を保存
        row_idx <= row_idx + 1;
        state   <= state + 1;
      end else if (state < 16) begin
        // [8～15] 列処理段階：col_idx = state - 8
        reg [63:0] col_vector;
        integer r_local;
        col_vector = 64'b0;
        for(r_local = 0; r_local < 8; r_local = r_local + 1) begin
          // row_buffer[r_local] から、列 col_idx の 8 ビットを抽出
          col_vector[r_local*8 +: 8] = row_buffer[r_local][((col_idx+1)*8-1) -: 8];
        end
        dct_in <= col_vector;
        col_buffer[col_idx] <= dct_out; // 1クロック遅れの結果を保存
        col_idx <= col_idx + 1;
        state   <= state + 1;
      end else begin
        // state == 16: 最終出力の再構成
        for (r = 0; r < 8; r = r + 1) begin
          for (j_local = 0; j_local < 8; j_local = j_local + 1) begin
            // col_buffer[j_local] のうち、行 r に対応する 8 ビットを抽出して out に配置
            out[r*8+j_local] <= col_buffer[j_local][((r+1)*8-1) -: 8];
          end
        end
        // 次のブロック処理に備えて FSM をリセット
        state   <= 0;
        row_idx <= 0;
        col_idx <= 0;
      end
    end
  end

endmodule
