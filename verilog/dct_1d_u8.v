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
  wire [7:0] p1_array_index_5639_comb;
  wire [7:0] p1_array_index_5641_comb;
  wire [7:0] p1_array_index_5643_comb;
  wire [7:0] p1_array_index_5645_comb;
  wire [7:0] p1_array_index_5648_comb;
  wire [7:0] p1_array_index_5650_comb;
  wire [7:0] p1_array_index_5654_comb;
  wire [7:0] p1_array_index_5656_comb;
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
  wire [14:0] p1_bit_slice_5707_comb;
  wire [13:0] p1_smul_3417_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5709_comb;
  wire [14:0] p1_smul_3323_NarrowedMult__comb;
  wire [14:0] p1_smul_3322_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5712_comb;
  wire [13:0] p1_smul_3437_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5714_comb;
  wire [14:0] p1_smul_3310_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5724_comb;
  wire [13:0] p1_smul_3484_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5726_comb;
  wire [14:0] p1_bit_slice_5727_comb;
  wire [13:0] p1_smul_3494_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5729_comb;
  wire [14:0] p1_smul_3303_NarrowedMult__comb;
  wire [13:0] p1_smul_3545_NarrowedMult__comb;
  wire [14:0] p1_smul_3293_NarrowedMult__comb;
  wire [14:0] p1_smul_3288_NarrowedMult__comb;
  wire [13:0] p1_smul_3573_NarrowedMult__comb;
  wire [16:0] p1_add_5743_comb;
  wire [16:0] p1_add_5748_comb;
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
  wire [16:0] p1_add_5791_comb;
  wire [16:0] p1_add_5792_comb;
  wire [15:0] p1_bit_slice_5795_comb;
  wire [15:0] p1_add_5796_comb;
  wire [15:0] p1_add_5797_comb;
  wire [15:0] p1_bit_slice_5798_comb;
  wire [13:0] p1_smul_3334_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5800_comb;
  wire [13:0] p1_bit_slice_5801_comb;
  wire [13:0] p1_smul_3331_NarrowedMult__comb;
  wire [13:0] p1_smul_3330_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5804_comb;
  wire [13:0] p1_bit_slice_5805_comb;
  wire [13:0] p1_smul_3327_NarrowedMult__comb;
  wire [15:0] p1_add_5807_comb;
  wire [15:0] p1_add_5809_comb;
  wire [15:0] p1_add_5811_comb;
  wire [15:0] p1_add_5813_comb;
  wire [15:0] p1_add_5823_comb;
  wire [15:0] p1_add_5825_comb;
  wire [15:0] p1_add_5827_comb;
  wire [15:0] p1_add_5829_comb;
  wire [13:0] p1_bit_slice_5831_comb;
  wire [13:0] p1_smul_3301_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5833_comb;
  wire [13:0] p1_smul_3299_NarrowedMult__comb;
  wire [13:0] p1_smul_3298_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5836_comb;
  wire [13:0] p1_smul_3296_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5838_comb;
  wire [15:0] p1_add_5839_comb;
  wire [15:0] p1_bit_slice_5840_comb;
  wire [15:0] p1_bit_slice_5841_comb;
  wire [15:0] p1_add_5842_comb;
  wire [16:0] p1_concat_5863_comb;
  wire [16:0] p1_concat_5864_comb;
  wire [16:0] p1_concat_5865_comb;
  wire [16:0] p1_concat_5866_comb;
  wire [16:0] p1_add_5867_comb;
  wire [16:0] p1_add_5868_comb;
  wire [16:0] p1_add_5869_comb;
  wire [16:0] p1_add_5870_comb;
  wire [16:0] p1_concat_5871_comb;
  wire [16:0] p1_concat_5872_comb;
  wire [16:0] p1_concat_5873_comb;
  wire [16:0] p1_concat_5874_comb;
  wire [8:0] p1_add_5887_comb;
  wire [8:0] p1_add_5888_comb;
  wire [8:0] p1_add_5889_comb;
  wire [8:0] p1_add_5890_comb;
  wire [23:0] p1_add_5891_comb;
  wire [23:0] p1_add_5893_comb;
  wire [14:0] p1_add_5895_comb;
  wire [14:0] p1_add_5897_comb;
  wire [14:0] p1_add_5899_comb;
  wire [14:0] p1_add_5901_comb;
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
  wire [14:0] p1_add_5915_comb;
  wire [14:0] p1_add_5917_comb;
  wire [14:0] p1_add_5919_comb;
  wire [14:0] p1_add_5921_comb;
  wire [23:0] p1_add_5923_comb;
  wire [23:0] p1_add_5925_comb;
  wire [24:0] p1_sum__83_comb;
  wire [24:0] p1_sum__84_comb;
  wire [15:0] p1_concat_5933_comb;
  wire [15:0] p1_concat_5934_comb;
  wire [15:0] p1_concat_5935_comb;
  wire [15:0] p1_concat_5936_comb;
  wire [24:0] p1_sum__79_comb;
  wire [24:0] p1_sum__80_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [24:0] p1_sum__75_comb;
  wire [24:0] p1_sum__76_comb;
  wire [15:0] p1_concat_5943_comb;
  wire [15:0] p1_concat_5944_comb;
  wire [15:0] p1_concat_5945_comb;
  wire [15:0] p1_concat_5946_comb;
  wire [24:0] p1_sum__71_comb;
  wire [24:0] p1_sum__72_comb;
  wire [23:0] p1_add_5949_comb;
  wire [23:0] p1_add_5950_comb;
  wire [24:0] p1_sum__70_comb;
  wire [24:0] p1_sum__68_comb;
  wire [24:0] p1_sum__67_comb;
  wire [24:0] p1_sum__66_comb;
  wire [24:0] p1_sum__64_comb;
  wire [23:0] p1_add_5969_comb;
  wire [24:0] p1_add_5971_comb;
  wire [23:0] p1_add_5972_comb;
  wire [23:0] p1_add_5973_comb;
  wire [24:0] p1_add_5974_comb;
  wire [24:0] p1_add_5975_comb;
  wire [24:0] p1_add_5976_comb;
  wire [23:0] p1_add_5977_comb;
  wire [23:0] p1_add_5978_comb;
  wire [24:0] p1_add_5979_comb;
  wire [23:0] p1_umul_2791_NarrowedMult__comb;
  wire [23:0] p1_add_5984_comb;
  wire [23:0] p1_add_5992_comb;
  wire [8:0] p1_clipped__16_comb;
  wire [8:0] p1_clipped__17_comb;
  wire [8:0] p1_clipped__18_comb;
  wire [8:0] p1_clipped__19_comb;
  wire [8:0] p1_clipped__20_comb;
  wire [8:0] p1_clipped__21_comb;
  wire [8:0] p1_clipped__22_comb;
  wire [8:0] p1_clipped__23_comb;
  wire [9:0] p1_add_6076_comb;
  wire [9:0] p1_add_6077_comb;
  wire [9:0] p1_add_6078_comb;
  wire [9:0] p1_add_6079_comb;
  wire [9:0] p1_add_6080_comb;
  wire [9:0] p1_add_6081_comb;
  wire [9:0] p1_add_6082_comb;
  wire [9:0] p1_add_6083_comb;
  wire [7:0] p1_clipped__8_comb;
  wire [7:0] p1_clipped__9_comb;
  wire [7:0] p1_clipped__10_comb;
  wire [7:0] p1_clipped__11_comb;
  wire [7:0] p1_clipped__12_comb;
  wire [7:0] p1_clipped__13_comb;
  wire [7:0] p1_clipped__14_comb;
  wire [7:0] p1_clipped__15_comb;
  wire [7:0] p1_result_comb[0:7];
  assign p1_array_index_5639_comb = p0_x[3'h0];
  assign p1_array_index_5641_comb = p0_x[3'h1];
  assign p1_array_index_5643_comb = p0_x[3'h6];
  assign p1_array_index_5645_comb = p0_x[3'h7];
  assign p1_array_index_5648_comb = p0_x[3'h2];
  assign p1_array_index_5650_comb = p0_x[3'h5];
  assign p1_array_index_5654_comb = p0_x[3'h3];
  assign p1_array_index_5656_comb = p0_x[3'h4];
  assign p1_smul_3342_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5639_comb, 9'h0fb);
  assign p1_smul_3341_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5641_comb, 9'h0d5);
  assign p1_smul_3336_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5643_comb, 9'h12b);
  assign p1_smul_3335_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5645_comb, 9'h105);
  assign p1_smul_3326_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5639_comb, 9'h0d5);
  assign p1_smul_3324_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h105);
  assign p1_smul_3321_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5650_comb, 9'h0fb);
  assign p1_smul_3319_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5645_comb, 9'h12b);
  assign p1_smul_3309_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5641_comb, 9'h105);
  assign p1_smul_3307_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5654_comb, 9'h0d5);
  assign p1_smul_3306_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5656_comb, 9'h0d5);
  assign p1_smul_3304_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5643_comb, 9'h105);
  assign p1_smul_3292_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h0d5);
  assign p1_smul_3291_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5654_comb, 9'h105);
  assign p1_smul_3290_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5656_comb, 9'h105);
  assign p1_smul_3289_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5650_comb, 9'h0d5);
  assign p1_smul_3340_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5648_comb, 8'h47);
  assign p1_smul_3356_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5654_comb, 6'h19);
  assign p1_smul_3358_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5656_comb, 6'h27);
  assign p1_smul_3337_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5650_comb, 8'hb9);
  assign p1_bit_slice_5707_comb = p1_smul_3326_NarrowedMult__comb[15:1];
  assign p1_smul_3417_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5641_comb, 6'h27);
  assign p1_bit_slice_5709_comb = p1_smul_3324_NarrowedMult__comb[15:1];
  assign p1_smul_3323_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5654_comb, 8'hb9);
  assign p1_smul_3322_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5656_comb, 8'h47);
  assign p1_bit_slice_5712_comb = p1_smul_3321_NarrowedMult__comb[15:1];
  assign p1_smul_3437_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5643_comb, 6'h19);
  assign p1_bit_slice_5714_comb = p1_smul_3319_NarrowedMult__comb[15:1];
  assign p1_smul_3310_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5639_comb, 8'h47);
  assign p1_bit_slice_5724_comb = p1_smul_3309_NarrowedMult__comb[15:1];
  assign p1_smul_3484_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5648_comb, 6'h27);
  assign p1_bit_slice_5726_comb = p1_smul_3307_NarrowedMult__comb[15:1];
  assign p1_bit_slice_5727_comb = p1_smul_3306_NarrowedMult__comb[15:1];
  assign p1_smul_3494_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5650_comb, 6'h27);
  assign p1_bit_slice_5729_comb = p1_smul_3304_NarrowedMult__comb[15:1];
  assign p1_smul_3303_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5645_comb, 8'h47);
  assign p1_smul_3545_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5639_comb, 6'h19);
  assign p1_smul_3293_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5641_comb, 8'hb9);
  assign p1_smul_3288_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5643_comb, 8'hb9);
  assign p1_smul_3573_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5645_comb, 6'h19);
  assign p1_add_5743_comb = {{1{p1_smul_3342_NarrowedMult__comb[15]}}, p1_smul_3342_NarrowedMult__comb} + {{1{p1_smul_3341_NarrowedMult__comb[15]}}, p1_smul_3341_NarrowedMult__comb};
  assign p1_add_5748_comb = {{1{p1_smul_3336_NarrowedMult__comb[15]}}, p1_smul_3336_NarrowedMult__comb} + {{1{p1_smul_3335_NarrowedMult__comb[15]}}, p1_smul_3335_NarrowedMult__comb};
  assign p1_smul_3333_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5641_comb, 7'h31);
  assign p1_smul_3332_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5648_comb, 7'h4f);
  assign p1_smul_3329_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5650_comb, 7'h4f);
  assign p1_smul_3328_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5643_comb, 7'h31);
  assign p1_smul_3318_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5639_comb, 9'h0b5);
  assign p1_smul_3317_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5641_comb, 9'h14b);
  assign p1_smul_3316_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h14b);
  assign p1_smul_3315_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5654_comb, 9'h0b5);
  assign p1_smul_3314_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5656_comb, 9'h0b5);
  assign p1_smul_3313_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5650_comb, 9'h14b);
  assign p1_smul_3312_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5643_comb, 9'h14b);
  assign p1_smul_3311_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5645_comb, 9'h0b5);
  assign p1_smul_3302_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5639_comb, 7'h31);
  assign p1_smul_3300_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5648_comb, 7'h31);
  assign p1_smul_3297_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5650_comb, 7'h31);
  assign p1_smul_3295_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5645_comb, 7'h31);
  assign p1_add_5791_comb = {{1{p1_smul_3292_NarrowedMult__comb[15]}}, p1_smul_3292_NarrowedMult__comb} + {{1{p1_smul_3291_NarrowedMult__comb[15]}}, p1_smul_3291_NarrowedMult__comb};
  assign p1_add_5792_comb = {{1{p1_smul_3290_NarrowedMult__comb[15]}}, p1_smul_3290_NarrowedMult__comb} + {{1{p1_smul_3289_NarrowedMult__comb[15]}}, p1_smul_3289_NarrowedMult__comb};
  assign p1_bit_slice_5795_comb = p1_add_5743_comb[16:1];
  assign p1_add_5796_comb = {{1{p1_smul_3340_NarrowedMult__comb[14]}}, p1_smul_3340_NarrowedMult__comb} + {{2{p1_smul_3356_NarrowedMult__comb[13]}}, p1_smul_3356_NarrowedMult__comb};
  assign p1_add_5797_comb = {{2{p1_smul_3358_NarrowedMult__comb[13]}}, p1_smul_3358_NarrowedMult__comb} + {{1{p1_smul_3337_NarrowedMult__comb[14]}}, p1_smul_3337_NarrowedMult__comb};
  assign p1_bit_slice_5798_comb = p1_add_5748_comb[16:1];
  assign p1_smul_3334_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5639_comb, 7'h3b);
  assign p1_bit_slice_5800_comb = p1_smul_3333_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5801_comb = p1_smul_3332_NarrowedMult__comb[14:1];
  assign p1_smul_3331_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5654_comb, 7'h45);
  assign p1_smul_3330_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5656_comb, 7'h45);
  assign p1_bit_slice_5804_comb = p1_smul_3329_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5805_comb = p1_smul_3328_NarrowedMult__comb[14:1];
  assign p1_smul_3327_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5645_comb, 7'h3b);
  assign p1_add_5807_comb = {{1{p1_bit_slice_5707_comb[14]}}, p1_bit_slice_5707_comb} + {{2{p1_smul_3417_NarrowedMult__comb[13]}}, p1_smul_3417_NarrowedMult__comb};
  assign p1_add_5809_comb = {{1{p1_bit_slice_5709_comb[14]}}, p1_bit_slice_5709_comb} + {{1{p1_smul_3323_NarrowedMult__comb[14]}}, p1_smul_3323_NarrowedMult__comb};
  assign p1_add_5811_comb = {{1{p1_smul_3322_NarrowedMult__comb[14]}}, p1_smul_3322_NarrowedMult__comb} + {{1{p1_bit_slice_5712_comb[14]}}, p1_bit_slice_5712_comb};
  assign p1_add_5813_comb = {{2{p1_smul_3437_NarrowedMult__comb[13]}}, p1_smul_3437_NarrowedMult__comb} + {{1{p1_bit_slice_5714_comb[14]}}, p1_bit_slice_5714_comb};
  assign p1_add_5823_comb = {{1{p1_smul_3310_NarrowedMult__comb[14]}}, p1_smul_3310_NarrowedMult__comb} + {{1{p1_bit_slice_5724_comb[14]}}, p1_bit_slice_5724_comb};
  assign p1_add_5825_comb = {{2{p1_smul_3484_NarrowedMult__comb[13]}}, p1_smul_3484_NarrowedMult__comb} + {{1{p1_bit_slice_5726_comb[14]}}, p1_bit_slice_5726_comb};
  assign p1_add_5827_comb = {{1{p1_bit_slice_5727_comb[14]}}, p1_bit_slice_5727_comb} + {{2{p1_smul_3494_NarrowedMult__comb[13]}}, p1_smul_3494_NarrowedMult__comb};
  assign p1_add_5829_comb = {{1{p1_bit_slice_5729_comb[14]}}, p1_bit_slice_5729_comb} + {{1{p1_smul_3303_NarrowedMult__comb[14]}}, p1_smul_3303_NarrowedMult__comb};
  assign p1_bit_slice_5831_comb = p1_smul_3302_NarrowedMult__comb[14:1];
  assign p1_smul_3301_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5641_comb, 7'h45);
  assign p1_bit_slice_5833_comb = p1_smul_3300_NarrowedMult__comb[14:1];
  assign p1_smul_3299_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5654_comb, 7'h3b);
  assign p1_smul_3298_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5656_comb, 7'h3b);
  assign p1_bit_slice_5836_comb = p1_smul_3297_NarrowedMult__comb[14:1];
  assign p1_smul_3296_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5643_comb, 7'h45);
  assign p1_bit_slice_5838_comb = p1_smul_3295_NarrowedMult__comb[14:1];
  assign p1_add_5839_comb = {{2{p1_smul_3545_NarrowedMult__comb[13]}}, p1_smul_3545_NarrowedMult__comb} + {{1{p1_smul_3293_NarrowedMult__comb[14]}}, p1_smul_3293_NarrowedMult__comb};
  assign p1_bit_slice_5840_comb = p1_add_5791_comb[16:1];
  assign p1_bit_slice_5841_comb = p1_add_5792_comb[16:1];
  assign p1_add_5842_comb = {{1{p1_smul_3288_NarrowedMult__comb[14]}}, p1_smul_3288_NarrowedMult__comb} + {{2{p1_smul_3573_NarrowedMult__comb[13]}}, p1_smul_3573_NarrowedMult__comb};
  assign p1_concat_5863_comb = {p1_add_5807_comb, p1_smul_3326_NarrowedMult__comb[0]};
  assign p1_concat_5864_comb = {p1_add_5809_comb, p1_smul_3324_NarrowedMult__comb[0]};
  assign p1_concat_5865_comb = {p1_add_5811_comb, p1_smul_3321_NarrowedMult__comb[0]};
  assign p1_concat_5866_comb = {p1_add_5813_comb, p1_smul_3319_NarrowedMult__comb[0]};
  assign p1_add_5867_comb = {{1{p1_smul_3318_NarrowedMult__comb[15]}}, p1_smul_3318_NarrowedMult__comb} + {{1{p1_smul_3317_NarrowedMult__comb[15]}}, p1_smul_3317_NarrowedMult__comb};
  assign p1_add_5868_comb = {{1{p1_smul_3316_NarrowedMult__comb[15]}}, p1_smul_3316_NarrowedMult__comb} + {{1{p1_smul_3315_NarrowedMult__comb[15]}}, p1_smul_3315_NarrowedMult__comb};
  assign p1_add_5869_comb = {{1{p1_smul_3314_NarrowedMult__comb[15]}}, p1_smul_3314_NarrowedMult__comb} + {{1{p1_smul_3313_NarrowedMult__comb[15]}}, p1_smul_3313_NarrowedMult__comb};
  assign p1_add_5870_comb = {{1{p1_smul_3312_NarrowedMult__comb[15]}}, p1_smul_3312_NarrowedMult__comb} + {{1{p1_smul_3311_NarrowedMult__comb[15]}}, p1_smul_3311_NarrowedMult__comb};
  assign p1_concat_5871_comb = {p1_add_5823_comb, p1_smul_3309_NarrowedMult__comb[0]};
  assign p1_concat_5872_comb = {p1_add_5825_comb, p1_smul_3307_NarrowedMult__comb[0]};
  assign p1_concat_5873_comb = {p1_add_5827_comb, p1_smul_3306_NarrowedMult__comb[0]};
  assign p1_concat_5874_comb = {p1_add_5829_comb, p1_smul_3304_NarrowedMult__comb[0]};
  assign p1_add_5887_comb = {{1{p1_array_index_5639_comb[7]}}, p1_array_index_5639_comb} + {{1{p1_array_index_5641_comb[7]}}, p1_array_index_5641_comb};
  assign p1_add_5888_comb = {{1{p1_array_index_5648_comb[7]}}, p1_array_index_5648_comb} + {{1{p1_array_index_5654_comb[7]}}, p1_array_index_5654_comb};
  assign p1_add_5889_comb = {{1{p1_array_index_5656_comb[7]}}, p1_array_index_5656_comb} + {{1{p1_array_index_5650_comb[7]}}, p1_array_index_5650_comb};
  assign p1_add_5890_comb = {{1{p1_array_index_5643_comb[7]}}, p1_array_index_5643_comb} + {{1{p1_array_index_5645_comb[7]}}, p1_array_index_5645_comb};
  assign p1_add_5891_comb = {{8{p1_bit_slice_5795_comb[15]}}, p1_bit_slice_5795_comb} + {{8{p1_add_5796_comb[15]}}, p1_add_5796_comb};
  assign p1_add_5893_comb = {{8{p1_add_5797_comb[15]}}, p1_add_5797_comb} + {{8{p1_bit_slice_5798_comb[15]}}, p1_bit_slice_5798_comb};
  assign p1_add_5895_comb = {{1{p1_smul_3334_NarrowedMult__comb[13]}}, p1_smul_3334_NarrowedMult__comb} + {{1{p1_bit_slice_5800_comb[13]}}, p1_bit_slice_5800_comb};
  assign p1_add_5897_comb = {{1{p1_bit_slice_5801_comb[13]}}, p1_bit_slice_5801_comb} + {{1{p1_smul_3331_NarrowedMult__comb[13]}}, p1_smul_3331_NarrowedMult__comb};
  assign p1_add_5899_comb = {{1{p1_smul_3330_NarrowedMult__comb[13]}}, p1_smul_3330_NarrowedMult__comb} + {{1{p1_bit_slice_5804_comb[13]}}, p1_bit_slice_5804_comb};
  assign p1_add_5901_comb = {{1{p1_bit_slice_5805_comb[13]}}, p1_bit_slice_5805_comb} + {{1{p1_smul_3327_NarrowedMult__comb[13]}}, p1_smul_3327_NarrowedMult__comb};
  assign p1_sum__101_comb = {{8{p1_concat_5863_comb[16]}}, p1_concat_5863_comb};
  assign p1_sum__102_comb = {{8{p1_concat_5864_comb[16]}}, p1_concat_5864_comb};
  assign p1_sum__103_comb = {{8{p1_concat_5865_comb[16]}}, p1_concat_5865_comb};
  assign p1_sum__104_comb = {{8{p1_concat_5866_comb[16]}}, p1_concat_5866_comb};
  assign p1_sum__97_comb = {{8{p1_add_5867_comb[16]}}, p1_add_5867_comb};
  assign p1_sum__98_comb = {{8{p1_add_5868_comb[16]}}, p1_add_5868_comb};
  assign p1_sum__99_comb = {{8{p1_add_5869_comb[16]}}, p1_add_5869_comb};
  assign p1_sum__100_comb = {{8{p1_add_5870_comb[16]}}, p1_add_5870_comb};
  assign p1_sum__93_comb = {{8{p1_concat_5871_comb[16]}}, p1_concat_5871_comb};
  assign p1_sum__94_comb = {{8{p1_concat_5872_comb[16]}}, p1_concat_5872_comb};
  assign p1_sum__95_comb = {{8{p1_concat_5873_comb[16]}}, p1_concat_5873_comb};
  assign p1_sum__96_comb = {{8{p1_concat_5874_comb[16]}}, p1_concat_5874_comb};
  assign p1_add_5915_comb = {{1{p1_bit_slice_5831_comb[13]}}, p1_bit_slice_5831_comb} + {{1{p1_smul_3301_NarrowedMult__comb[13]}}, p1_smul_3301_NarrowedMult__comb};
  assign p1_add_5917_comb = {{1{p1_bit_slice_5833_comb[13]}}, p1_bit_slice_5833_comb} + {{1{p1_smul_3299_NarrowedMult__comb[13]}}, p1_smul_3299_NarrowedMult__comb};
  assign p1_add_5919_comb = {{1{p1_smul_3298_NarrowedMult__comb[13]}}, p1_smul_3298_NarrowedMult__comb} + {{1{p1_bit_slice_5836_comb[13]}}, p1_bit_slice_5836_comb};
  assign p1_add_5921_comb = {{1{p1_smul_3296_NarrowedMult__comb[13]}}, p1_smul_3296_NarrowedMult__comb} + {{1{p1_bit_slice_5838_comb[13]}}, p1_bit_slice_5838_comb};
  assign p1_add_5923_comb = {{8{p1_add_5839_comb[15]}}, p1_add_5839_comb} + {{8{p1_bit_slice_5840_comb[15]}}, p1_bit_slice_5840_comb};
  assign p1_add_5925_comb = {{8{p1_bit_slice_5841_comb[15]}}, p1_bit_slice_5841_comb} + {{8{p1_add_5842_comb[15]}}, p1_add_5842_comb};
  assign p1_sum__83_comb = {p1_add_5891_comb, p1_add_5743_comb[0]};
  assign p1_sum__84_comb = {p1_add_5893_comb, p1_add_5748_comb[0]};
  assign p1_concat_5933_comb = {p1_add_5895_comb, p1_smul_3333_NarrowedMult__comb[0]};
  assign p1_concat_5934_comb = {p1_add_5897_comb, p1_smul_3332_NarrowedMult__comb[0]};
  assign p1_concat_5935_comb = {p1_add_5899_comb, p1_smul_3329_NarrowedMult__comb[0]};
  assign p1_concat_5936_comb = {p1_add_5901_comb, p1_smul_3328_NarrowedMult__comb[0]};
  assign p1_sum__79_comb = p1_sum__101_comb + p1_sum__102_comb;
  assign p1_sum__80_comb = p1_sum__103_comb + p1_sum__104_comb;
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_sum__75_comb = p1_sum__93_comb + p1_sum__94_comb;
  assign p1_sum__76_comb = p1_sum__95_comb + p1_sum__96_comb;
  assign p1_concat_5943_comb = {p1_add_5915_comb, p1_smul_3302_NarrowedMult__comb[0]};
  assign p1_concat_5944_comb = {p1_add_5917_comb, p1_smul_3300_NarrowedMult__comb[0]};
  assign p1_concat_5945_comb = {p1_add_5919_comb, p1_smul_3297_NarrowedMult__comb[0]};
  assign p1_concat_5946_comb = {p1_add_5921_comb, p1_smul_3295_NarrowedMult__comb[0]};
  assign p1_sum__71_comb = {p1_add_5923_comb, p1_add_5791_comb[0]};
  assign p1_sum__72_comb = {p1_add_5925_comb, p1_add_5792_comb[0]};
  assign p1_add_5949_comb = {{15{p1_add_5887_comb[8]}}, p1_add_5887_comb} + {{15{p1_add_5888_comb[8]}}, p1_add_5888_comb};
  assign p1_add_5950_comb = {{15{p1_add_5889_comb[8]}}, p1_add_5889_comb} + {{15{p1_add_5890_comb[8]}}, p1_add_5890_comb};
  assign p1_sum__70_comb = p1_sum__83_comb + p1_sum__84_comb;
  assign p1_sum__68_comb = p1_sum__79_comb + p1_sum__80_comb;
  assign p1_sum__67_comb = p1_sum__77_comb + p1_sum__78_comb;
  assign p1_sum__66_comb = p1_sum__75_comb + p1_sum__76_comb;
  assign p1_sum__64_comb = p1_sum__71_comb + p1_sum__72_comb;
  assign p1_add_5969_comb = p1_add_5949_comb + p1_add_5950_comb;
  assign p1_add_5971_comb = p1_sum__70_comb + 25'h000_0001;
  assign p1_add_5972_comb = {{8{p1_concat_5933_comb[15]}}, p1_concat_5933_comb} + {{8{p1_concat_5934_comb[15]}}, p1_concat_5934_comb};
  assign p1_add_5973_comb = {{8{p1_concat_5935_comb[15]}}, p1_concat_5935_comb} + {{8{p1_concat_5936_comb[15]}}, p1_concat_5936_comb};
  assign p1_add_5974_comb = p1_sum__68_comb + 25'h000_0001;
  assign p1_add_5975_comb = p1_sum__67_comb + 25'h000_0001;
  assign p1_add_5976_comb = p1_sum__66_comb + 25'h000_0001;
  assign p1_add_5977_comb = {{8{p1_concat_5943_comb[15]}}, p1_concat_5943_comb} + {{8{p1_concat_5944_comb[15]}}, p1_concat_5944_comb};
  assign p1_add_5978_comb = {{8{p1_concat_5945_comb[15]}}, p1_concat_5945_comb} + {{8{p1_concat_5946_comb[15]}}, p1_concat_5946_comb};
  assign p1_add_5979_comb = p1_sum__64_comb + 25'h000_0001;
  assign p1_umul_2791_NarrowedMult__comb = umul24b_24b_x_7b(p1_add_5969_comb, 7'h5b);
  assign p1_add_5984_comb = p1_add_5972_comb + p1_add_5973_comb;
  assign p1_add_5992_comb = p1_add_5977_comb + p1_add_5978_comb;
  assign p1_clipped__16_comb = $signed(p1_umul_2791_NarrowedMult__comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_umul_2791_NarrowedMult__comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_umul_2791_NarrowedMult__comb[15:7]);
  assign p1_clipped__17_comb = $signed(p1_add_5971_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5971_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5971_comb[16:8]);
  assign p1_clipped__18_comb = $signed(p1_add_5984_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5984_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5984_comb[15:7]);
  assign p1_clipped__19_comb = $signed(p1_add_5974_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5974_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5974_comb[16:8]);
  assign p1_clipped__20_comb = $signed(p1_add_5975_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5975_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5975_comb[16:8]);
  assign p1_clipped__21_comb = $signed(p1_add_5976_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5976_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5976_comb[16:8]);
  assign p1_clipped__22_comb = $signed(p1_add_5992_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5992_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5992_comb[15:7]);
  assign p1_clipped__23_comb = $signed(p1_add_5979_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5979_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5979_comb[16:8]);
  assign p1_add_6076_comb = {{1{p1_clipped__16_comb[8]}}, p1_clipped__16_comb} + 10'h001;
  assign p1_add_6077_comb = {{1{p1_clipped__17_comb[8]}}, p1_clipped__17_comb} + 10'h001;
  assign p1_add_6078_comb = {{1{p1_clipped__18_comb[8]}}, p1_clipped__18_comb} + 10'h001;
  assign p1_add_6079_comb = {{1{p1_clipped__19_comb[8]}}, p1_clipped__19_comb} + 10'h001;
  assign p1_add_6080_comb = {{1{p1_clipped__20_comb[8]}}, p1_clipped__20_comb} + 10'h001;
  assign p1_add_6081_comb = {{1{p1_clipped__21_comb[8]}}, p1_clipped__21_comb} + 10'h001;
  assign p1_add_6082_comb = {{1{p1_clipped__22_comb[8]}}, p1_clipped__22_comb} + 10'h001;
  assign p1_add_6083_comb = {{1{p1_clipped__23_comb[8]}}, p1_clipped__23_comb} + 10'h001;
  assign p1_clipped__8_comb = p1_add_6076_comb[8:1] & {8{~p1_add_6076_comb[9]}};
  assign p1_clipped__9_comb = p1_add_6077_comb[8:1] & {8{~p1_add_6077_comb[9]}};
  assign p1_clipped__10_comb = p1_add_6078_comb[8:1] & {8{~p1_add_6078_comb[9]}};
  assign p1_clipped__11_comb = p1_add_6079_comb[8:1] & {8{~p1_add_6079_comb[9]}};
  assign p1_clipped__12_comb = p1_add_6080_comb[8:1] & {8{~p1_add_6080_comb[9]}};
  assign p1_clipped__13_comb = p1_add_6081_comb[8:1] & {8{~p1_add_6081_comb[9]}};
  assign p1_clipped__14_comb = p1_add_6082_comb[8:1] & {8{~p1_add_6082_comb[9]}};
  assign p1_clipped__15_comb = p1_add_6083_comb[8:1] & {8{~p1_add_6083_comb[9]}};
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
