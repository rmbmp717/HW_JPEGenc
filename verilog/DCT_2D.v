`timescale 1ns / 1ps
`define DEBUG

module DCT_2D(
  input  wire             clock,
  input  wire             reset_n,
  input  wire             dct_enable,       // DCT 動作のON/OFF制御信号
  input  wire [9:0]       pix_data [0:63],  // 8x8 の 10ビットピクセル（行優先）
  output reg  [9:0]       out      [0:63]   // 最終 2D DCT 結果（行優先）
);

  // Debug 
  wire [639:0] pix_data_flat;
  genvar idx;
  generate
    for (idx = 0; idx < 64; idx = idx + 1) begin : flatten
      // pix_data_flat の最上位10ビットに pix_data[0]、その次に pix_data[1]、…、最下位に pix_data[63]
      assign pix_data_flat[639 - idx*10 -: 10] = pix_data[idx];
    end
  endgenerate

  // Debug 
  `ifdef DEBUG
  // 行0 (out[0]～out[7]) を 80ビットにまとめる
  wire [79:0] out_row0 = { out[7],  out[6],  out[5],  out[4],  out[3],  out[2],  out[1],  out[0]  },
              out_row1 = { out[15], out[14], out[13], out[12], out[11], out[10], out[9],  out[8]  },
              out_row2 = { out[23], out[22], out[21], out[20], out[19], out[18], out[17], out[16] },
              out_row3 = { out[31], out[30], out[29], out[28], out[27], out[26], out[25], out[24] },
              out_row4 = { out[39], out[38], out[37], out[36], out[35], out[34], out[33], out[32] },
              out_row5 = { out[47], out[46], out[45], out[44], out[43], out[42], out[41], out[40] },
              out_row6 = { out[55], out[54], out[53], out[52], out[51], out[50], out[49], out[48] },
              out_row7 = { out[63], out[62], out[61], out[60], out[59], out[58], out[57], out[56] };

  wire [9:0] row_in0_0;
  wire [9:0] row_in0_1;
  wire [9:0] row_in0_2;
  wire [9:0] row_in0_3;
  wire [9:0] row_in0_4;
  wire [9:0] row_in0_5;
  wire [9:0] row_in0_6;
  wire [9:0] row_in0_7;

  assign row_in0_0 = row_in0[9:0];
  assign row_in0_1 = row_in0[19:10];
  assign row_in0_2 = row_in0[29:20];
  assign row_in0_3 = row_in0[39:30];
  assign row_in0_4 = row_in0[49:40];
  assign row_in0_5 = row_in0[59:50];
  assign row_in0_6 = row_in0[69:60];
  assign row_in0_7 = row_in0[79:70];

  wire [79:0] row_in0;
  wire [79:0] row_in1;
  wire [79:0] row_in2;
  wire [79:0] row_in3;
  wire [79:0] row_in4;
  wire [79:0] row_in5;
  wire [79:0] row_in6;
  wire [79:0] row_in7;

  assign row_in0 = row_in[0];
  assign row_in1 = row_in[1];
  assign row_in2 = row_in[2];
  assign row_in3 = row_in[3];
  assign row_in4 = row_in[4];
  assign row_in5 = row_in[5];
  assign row_in6 = row_in[6];
  assign row_in7 = row_in[7];

  wire [9:0] col_buffer0_0;
  wire [9:0] col_buffer0_1;
  wire [9:0] col_buffer0_2;
  wire [9:0] col_buffer0_3;
  wire [9:0] col_buffer0_4;
  wire [9:0] col_buffer0_5;
  wire [9:0] col_buffer0_6;
  wire [9:0] col_buffer0_7;

  assign col_buffer0_0 = col_buffer0[9:0];
  assign col_buffer0_1 = col_buffer0[19:10];
  assign col_buffer0_2 = col_buffer0[29:20];
  assign col_buffer0_3 = col_buffer0[39:30];

  wire [79:0] col_buffer0;
  wire [79:0] col_buffer1;
  wire [79:0] col_buffer2;
  wire [79:0] col_buffer3;
  wire [79:0] col_buffer4;
  wire [79:0] col_buffer5;
  wire [79:0] col_buffer6;
  wire [79:0] col_buffer7;

  assign col_buffer0 = col_buffer[0];
  assign col_buffer1 = col_buffer[1];
  assign col_buffer2 = col_buffer[2];
  assign col_buffer3 = col_buffer[3];
  assign col_buffer4 = col_buffer[4];
  assign col_buffer5 = col_buffer[5];
  assign col_buffer6 = col_buffer[6];
  assign col_buffer7 = col_buffer[7];

  wire [9:0] row_buffer0_0;
  wire [9:0] row_buffer0_1;
  wire [9:0] row_buffer0_2;
  wire [9:0] row_buffer0_3;
  wire [9:0] row_buffer0_4;
  wire [9:0] row_buffer0_5;
  wire [9:0] row_buffer0_6;
  wire [9:0] row_buffer0_7;

  assign row_buffer0_0 = row_buffer0[9:0];
  assign row_buffer0_1 = row_buffer0[19:10];
  assign row_buffer0_2 = row_buffer0[29:20];
  assign row_buffer0_3 = row_buffer0[39:30];
  assign row_buffer0_4 = row_buffer0[49:40];
  assign row_buffer0_5 = row_buffer0[59:50];
  assign row_buffer0_6 = row_buffer0[69:60];
  assign row_buffer0_7 = row_buffer0[79:70];

  wire [79:0] row_buffer0;
  wire [79:0] row_buffer1;
  wire [79:0] row_buffer2;
  wire [79:0] row_buffer3;
  wire [79:0] row_buffer4;
  wire [79:0] row_buffer5;
  wire [79:0] row_buffer6;
  wire [79:0] row_buffer7;

  assign row_buffer0 = row_buffer[0];
  assign row_buffer1 = row_buffer[1];
  assign row_buffer2 = row_buffer[2];
  assign row_buffer3 = row_buffer[3];
  assign row_buffer4 = row_buffer[4];
  assign row_buffer5 = row_buffer[5];
  assign row_buffer6 = row_buffer[6];
  assign row_buffer7 = row_buffer[7];

  wire [9:0] col_vector0_0;
  wire [9:0] col_vector0_1;
  wire [9:0] col_vector0_2;
  wire [9:0] col_vector0_3;

  assign col_vector0_0 = col_vector0[9:0];
  assign col_vector0_1 = col_vector0[19:10];
  assign col_vector0_2 = col_vector0[29:20];
  assign col_vector0_3 = col_vector0[39:30];

  wire [79:0] col_vector0;
  wire [79:0] col_vector1;
  wire [79:0] col_vector2;
  wire [79:0] col_vector3;
  wire [79:0] col_vector4;
  wire [79:0] col_vector5;
  wire [79:0] col_vector6;
  wire [79:0] col_vector7;

  assign col_vector0 = col_vector[0];
  assign col_vector1 = col_vector[1];
  assign col_vector2 = col_vector[2];
  assign col_vector3 = col_vector[3];
  assign col_vector4 = col_vector[4];
  assign col_vector5 = col_vector[5];
  assign col_vector6 = col_vector[6];
  assign col_vector7 = col_vector[7];

  wire [9:0] dct_in_0_0;
  wire [9:0] dct_in_0_1;
  wire [9:0] dct_in_0_2;
  wire [9:0] dct_in_0_3;
  wire [9:0] dct_in_0_4;
  wire [9:0] dct_in_0_5;
  wire [9:0] dct_in_0_6;
  wire [9:0] dct_in_0_7;

  assign dct_in_0_0 = dct_in_0[9:0];
  assign dct_in_0_1 = dct_in_0[19:10];
  assign dct_in_0_2 = dct_in_0[29:20];
  assign dct_in_0_3 = dct_in_0[39:30];
  assign dct_in_0_4 = dct_in_0[49:40];
  assign dct_in_0_5 = dct_in_0[59:50];
  assign dct_in_0_6 = dct_in_0[69:60];
  assign dct_in_0_7 = dct_in_0[79:70];

  wire [9:0] dct_out_0_0;
  wire [9:0] dct_out_0_1;
  wire [9:0] dct_out_0_2;
  wire [9:0] dct_out_0_3;
  wire [9:0] dct_out_0_4;
  wire [9:0] dct_out_0_5;
  wire [9:0] dct_out_0_6;
  wire [9:0] dct_out_0_7;

  assign dct_out_0_0 = dct_out_0[9:0];
  assign dct_out_0_1 = dct_out_0[19:10];
  assign dct_out_0_2 = dct_out_0[29:20];
  assign dct_out_0_3 = dct_out_0[39:30];
  assign dct_out_0_4 = dct_out_0[49:40];
  assign dct_out_0_5 = dct_out_0[59:50];
  assign dct_out_0_6 = dct_out_0[69:60];
  assign dct_out_0_7 = dct_out_0[79:70];
  `endif
  // Debug End

  // FSM 用の状態カウンタ：0～7: 行処理, 8～15: 列処理, 16: 出力再構成
  reg [4:0] state_h;
  reg [4:0] state_v;
  reg [3:0] row_idx;
  reg [3:0] col_idx;

  // row_buffer: 各行の DCT 出力を保持（各行は 80 ビット）
  reg [79:0] row_buffer [0:7];
  // col_buffer: 各列の DCT 出力を保持（各列は 80 ビット）
  reg [79:0] col_buffer [0:7];

  // dct_1d_s10 用の入力・出力（1回分の 80 ビットベクトル）
  reg  [79:0] dct_in_0, dct_in_1;
  wire [79:0] dct_out_0, dct_out_1;

  // --------------------------------------------------------------------
  // dct_1d_s10 のインスタンス（3クロックレイテンシで結果が得られると仮定）
  // PIPE_LINE_STAGE = 3
  dct_1d_s10 m0_dct_inst( .clk(clock), .x(dct_in_0), .out(dct_out_0));
  dct_1d_s10 m1_dct_inst( .clk(clock), .x(dct_in_1), .out(dct_out_1));

  // 入力 pix_data を行単位でまとめる（行 i は row_in[i] とする）
  wire [79:0] row_in [0:7];
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

  // 列データのバッファ
  wire [79:0] col_vector [0:7];
  genvar col, row;
  generate
    for(col = 0; col < 8; col = col + 1) begin: build_col_vec
      assign col_vector[col] = {
        row_buffer[7][col*10 +: 10],  // 第7行の `col` 番目の8ビット
        row_buffer[6][col*10 +: 10],  // 第6行
        row_buffer[5][col*10 +: 10],  // 第5行
        row_buffer[4][col*10 +: 10],  // 第4行
        row_buffer[3][col*10 +: 10],  // 第3行
        row_buffer[2][col*10 +: 10],  // 第2行
        row_buffer[1][col*10 +: 10],  // 第1行
        row_buffer[0][col*10 +: 10]   // 第0行
      };
    end
  endgenerate

  reg state_h_end;
  reg state_v_end;

  integer sel;

  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      state_h   <= 0;
      dct_in_0    <= 0;
      dct_in_1    <= 0;
      row_idx   <= 0;
      col_idx   <= 0;
      state_h_end <= 0;
      state_v   <= 0;
      state_v_end <= 0;
      for (sel = 0; sel < 8; sel = sel + 1) begin
        row_buffer[sel] <= 80'b0;
        col_buffer[sel] <= 80'b0;
      end
    end else begin
      // H DCT
      case(state_h) 
        0: begin
          state_h_end <= 0;
          if(dct_enable) begin
            state_h <= 1;
          end
        end
        1: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            row_idx <= row_idx + 2;
            state_h <= 2;
        end
        2: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            row_idx <= row_idx + 2;
            state_h <= 3;
        end
        3: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            row_idx <= row_idx + 2;
            state_h <= 4;
        end
        4: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            state_h <= 5;
        end
        5: begin
            state_h <= 6;
        end
        6: begin
            // 出力スタート
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            state_h <= 7;
        end
        7: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            state_h <= 8;
        end
        8: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            state_h <= 9;
        end
        9: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            state_h <= 10;
        end
        10: begin
            state_h_end <= 1;
            state_h <= 0;
        end
      endcase

      // V DCT
      // state machine
      case(state_v) 
        0: begin
          state_v_end <= 0;
          if(state_h_end) begin
            state_v <= 1;
          end
        end
        1: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            col_idx <= col_idx + 2;
            state_v <= 2;
        end
        2: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            col_idx <= col_idx + 2;
            state_v <= 3;
        end
        3: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            col_idx <= col_idx + 2;
            state_v <= 4;
        end
        4: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];  
            state_v <= 5;
        end
        5: begin
            state_v <= 6;
        end
        6: begin 
            // 出力スタート
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            state_v <= 7;
        end
        7: begin
            col_buffer[col_idx-6] <= dct_out_0;   
            col_buffer[col_idx-6+1] <= dct_out_1;   
            col_idx <= col_idx + 2;
            state_v <= 8;
        end
        8: begin
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            state_v <= 9;
        end
        9: begin
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            state_v <= 10;
        end
        10: begin
            state_v_end <= 1;
            state_v <= 0;
        end
      endcase
    end
  end

  // Debug 
 `ifdef DEBUG
  wire [79:0] out_w0, out_w1, out_w2, out_w3, out_w4, out_w5, out_w6, out_w7;
  assign out_w0 = { out_w[ 0], out_w[ 1], out_w[ 2], out_w[ 3], out_w[ 4], out_w[ 5], out_w[ 6], out_w[ 7] };
  assign out_w1 = { out_w[ 8], out_w[ 9], out_w[10], out_w[11], out_w[12], out_w[13], out_w[14], out_w[15] };
  assign out_w2 = { out_w[16], out_w[17], out_w[18], out_w[19], out_w[20], out_w[21], out_w[22], out_w[23] };
  assign out_w3 = { out_w[24], out_w[25], out_w[26], out_w[27], out_w[28], out_w[29], out_w[30], out_w[31] };
  assign out_w4 = { out_w[32], out_w[33], out_w[34], out_w[35], out_w[36], out_w[37], out_w[38], out_w[39] };
  assign out_w5 = { out_w[40], out_w[41], out_w[42], out_w[43], out_w[44], out_w[45], out_w[46], out_w[47] };
  assign out_w6 = { out_w[48], out_w[49], out_w[50], out_w[51], out_w[52], out_w[53], out_w[54], out_w[55] };
  assign out_w7 = { out_w[56], out_w[57], out_w[58], out_w[59], out_w[60], out_w[61], out_w[62], out_w[63] };
  `endif
  // Debug End

  // 最終出力（行優先）を生成するための中間 wire 配列
  wire [9:0] out_w [0:63];

  genvar r, c;
  generate
    for(r = 0; r < 8; r = r + 1) begin: out_row
      for(c = 0; c < 8; c = c + 1) begin: out_col
        // ここで、(7 - r) によって行順序を反転させている
        assign out_w[r*8 + c] = col_buffer[c][(r*10) +: 10];
      end
    end
  endgenerate

  // 必要に応じて、out_w の内容を出力レジスタ out にクロック同期で転送する
  // 例:
  always @(posedge clock or negedge reset_n) begin
    if(!reset_n)
      for(integer i = 0; i < 64; i = i + 1)
        out[i] <= 10'd0;
    else if(state_v_end) // V DCT が終了したタイミングで
      for(integer i = 0; i < 64; i = i + 1)
        out[i] <= out_w[i];
  end


endmodule
