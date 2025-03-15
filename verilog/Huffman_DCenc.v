module Huffman_DCenc(
  input wire clk,
  input wire [9:0] dc_in,
  input wire is_luminance,
  output wire [32:0] out
);
  wire [7:0] literal_705[0:12];
  assign literal_705[0] = 8'h01;
  assign literal_705[1] = 8'h00;
  assign literal_705[2] = 8'h04;
  assign literal_705[3] = 8'h05;
  assign literal_705[4] = 8'h0c;
  assign literal_705[5] = 8'h0d;
  assign literal_705[6] = 8'h0e;
  assign literal_705[7] = 8'h1e;
  assign literal_705[8] = 8'h3e;
  assign literal_705[9] = 8'h7e;
  assign literal_705[10] = 8'hfe;
  assign literal_705[11] = 8'hfe;
  assign literal_705[12] = 8'h00;
  wire [7:0] literal_707[0:12];
  assign literal_707[0] = 8'h06;
  assign literal_707[1] = 8'h05;
  assign literal_707[2] = 8'h03;
  assign literal_707[3] = 8'h02;
  assign literal_707[4] = 8'h00;
  assign literal_707[5] = 8'h01;
  assign literal_707[6] = 8'h04;
  assign literal_707[7] = 8'h0e;
  assign literal_707[8] = 8'h1e;
  assign literal_707[9] = 8'h3e;
  assign literal_707[10] = 8'h7e;
  assign literal_707[11] = 8'hfe;
  assign literal_707[12] = 8'h00;
  wire [3:0] literal_708[0:12];
  assign literal_708[0] = 4'h2;
  assign literal_708[1] = 4'h2;
  assign literal_708[2] = 4'h3;
  assign literal_708[3] = 4'h3;
  assign literal_708[4] = 4'h4;
  assign literal_708[5] = 4'h4;
  assign literal_708[6] = 4'h4;
  assign literal_708[7] = 4'h5;
  assign literal_708[8] = 4'h6;
  assign literal_708[9] = 4'h7;
  assign literal_708[10] = 4'h8;
  assign literal_708[11] = 4'h9;
  assign literal_708[12] = 4'h0;
  wire [3:0] literal_709[0:12];
  assign literal_709[0] = 4'h3;
  assign literal_709[1] = 4'h3;
  assign literal_709[2] = 4'h3;
  assign literal_709[3] = 4'h3;
  assign literal_709[4] = 4'h3;
  assign literal_709[5] = 4'h3;
  assign literal_709[6] = 4'h3;
  assign literal_709[7] = 4'h4;
  assign literal_709[8] = 4'h5;
  assign literal_709[9] = 4'h6;
  assign literal_709[10] = 4'h7;
  assign literal_709[11] = 4'h8;
  assign literal_709[12] = 4'h0;

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [9:0] p0_dc_in;
  reg p0_is_luminance;
  always @ (posedge clk) begin
    p0_dc_in <= dc_in;
    p0_is_luminance <= is_luminance;
  end

  // ===== Pipe stage 1:
  wire [7:0] p1_bin_value__1_comb;
  wire [7:0] p1_bin_value_comb;
  wire [7:0] p1_dc_in_abs_comb;
  wire p1_BoolList_squeezed_const_msb_bits_comb;
  wire [2:0] p1_sel_684_comb;
  wire p1_BoolList_squeezed_const_msb_bits__1_comb;
  wire [3:0] p1_concat_696_comb;
  wire [3:0] p1_Length_squeezed_const_msb_bits_comb;
  wire [7:0] p1_Code_size_comb;
  wire [3:0] p1_bit_slice_706_comb;
  wire [5:0] p1_BoolList_squeezed_squeezed_comb;
  wire [2:0] p1_Length_squeezed_squeezed_comb;
  wire [7:0] p1_flipped_comb;
  wire [8:0] p1_BoolList_comb;
  wire [7:0] p1_Length_comb;
  wire [7:0] p1_Code_list_comb;
  wire [32:0] p1_tuple_728_comb;
  assign p1_bin_value__1_comb = p0_dc_in[7:0];
  assign p1_bin_value_comb = -p1_bin_value__1_comb;
  assign p1_dc_in_abs_comb = p0_dc_in[9] ? p1_bin_value_comb : p1_bin_value__1_comb;
  assign p1_BoolList_squeezed_const_msb_bits_comb = 1'h0;
  assign p1_sel_684_comb = |p1_dc_in_abs_comb[7:3] ? 3'h4 : {p1_BoolList_squeezed_const_msb_bits_comb, |p1_dc_in_abs_comb[7:2] ? 2'h3 : (|p1_dc_in_abs_comb[7:1] ? 2'h2 : 2'h1)};
  assign p1_BoolList_squeezed_const_msb_bits__1_comb = 1'h0;
  assign p1_concat_696_comb = {p1_BoolList_squeezed_const_msb_bits__1_comb, |p1_dc_in_abs_comb[7:6] ? 3'h7 : (|p1_dc_in_abs_comb[7:5] ? 3'h6 : (|p1_dc_in_abs_comb[7:4] ? 3'h5 : p1_sel_684_comb))};
  assign p1_Length_squeezed_const_msb_bits_comb = 4'h0;
  assign p1_Code_size_comb = {p1_Length_squeezed_const_msb_bits_comb, p1_dc_in_abs_comb[7] ? 4'h8 : p1_concat_696_comb} & {8{p1_dc_in_abs_comb != 8'h00}};
  assign p1_bit_slice_706_comb = p1_Code_size_comb[3:0];
  assign p1_BoolList_squeezed_squeezed_comb = p0_is_luminance ? literal_707[p1_bit_slice_706_comb > 4'hc ? 4'hc : p1_bit_slice_706_comb][5:0] : literal_705[p1_bit_slice_706_comb > 4'hc ? 4'hc : p1_bit_slice_706_comb][5:0];
  assign p1_Length_squeezed_squeezed_comb = p0_is_luminance ? literal_709[p1_bit_slice_706_comb > 4'hc ? 4'hc : p1_bit_slice_706_comb][2:0] : literal_708[p1_bit_slice_706_comb > 4'hc ? 4'hc : p1_bit_slice_706_comb][2:0];
  assign p1_flipped_comb = ~p1_bin_value_comb;
  assign p1_BoolList_comb = {3'h0, p1_BoolList_squeezed_squeezed_comb};
  assign p1_Length_comb = {5'h00, p1_Length_squeezed_squeezed_comb};
  assign p1_Code_list_comb = $signed(p0_dc_in) <= $signed(10'h000) ? p1_flipped_comb : p1_bin_value__1_comb;
  assign p1_tuple_728_comb = {p1_BoolList_comb, p1_Length_comb, p1_Code_list_comb, p1_Code_size_comb};

  // Registers for pipe stage 1:
  reg [32:0] p1_tuple_728;
  always @ (posedge clk) begin
    p1_tuple_728 <= p1_tuple_728_comb;
  end
  assign out = p1_tuple_728;
endmodule
