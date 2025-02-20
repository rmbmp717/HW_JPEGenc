module Huffman_DCenc(
  input wire clk,
  input wire [511:0] matrix,
  input wire is_luminance,
  output wire [23:0] out
);
  wire [3:0] literal_827[0:12];
  assign literal_827[0] = 4'h2;
  assign literal_827[1] = 4'h2;
  assign literal_827[2] = 4'h3;
  assign literal_827[3] = 4'h3;
  assign literal_827[4] = 4'h4;
  assign literal_827[5] = 4'h4;
  assign literal_827[6] = 4'h4;
  assign literal_827[7] = 4'h5;
  assign literal_827[8] = 4'h6;
  assign literal_827[9] = 4'h7;
  assign literal_827[10] = 4'h8;
  assign literal_827[11] = 4'h9;
  assign literal_827[12] = 4'h0;
  wire [3:0] literal_829[0:12];
  assign literal_829[0] = 4'h3;
  assign literal_829[1] = 4'h3;
  assign literal_829[2] = 4'h3;
  assign literal_829[3] = 4'h3;
  assign literal_829[4] = 4'h3;
  assign literal_829[5] = 4'h3;
  assign literal_829[6] = 4'h3;
  assign literal_829[7] = 4'h4;
  assign literal_829[8] = 4'h5;
  assign literal_829[9] = 4'h6;
  assign literal_829[10] = 4'h7;
  assign literal_829[11] = 4'h8;
  assign literal_829[12] = 4'h0;
  wire [6:0] literal_830[0:12];
  assign literal_830[0] = 7'h60;
  assign literal_830[1] = 7'h50;
  assign literal_830[2] = 7'h30;
  assign literal_830[3] = 7'h20;
  assign literal_830[4] = 7'h00;
  assign literal_830[5] = 7'h10;
  assign literal_830[6] = 7'h40;
  assign literal_830[7] = 7'h70;
  assign literal_830[8] = 7'h78;
  assign literal_830[9] = 7'h7c;
  assign literal_830[10] = 7'h7e;
  assign literal_830[11] = 7'h7f;
  assign literal_830[12] = 7'h00;
  wire [7:0] literal_833[0:12];
  assign literal_833[0] = 8'h02;
  assign literal_833[1] = 8'h00;
  assign literal_833[2] = 8'h20;
  assign literal_833[3] = 8'h28;
  assign literal_833[4] = 8'h60;
  assign literal_833[5] = 8'h68;
  assign literal_833[6] = 8'h70;
  assign literal_833[7] = 8'h78;
  assign literal_833[8] = 8'h7c;
  assign literal_833[9] = 8'h7e;
  assign literal_833[10] = 8'h7f;
  assign literal_833[11] = 8'hfe;
  assign literal_833[12] = 8'h00;
  wire [7:0] matrix_unflattened[0:7][0:7];
  assign matrix_unflattened[0][0] = matrix[7:0];
  assign matrix_unflattened[0][1] = matrix[15:8];
  assign matrix_unflattened[0][2] = matrix[23:16];
  assign matrix_unflattened[0][3] = matrix[31:24];
  assign matrix_unflattened[0][4] = matrix[39:32];
  assign matrix_unflattened[0][5] = matrix[47:40];
  assign matrix_unflattened[0][6] = matrix[55:48];
  assign matrix_unflattened[0][7] = matrix[63:56];
  assign matrix_unflattened[1][0] = matrix[71:64];
  assign matrix_unflattened[1][1] = matrix[79:72];
  assign matrix_unflattened[1][2] = matrix[87:80];
  assign matrix_unflattened[1][3] = matrix[95:88];
  assign matrix_unflattened[1][4] = matrix[103:96];
  assign matrix_unflattened[1][5] = matrix[111:104];
  assign matrix_unflattened[1][6] = matrix[119:112];
  assign matrix_unflattened[1][7] = matrix[127:120];
  assign matrix_unflattened[2][0] = matrix[135:128];
  assign matrix_unflattened[2][1] = matrix[143:136];
  assign matrix_unflattened[2][2] = matrix[151:144];
  assign matrix_unflattened[2][3] = matrix[159:152];
  assign matrix_unflattened[2][4] = matrix[167:160];
  assign matrix_unflattened[2][5] = matrix[175:168];
  assign matrix_unflattened[2][6] = matrix[183:176];
  assign matrix_unflattened[2][7] = matrix[191:184];
  assign matrix_unflattened[3][0] = matrix[199:192];
  assign matrix_unflattened[3][1] = matrix[207:200];
  assign matrix_unflattened[3][2] = matrix[215:208];
  assign matrix_unflattened[3][3] = matrix[223:216];
  assign matrix_unflattened[3][4] = matrix[231:224];
  assign matrix_unflattened[3][5] = matrix[239:232];
  assign matrix_unflattened[3][6] = matrix[247:240];
  assign matrix_unflattened[3][7] = matrix[255:248];
  assign matrix_unflattened[4][0] = matrix[263:256];
  assign matrix_unflattened[4][1] = matrix[271:264];
  assign matrix_unflattened[4][2] = matrix[279:272];
  assign matrix_unflattened[4][3] = matrix[287:280];
  assign matrix_unflattened[4][4] = matrix[295:288];
  assign matrix_unflattened[4][5] = matrix[303:296];
  assign matrix_unflattened[4][6] = matrix[311:304];
  assign matrix_unflattened[4][7] = matrix[319:312];
  assign matrix_unflattened[5][0] = matrix[327:320];
  assign matrix_unflattened[5][1] = matrix[335:328];
  assign matrix_unflattened[5][2] = matrix[343:336];
  assign matrix_unflattened[5][3] = matrix[351:344];
  assign matrix_unflattened[5][4] = matrix[359:352];
  assign matrix_unflattened[5][5] = matrix[367:360];
  assign matrix_unflattened[5][6] = matrix[375:368];
  assign matrix_unflattened[5][7] = matrix[383:376];
  assign matrix_unflattened[6][0] = matrix[391:384];
  assign matrix_unflattened[6][1] = matrix[399:392];
  assign matrix_unflattened[6][2] = matrix[407:400];
  assign matrix_unflattened[6][3] = matrix[415:408];
  assign matrix_unflattened[6][4] = matrix[423:416];
  assign matrix_unflattened[6][5] = matrix[431:424];
  assign matrix_unflattened[6][6] = matrix[439:432];
  assign matrix_unflattened[6][7] = matrix[447:440];
  assign matrix_unflattened[7][0] = matrix[455:448];
  assign matrix_unflattened[7][1] = matrix[463:456];
  assign matrix_unflattened[7][2] = matrix[471:464];
  assign matrix_unflattened[7][3] = matrix[479:472];
  assign matrix_unflattened[7][4] = matrix[487:480];
  assign matrix_unflattened[7][5] = matrix[495:488];
  assign matrix_unflattened[7][6] = matrix[503:496];
  assign matrix_unflattened[7][7] = matrix[511:504];

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [7:0] p0_matrix[0:7][0:7];
  reg p0_is_luminance;
  always @ (posedge clk) begin
    p0_matrix[0][0] <= matrix_unflattened[0][0];
    p0_matrix[0][1] <= matrix_unflattened[0][1];
    p0_matrix[0][2] <= matrix_unflattened[0][2];
    p0_matrix[0][3] <= matrix_unflattened[0][3];
    p0_matrix[0][4] <= matrix_unflattened[0][4];
    p0_matrix[0][5] <= matrix_unflattened[0][5];
    p0_matrix[0][6] <= matrix_unflattened[0][6];
    p0_matrix[0][7] <= matrix_unflattened[0][7];
    p0_matrix[1][0] <= matrix_unflattened[1][0];
    p0_matrix[1][1] <= matrix_unflattened[1][1];
    p0_matrix[1][2] <= matrix_unflattened[1][2];
    p0_matrix[1][3] <= matrix_unflattened[1][3];
    p0_matrix[1][4] <= matrix_unflattened[1][4];
    p0_matrix[1][5] <= matrix_unflattened[1][5];
    p0_matrix[1][6] <= matrix_unflattened[1][6];
    p0_matrix[1][7] <= matrix_unflattened[1][7];
    p0_matrix[2][0] <= matrix_unflattened[2][0];
    p0_matrix[2][1] <= matrix_unflattened[2][1];
    p0_matrix[2][2] <= matrix_unflattened[2][2];
    p0_matrix[2][3] <= matrix_unflattened[2][3];
    p0_matrix[2][4] <= matrix_unflattened[2][4];
    p0_matrix[2][5] <= matrix_unflattened[2][5];
    p0_matrix[2][6] <= matrix_unflattened[2][6];
    p0_matrix[2][7] <= matrix_unflattened[2][7];
    p0_matrix[3][0] <= matrix_unflattened[3][0];
    p0_matrix[3][1] <= matrix_unflattened[3][1];
    p0_matrix[3][2] <= matrix_unflattened[3][2];
    p0_matrix[3][3] <= matrix_unflattened[3][3];
    p0_matrix[3][4] <= matrix_unflattened[3][4];
    p0_matrix[3][5] <= matrix_unflattened[3][5];
    p0_matrix[3][6] <= matrix_unflattened[3][6];
    p0_matrix[3][7] <= matrix_unflattened[3][7];
    p0_matrix[4][0] <= matrix_unflattened[4][0];
    p0_matrix[4][1] <= matrix_unflattened[4][1];
    p0_matrix[4][2] <= matrix_unflattened[4][2];
    p0_matrix[4][3] <= matrix_unflattened[4][3];
    p0_matrix[4][4] <= matrix_unflattened[4][4];
    p0_matrix[4][5] <= matrix_unflattened[4][5];
    p0_matrix[4][6] <= matrix_unflattened[4][6];
    p0_matrix[4][7] <= matrix_unflattened[4][7];
    p0_matrix[5][0] <= matrix_unflattened[5][0];
    p0_matrix[5][1] <= matrix_unflattened[5][1];
    p0_matrix[5][2] <= matrix_unflattened[5][2];
    p0_matrix[5][3] <= matrix_unflattened[5][3];
    p0_matrix[5][4] <= matrix_unflattened[5][4];
    p0_matrix[5][5] <= matrix_unflattened[5][5];
    p0_matrix[5][6] <= matrix_unflattened[5][6];
    p0_matrix[5][7] <= matrix_unflattened[5][7];
    p0_matrix[6][0] <= matrix_unflattened[6][0];
    p0_matrix[6][1] <= matrix_unflattened[6][1];
    p0_matrix[6][2] <= matrix_unflattened[6][2];
    p0_matrix[6][3] <= matrix_unflattened[6][3];
    p0_matrix[6][4] <= matrix_unflattened[6][4];
    p0_matrix[6][5] <= matrix_unflattened[6][5];
    p0_matrix[6][6] <= matrix_unflattened[6][6];
    p0_matrix[6][7] <= matrix_unflattened[6][7];
    p0_matrix[7][0] <= matrix_unflattened[7][0];
    p0_matrix[7][1] <= matrix_unflattened[7][1];
    p0_matrix[7][2] <= matrix_unflattened[7][2];
    p0_matrix[7][3] <= matrix_unflattened[7][3];
    p0_matrix[7][4] <= matrix_unflattened[7][4];
    p0_matrix[7][5] <= matrix_unflattened[7][5];
    p0_matrix[7][6] <= matrix_unflattened[7][6];
    p0_matrix[7][7] <= matrix_unflattened[7][7];
    p0_is_luminance <= is_luminance;
  end

  // ===== Pipe stage 1:
  wire [7:0] p1_dc_comb;
  wire p1_or_reduce_783_comb;
  wire [2:0] p1_concat_784_comb;
  wire p1_or_reduce_785_comb;
  assign p1_dc_comb = p0_matrix[3'h0][3'h0];
  assign p1_or_reduce_783_comb = |p1_dc_comb[7:3];
  assign p1_concat_784_comb = {1'h0, |p1_dc_comb[7:2] ? 2'h3 : (|p1_dc_comb[7:1] ? 2'h2 : 2'h1)};
  assign p1_or_reduce_785_comb = |p1_dc_comb[7:4];

  // Registers for pipe stage 1:
  reg p1_is_luminance;
  reg [7:0] p1_dc;
  reg p1_or_reduce_783;
  reg [2:0] p1_concat_784;
  reg p1_or_reduce_785;
  always @ (posedge clk) begin
    p1_is_luminance <= p0_is_luminance;
    p1_dc <= p1_dc_comb;
    p1_or_reduce_783 <= p1_or_reduce_783_comb;
    p1_concat_784 <= p1_concat_784_comb;
    p1_or_reduce_785 <= p1_or_reduce_785_comb;
  end

  // ===== Pipe stage 2:
  wire p2_eq_810_comb;
  wire [3:0] p2_concat_812_comb;
  wire [3:0] p2_sel_815_comb;
  wire [3:0] p2_sign_ext_816_comb;
  wire [7:0] p2_code_list_comb;
  assign p2_eq_810_comb = p1_dc == 8'h00;
  assign p2_concat_812_comb = {1'h0, |p1_dc[7:6] ? 3'h7 : (|p1_dc[7:5] ? 3'h6 : (p1_or_reduce_785 ? 3'h5 : (p1_or_reduce_783 ? 3'h4 : p1_concat_784)))};
  assign p2_sel_815_comb = p1_dc[7] ? 4'h8 : p2_concat_812_comb;
  assign p2_sign_ext_816_comb = {4{~p2_eq_810_comb}};
  assign p2_code_list_comb = p2_eq_810_comb ? 8'hff : p1_dc;

  // Registers for pipe stage 2:
  reg p2_is_luminance;
  reg [3:0] p2_sel_815;
  reg [3:0] p2_sign_ext_816;
  reg [7:0] p2_code_list;
  always @ (posedge clk) begin
    p2_is_luminance <= p1_is_luminance;
    p2_sel_815 <= p2_sel_815_comb;
    p2_sign_ext_816 <= p2_sign_ext_816_comb;
    p2_code_list <= p2_code_list_comb;
  end

  // ===== Pipe stage 3:
  wire [3:0] p3_size__1_comb;
  wire [2:0] p3_length_squeezed_squeezed_comb;
  wire [7:0] p3_BoolList_comb;
  wire [7:0] p3_length_comb;
  wire [23:0] p3_tuple_844_comb;
  assign p3_size__1_comb = p2_sel_815 & p2_sign_ext_816;
  assign p3_length_squeezed_squeezed_comb = p2_is_luminance ? literal_829[p3_size__1_comb > 4'hc ? 4'hc : p3_size__1_comb][2:0] : literal_827[p3_size__1_comb > 4'hc ? 4'hc : p3_size__1_comb][2:0];
  assign p3_BoolList_comb = p2_is_luminance ? {literal_830[p3_size__1_comb > 4'hc ? 4'hc : p3_size__1_comb], 1'h0} : literal_833[p3_size__1_comb];
  assign p3_length_comb = {5'h00, p3_length_squeezed_squeezed_comb};
  assign p3_tuple_844_comb = {p3_BoolList_comb, p3_length_comb, p2_code_list};

  // Registers for pipe stage 3:
  reg [23:0] p3_tuple_844;
  always @ (posedge clk) begin
    p3_tuple_844 <= p3_tuple_844_comb;
  end
  assign out = p3_tuple_844;
endmodule
