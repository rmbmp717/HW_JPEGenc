`timescale 1ns / 1ps
//`define DEBUG

module DCT_2D(
  input  wire             clock,
  input  wire             reset_n,
  input  wire             dct_enable,       // DCT 動作のON/OFF制御信号
  input  wire [11:0]      pix_data [0:63],  // 8x8 の s12ビットピクセル（行優先）768 bits
  output reg  [11:0]      out      [0:63]   // 最終 2D DCT 結果（行優先）
);

  // Debug 
  wire [767:0] pix_data_flat;
  genvar idx;
  generate
    for (idx = 0; idx < 64; idx = idx + 1) begin : flatten
      // pix_data_flat の最上位10ビットに pix_data[0]、その次に pix_data[1]、…、最下位に pix_data[63]
      assign pix_data_flat[767 - idx*12 -: 12] = pix_data[idx];
    end
  endgenerate


  // FSM 用の状態カウンタ：0～7: 行処理, 8～15: 列処理, 16: 出力再構成
  reg [7:0] dct_state;
  reg       dct_end;
  reg [3:0] row_idx;
  reg [3:0] col_idx;

  // row_buffer: 各行の DCT 出力を保持（各行は 96 ビット）
  reg [95:0] row_buffer [0:7];
  // col_buffer: 各列の DCT 出力を保持（各列は 96 ビット）
  reg [95:0] col_buffer [0:7];

  // dct_1d_s12 用の入力・出力（1回分の 96 ビットベクトル）
  reg  [95:0] dct_in_0, dct_in_1;
  wire [95:0] dct_out_0, dct_out_1;

  // --------------------------------------------------------------------
  // dct_1d_s10 のインスタンス（3クロックレイテンシで結果が得られると仮定）
  // PIPE_LINE_STAGE = 3
  dct_1d_s12 m0_dct_inst( .clk(clock), .x(dct_in_0), .out(dct_out_0));
  dct_1d_s12 m1_dct_inst( .clk(clock), .x(dct_in_1), .out(dct_out_1));

  // 入力 pix_data を行単位でまとめる（行 i は row_in[i] とする） 12 bit x 8 pixls
  wire [95:0] row_in [0:7];
  genvar i, j;
  generate
    for(i = 0; i < 8; i = i + 1) begin: build_rows
      // 各行は、pix_data[ i*8 + 0 ] ～ pix_data[ i*8 + 7 ]
      assign row_in[i] = { pix_data[i*8+7],
                           pix_data[i*8+6],
                           pix_data[i*8+6],
                           pix_data[i*8+5],
                           pix_data[i*8+4],
                           pix_data[i*8+3],
                           pix_data[i*8+2],
                           pix_data[i*8+1],
                           pix_data[i*8+0] };
    end
  endgenerate

  wire [95:0] row_in_0 = row_in[0];
  wire [95:0] row_in_1 = row_in[1];
  wire [95:0] row_in_2 = row_in[2];
  wire [95:0] row_in_3 = row_in[3];
  wire [95:0] row_in_4 = row_in[4];
  wire [95:0] row_in_5 = row_in[5];
  wire [95:0] row_in_6 = row_in[6];
  wire [95:0] row_in_7 = row_in[7];

  // 列データのバッファ 12 bit x 8 pixls
  wire [95:0] col_vector [0:7];
  genvar col, row;
  generate
    for(col = 0; col < 8; col = col + 1) begin: build_col_vec
      assign col_vector[col] = {
        row_buffer[7][col*12 +: 12],  // 第7行の `col` 番目の8ビット
        row_buffer[6][col*12 +: 12],  // 第6行
        row_buffer[5][col*12 +: 12],  // 第5行
        row_buffer[4][col*12 +: 12],  // 第4行
        row_buffer[3][col*12 +: 12],  // 第3行
        row_buffer[2][col*12 +: 12],  // 第2行
        row_buffer[1][col*12 +: 12],  // 第1行
        row_buffer[0][col*12 +: 12]   // 第0行
      };
    end
  endgenerate

  reg state_h_end;
  reg state_v_end;

  integer sel;

  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      dct_state   <= 0;
      dct_end     <= 0;
      dct_in_0    <= 0;
      dct_in_1    <= 0;
      row_idx   <= 0;
      col_idx   <= 0;
      for (sel = 0; sel < 8; sel = sel + 1) begin
        row_buffer[sel] <= 96'b0;
        col_buffer[sel] <= 96'b0;
      end
    end else begin
      // H DCT Start
      case(dct_state) 
        0: begin
          dct_end <= 0;
          row_idx <= 0;
          col_idx <= 0;
          for (sel = 0; sel < 8; sel = sel + 1) begin
            row_buffer[sel] <= 96'b0;
            col_buffer[sel] <= 96'b0;
          end
          if(dct_enable) begin
            dct_state <= 1;
          end
        end
        1: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            //dct_in_0 <= 0;      // 入力をセット
            //dct_in_1 <= 0;    // 入力をセット
            row_idx <= row_idx + 2;
            dct_state <= 2;
        end
        2: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            //dct_in_0 <= 0;      // 入力をセット
            //dct_in_1 <= 0;    // 入力をセット
            row_idx <= row_idx + 2;
            dct_state <= 3;
        end
        3: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            //dct_in_0 <= 0;      // 入力をセット
            //dct_in_1 <= 0;    // 入力をセット
            row_idx <= row_idx + 2;
            dct_state <= 4;
        end
        4: begin
            dct_in_0 <= row_in[row_idx];      // 入力をセット
            dct_in_1 <= row_in[row_idx+1];    // 入力をセット
            //dct_in_0 <= 0;      // 入力をセット
            //dct_in_1 <= 0;    // 入力をセット
            dct_state <= 5;
        end
        5: begin
            dct_state <= 6;
        end
        6: begin
            // 出力スタート
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            dct_state <= 7;
        end
        7: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            dct_state <= 8;
        end
        8: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            dct_state <= 9;
        end
        9: begin
            row_idx <= row_idx + 2;
            row_buffer[row_idx-6]   <= dct_out_0;   
            row_buffer[row_idx+1-6] <= dct_out_1;   
            dct_state <= 10;
        end
        10: begin
            dct_state <= 11;
        end
        11: begin
            dct_state <= 12;
        end

      // V DCT Start

        12: begin
            dct_state <= 13;
        end
        13: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            //dct_in_0 <= 0;    // 入力をセット
            //dct_in_1 <= 0;   
            col_idx <= col_idx + 2;
            dct_state <= 14;
        end
        14: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            //dct_in_0 <= 0;    // 入力をセット
            //dct_in_1 <= 0;   
            col_idx <= col_idx + 2;
            dct_state <= 15;
        end
        15: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];   
            //dct_in_0 <= 0;    // 入力をセット
            //dct_in_1 <= 0;   
            col_idx <= col_idx + 2;
            dct_state <= 16;
        end
        16: begin
            dct_in_0 <= col_vector[col_idx];    // 入力をセット
            dct_in_1 <= col_vector[col_idx+1];  
            //dct_in_0 <= 0;    // 入力をセット
            //dct_in_1 <= 0;   
            dct_state <= 17;
        end
        17: begin
            dct_state <= 18;
        end
        18: begin 
            // 出力スタート
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            dct_state <= 19;
        end
        19: begin
            col_buffer[col_idx-6] <= dct_out_0;   
            col_buffer[col_idx-6+1] <= dct_out_1;   
            col_idx <= col_idx + 2;
            dct_state <= 20;
        end
        20: begin
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            dct_state <= 21;
        end
        21: begin
            col_buffer[col_idx-6] <= dct_out_0;    
            col_buffer[col_idx-6+1] <= dct_out_1; 
            col_idx <= col_idx + 2;
            dct_state <= 22;
        end
        22: begin
            dct_end <= 1;
            dct_state <= 0;
        end
      endcase
    end
  end

  // Debug 
 `ifdef DEBUG
  wire [95:0] out_w0, out_w1, out_w2, out_w3, out_w4, out_w5, out_w6, out_w7;
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
  wire [11:0] out_w [0:63];

  genvar r, c;
  generate
    for(r = 0; r < 8; r = r + 1) begin: out_row
      for(c = 0; c < 8; c = c + 1) begin: out_col
        // ここで、(7 - r) によって行順序を反転させている
        assign out_w[r*8 + c] = col_buffer[c][(r*12) +: 12];
      end
    end
  endgenerate

  // 必要に応じて、out_w の内容を出力レジスタ out にクロック同期で転送する
  // 例:
  always @(posedge clock or negedge reset_n) begin
    if(!reset_n)
      for(integer i = 0; i < 64; i = i + 1)
        out[i] <= 12'd0;
    else if(dct_end) // V DCT が終了したタイミングで
      for(integer i = 0; i < 64; i = i + 1)
        out[i] <= out_w[i];
  end


endmodule
