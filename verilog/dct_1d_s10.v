module dct_1d_s10(
  input wire clk,
  input wire [79:0] x,
  output wire [79:0] out
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [18:0] smul19b_11b_x_9b (input reg [10:0] lhs, input reg [8:0] rhs);
    reg signed [10:0] signed_lhs;
    reg signed [8:0] signed_rhs;
    reg signed [18:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul19b_11b_x_9b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [19:0] smul20b_11b_x_9b (input reg [10:0] lhs, input reg [8:0] rhs);
    reg signed [10:0] signed_lhs;
    reg signed [8:0] signed_rhs;
    reg signed [19:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul20b_11b_x_9b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [17:0] smul18b_18b_x_8b (input reg [17:0] lhs, input reg [7:0] rhs);
    reg signed [17:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [17:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul18b_18b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [17:0] smul18b_18b_x_6b (input reg [17:0] lhs, input reg [5:0] rhs);
    reg signed [17:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [17:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul18b_18b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [18:0] smul19b_19b_x_7b (input reg [18:0] lhs, input reg [6:0] rhs);
    reg signed [18:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [18:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul19b_19b_x_7b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [18:0] smul19b_19b_x_6b (input reg [18:0] lhs, input reg [5:0] rhs);
    reg signed [18:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [18:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul19b_19b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [18:0] smul19b_19b_x_8b (input reg [18:0] lhs, input reg [7:0] rhs);
    reg signed [18:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [18:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul19b_19b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [17:0] smul18b_18b_x_7b (input reg [17:0] lhs, input reg [6:0] rhs);
    reg signed [17:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [17:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul18b_18b_x_7b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [23:0] umul24b_24b_x_7b (input reg [23:0] lhs, input reg [6:0] rhs);
    begin
      umul24b_24b_x_7b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY
  wire [9:0] x_unflattened[0:7];
  assign x_unflattened[0] = x[9:0];
  assign x_unflattened[1] = x[19:10];
  assign x_unflattened[2] = x[29:20];
  assign x_unflattened[3] = x[39:30];
  assign x_unflattened[4] = x[49:40];
  assign x_unflattened[5] = x[59:50];
  assign x_unflattened[6] = x[69:60];
  assign x_unflattened[7] = x[79:70];

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [9:0] p0_x[0:7];
  always @ (posedge clk) begin
    p0_x[0] <= x_unflattened[0];
    p0_x[1] <= x_unflattened[1];
    p0_x[2] <= x_unflattened[2];
    p0_x[3] <= x_unflattened[3];
    p0_x[4] <= x_unflattened[4];
    p0_x[5] <= x_unflattened[5];
    p0_x[6] <= x_unflattened[6];
    p0_x[7] <= x_unflattened[7];
  end

  // ===== Pipe stage 1:
  wire [9:0] p1_array_index_5852_comb;
  wire [9:0] p1_array_index_5853_comb;
  wire [9:0] p1_array_index_5854_comb;
  wire [9:0] p1_array_index_5855_comb;
  wire [9:0] p1_array_index_5856_comb;
  wire [9:0] p1_array_index_5857_comb;
  wire [9:0] p1_array_index_5858_comb;
  wire [9:0] p1_array_index_5859_comb;
  wire [2:0] p1_bit_slice_5860_comb;
  wire [2:0] p1_bit_slice_5861_comb;
  wire [2:0] p1_bit_slice_5862_comb;
  wire [2:0] p1_bit_slice_5863_comb;
  wire [2:0] p1_bit_slice_5864_comb;
  wire [2:0] p1_bit_slice_5865_comb;
  wire [2:0] p1_bit_slice_5866_comb;
  wire [2:0] p1_bit_slice_5867_comb;
  wire [3:0] p1_add_5884_comb;
  wire [3:0] p1_add_5886_comb;
  wire [3:0] p1_add_5888_comb;
  wire [3:0] p1_add_5890_comb;
  wire [3:0] p1_add_5892_comb;
  wire [3:0] p1_add_5894_comb;
  wire [3:0] p1_add_5896_comb;
  wire [3:0] p1_add_5898_comb;
  wire [10:0] p1_concat_5900_comb;
  wire [10:0] p1_concat_5901_comb;
  wire [10:0] p1_concat_5902_comb;
  wire [10:0] p1_concat_5903_comb;
  wire [10:0] p1_concat_5904_comb;
  wire [10:0] p1_concat_5905_comb;
  wire [10:0] p1_concat_5906_comb;
  wire [10:0] p1_concat_5907_comb;
  wire [23:0] p1_sign_ext_5910_comb;
  wire [23:0] p1_sign_ext_5911_comb;
  wire [23:0] p1_sign_ext_5912_comb;
  wire [23:0] p1_sign_ext_5913_comb;
  wire [23:0] p1_sign_ext_5916_comb;
  wire [23:0] p1_sign_ext_5917_comb;
  wire [23:0] p1_sign_ext_5922_comb;
  wire [23:0] p1_sign_ext_5927_comb;
  wire [18:0] p1_smul_6038_comb;
  wire [18:0] p1_smul_6039_comb;
  wire [18:0] p1_smul_6040_comb;
  wire [18:0] p1_smul_6041_comb;
  wire [18:0] p1_smul_6042_comb;
  wire [18:0] p1_smul_6043_comb;
  wire [18:0] p1_smul_6044_comb;
  wire [18:0] p1_smul_6045_comb;
  wire [19:0] p1_smul_5932_comb;
  wire [19:0] p1_smul_5933_comb;
  wire [17:0] p1_bit_slice_5936_comb;
  wire [17:0] p1_bit_slice_5938_comb;
  wire [19:0] p1_smul_5942_comb;
  wire [19:0] p1_smul_5943_comb;
  wire [19:0] p1_smul_5950_comb;
  wire [19:0] p1_smul_5952_comb;
  wire [19:0] p1_smul_5957_comb;
  wire [19:0] p1_smul_5959_comb;
  wire [19:0] p1_smul_5962_comb;
  wire [18:0] p1_bit_slice_5946_comb;
  wire [19:0] p1_smul_5964_comb;
  wire [19:0] p1_smul_5965_comb;
  wire [18:0] p1_bit_slice_5947_comb;
  wire [19:0] p1_smul_5967_comb;
  wire [19:0] p1_smul_5974_comb;
  wire [19:0] p1_smul_5975_comb;
  wire [19:0] p1_smul_5976_comb;
  wire [19:0] p1_smul_5977_comb;
  wire [18:0] p1_add_6064_comb;
  wire [18:0] p1_add_6065_comb;
  wire [18:0] p1_add_6066_comb;
  wire [18:0] p1_add_6067_comb;
  wire [19:0] p1_add_5980_comb;
  wire [17:0] p1_smul_5981_comb;
  wire [17:0] p1_smul_5982_comb;
  wire [17:0] p1_smul_5983_comb;
  wire [17:0] p1_smul_5984_comb;
  wire [19:0] p1_add_5985_comb;
  wire [18:0] p1_smul_5986_comb;
  wire [18:0] p1_smul_5987_comb;
  wire [18:0] p1_smul_5989_comb;
  wire [18:0] p1_smul_5991_comb;
  wire [18:0] p1_smul_5992_comb;
  wire [18:0] p1_smul_5994_comb;
  wire [18:0] p1_smul_6004_comb;
  wire [18:0] p1_smul_6006_comb;
  wire [18:0] p1_smul_6009_comb;
  wire [18:0] p1_smul_6011_comb;
  wire [18:0] p1_smul_6012_comb;
  wire [18:0] p1_smul_6013_comb;
  wire [19:0] p1_add_6014_comb;
  wire [19:0] p1_add_6015_comb;
  wire [24:0] p1_sum__97_comb;
  wire [24:0] p1_sum__98_comb;
  wire [24:0] p1_sum__99_comb;
  wire [24:0] p1_sum__100_comb;
  wire [17:0] p1_bit_slice_5972_comb;
  wire [17:0] p1_bit_slice_5973_comb;
  wire [17:0] p1_bit_slice_5978_comb;
  wire [17:0] p1_bit_slice_5979_comb;
  wire [18:0] p1_bit_slice_6024_comb;
  wire [17:0] p1_add_6025_comb;
  wire [17:0] p1_add_6026_comb;
  wire [18:0] p1_bit_slice_6027_comb;
  wire [17:0] p1_bit_slice_6028_comb;
  wire [17:0] p1_bit_slice_6029_comb;
  wire [18:0] p1_add_6030_comb;
  wire p1_bit_slice_6031_comb;
  wire [18:0] p1_add_6032_comb;
  wire p1_bit_slice_6033_comb;
  wire [18:0] p1_add_6034_comb;
  wire p1_bit_slice_6035_comb;
  wire [18:0] p1_add_6036_comb;
  wire p1_bit_slice_6037_comb;
  wire [18:0] p1_add_6046_comb;
  wire p1_bit_slice_6047_comb;
  wire [18:0] p1_add_6048_comb;
  wire p1_bit_slice_6049_comb;
  wire [18:0] p1_add_6050_comb;
  wire p1_bit_slice_6051_comb;
  wire [18:0] p1_add_6052_comb;
  wire p1_bit_slice_6053_comb;
  wire [17:0] p1_bit_slice_6054_comb;
  wire [17:0] p1_bit_slice_6055_comb;
  wire [18:0] p1_bit_slice_6056_comb;
  wire [18:0] p1_bit_slice_6057_comb;
  wire [11:0] p1_add_6058_comb;
  wire [11:0] p1_add_6059_comb;
  wire [11:0] p1_add_6060_comb;
  wire [11:0] p1_add_6061_comb;
  wire p1_bit_slice_6062_comb;
  wire p1_bit_slice_6063_comb;
  wire p1_bit_slice_6068_comb;
  wire p1_bit_slice_6069_comb;
  wire p1_bit_slice_6070_comb;
  wire p1_bit_slice_6071_comb;
  wire p1_bit_slice_6076_comb;
  wire p1_bit_slice_6077_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  assign p1_array_index_5852_comb = p0_x[3'h2];
  assign p1_array_index_5853_comb = p0_x[3'h3];
  assign p1_array_index_5854_comb = p0_x[3'h4];
  assign p1_array_index_5855_comb = p0_x[3'h5];
  assign p1_array_index_5856_comb = p0_x[3'h1];
  assign p1_array_index_5857_comb = p0_x[3'h6];
  assign p1_array_index_5858_comb = p0_x[3'h0];
  assign p1_array_index_5859_comb = p0_x[3'h7];
  assign p1_bit_slice_5860_comb = p1_array_index_5852_comb[9:7];
  assign p1_bit_slice_5861_comb = p1_array_index_5853_comb[9:7];
  assign p1_bit_slice_5862_comb = p1_array_index_5854_comb[9:7];
  assign p1_bit_slice_5863_comb = p1_array_index_5855_comb[9:7];
  assign p1_bit_slice_5864_comb = p1_array_index_5856_comb[9:7];
  assign p1_bit_slice_5865_comb = p1_array_index_5857_comb[9:7];
  assign p1_bit_slice_5866_comb = p1_array_index_5858_comb[9:7];
  assign p1_bit_slice_5867_comb = p1_array_index_5859_comb[9:7];
  assign p1_add_5884_comb = {{1{p1_bit_slice_5860_comb[2]}}, p1_bit_slice_5860_comb} + 4'hf;
  assign p1_add_5886_comb = {{1{p1_bit_slice_5861_comb[2]}}, p1_bit_slice_5861_comb} + 4'hf;
  assign p1_add_5888_comb = {{1{p1_bit_slice_5862_comb[2]}}, p1_bit_slice_5862_comb} + 4'hf;
  assign p1_add_5890_comb = {{1{p1_bit_slice_5863_comb[2]}}, p1_bit_slice_5863_comb} + 4'hf;
  assign p1_add_5892_comb = {{1{p1_bit_slice_5864_comb[2]}}, p1_bit_slice_5864_comb} + 4'hf;
  assign p1_add_5894_comb = {{1{p1_bit_slice_5865_comb[2]}}, p1_bit_slice_5865_comb} + 4'hf;
  assign p1_add_5896_comb = {{1{p1_bit_slice_5866_comb[2]}}, p1_bit_slice_5866_comb} + 4'hf;
  assign p1_add_5898_comb = {{1{p1_bit_slice_5867_comb[2]}}, p1_bit_slice_5867_comb} + 4'hf;
  assign p1_concat_5900_comb = {p1_add_5884_comb, p1_array_index_5852_comb[6:0]};
  assign p1_concat_5901_comb = {p1_add_5886_comb, p1_array_index_5853_comb[6:0]};
  assign p1_concat_5902_comb = {p1_add_5888_comb, p1_array_index_5854_comb[6:0]};
  assign p1_concat_5903_comb = {p1_add_5890_comb, p1_array_index_5855_comb[6:0]};
  assign p1_concat_5904_comb = {p1_add_5892_comb, p1_array_index_5856_comb[6:0]};
  assign p1_concat_5905_comb = {p1_add_5894_comb, p1_array_index_5857_comb[6:0]};
  assign p1_concat_5906_comb = {p1_add_5896_comb, p1_array_index_5858_comb[6:0]};
  assign p1_concat_5907_comb = {p1_add_5898_comb, p1_array_index_5859_comb[6:0]};
  assign p1_sign_ext_5910_comb = {{13{p1_concat_5900_comb[10]}}, p1_concat_5900_comb};
  assign p1_sign_ext_5911_comb = {{13{p1_concat_5901_comb[10]}}, p1_concat_5901_comb};
  assign p1_sign_ext_5912_comb = {{13{p1_concat_5902_comb[10]}}, p1_concat_5902_comb};
  assign p1_sign_ext_5913_comb = {{13{p1_concat_5903_comb[10]}}, p1_concat_5903_comb};
  assign p1_sign_ext_5916_comb = {{13{p1_concat_5904_comb[10]}}, p1_concat_5904_comb};
  assign p1_sign_ext_5917_comb = {{13{p1_concat_5905_comb[10]}}, p1_concat_5905_comb};
  assign p1_sign_ext_5922_comb = {{13{p1_concat_5906_comb[10]}}, p1_concat_5906_comb};
  assign p1_sign_ext_5927_comb = {{13{p1_concat_5907_comb[10]}}, p1_concat_5907_comb};
  assign p1_smul_6038_comb = smul19b_11b_x_9b(p1_concat_5906_comb, 9'h0b5);
  assign p1_smul_6039_comb = smul19b_11b_x_9b(p1_concat_5904_comb, 9'h14b);
  assign p1_smul_6040_comb = smul19b_11b_x_9b(p1_concat_5900_comb, 9'h14b);
  assign p1_smul_6041_comb = smul19b_11b_x_9b(p1_concat_5901_comb, 9'h0b5);
  assign p1_smul_6042_comb = smul19b_11b_x_9b(p1_concat_5902_comb, 9'h0b5);
  assign p1_smul_6043_comb = smul19b_11b_x_9b(p1_concat_5903_comb, 9'h14b);
  assign p1_smul_6044_comb = smul19b_11b_x_9b(p1_concat_5905_comb, 9'h14b);
  assign p1_smul_6045_comb = smul19b_11b_x_9b(p1_concat_5907_comb, 9'h0b5);
  assign p1_smul_5932_comb = smul20b_11b_x_9b(p1_concat_5906_comb, 9'h0fb);
  assign p1_smul_5933_comb = smul20b_11b_x_9b(p1_concat_5904_comb, 9'h0d5);
  assign p1_bit_slice_5936_comb = p1_sign_ext_5911_comb[17:0];
  assign p1_bit_slice_5938_comb = p1_sign_ext_5912_comb[17:0];
  assign p1_smul_5942_comb = smul20b_11b_x_9b(p1_concat_5905_comb, 9'h12b);
  assign p1_smul_5943_comb = smul20b_11b_x_9b(p1_concat_5907_comb, 9'h105);
  assign p1_smul_5950_comb = smul20b_11b_x_9b(p1_concat_5906_comb, 9'h0d5);
  assign p1_smul_5952_comb = smul20b_11b_x_9b(p1_concat_5900_comb, 9'h105);
  assign p1_smul_5957_comb = smul20b_11b_x_9b(p1_concat_5903_comb, 9'h0fb);
  assign p1_smul_5959_comb = smul20b_11b_x_9b(p1_concat_5907_comb, 9'h12b);
  assign p1_smul_5962_comb = smul20b_11b_x_9b(p1_concat_5904_comb, 9'h105);
  assign p1_bit_slice_5946_comb = p1_sign_ext_5910_comb[18:0];
  assign p1_smul_5964_comb = smul20b_11b_x_9b(p1_concat_5901_comb, 9'h0d5);
  assign p1_smul_5965_comb = smul20b_11b_x_9b(p1_concat_5902_comb, 9'h0d5);
  assign p1_bit_slice_5947_comb = p1_sign_ext_5913_comb[18:0];
  assign p1_smul_5967_comb = smul20b_11b_x_9b(p1_concat_5905_comb, 9'h105);
  assign p1_smul_5974_comb = smul20b_11b_x_9b(p1_concat_5900_comb, 9'h0d5);
  assign p1_smul_5975_comb = smul20b_11b_x_9b(p1_concat_5901_comb, 9'h105);
  assign p1_smul_5976_comb = smul20b_11b_x_9b(p1_concat_5902_comb, 9'h105);
  assign p1_smul_5977_comb = smul20b_11b_x_9b(p1_concat_5903_comb, 9'h0d5);
  assign p1_add_6064_comb = p1_smul_6038_comb + p1_smul_6039_comb;
  assign p1_add_6065_comb = p1_smul_6040_comb + p1_smul_6041_comb;
  assign p1_add_6066_comb = p1_smul_6042_comb + p1_smul_6043_comb;
  assign p1_add_6067_comb = p1_smul_6044_comb + p1_smul_6045_comb;
  assign p1_add_5980_comb = p1_smul_5932_comb + p1_smul_5933_comb;
  assign p1_smul_5981_comb = smul18b_18b_x_8b(p1_sign_ext_5910_comb[17:0], 8'h47);
  assign p1_smul_5982_comb = smul18b_18b_x_6b(p1_bit_slice_5936_comb, 6'h19);
  assign p1_smul_5983_comb = smul18b_18b_x_6b(p1_bit_slice_5938_comb, 6'h27);
  assign p1_smul_5984_comb = smul18b_18b_x_8b(p1_sign_ext_5913_comb[17:0], 8'hb9);
  assign p1_add_5985_comb = p1_smul_5942_comb + p1_smul_5943_comb;
  assign p1_smul_5986_comb = smul19b_19b_x_7b(p1_sign_ext_5916_comb[18:0], 7'h31);
  assign p1_smul_5987_comb = smul19b_19b_x_7b(p1_sign_ext_5917_comb[18:0], 7'h31);
  assign p1_smul_5989_comb = smul19b_19b_x_6b(p1_sign_ext_5916_comb[18:0], 6'h27);
  assign p1_smul_5991_comb = smul19b_19b_x_8b(p1_sign_ext_5911_comb[18:0], 8'hb9);
  assign p1_smul_5992_comb = smul19b_19b_x_8b(p1_sign_ext_5912_comb[18:0], 8'h47);
  assign p1_smul_5994_comb = smul19b_19b_x_6b(p1_sign_ext_5917_comb[18:0], 6'h19);
  assign p1_smul_6004_comb = smul19b_19b_x_8b(p1_sign_ext_5922_comb[18:0], 8'h47);
  assign p1_smul_6006_comb = smul19b_19b_x_6b(p1_bit_slice_5946_comb, 6'h27);
  assign p1_smul_6009_comb = smul19b_19b_x_6b(p1_bit_slice_5947_comb, 6'h27);
  assign p1_smul_6011_comb = smul19b_19b_x_8b(p1_sign_ext_5927_comb[18:0], 8'h47);
  assign p1_smul_6012_comb = smul19b_19b_x_7b(p1_sign_ext_5922_comb[18:0], 7'h31);
  assign p1_smul_6013_comb = smul19b_19b_x_7b(p1_sign_ext_5927_comb[18:0], 7'h31);
  assign p1_add_6014_comb = p1_smul_5974_comb + p1_smul_5975_comb;
  assign p1_add_6015_comb = p1_smul_5976_comb + p1_smul_5977_comb;
  assign p1_sum__97_comb = {{6{p1_add_6064_comb[18]}}, p1_add_6064_comb};
  assign p1_sum__98_comb = {{6{p1_add_6065_comb[18]}}, p1_add_6065_comb};
  assign p1_sum__99_comb = {{6{p1_add_6066_comb[18]}}, p1_add_6066_comb};
  assign p1_sum__100_comb = {{6{p1_add_6067_comb[18]}}, p1_add_6067_comb};
  assign p1_bit_slice_5972_comb = p1_sign_ext_5922_comb[17:0];
  assign p1_bit_slice_5973_comb = p1_sign_ext_5916_comb[17:0];
  assign p1_bit_slice_5978_comb = p1_sign_ext_5917_comb[17:0];
  assign p1_bit_slice_5979_comb = p1_sign_ext_5927_comb[17:0];
  assign p1_bit_slice_6024_comb = p1_add_5980_comb[19:1];
  assign p1_add_6025_comb = p1_smul_5981_comb + p1_smul_5982_comb;
  assign p1_add_6026_comb = p1_smul_5983_comb + p1_smul_5984_comb;
  assign p1_bit_slice_6027_comb = p1_add_5985_comb[19:1];
  assign p1_bit_slice_6028_comb = p1_smul_5986_comb[18:1];
  assign p1_bit_slice_6029_comb = p1_smul_5987_comb[18:1];
  assign p1_add_6030_comb = p1_smul_5950_comb[19:1] + p1_smul_5989_comb;
  assign p1_bit_slice_6031_comb = p1_smul_5950_comb[0];
  assign p1_add_6032_comb = p1_smul_5952_comb[19:1] + p1_smul_5991_comb;
  assign p1_bit_slice_6033_comb = p1_smul_5952_comb[0];
  assign p1_add_6034_comb = p1_smul_5992_comb + p1_smul_5957_comb[19:1];
  assign p1_bit_slice_6035_comb = p1_smul_5957_comb[0];
  assign p1_add_6036_comb = p1_smul_5994_comb + p1_smul_5959_comb[19:1];
  assign p1_bit_slice_6037_comb = p1_smul_5959_comb[0];
  assign p1_add_6046_comb = p1_smul_6004_comb + p1_smul_5962_comb[19:1];
  assign p1_bit_slice_6047_comb = p1_smul_5962_comb[0];
  assign p1_add_6048_comb = p1_smul_6006_comb + p1_smul_5964_comb[19:1];
  assign p1_bit_slice_6049_comb = p1_smul_5964_comb[0];
  assign p1_add_6050_comb = p1_smul_5965_comb[19:1] + p1_smul_6009_comb;
  assign p1_bit_slice_6051_comb = p1_smul_5965_comb[0];
  assign p1_add_6052_comb = p1_smul_5967_comb[19:1] + p1_smul_6011_comb;
  assign p1_bit_slice_6053_comb = p1_smul_5967_comb[0];
  assign p1_bit_slice_6054_comb = p1_smul_6012_comb[18:1];
  assign p1_bit_slice_6055_comb = p1_smul_6013_comb[18:1];
  assign p1_bit_slice_6056_comb = p1_add_6014_comb[19:1];
  assign p1_bit_slice_6057_comb = p1_add_6015_comb[19:1];
  assign p1_add_6058_comb = p1_sign_ext_5922_comb[11:0] + p1_sign_ext_5916_comb[11:0];
  assign p1_add_6059_comb = p1_sign_ext_5910_comb[11:0] + p1_sign_ext_5911_comb[11:0];
  assign p1_add_6060_comb = p1_sign_ext_5912_comb[11:0] + p1_sign_ext_5913_comb[11:0];
  assign p1_add_6061_comb = p1_sign_ext_5917_comb[11:0] + p1_sign_ext_5927_comb[11:0];
  assign p1_bit_slice_6062_comb = p1_smul_5986_comb[0];
  assign p1_bit_slice_6063_comb = p1_smul_5987_comb[0];
  assign p1_bit_slice_6068_comb = p1_smul_6012_comb[0];
  assign p1_bit_slice_6069_comb = p1_smul_6013_comb[0];
  assign p1_bit_slice_6070_comb = p1_add_5980_comb[0];
  assign p1_bit_slice_6071_comb = p1_add_5985_comb[0];
  assign p1_bit_slice_6076_comb = p1_add_6014_comb[0];
  assign p1_bit_slice_6077_comb = p1_add_6015_comb[0];
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;

  // Registers for pipe stage 1:
  reg [17:0] p1_bit_slice_5936;
  reg [17:0] p1_bit_slice_5938;
  reg [18:0] p1_bit_slice_5946;
  reg [18:0] p1_bit_slice_5947;
  reg [17:0] p1_bit_slice_5972;
  reg [17:0] p1_bit_slice_5973;
  reg [17:0] p1_bit_slice_5978;
  reg [17:0] p1_bit_slice_5979;
  reg [18:0] p1_bit_slice_6024;
  reg [17:0] p1_add_6025;
  reg [17:0] p1_add_6026;
  reg [18:0] p1_bit_slice_6027;
  reg [17:0] p1_bit_slice_6028;
  reg [17:0] p1_bit_slice_6029;
  reg [18:0] p1_add_6030;
  reg p1_bit_slice_6031;
  reg [18:0] p1_add_6032;
  reg p1_bit_slice_6033;
  reg [18:0] p1_add_6034;
  reg p1_bit_slice_6035;
  reg [18:0] p1_add_6036;
  reg p1_bit_slice_6037;
  reg [18:0] p1_add_6046;
  reg p1_bit_slice_6047;
  reg [18:0] p1_add_6048;
  reg p1_bit_slice_6049;
  reg [18:0] p1_add_6050;
  reg p1_bit_slice_6051;
  reg [18:0] p1_add_6052;
  reg p1_bit_slice_6053;
  reg [17:0] p1_bit_slice_6054;
  reg [17:0] p1_bit_slice_6055;
  reg [18:0] p1_bit_slice_6056;
  reg [18:0] p1_bit_slice_6057;
  reg [11:0] p1_add_6058;
  reg [11:0] p1_add_6059;
  reg [11:0] p1_add_6060;
  reg [11:0] p1_add_6061;
  reg p1_bit_slice_6062;
  reg p1_bit_slice_6063;
  reg p1_bit_slice_6068;
  reg p1_bit_slice_6069;
  reg p1_bit_slice_6070;
  reg p1_bit_slice_6071;
  reg p1_bit_slice_6076;
  reg p1_bit_slice_6077;
  reg [24:0] p1_sum__77;
  reg [24:0] p1_sum__78;
  always @ (posedge clk) begin
    p1_bit_slice_5936 <= p1_bit_slice_5936_comb;
    p1_bit_slice_5938 <= p1_bit_slice_5938_comb;
    p1_bit_slice_5946 <= p1_bit_slice_5946_comb;
    p1_bit_slice_5947 <= p1_bit_slice_5947_comb;
    p1_bit_slice_5972 <= p1_bit_slice_5972_comb;
    p1_bit_slice_5973 <= p1_bit_slice_5973_comb;
    p1_bit_slice_5978 <= p1_bit_slice_5978_comb;
    p1_bit_slice_5979 <= p1_bit_slice_5979_comb;
    p1_bit_slice_6024 <= p1_bit_slice_6024_comb;
    p1_add_6025 <= p1_add_6025_comb;
    p1_add_6026 <= p1_add_6026_comb;
    p1_bit_slice_6027 <= p1_bit_slice_6027_comb;
    p1_bit_slice_6028 <= p1_bit_slice_6028_comb;
    p1_bit_slice_6029 <= p1_bit_slice_6029_comb;
    p1_add_6030 <= p1_add_6030_comb;
    p1_bit_slice_6031 <= p1_bit_slice_6031_comb;
    p1_add_6032 <= p1_add_6032_comb;
    p1_bit_slice_6033 <= p1_bit_slice_6033_comb;
    p1_add_6034 <= p1_add_6034_comb;
    p1_bit_slice_6035 <= p1_bit_slice_6035_comb;
    p1_add_6036 <= p1_add_6036_comb;
    p1_bit_slice_6037 <= p1_bit_slice_6037_comb;
    p1_add_6046 <= p1_add_6046_comb;
    p1_bit_slice_6047 <= p1_bit_slice_6047_comb;
    p1_add_6048 <= p1_add_6048_comb;
    p1_bit_slice_6049 <= p1_bit_slice_6049_comb;
    p1_add_6050 <= p1_add_6050_comb;
    p1_bit_slice_6051 <= p1_bit_slice_6051_comb;
    p1_add_6052 <= p1_add_6052_comb;
    p1_bit_slice_6053 <= p1_bit_slice_6053_comb;
    p1_bit_slice_6054 <= p1_bit_slice_6054_comb;
    p1_bit_slice_6055 <= p1_bit_slice_6055_comb;
    p1_bit_slice_6056 <= p1_bit_slice_6056_comb;
    p1_bit_slice_6057 <= p1_bit_slice_6057_comb;
    p1_add_6058 <= p1_add_6058_comb;
    p1_add_6059 <= p1_add_6059_comb;
    p1_add_6060 <= p1_add_6060_comb;
    p1_add_6061 <= p1_add_6061_comb;
    p1_bit_slice_6062 <= p1_bit_slice_6062_comb;
    p1_bit_slice_6063 <= p1_bit_slice_6063_comb;
    p1_bit_slice_6068 <= p1_bit_slice_6068_comb;
    p1_bit_slice_6069 <= p1_bit_slice_6069_comb;
    p1_bit_slice_6070 <= p1_bit_slice_6070_comb;
    p1_bit_slice_6071 <= p1_bit_slice_6071_comb;
    p1_bit_slice_6076 <= p1_bit_slice_6076_comb;
    p1_bit_slice_6077 <= p1_bit_slice_6077_comb;
    p1_sum__77 <= p1_sum__77_comb;
    p1_sum__78 <= p1_sum__78_comb;
  end

  // ===== Pipe stage 2:
  wire [18:0] p2_smul_6185_comb;
  wire [18:0] p2_smul_6188_comb;
  wire [18:0] p2_smul_6191_comb;
  wire [18:0] p2_smul_6194_comb;
  wire [17:0] p2_smul_6196_comb;
  wire [17:0] p2_smul_6197_comb;
  wire [17:0] p2_smul_6198_comb;
  wire [17:0] p2_smul_6199_comb;
  wire [19:0] p2_concat_6224_comb;
  wire [19:0] p2_concat_6225_comb;
  wire [19:0] p2_concat_6226_comb;
  wire [19:0] p2_concat_6227_comb;
  wire [19:0] p2_concat_6228_comb;
  wire [19:0] p2_concat_6229_comb;
  wire [19:0] p2_concat_6230_comb;
  wire [19:0] p2_concat_6231_comb;
  wire [17:0] p2_smul_6200_comb;
  wire [17:0] p2_smul_6202_comb;
  wire [17:0] p2_smul_6203_comb;
  wire [17:0] p2_smul_6205_comb;
  wire [17:0] p2_smul_6206_comb;
  wire [17:0] p2_smul_6208_comb;
  wire [17:0] p2_smul_6209_comb;
  wire [17:0] p2_smul_6211_comb;
  wire [17:0] p2_add_6212_comb;
  wire [17:0] p2_add_6213_comb;
  wire [23:0] p2_add_6246_comb;
  wire [23:0] p2_add_6247_comb;
  wire [24:0] p2_sum__101_comb;
  wire [24:0] p2_sum__102_comb;
  wire [24:0] p2_sum__103_comb;
  wire [24:0] p2_sum__104_comb;
  wire [24:0] p2_sum__93_comb;
  wire [24:0] p2_sum__94_comb;
  wire [24:0] p2_sum__95_comb;
  wire [24:0] p2_sum__96_comb;
  wire [17:0] p2_add_6218_comb;
  wire [17:0] p2_add_6219_comb;
  wire [17:0] p2_add_6221_comb;
  wire [17:0] p2_add_6223_comb;
  wire [17:0] p2_add_6232_comb;
  wire [17:0] p2_add_6233_comb;
  wire [17:0] p2_add_6235_comb;
  wire [17:0] p2_add_6237_comb;
  wire [23:0] p2_add_6266_comb;
  wire [23:0] p2_add_6267_comb;
  wire [24:0] p2_sum__83_comb;
  wire [24:0] p2_sum__84_comb;
  wire [24:0] p2_sum__79_comb;
  wire [24:0] p2_sum__80_comb;
  wire [24:0] p2_sum__75_comb;
  wire [24:0] p2_sum__76_comb;
  wire [18:0] p2_concat_6248_comb;
  wire [18:0] p2_concat_6249_comb;
  wire [18:0] p2_concat_6250_comb;
  wire [18:0] p2_concat_6251_comb;
  wire [18:0] p2_concat_6260_comb;
  wire [18:0] p2_concat_6261_comb;
  wire [18:0] p2_concat_6262_comb;
  wire [18:0] p2_concat_6263_comb;
  wire [23:0] p2_add_6264_comb;
  wire [23:0] p2_add_6265_comb;
  wire [23:0] p2_add_6284_comb;
  wire [24:0] p2_sum__70_comb;
  wire [24:0] p2_sum__68_comb;
  wire [24:0] p2_sum__67_comb;
  wire [24:0] p2_sum__66_comb;
  wire [24:0] p2_sum__71_comb;
  wire [24:0] p2_sum__72_comb;
  wire [23:0] p2_umul_2673_NarrowedMult__comb;
  wire [24:0] p2_add_6301_comb;
  wire [24:0] p2_add_6303_comb;
  wire [24:0] p2_add_6304_comb;
  wire [24:0] p2_add_6305_comb;
  wire [23:0] p2_add_6288_comb;
  wire [23:0] p2_add_6289_comb;
  wire [23:0] p2_add_6296_comb;
  wire [23:0] p2_add_6297_comb;
  wire [24:0] p2_sum__64_comb;
  wire [16:0] p2_bit_slice_6308_comb;
  wire [16:0] p2_bit_slice_6309_comb;
  wire [16:0] p2_bit_slice_6311_comb;
  wire [16:0] p2_bit_slice_6312_comb;
  wire [16:0] p2_bit_slice_6313_comb;
  wire [23:0] p2_add_6302_comb;
  wire [23:0] p2_add_6306_comb;
  wire [24:0] p2_add_6307_comb;
  wire [16:0] p2_bit_slice_6310_comb;
  wire [16:0] p2_bit_slice_6314_comb;
  wire [16:0] p2_bit_slice_6315_comb;
  wire [17:0] p2_add_6329_comb;
  wire [17:0] p2_add_6330_comb;
  wire [17:0] p2_add_6331_comb;
  wire [17:0] p2_add_6332_comb;
  wire [17:0] p2_add_6333_comb;
  wire [17:0] p2_sign_ext_6320_comb;
  wire [17:0] p2_sign_ext_6327_comb;
  wire [17:0] p2_sign_ext_6328_comb;
  wire [9:0] p2_bit_slice_6334_comb;
  wire [9:0] p2_bit_slice_6335_comb;
  wire [9:0] p2_bit_slice_6336_comb;
  wire [9:0] p2_bit_slice_6337_comb;
  wire [9:0] p2_bit_slice_6338_comb;
  wire [6:0] p2_bit_slice_6339_comb;
  wire [6:0] p2_bit_slice_6340_comb;
  wire [6:0] p2_bit_slice_6341_comb;
  wire [6:0] p2_bit_slice_6342_comb;
  wire [6:0] p2_bit_slice_6343_comb;
  assign p2_smul_6185_comb = smul19b_19b_x_7b(p1_bit_slice_5946, 7'h4f);
  assign p2_smul_6188_comb = smul19b_19b_x_7b(p1_bit_slice_5947, 7'h4f);
  assign p2_smul_6191_comb = smul19b_19b_x_7b(p1_bit_slice_5946, 7'h31);
  assign p2_smul_6194_comb = smul19b_19b_x_7b(p1_bit_slice_5947, 7'h31);
  assign p2_smul_6196_comb = smul18b_18b_x_6b(p1_bit_slice_5972, 6'h19);
  assign p2_smul_6197_comb = smul18b_18b_x_8b(p1_bit_slice_5973, 8'hb9);
  assign p2_smul_6198_comb = smul18b_18b_x_8b(p1_bit_slice_5978, 8'hb9);
  assign p2_smul_6199_comb = smul18b_18b_x_6b(p1_bit_slice_5979, 6'h19);
  assign p2_concat_6224_comb = {p1_add_6030, p1_bit_slice_6031};
  assign p2_concat_6225_comb = {p1_add_6032, p1_bit_slice_6033};
  assign p2_concat_6226_comb = {p1_add_6034, p1_bit_slice_6035};
  assign p2_concat_6227_comb = {p1_add_6036, p1_bit_slice_6037};
  assign p2_concat_6228_comb = {p1_add_6046, p1_bit_slice_6047};
  assign p2_concat_6229_comb = {p1_add_6048, p1_bit_slice_6049};
  assign p2_concat_6230_comb = {p1_add_6050, p1_bit_slice_6051};
  assign p2_concat_6231_comb = {p1_add_6052, p1_bit_slice_6053};
  assign p2_smul_6200_comb = smul18b_18b_x_7b(p1_bit_slice_5972, 7'h3b);
  assign p2_smul_6202_comb = smul18b_18b_x_7b(p1_bit_slice_5936, 7'h45);
  assign p2_smul_6203_comb = smul18b_18b_x_7b(p1_bit_slice_5938, 7'h45);
  assign p2_smul_6205_comb = smul18b_18b_x_7b(p1_bit_slice_5979, 7'h3b);
  assign p2_smul_6206_comb = smul18b_18b_x_7b(p1_bit_slice_5973, 7'h45);
  assign p2_smul_6208_comb = smul18b_18b_x_7b(p1_bit_slice_5936, 7'h3b);
  assign p2_smul_6209_comb = smul18b_18b_x_7b(p1_bit_slice_5938, 7'h3b);
  assign p2_smul_6211_comb = smul18b_18b_x_7b(p1_bit_slice_5978, 7'h45);
  assign p2_add_6212_comb = p2_smul_6196_comb + p2_smul_6197_comb;
  assign p2_add_6213_comb = p2_smul_6198_comb + p2_smul_6199_comb;
  assign p2_add_6246_comb = {{5{p1_bit_slice_6024[18]}}, p1_bit_slice_6024} + {{6{p1_add_6025[17]}}, p1_add_6025};
  assign p2_add_6247_comb = {{6{p1_add_6026[17]}}, p1_add_6026} + {{5{p1_bit_slice_6027[18]}}, p1_bit_slice_6027};
  assign p2_sum__101_comb = {{5{p2_concat_6224_comb[19]}}, p2_concat_6224_comb};
  assign p2_sum__102_comb = {{5{p2_concat_6225_comb[19]}}, p2_concat_6225_comb};
  assign p2_sum__103_comb = {{5{p2_concat_6226_comb[19]}}, p2_concat_6226_comb};
  assign p2_sum__104_comb = {{5{p2_concat_6227_comb[19]}}, p2_concat_6227_comb};
  assign p2_sum__93_comb = {{5{p2_concat_6228_comb[19]}}, p2_concat_6228_comb};
  assign p2_sum__94_comb = {{5{p2_concat_6229_comb[19]}}, p2_concat_6229_comb};
  assign p2_sum__95_comb = {{5{p2_concat_6230_comb[19]}}, p2_concat_6230_comb};
  assign p2_sum__96_comb = {{5{p2_concat_6231_comb[19]}}, p2_concat_6231_comb};
  assign p2_add_6218_comb = p2_smul_6200_comb + p1_bit_slice_6028;
  assign p2_add_6219_comb = p2_smul_6185_comb[18:1] + p2_smul_6202_comb;
  assign p2_add_6221_comb = p2_smul_6203_comb + p2_smul_6188_comb[18:1];
  assign p2_add_6223_comb = p1_bit_slice_6029 + p2_smul_6205_comb;
  assign p2_add_6232_comb = p1_bit_slice_6054 + p2_smul_6206_comb;
  assign p2_add_6233_comb = p2_smul_6191_comb[18:1] + p2_smul_6208_comb;
  assign p2_add_6235_comb = p2_smul_6209_comb + p2_smul_6194_comb[18:1];
  assign p2_add_6237_comb = p2_smul_6211_comb + p1_bit_slice_6055;
  assign p2_add_6266_comb = {{12{p1_add_6058[11]}}, p1_add_6058} + {{12{p1_add_6059[11]}}, p1_add_6059};
  assign p2_add_6267_comb = {{12{p1_add_6060[11]}}, p1_add_6060} + {{12{p1_add_6061[11]}}, p1_add_6061};
  assign p2_sum__83_comb = {p2_add_6246_comb, p1_bit_slice_6070};
  assign p2_sum__84_comb = {p2_add_6247_comb, p1_bit_slice_6071};
  assign p2_sum__79_comb = p2_sum__101_comb + p2_sum__102_comb;
  assign p2_sum__80_comb = p2_sum__103_comb + p2_sum__104_comb;
  assign p2_sum__75_comb = p2_sum__93_comb + p2_sum__94_comb;
  assign p2_sum__76_comb = p2_sum__95_comb + p2_sum__96_comb;
  assign p2_concat_6248_comb = {p2_add_6218_comb, p1_bit_slice_6062};
  assign p2_concat_6249_comb = {p2_add_6219_comb, p2_smul_6185_comb[0]};
  assign p2_concat_6250_comb = {p2_add_6221_comb, p2_smul_6188_comb[0]};
  assign p2_concat_6251_comb = {p2_add_6223_comb, p1_bit_slice_6063};
  assign p2_concat_6260_comb = {p2_add_6232_comb, p1_bit_slice_6068};
  assign p2_concat_6261_comb = {p2_add_6233_comb, p2_smul_6191_comb[0]};
  assign p2_concat_6262_comb = {p2_add_6235_comb, p2_smul_6194_comb[0]};
  assign p2_concat_6263_comb = {p2_add_6237_comb, p1_bit_slice_6069};
  assign p2_add_6264_comb = {{6{p2_add_6212_comb[17]}}, p2_add_6212_comb} + {{5{p1_bit_slice_6056[18]}}, p1_bit_slice_6056};
  assign p2_add_6265_comb = {{5{p1_bit_slice_6057[18]}}, p1_bit_slice_6057} + {{6{p2_add_6213_comb[17]}}, p2_add_6213_comb};
  assign p2_add_6284_comb = p2_add_6266_comb + p2_add_6267_comb;
  assign p2_sum__70_comb = p2_sum__83_comb + p2_sum__84_comb;
  assign p2_sum__68_comb = p2_sum__79_comb + p2_sum__80_comb;
  assign p2_sum__67_comb = p1_sum__77 + p1_sum__78;
  assign p2_sum__66_comb = p2_sum__75_comb + p2_sum__76_comb;
  assign p2_sum__71_comb = {p2_add_6264_comb, p1_bit_slice_6076};
  assign p2_sum__72_comb = {p2_add_6265_comb, p1_bit_slice_6077};
  assign p2_umul_2673_NarrowedMult__comb = umul24b_24b_x_7b(p2_add_6284_comb, 7'h5b);
  assign p2_add_6301_comb = p2_sum__70_comb + 25'h000_0001;
  assign p2_add_6303_comb = p2_sum__68_comb + 25'h000_0001;
  assign p2_add_6304_comb = p2_sum__67_comb + 25'h000_0001;
  assign p2_add_6305_comb = p2_sum__66_comb + 25'h000_0001;
  assign p2_add_6288_comb = {{5{p2_concat_6248_comb[18]}}, p2_concat_6248_comb} + {{5{p2_concat_6249_comb[18]}}, p2_concat_6249_comb};
  assign p2_add_6289_comb = {{5{p2_concat_6250_comb[18]}}, p2_concat_6250_comb} + {{5{p2_concat_6251_comb[18]}}, p2_concat_6251_comb};
  assign p2_add_6296_comb = {{5{p2_concat_6260_comb[18]}}, p2_concat_6260_comb} + {{5{p2_concat_6261_comb[18]}}, p2_concat_6261_comb};
  assign p2_add_6297_comb = {{5{p2_concat_6262_comb[18]}}, p2_concat_6262_comb} + {{5{p2_concat_6263_comb[18]}}, p2_concat_6263_comb};
  assign p2_sum__64_comb = p2_sum__71_comb + p2_sum__72_comb;
  assign p2_bit_slice_6308_comb = p2_umul_2673_NarrowedMult__comb[23:7];
  assign p2_bit_slice_6309_comb = p2_add_6301_comb[24:8];
  assign p2_bit_slice_6311_comb = p2_add_6303_comb[24:8];
  assign p2_bit_slice_6312_comb = p2_add_6304_comb[24:8];
  assign p2_bit_slice_6313_comb = p2_add_6305_comb[24:8];
  assign p2_add_6302_comb = p2_add_6288_comb + p2_add_6289_comb;
  assign p2_add_6306_comb = p2_add_6296_comb + p2_add_6297_comb;
  assign p2_add_6307_comb = p2_sum__64_comb + 25'h000_0001;
  assign p2_bit_slice_6310_comb = p2_add_6302_comb[23:7];
  assign p2_bit_slice_6314_comb = p2_add_6306_comb[23:7];
  assign p2_bit_slice_6315_comb = p2_add_6307_comb[24:8];
  assign p2_add_6329_comb = {{1{p2_bit_slice_6308_comb[16]}}, p2_bit_slice_6308_comb} + 18'h0_0001;
  assign p2_add_6330_comb = {{1{p2_bit_slice_6309_comb[16]}}, p2_bit_slice_6309_comb} + 18'h0_0001;
  assign p2_add_6331_comb = {{1{p2_bit_slice_6311_comb[16]}}, p2_bit_slice_6311_comb} + 18'h0_0001;
  assign p2_add_6332_comb = {{1{p2_bit_slice_6312_comb[16]}}, p2_bit_slice_6312_comb} + 18'h0_0001;
  assign p2_add_6333_comb = {{1{p2_bit_slice_6313_comb[16]}}, p2_bit_slice_6313_comb} + 18'h0_0001;
  assign p2_sign_ext_6320_comb = {{1{p2_bit_slice_6310_comb[16]}}, p2_bit_slice_6310_comb};
  assign p2_sign_ext_6327_comb = {{1{p2_bit_slice_6314_comb[16]}}, p2_bit_slice_6314_comb};
  assign p2_sign_ext_6328_comb = {{1{p2_bit_slice_6315_comb[16]}}, p2_bit_slice_6315_comb};
  assign p2_bit_slice_6334_comb = p2_add_6329_comb[17:8];
  assign p2_bit_slice_6335_comb = p2_add_6330_comb[17:8];
  assign p2_bit_slice_6336_comb = p2_add_6331_comb[17:8];
  assign p2_bit_slice_6337_comb = p2_add_6332_comb[17:8];
  assign p2_bit_slice_6338_comb = p2_add_6333_comb[17:8];
  assign p2_bit_slice_6339_comb = p2_add_6329_comb[7:1];
  assign p2_bit_slice_6340_comb = p2_add_6330_comb[7:1];
  assign p2_bit_slice_6341_comb = p2_add_6331_comb[7:1];
  assign p2_bit_slice_6342_comb = p2_add_6332_comb[7:1];
  assign p2_bit_slice_6343_comb = p2_add_6333_comb[7:1];

  // Registers for pipe stage 2:
  reg [17:0] p2_sign_ext_6320;
  reg [17:0] p2_sign_ext_6327;
  reg [17:0] p2_sign_ext_6328;
  reg [9:0] p2_bit_slice_6334;
  reg [9:0] p2_bit_slice_6335;
  reg [9:0] p2_bit_slice_6336;
  reg [9:0] p2_bit_slice_6337;
  reg [9:0] p2_bit_slice_6338;
  reg [6:0] p2_bit_slice_6339;
  reg [6:0] p2_bit_slice_6340;
  reg [6:0] p2_bit_slice_6341;
  reg [6:0] p2_bit_slice_6342;
  reg [6:0] p2_bit_slice_6343;
  always @ (posedge clk) begin
    p2_sign_ext_6320 <= p2_sign_ext_6320_comb;
    p2_sign_ext_6327 <= p2_sign_ext_6327_comb;
    p2_sign_ext_6328 <= p2_sign_ext_6328_comb;
    p2_bit_slice_6334 <= p2_bit_slice_6334_comb;
    p2_bit_slice_6335 <= p2_bit_slice_6335_comb;
    p2_bit_slice_6336 <= p2_bit_slice_6336_comb;
    p2_bit_slice_6337 <= p2_bit_slice_6337_comb;
    p2_bit_slice_6338 <= p2_bit_slice_6338_comb;
    p2_bit_slice_6339 <= p2_bit_slice_6339_comb;
    p2_bit_slice_6340 <= p2_bit_slice_6340_comb;
    p2_bit_slice_6341 <= p2_bit_slice_6341_comb;
    p2_bit_slice_6342 <= p2_bit_slice_6342_comb;
    p2_bit_slice_6343 <= p2_bit_slice_6343_comb;
  end

  // ===== Pipe stage 3:
  wire [17:0] p3_add_6373_comb;
  wire [17:0] p3_add_6374_comb;
  wire [17:0] p3_add_6375_comb;
  wire [9:0] p3_bit_slice_6376_comb;
  wire [9:0] p3_bit_slice_6377_comb;
  wire [9:0] p3_bit_slice_6378_comb;
  wire [10:0] p3_add_6395_comb;
  wire [10:0] p3_add_6396_comb;
  wire [10:0] p3_add_6397_comb;
  wire [10:0] p3_add_6399_comb;
  wire [10:0] p3_add_6400_comb;
  wire [10:0] p3_add_6401_comb;
  wire [10:0] p3_add_6402_comb;
  wire [10:0] p3_add_6404_comb;
  wire [17:0] p3_concat_6406_comb;
  wire [17:0] p3_concat_6409_comb;
  wire [17:0] p3_concat_6412_comb;
  wire [17:0] p3_concat_6415_comb;
  wire [17:0] p3_concat_6418_comb;
  wire [17:0] p3_concat_6421_comb;
  wire [17:0] p3_concat_6424_comb;
  wire [17:0] p3_concat_6427_comb;
  wire [9:0] p3_clipped__8_comb;
  wire [9:0] p3_clipped__9_comb;
  wire [9:0] p3_clipped__10_comb;
  wire [9:0] p3_clipped__11_comb;
  wire [9:0] p3_clipped__12_comb;
  wire [9:0] p3_clipped__13_comb;
  wire [9:0] p3_clipped__14_comb;
  wire [9:0] p3_clipped__15_comb;
  wire [9:0] p3_result_comb[0:7];
  assign p3_add_6373_comb = p2_sign_ext_6320 + 18'h0_0001;
  assign p3_add_6374_comb = p2_sign_ext_6327 + 18'h0_0001;
  assign p3_add_6375_comb = p2_sign_ext_6328 + 18'h0_0001;
  assign p3_bit_slice_6376_comb = p3_add_6373_comb[17:8];
  assign p3_bit_slice_6377_comb = p3_add_6374_comb[17:8];
  assign p3_bit_slice_6378_comb = p3_add_6375_comb[17:8];
  assign p3_add_6395_comb = {{1{p2_bit_slice_6334[9]}}, p2_bit_slice_6334} + 11'h001;
  assign p3_add_6396_comb = {{1{p2_bit_slice_6335[9]}}, p2_bit_slice_6335} + 11'h001;
  assign p3_add_6397_comb = {{1{p3_bit_slice_6376_comb[9]}}, p3_bit_slice_6376_comb} + 11'h001;
  assign p3_add_6399_comb = {{1{p2_bit_slice_6336[9]}}, p2_bit_slice_6336} + 11'h001;
  assign p3_add_6400_comb = {{1{p2_bit_slice_6337[9]}}, p2_bit_slice_6337} + 11'h001;
  assign p3_add_6401_comb = {{1{p2_bit_slice_6338[9]}}, p2_bit_slice_6338} + 11'h001;
  assign p3_add_6402_comb = {{1{p3_bit_slice_6377_comb[9]}}, p3_bit_slice_6377_comb} + 11'h001;
  assign p3_add_6404_comb = {{1{p3_bit_slice_6378_comb[9]}}, p3_bit_slice_6378_comb} + 11'h001;
  assign p3_concat_6406_comb = {p3_add_6395_comb, p2_bit_slice_6339};
  assign p3_concat_6409_comb = {p3_add_6396_comb, p2_bit_slice_6340};
  assign p3_concat_6412_comb = {p3_add_6397_comb, p3_add_6373_comb[7:1]};
  assign p3_concat_6415_comb = {p3_add_6399_comb, p2_bit_slice_6341};
  assign p3_concat_6418_comb = {p3_add_6400_comb, p2_bit_slice_6342};
  assign p3_concat_6421_comb = {p3_add_6401_comb, p2_bit_slice_6343};
  assign p3_concat_6424_comb = {p3_add_6402_comb, p3_add_6374_comb[7:1]};
  assign p3_concat_6427_comb = {p3_add_6404_comb, p3_add_6375_comb[7:1]};
  assign p3_clipped__8_comb = $signed(p3_concat_6406_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6406_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6395_comb[2:0], p2_bit_slice_6339});
  assign p3_clipped__9_comb = $signed(p3_concat_6409_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6409_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6396_comb[2:0], p2_bit_slice_6340});
  assign p3_clipped__10_comb = $signed(p3_concat_6412_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6412_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6397_comb[2:0], p3_add_6373_comb[7:1]});
  assign p3_clipped__11_comb = $signed(p3_concat_6415_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6415_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6399_comb[2:0], p2_bit_slice_6341});
  assign p3_clipped__12_comb = $signed(p3_concat_6418_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6418_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6400_comb[2:0], p2_bit_slice_6342});
  assign p3_clipped__13_comb = $signed(p3_concat_6421_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6421_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6401_comb[2:0], p2_bit_slice_6343});
  assign p3_clipped__14_comb = $signed(p3_concat_6424_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6424_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6402_comb[2:0], p3_add_6374_comb[7:1]});
  assign p3_clipped__15_comb = $signed(p3_concat_6427_comb) < $signed(18'h3_fe01) ? 10'h201 : ($signed(p3_concat_6427_comb) > $signed(18'h0_01ff) ? 10'h1ff : {p3_add_6404_comb[2:0], p3_add_6375_comb[7:1]});
  assign p3_result_comb[0] = p3_clipped__8_comb;
  assign p3_result_comb[1] = p3_clipped__9_comb;
  assign p3_result_comb[2] = p3_clipped__10_comb;
  assign p3_result_comb[3] = p3_clipped__11_comb;
  assign p3_result_comb[4] = p3_clipped__12_comb;
  assign p3_result_comb[5] = p3_clipped__13_comb;
  assign p3_result_comb[6] = p3_clipped__14_comb;
  assign p3_result_comb[7] = p3_clipped__15_comb;

  // Registers for pipe stage 3:
  reg [9:0] p3_result[0:7];
  always @ (posedge clk) begin
    p3_result[0] <= p3_result_comb[0];
    p3_result[1] <= p3_result_comb[1];
    p3_result[2] <= p3_result_comb[2];
    p3_result[3] <= p3_result_comb[3];
    p3_result[4] <= p3_result_comb[4];
    p3_result[5] <= p3_result_comb[5];
    p3_result[6] <= p3_result_comb[6];
    p3_result[7] <= p3_result_comb[7];
  end
  assign out = {p3_result[7], p3_result[6], p3_result[5], p3_result[4], p3_result[3], p3_result[2], p3_result[1], p3_result[0]};
endmodule
