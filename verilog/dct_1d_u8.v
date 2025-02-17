module dct_1d_u8(
  input wire clk,
  input wire [63:0] x,
  output wire [63:0] out
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [15:0] smul16b_8b_x_9b (input reg [7:0] lhs, input reg [8:0] rhs);
    reg signed [7:0] signed_lhs;
    reg signed [8:0] signed_rhs;
    reg signed [15:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul16b_8b_x_9b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [14:0] smul15b_8b_x_8b (input reg [7:0] lhs, input reg [7:0] rhs);
    reg signed [7:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [14:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul15b_8b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [13:0] smul14b_8b_x_6b (input reg [7:0] lhs, input reg [5:0] rhs);
    reg signed [7:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [13:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul14b_8b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [14:0] smul15b_8b_x_7b (input reg [7:0] lhs, input reg [6:0] rhs);
    reg signed [7:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [14:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul15b_8b_x_7b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [13:0] smul14b_8b_x_7b (input reg [7:0] lhs, input reg [6:0] rhs);
    reg signed [7:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [13:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul14b_8b_x_7b = $unsigned(signed_result);
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
  wire [7:0] x_unflattened[0:7];
  assign x_unflattened[0] = x[7:0];
  assign x_unflattened[1] = x[15:8];
  assign x_unflattened[2] = x[23:16];
  assign x_unflattened[3] = x[31:24];
  assign x_unflattened[4] = x[39:32];
  assign x_unflattened[5] = x[47:40];
  assign x_unflattened[6] = x[55:48];
  assign x_unflattened[7] = x[63:56];

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [7:0] p0_x[0:7];
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
  wire [7:0] p1_array_index_5631_comb;
  wire [7:0] p1_array_index_5633_comb;
  wire [7:0] p1_array_index_5635_comb;
  wire [7:0] p1_array_index_5637_comb;
  wire [7:0] p1_array_index_5640_comb;
  wire [7:0] p1_array_index_5642_comb;
  wire [7:0] p1_array_index_5646_comb;
  wire [7:0] p1_array_index_5648_comb;
  wire [15:0] p1_smul_3342_NarrowedMult__comb;
  wire [15:0] p1_smul_3341_NarrowedMult__comb;
  wire [15:0] p1_smul_3336_NarrowedMult__comb;
  wire [15:0] p1_smul_3335_NarrowedMult__comb;
  wire [15:0] p1_smul_3326_NarrowedMult__comb;
  wire [15:0] p1_smul_3324_NarrowedMult__comb;
  wire [15:0] p1_smul_3321_NarrowedMult__comb;
  wire [15:0] p1_smul_3319_NarrowedMult__comb;
  wire [15:0] p1_smul_3309_NarrowedMult__comb;
  wire [15:0] p1_smul_3307_NarrowedMult__comb;
  wire [15:0] p1_smul_3306_NarrowedMult__comb;
  wire [15:0] p1_smul_3304_NarrowedMult__comb;
  wire [15:0] p1_smul_3292_NarrowedMult__comb;
  wire [15:0] p1_smul_3291_NarrowedMult__comb;
  wire [15:0] p1_smul_3290_NarrowedMult__comb;
  wire [15:0] p1_smul_3289_NarrowedMult__comb;
  wire [14:0] p1_smul_3340_NarrowedMult__comb;
  wire [13:0] p1_smul_3356_NarrowedMult__comb;
  wire [13:0] p1_smul_3358_NarrowedMult__comb;
  wire [14:0] p1_smul_3337_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5699_comb;
  wire [13:0] p1_smul_3417_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5701_comb;
  wire [14:0] p1_smul_3323_NarrowedMult__comb;
  wire [14:0] p1_smul_3322_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5704_comb;
  wire [13:0] p1_smul_3437_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5706_comb;
  wire [14:0] p1_smul_3310_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5716_comb;
  wire [13:0] p1_smul_3484_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5718_comb;
  wire [14:0] p1_bit_slice_5719_comb;
  wire [13:0] p1_smul_3494_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5721_comb;
  wire [14:0] p1_smul_3303_NarrowedMult__comb;
  wire [13:0] p1_smul_3545_NarrowedMult__comb;
  wire [14:0] p1_smul_3293_NarrowedMult__comb;
  wire [14:0] p1_smul_3288_NarrowedMult__comb;
  wire [13:0] p1_smul_3573_NarrowedMult__comb;
  wire [16:0] p1_add_5735_comb;
  wire [16:0] p1_add_5740_comb;
  wire [14:0] p1_smul_3333_NarrowedMult__comb;
  wire [14:0] p1_smul_3332_NarrowedMult__comb;
  wire [14:0] p1_smul_3329_NarrowedMult__comb;
  wire [14:0] p1_smul_3328_NarrowedMult__comb;
  wire [15:0] p1_smul_3318_NarrowedMult__comb;
  wire [15:0] p1_smul_3317_NarrowedMult__comb;
  wire [15:0] p1_smul_3316_NarrowedMult__comb;
  wire [15:0] p1_smul_3315_NarrowedMult__comb;
  wire [15:0] p1_smul_3314_NarrowedMult__comb;
  wire [15:0] p1_smul_3313_NarrowedMult__comb;
  wire [15:0] p1_smul_3312_NarrowedMult__comb;
  wire [15:0] p1_smul_3311_NarrowedMult__comb;
  wire [14:0] p1_smul_3302_NarrowedMult__comb;
  wire [14:0] p1_smul_3300_NarrowedMult__comb;
  wire [14:0] p1_smul_3297_NarrowedMult__comb;
  wire [14:0] p1_smul_3295_NarrowedMult__comb;
  wire [16:0] p1_add_5783_comb;
  wire [16:0] p1_add_5784_comb;
  wire [15:0] p1_bit_slice_5787_comb;
  wire [15:0] p1_add_5788_comb;
  wire [15:0] p1_add_5789_comb;
  wire [15:0] p1_bit_slice_5790_comb;
  wire [13:0] p1_smul_3334_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5792_comb;
  wire [13:0] p1_bit_slice_5793_comb;
  wire [13:0] p1_smul_3331_NarrowedMult__comb;
  wire [13:0] p1_smul_3330_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5796_comb;
  wire [13:0] p1_bit_slice_5797_comb;
  wire [13:0] p1_smul_3327_NarrowedMult__comb;
  wire [15:0] p1_add_5799_comb;
  wire [15:0] p1_add_5801_comb;
  wire [15:0] p1_add_5803_comb;
  wire [15:0] p1_add_5805_comb;
  wire [15:0] p1_add_5815_comb;
  wire [15:0] p1_add_5817_comb;
  wire [15:0] p1_add_5819_comb;
  wire [15:0] p1_add_5821_comb;
  wire [13:0] p1_bit_slice_5823_comb;
  wire [13:0] p1_smul_3301_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5825_comb;
  wire [13:0] p1_smul_3299_NarrowedMult__comb;
  wire [13:0] p1_smul_3298_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5828_comb;
  wire [13:0] p1_smul_3296_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5830_comb;
  wire [15:0] p1_add_5831_comb;
  wire [15:0] p1_bit_slice_5832_comb;
  wire [15:0] p1_bit_slice_5833_comb;
  wire [15:0] p1_add_5834_comb;
  wire [16:0] p1_concat_5855_comb;
  wire [16:0] p1_concat_5856_comb;
  wire [16:0] p1_concat_5857_comb;
  wire [16:0] p1_concat_5858_comb;
  wire [16:0] p1_add_5859_comb;
  wire [16:0] p1_add_5860_comb;
  wire [16:0] p1_add_5861_comb;
  wire [16:0] p1_add_5862_comb;
  wire [16:0] p1_concat_5863_comb;
  wire [16:0] p1_concat_5864_comb;
  wire [16:0] p1_concat_5865_comb;
  wire [16:0] p1_concat_5866_comb;
  wire [8:0] p1_add_5879_comb;
  wire [8:0] p1_add_5880_comb;
  wire [8:0] p1_add_5881_comb;
  wire [8:0] p1_add_5882_comb;
  wire [23:0] p1_add_5883_comb;
  wire [23:0] p1_add_5885_comb;
  wire [14:0] p1_add_5887_comb;
  wire [14:0] p1_add_5889_comb;
  wire [14:0] p1_add_5891_comb;
  wire [14:0] p1_add_5893_comb;
  wire [24:0] p1_sum__101_comb;
  wire [24:0] p1_sum__102_comb;
  wire [24:0] p1_sum__103_comb;
  wire [24:0] p1_sum__104_comb;
  wire [24:0] p1_sum__97_comb;
  wire [24:0] p1_sum__98_comb;
  wire [24:0] p1_sum__99_comb;
  wire [24:0] p1_sum__100_comb;
  wire [24:0] p1_sum__93_comb;
  wire [24:0] p1_sum__94_comb;
  wire [24:0] p1_sum__95_comb;
  wire [24:0] p1_sum__96_comb;
  wire [14:0] p1_add_5907_comb;
  wire [14:0] p1_add_5909_comb;
  wire [14:0] p1_add_5911_comb;
  wire [14:0] p1_add_5913_comb;
  wire [23:0] p1_add_5915_comb;
  wire [23:0] p1_add_5917_comb;
  wire [24:0] p1_sum__83_comb;
  wire [24:0] p1_sum__84_comb;
  wire [15:0] p1_concat_5925_comb;
  wire [15:0] p1_concat_5926_comb;
  wire [15:0] p1_concat_5927_comb;
  wire [15:0] p1_concat_5928_comb;
  wire [24:0] p1_sum__79_comb;
  wire [24:0] p1_sum__80_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [24:0] p1_sum__75_comb;
  wire [24:0] p1_sum__76_comb;
  wire [15:0] p1_concat_5935_comb;
  wire [15:0] p1_concat_5936_comb;
  wire [15:0] p1_concat_5937_comb;
  wire [15:0] p1_concat_5938_comb;
  wire [24:0] p1_sum__71_comb;
  wire [24:0] p1_sum__72_comb;
  wire [23:0] p1_add_5941_comb;
  wire [23:0] p1_add_5942_comb;
  wire [24:0] p1_sum__70_comb;
  wire [24:0] p1_sum__68_comb;
  wire [24:0] p1_sum__67_comb;
  wire [24:0] p1_sum__66_comb;
  wire [24:0] p1_sum__64_comb;
  wire [23:0] p1_add_5961_comb;
  wire [24:0] p1_add_5963_comb;
  wire [23:0] p1_add_5964_comb;
  wire [23:0] p1_add_5965_comb;
  wire [24:0] p1_add_5966_comb;
  wire [24:0] p1_add_5967_comb;
  wire [24:0] p1_add_5968_comb;
  wire [23:0] p1_add_5969_comb;
  wire [23:0] p1_add_5970_comb;
  wire [24:0] p1_add_5971_comb;
  wire [23:0] p1_umul_2791_NarrowedMult__comb;
  wire [23:0] p1_add_5976_comb;
  wire [23:0] p1_add_5984_comb;
  wire [8:0] p1_clipped__16_comb;
  wire [8:0] p1_clipped__17_comb;
  wire [8:0] p1_clipped__18_comb;
  wire [8:0] p1_clipped__19_comb;
  wire [8:0] p1_clipped__20_comb;
  wire [8:0] p1_clipped__21_comb;
  wire [8:0] p1_clipped__22_comb;
  wire [8:0] p1_clipped__23_comb;
  wire [9:0] p1_add_6068_comb;
  wire [9:0] p1_add_6069_comb;
  wire [9:0] p1_add_6070_comb;
  wire [9:0] p1_add_6071_comb;
  wire [9:0] p1_add_6072_comb;
  wire [9:0] p1_add_6073_comb;
  wire [9:0] p1_add_6074_comb;
  wire [9:0] p1_add_6075_comb;
  wire [7:0] p1_clipped__8_comb;
  wire [7:0] p1_clipped__9_comb;
  wire [7:0] p1_clipped__10_comb;
  wire [7:0] p1_clipped__11_comb;
  wire [7:0] p1_clipped__12_comb;
  wire [7:0] p1_clipped__13_comb;
  wire [7:0] p1_clipped__14_comb;
  wire [7:0] p1_clipped__15_comb;
  wire [7:0] p1_result_comb[0:7];
  assign p1_array_index_5631_comb = p0_x[3'h0];
  assign p1_array_index_5633_comb = p0_x[3'h1];
  assign p1_array_index_5635_comb = p0_x[3'h6];
  assign p1_array_index_5637_comb = p0_x[3'h7];
  assign p1_array_index_5640_comb = p0_x[3'h2];
  assign p1_array_index_5642_comb = p0_x[3'h5];
  assign p1_array_index_5646_comb = p0_x[3'h3];
  assign p1_array_index_5648_comb = p0_x[3'h4];
  assign p1_smul_3342_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5631_comb, 9'h0fb);
  assign p1_smul_3341_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5633_comb, 9'h0d5);
  assign p1_smul_3336_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5635_comb, 9'h12b);
  assign p1_smul_3335_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5637_comb, 9'h105);
  assign p1_smul_3326_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5631_comb, 9'h0d5);
  assign p1_smul_3324_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5640_comb, 9'h105);
  assign p1_smul_3321_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5642_comb, 9'h0fb);
  assign p1_smul_3319_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5637_comb, 9'h12b);
  assign p1_smul_3309_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5633_comb, 9'h105);
  assign p1_smul_3307_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5646_comb, 9'h0d5);
  assign p1_smul_3306_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h0d5);
  assign p1_smul_3304_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5635_comb, 9'h105);
  assign p1_smul_3292_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5640_comb, 9'h0d5);
  assign p1_smul_3291_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5646_comb, 9'h105);
  assign p1_smul_3290_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h105);
  assign p1_smul_3289_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5642_comb, 9'h0d5);
  assign p1_smul_3340_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5640_comb, 8'h47);
  assign p1_smul_3356_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5646_comb, 6'h19);
  assign p1_smul_3358_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5648_comb, 6'h27);
  assign p1_smul_3337_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5642_comb, 8'hb9);
  assign p1_bit_slice_5699_comb = p1_smul_3326_NarrowedMult__comb[15:1];
  assign p1_smul_3417_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5633_comb, 6'h27);
  assign p1_bit_slice_5701_comb = p1_smul_3324_NarrowedMult__comb[15:1];
  assign p1_smul_3323_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5646_comb, 8'hb9);
  assign p1_smul_3322_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5648_comb, 8'h47);
  assign p1_bit_slice_5704_comb = p1_smul_3321_NarrowedMult__comb[15:1];
  assign p1_smul_3437_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5635_comb, 6'h19);
  assign p1_bit_slice_5706_comb = p1_smul_3319_NarrowedMult__comb[15:1];
  assign p1_smul_3310_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5631_comb, 8'h47);
  assign p1_bit_slice_5716_comb = p1_smul_3309_NarrowedMult__comb[15:1];
  assign p1_smul_3484_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5640_comb, 6'h27);
  assign p1_bit_slice_5718_comb = p1_smul_3307_NarrowedMult__comb[15:1];
  assign p1_bit_slice_5719_comb = p1_smul_3306_NarrowedMult__comb[15:1];
  assign p1_smul_3494_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5642_comb, 6'h27);
  assign p1_bit_slice_5721_comb = p1_smul_3304_NarrowedMult__comb[15:1];
  assign p1_smul_3303_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5637_comb, 8'h47);
  assign p1_smul_3545_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5631_comb, 6'h19);
  assign p1_smul_3293_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5633_comb, 8'hb9);
  assign p1_smul_3288_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5635_comb, 8'hb9);
  assign p1_smul_3573_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5637_comb, 6'h19);
  assign p1_add_5735_comb = {{1{p1_smul_3342_NarrowedMult__comb[15]}}, p1_smul_3342_NarrowedMult__comb} + {{1{p1_smul_3341_NarrowedMult__comb[15]}}, p1_smul_3341_NarrowedMult__comb};
  assign p1_add_5740_comb = {{1{p1_smul_3336_NarrowedMult__comb[15]}}, p1_smul_3336_NarrowedMult__comb} + {{1{p1_smul_3335_NarrowedMult__comb[15]}}, p1_smul_3335_NarrowedMult__comb};
  assign p1_smul_3333_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5633_comb, 7'h31);
  assign p1_smul_3332_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5640_comb, 7'h4f);
  assign p1_smul_3329_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5642_comb, 7'h4f);
  assign p1_smul_3328_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5635_comb, 7'h31);
  assign p1_smul_3318_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5631_comb, 9'h0b5);
  assign p1_smul_3317_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5633_comb, 9'h14b);
  assign p1_smul_3316_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5640_comb, 9'h14b);
  assign p1_smul_3315_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5646_comb, 9'h0b5);
  assign p1_smul_3314_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h0b5);
  assign p1_smul_3313_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5642_comb, 9'h14b);
  assign p1_smul_3312_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5635_comb, 9'h14b);
  assign p1_smul_3311_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5637_comb, 9'h0b5);
  assign p1_smul_3302_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5631_comb, 7'h31);
  assign p1_smul_3300_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5640_comb, 7'h31);
  assign p1_smul_3297_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5642_comb, 7'h31);
  assign p1_smul_3295_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5637_comb, 7'h31);
  assign p1_add_5783_comb = {{1{p1_smul_3292_NarrowedMult__comb[15]}}, p1_smul_3292_NarrowedMult__comb} + {{1{p1_smul_3291_NarrowedMult__comb[15]}}, p1_smul_3291_NarrowedMult__comb};
  assign p1_add_5784_comb = {{1{p1_smul_3290_NarrowedMult__comb[15]}}, p1_smul_3290_NarrowedMult__comb} + {{1{p1_smul_3289_NarrowedMult__comb[15]}}, p1_smul_3289_NarrowedMult__comb};
  assign p1_bit_slice_5787_comb = p1_add_5735_comb[16:1];
  assign p1_add_5788_comb = {{1{p1_smul_3340_NarrowedMult__comb[14]}}, p1_smul_3340_NarrowedMult__comb} + {{2{p1_smul_3356_NarrowedMult__comb[13]}}, p1_smul_3356_NarrowedMult__comb};
  assign p1_add_5789_comb = {{2{p1_smul_3358_NarrowedMult__comb[13]}}, p1_smul_3358_NarrowedMult__comb} + {{1{p1_smul_3337_NarrowedMult__comb[14]}}, p1_smul_3337_NarrowedMult__comb};
  assign p1_bit_slice_5790_comb = p1_add_5740_comb[16:1];
  assign p1_smul_3334_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5631_comb, 7'h3b);
  assign p1_bit_slice_5792_comb = p1_smul_3333_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5793_comb = p1_smul_3332_NarrowedMult__comb[14:1];
  assign p1_smul_3331_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5646_comb, 7'h45);
  assign p1_smul_3330_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5648_comb, 7'h45);
  assign p1_bit_slice_5796_comb = p1_smul_3329_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5797_comb = p1_smul_3328_NarrowedMult__comb[14:1];
  assign p1_smul_3327_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5637_comb, 7'h3b);
  assign p1_add_5799_comb = {{1{p1_bit_slice_5699_comb[14]}}, p1_bit_slice_5699_comb} + {{2{p1_smul_3417_NarrowedMult__comb[13]}}, p1_smul_3417_NarrowedMult__comb};
  assign p1_add_5801_comb = {{1{p1_bit_slice_5701_comb[14]}}, p1_bit_slice_5701_comb} + {{1{p1_smul_3323_NarrowedMult__comb[14]}}, p1_smul_3323_NarrowedMult__comb};
  assign p1_add_5803_comb = {{1{p1_smul_3322_NarrowedMult__comb[14]}}, p1_smul_3322_NarrowedMult__comb} + {{1{p1_bit_slice_5704_comb[14]}}, p1_bit_slice_5704_comb};
  assign p1_add_5805_comb = {{2{p1_smul_3437_NarrowedMult__comb[13]}}, p1_smul_3437_NarrowedMult__comb} + {{1{p1_bit_slice_5706_comb[14]}}, p1_bit_slice_5706_comb};
  assign p1_add_5815_comb = {{1{p1_smul_3310_NarrowedMult__comb[14]}}, p1_smul_3310_NarrowedMult__comb} + {{1{p1_bit_slice_5716_comb[14]}}, p1_bit_slice_5716_comb};
  assign p1_add_5817_comb = {{2{p1_smul_3484_NarrowedMult__comb[13]}}, p1_smul_3484_NarrowedMult__comb} + {{1{p1_bit_slice_5718_comb[14]}}, p1_bit_slice_5718_comb};
  assign p1_add_5819_comb = {{1{p1_bit_slice_5719_comb[14]}}, p1_bit_slice_5719_comb} + {{2{p1_smul_3494_NarrowedMult__comb[13]}}, p1_smul_3494_NarrowedMult__comb};
  assign p1_add_5821_comb = {{1{p1_bit_slice_5721_comb[14]}}, p1_bit_slice_5721_comb} + {{1{p1_smul_3303_NarrowedMult__comb[14]}}, p1_smul_3303_NarrowedMult__comb};
  assign p1_bit_slice_5823_comb = p1_smul_3302_NarrowedMult__comb[14:1];
  assign p1_smul_3301_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5633_comb, 7'h45);
  assign p1_bit_slice_5825_comb = p1_smul_3300_NarrowedMult__comb[14:1];
  assign p1_smul_3299_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5646_comb, 7'h3b);
  assign p1_smul_3298_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5648_comb, 7'h3b);
  assign p1_bit_slice_5828_comb = p1_smul_3297_NarrowedMult__comb[14:1];
  assign p1_smul_3296_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5635_comb, 7'h45);
  assign p1_bit_slice_5830_comb = p1_smul_3295_NarrowedMult__comb[14:1];
  assign p1_add_5831_comb = {{2{p1_smul_3545_NarrowedMult__comb[13]}}, p1_smul_3545_NarrowedMult__comb} + {{1{p1_smul_3293_NarrowedMult__comb[14]}}, p1_smul_3293_NarrowedMult__comb};
  assign p1_bit_slice_5832_comb = p1_add_5783_comb[16:1];
  assign p1_bit_slice_5833_comb = p1_add_5784_comb[16:1];
  assign p1_add_5834_comb = {{1{p1_smul_3288_NarrowedMult__comb[14]}}, p1_smul_3288_NarrowedMult__comb} + {{2{p1_smul_3573_NarrowedMult__comb[13]}}, p1_smul_3573_NarrowedMult__comb};
  assign p1_concat_5855_comb = {p1_add_5799_comb, p1_smul_3326_NarrowedMult__comb[0]};
  assign p1_concat_5856_comb = {p1_add_5801_comb, p1_smul_3324_NarrowedMult__comb[0]};
  assign p1_concat_5857_comb = {p1_add_5803_comb, p1_smul_3321_NarrowedMult__comb[0]};
  assign p1_concat_5858_comb = {p1_add_5805_comb, p1_smul_3319_NarrowedMult__comb[0]};
  assign p1_add_5859_comb = {{1{p1_smul_3318_NarrowedMult__comb[15]}}, p1_smul_3318_NarrowedMult__comb} + {{1{p1_smul_3317_NarrowedMult__comb[15]}}, p1_smul_3317_NarrowedMult__comb};
  assign p1_add_5860_comb = {{1{p1_smul_3316_NarrowedMult__comb[15]}}, p1_smul_3316_NarrowedMult__comb} + {{1{p1_smul_3315_NarrowedMult__comb[15]}}, p1_smul_3315_NarrowedMult__comb};
  assign p1_add_5861_comb = {{1{p1_smul_3314_NarrowedMult__comb[15]}}, p1_smul_3314_NarrowedMult__comb} + {{1{p1_smul_3313_NarrowedMult__comb[15]}}, p1_smul_3313_NarrowedMult__comb};
  assign p1_add_5862_comb = {{1{p1_smul_3312_NarrowedMult__comb[15]}}, p1_smul_3312_NarrowedMult__comb} + {{1{p1_smul_3311_NarrowedMult__comb[15]}}, p1_smul_3311_NarrowedMult__comb};
  assign p1_concat_5863_comb = {p1_add_5815_comb, p1_smul_3309_NarrowedMult__comb[0]};
  assign p1_concat_5864_comb = {p1_add_5817_comb, p1_smul_3307_NarrowedMult__comb[0]};
  assign p1_concat_5865_comb = {p1_add_5819_comb, p1_smul_3306_NarrowedMult__comb[0]};
  assign p1_concat_5866_comb = {p1_add_5821_comb, p1_smul_3304_NarrowedMult__comb[0]};
  assign p1_add_5879_comb = {{1{p1_array_index_5631_comb[7]}}, p1_array_index_5631_comb} + {{1{p1_array_index_5633_comb[7]}}, p1_array_index_5633_comb};
  assign p1_add_5880_comb = {{1{p1_array_index_5640_comb[7]}}, p1_array_index_5640_comb} + {{1{p1_array_index_5646_comb[7]}}, p1_array_index_5646_comb};
  assign p1_add_5881_comb = {{1{p1_array_index_5648_comb[7]}}, p1_array_index_5648_comb} + {{1{p1_array_index_5642_comb[7]}}, p1_array_index_5642_comb};
  assign p1_add_5882_comb = {{1{p1_array_index_5635_comb[7]}}, p1_array_index_5635_comb} + {{1{p1_array_index_5637_comb[7]}}, p1_array_index_5637_comb};
  assign p1_add_5883_comb = {{8{p1_bit_slice_5787_comb[15]}}, p1_bit_slice_5787_comb} + {{8{p1_add_5788_comb[15]}}, p1_add_5788_comb};
  assign p1_add_5885_comb = {{8{p1_add_5789_comb[15]}}, p1_add_5789_comb} + {{8{p1_bit_slice_5790_comb[15]}}, p1_bit_slice_5790_comb};
  assign p1_add_5887_comb = {{1{p1_smul_3334_NarrowedMult__comb[13]}}, p1_smul_3334_NarrowedMult__comb} + {{1{p1_bit_slice_5792_comb[13]}}, p1_bit_slice_5792_comb};
  assign p1_add_5889_comb = {{1{p1_bit_slice_5793_comb[13]}}, p1_bit_slice_5793_comb} + {{1{p1_smul_3331_NarrowedMult__comb[13]}}, p1_smul_3331_NarrowedMult__comb};
  assign p1_add_5891_comb = {{1{p1_smul_3330_NarrowedMult__comb[13]}}, p1_smul_3330_NarrowedMult__comb} + {{1{p1_bit_slice_5796_comb[13]}}, p1_bit_slice_5796_comb};
  assign p1_add_5893_comb = {{1{p1_bit_slice_5797_comb[13]}}, p1_bit_slice_5797_comb} + {{1{p1_smul_3327_NarrowedMult__comb[13]}}, p1_smul_3327_NarrowedMult__comb};
  assign p1_sum__101_comb = {{8{p1_concat_5855_comb[16]}}, p1_concat_5855_comb};
  assign p1_sum__102_comb = {{8{p1_concat_5856_comb[16]}}, p1_concat_5856_comb};
  assign p1_sum__103_comb = {{8{p1_concat_5857_comb[16]}}, p1_concat_5857_comb};
  assign p1_sum__104_comb = {{8{p1_concat_5858_comb[16]}}, p1_concat_5858_comb};
  assign p1_sum__97_comb = {{8{p1_add_5859_comb[16]}}, p1_add_5859_comb};
  assign p1_sum__98_comb = {{8{p1_add_5860_comb[16]}}, p1_add_5860_comb};
  assign p1_sum__99_comb = {{8{p1_add_5861_comb[16]}}, p1_add_5861_comb};
  assign p1_sum__100_comb = {{8{p1_add_5862_comb[16]}}, p1_add_5862_comb};
  assign p1_sum__93_comb = {{8{p1_concat_5863_comb[16]}}, p1_concat_5863_comb};
  assign p1_sum__94_comb = {{8{p1_concat_5864_comb[16]}}, p1_concat_5864_comb};
  assign p1_sum__95_comb = {{8{p1_concat_5865_comb[16]}}, p1_concat_5865_comb};
  assign p1_sum__96_comb = {{8{p1_concat_5866_comb[16]}}, p1_concat_5866_comb};
  assign p1_add_5907_comb = {{1{p1_bit_slice_5823_comb[13]}}, p1_bit_slice_5823_comb} + {{1{p1_smul_3301_NarrowedMult__comb[13]}}, p1_smul_3301_NarrowedMult__comb};
  assign p1_add_5909_comb = {{1{p1_bit_slice_5825_comb[13]}}, p1_bit_slice_5825_comb} + {{1{p1_smul_3299_NarrowedMult__comb[13]}}, p1_smul_3299_NarrowedMult__comb};
  assign p1_add_5911_comb = {{1{p1_smul_3298_NarrowedMult__comb[13]}}, p1_smul_3298_NarrowedMult__comb} + {{1{p1_bit_slice_5828_comb[13]}}, p1_bit_slice_5828_comb};
  assign p1_add_5913_comb = {{1{p1_smul_3296_NarrowedMult__comb[13]}}, p1_smul_3296_NarrowedMult__comb} + {{1{p1_bit_slice_5830_comb[13]}}, p1_bit_slice_5830_comb};
  assign p1_add_5915_comb = {{8{p1_add_5831_comb[15]}}, p1_add_5831_comb} + {{8{p1_bit_slice_5832_comb[15]}}, p1_bit_slice_5832_comb};
  assign p1_add_5917_comb = {{8{p1_bit_slice_5833_comb[15]}}, p1_bit_slice_5833_comb} + {{8{p1_add_5834_comb[15]}}, p1_add_5834_comb};
  assign p1_sum__83_comb = {p1_add_5883_comb, p1_add_5735_comb[0]};
  assign p1_sum__84_comb = {p1_add_5885_comb, p1_add_5740_comb[0]};
  assign p1_concat_5925_comb = {p1_add_5887_comb, p1_smul_3333_NarrowedMult__comb[0]};
  assign p1_concat_5926_comb = {p1_add_5889_comb, p1_smul_3332_NarrowedMult__comb[0]};
  assign p1_concat_5927_comb = {p1_add_5891_comb, p1_smul_3329_NarrowedMult__comb[0]};
  assign p1_concat_5928_comb = {p1_add_5893_comb, p1_smul_3328_NarrowedMult__comb[0]};
  assign p1_sum__79_comb = p1_sum__101_comb + p1_sum__102_comb;
  assign p1_sum__80_comb = p1_sum__103_comb + p1_sum__104_comb;
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_sum__75_comb = p1_sum__93_comb + p1_sum__94_comb;
  assign p1_sum__76_comb = p1_sum__95_comb + p1_sum__96_comb;
  assign p1_concat_5935_comb = {p1_add_5907_comb, p1_smul_3302_NarrowedMult__comb[0]};
  assign p1_concat_5936_comb = {p1_add_5909_comb, p1_smul_3300_NarrowedMult__comb[0]};
  assign p1_concat_5937_comb = {p1_add_5911_comb, p1_smul_3297_NarrowedMult__comb[0]};
  assign p1_concat_5938_comb = {p1_add_5913_comb, p1_smul_3295_NarrowedMult__comb[0]};
  assign p1_sum__71_comb = {p1_add_5915_comb, p1_add_5783_comb[0]};
  assign p1_sum__72_comb = {p1_add_5917_comb, p1_add_5784_comb[0]};
  assign p1_add_5941_comb = {{15{p1_add_5879_comb[8]}}, p1_add_5879_comb} + {{15{p1_add_5880_comb[8]}}, p1_add_5880_comb};
  assign p1_add_5942_comb = {{15{p1_add_5881_comb[8]}}, p1_add_5881_comb} + {{15{p1_add_5882_comb[8]}}, p1_add_5882_comb};
  assign p1_sum__70_comb = p1_sum__83_comb + p1_sum__84_comb;
  assign p1_sum__68_comb = p1_sum__79_comb + p1_sum__80_comb;
  assign p1_sum__67_comb = p1_sum__77_comb + p1_sum__78_comb;
  assign p1_sum__66_comb = p1_sum__75_comb + p1_sum__76_comb;
  assign p1_sum__64_comb = p1_sum__71_comb + p1_sum__72_comb;
  assign p1_add_5961_comb = p1_add_5941_comb + p1_add_5942_comb;
  assign p1_add_5963_comb = p1_sum__70_comb + 25'h000_0001;
  assign p1_add_5964_comb = {{8{p1_concat_5925_comb[15]}}, p1_concat_5925_comb} + {{8{p1_concat_5926_comb[15]}}, p1_concat_5926_comb};
  assign p1_add_5965_comb = {{8{p1_concat_5927_comb[15]}}, p1_concat_5927_comb} + {{8{p1_concat_5928_comb[15]}}, p1_concat_5928_comb};
  assign p1_add_5966_comb = p1_sum__68_comb + 25'h000_0001;
  assign p1_add_5967_comb = p1_sum__67_comb + 25'h000_0001;
  assign p1_add_5968_comb = p1_sum__66_comb + 25'h000_0001;
  assign p1_add_5969_comb = {{8{p1_concat_5935_comb[15]}}, p1_concat_5935_comb} + {{8{p1_concat_5936_comb[15]}}, p1_concat_5936_comb};
  assign p1_add_5970_comb = {{8{p1_concat_5937_comb[15]}}, p1_concat_5937_comb} + {{8{p1_concat_5938_comb[15]}}, p1_concat_5938_comb};
  assign p1_add_5971_comb = p1_sum__64_comb + 25'h000_0001;
  assign p1_umul_2791_NarrowedMult__comb = umul24b_24b_x_7b(p1_add_5961_comb, 7'h5b);
  assign p1_add_5976_comb = p1_add_5964_comb + p1_add_5965_comb;
  assign p1_add_5984_comb = p1_add_5969_comb + p1_add_5970_comb;
  assign p1_clipped__16_comb = $signed(p1_umul_2791_NarrowedMult__comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_umul_2791_NarrowedMult__comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_umul_2791_NarrowedMult__comb[15:7]);
  assign p1_clipped__17_comb = $signed(p1_add_5963_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5963_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5963_comb[16:8]);
  assign p1_clipped__18_comb = $signed(p1_add_5976_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5976_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5976_comb[15:7]);
  assign p1_clipped__19_comb = $signed(p1_add_5966_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5966_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5966_comb[16:8]);
  assign p1_clipped__20_comb = $signed(p1_add_5967_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5967_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5967_comb[16:8]);
  assign p1_clipped__21_comb = $signed(p1_add_5968_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5968_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5968_comb[16:8]);
  assign p1_clipped__22_comb = $signed(p1_add_5984_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5984_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5984_comb[15:7]);
  assign p1_clipped__23_comb = $signed(p1_add_5971_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5971_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5971_comb[16:8]);
  assign p1_add_6068_comb = {{1{p1_clipped__16_comb[8]}}, p1_clipped__16_comb} + 10'h001;
  assign p1_add_6069_comb = {{1{p1_clipped__17_comb[8]}}, p1_clipped__17_comb} + 10'h001;
  assign p1_add_6070_comb = {{1{p1_clipped__18_comb[8]}}, p1_clipped__18_comb} + 10'h001;
  assign p1_add_6071_comb = {{1{p1_clipped__19_comb[8]}}, p1_clipped__19_comb} + 10'h001;
  assign p1_add_6072_comb = {{1{p1_clipped__20_comb[8]}}, p1_clipped__20_comb} + 10'h001;
  assign p1_add_6073_comb = {{1{p1_clipped__21_comb[8]}}, p1_clipped__21_comb} + 10'h001;
  assign p1_add_6074_comb = {{1{p1_clipped__22_comb[8]}}, p1_clipped__22_comb} + 10'h001;
  assign p1_add_6075_comb = {{1{p1_clipped__23_comb[8]}}, p1_clipped__23_comb} + 10'h001;
  assign p1_clipped__8_comb = p1_add_6068_comb[8:1] & {8{~p1_add_6068_comb[9]}};
  assign p1_clipped__9_comb = p1_add_6069_comb[8:1] & {8{~p1_add_6069_comb[9]}};
  assign p1_clipped__10_comb = p1_add_6070_comb[8:1] & {8{~p1_add_6070_comb[9]}};
  assign p1_clipped__11_comb = p1_add_6071_comb[8:1] & {8{~p1_add_6071_comb[9]}};
  assign p1_clipped__12_comb = p1_add_6072_comb[8:1] & {8{~p1_add_6072_comb[9]}};
  assign p1_clipped__13_comb = p1_add_6073_comb[8:1] & {8{~p1_add_6073_comb[9]}};
  assign p1_clipped__14_comb = p1_add_6074_comb[8:1] & {8{~p1_add_6074_comb[9]}};
  assign p1_clipped__15_comb = p1_add_6075_comb[8:1] & {8{~p1_add_6075_comb[9]}};
  assign p1_result_comb[0] = p1_clipped__8_comb;
  assign p1_result_comb[1] = p1_clipped__9_comb;
  assign p1_result_comb[2] = p1_clipped__10_comb;
  assign p1_result_comb[3] = p1_clipped__11_comb;
  assign p1_result_comb[4] = p1_clipped__12_comb;
  assign p1_result_comb[5] = p1_clipped__13_comb;
  assign p1_result_comb[6] = p1_clipped__14_comb;
  assign p1_result_comb[7] = p1_clipped__15_comb;

  // Registers for pipe stage 1:
  reg [7:0] p1_result[0:7];
  always @ (posedge clk) begin
    p1_result[0] <= p1_result_comb[0];
    p1_result[1] <= p1_result_comb[1];
    p1_result[2] <= p1_result_comb[2];
    p1_result[3] <= p1_result_comb[3];
    p1_result[4] <= p1_result_comb[4];
    p1_result[5] <= p1_result_comb[5];
    p1_result[6] <= p1_result_comb[6];
    p1_result[7] <= p1_result_comb[7];
  end
  assign out = {p1_result[7], p1_result[6], p1_result[5], p1_result[4], p1_result[3], p1_result[2], p1_result[1], p1_result[0]};
endmodule
