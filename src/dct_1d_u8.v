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
  wire [7:0] p1_array_index_5648_comb;
  wire [7:0] p1_array_index_5650_comb;
  wire [7:0] p1_array_index_5645_comb;
  wire [7:0] p1_array_index_5641_comb;
  wire [7:0] p1_array_index_5654_comb;
  wire [7:0] p1_array_index_5656_comb;
  wire [7:0] p1_array_index_5643_comb;
  wire [15:0] p1_smul_3326_NarrowedMult__comb;
  wire [15:0] p1_smul_3324_NarrowedMult__comb;
  wire [15:0] p1_smul_3321_NarrowedMult__comb;
  wire [15:0] p1_smul_3319_NarrowedMult__comb;
  wire [15:0] p1_smul_3309_NarrowedMult__comb;
  wire [15:0] p1_smul_3307_NarrowedMult__comb;
  wire [15:0] p1_smul_3306_NarrowedMult__comb;
  wire [15:0] p1_smul_3304_NarrowedMult__comb;
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
  wire [15:0] p1_smul_3342_NarrowedMult__comb;
  wire [15:0] p1_smul_3341_NarrowedMult__comb;
  wire [15:0] p1_smul_3336_NarrowedMult__comb;
  wire [15:0] p1_smul_3335_NarrowedMult__comb;
  wire [15:0] p1_smul_3292_NarrowedMult__comb;
  wire [15:0] p1_smul_3291_NarrowedMult__comb;
  wire [15:0] p1_smul_3290_NarrowedMult__comb;
  wire [15:0] p1_smul_3289_NarrowedMult__comb;
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
  wire [13:0] p1_smul_3334_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5800_comb;
  wire [13:0] p1_bit_slice_5801_comb;
  wire [13:0] p1_smul_3331_NarrowedMult__comb;
  wire [13:0] p1_smul_3330_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5804_comb;
  wire [13:0] p1_bit_slice_5805_comb;
  wire [13:0] p1_smul_3327_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5831_comb;
  wire [13:0] p1_smul_3301_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5833_comb;
  wire [13:0] p1_smul_3299_NarrowedMult__comb;
  wire [13:0] p1_smul_3298_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5836_comb;
  wire [13:0] p1_smul_3296_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5838_comb;
  wire [8:0] p1_add_5879_comb;
  wire [8:0] p1_add_5880_comb;
  wire [8:0] p1_add_5881_comb;
  wire [8:0] p1_add_5882_comb;
  wire [14:0] p1_smul_3340_NarrowedMult__comb;
  wire [13:0] p1_smul_3356_NarrowedMult__comb;
  wire [13:0] p1_smul_3358_NarrowedMult__comb;
  wire [14:0] p1_smul_3337_NarrowedMult__comb;
  wire [13:0] p1_smul_3545_NarrowedMult__comb;
  wire [14:0] p1_smul_3293_NarrowedMult__comb;
  wire [14:0] p1_smul_3288_NarrowedMult__comb;
  wire [13:0] p1_smul_3573_NarrowedMult__comb;
  wire [16:0] p1_add_5863_comb;
  wire [16:0] p1_add_5864_comb;
  wire [16:0] p1_add_5865_comb;
  wire [16:0] p1_add_5866_comb;
  wire [16:0] p1_add_5743_comb;
  wire [16:0] p1_add_5748_comb;
  wire [16:0] p1_add_5791_comb;
  wire [16:0] p1_add_5792_comb;
  wire [15:0] p1_add_5807_comb;
  wire [15:0] p1_add_5809_comb;
  wire [15:0] p1_add_5811_comb;
  wire [15:0] p1_add_5813_comb;
  wire [15:0] p1_add_5823_comb;
  wire [15:0] p1_add_5825_comb;
  wire [15:0] p1_add_5827_comb;
  wire [15:0] p1_add_5829_comb;
  wire [14:0] p1_add_5885_comb;
  wire [14:0] p1_add_5887_comb;
  wire [14:0] p1_add_5889_comb;
  wire [14:0] p1_add_5891_comb;
  wire [24:0] p1_sum__97_comb;
  wire [24:0] p1_sum__98_comb;
  wire [24:0] p1_sum__99_comb;
  wire [24:0] p1_sum__100_comb;
  wire [14:0] p1_add_5897_comb;
  wire [14:0] p1_add_5899_comb;
  wire [14:0] p1_add_5901_comb;
  wire [14:0] p1_add_5903_comb;
  wire [23:0] p1_add_5921_comb;
  wire [23:0] p1_add_5922_comb;
  wire [15:0] p1_bit_slice_5795_comb;
  wire [15:0] p1_add_5796_comb;
  wire [15:0] p1_add_5797_comb;
  wire [15:0] p1_bit_slice_5798_comb;
  wire [15:0] p1_add_5839_comb;
  wire [15:0] p1_bit_slice_5840_comb;
  wire [15:0] p1_bit_slice_5841_comb;
  wire [15:0] p1_add_5842_comb;
  wire [16:0] p1_concat_5859_comb;
  wire [16:0] p1_concat_5860_comb;
  wire [16:0] p1_concat_5861_comb;
  wire [16:0] p1_concat_5862_comb;
  wire [16:0] p1_concat_5867_comb;
  wire [16:0] p1_concat_5868_comb;
  wire [16:0] p1_concat_5869_comb;
  wire [16:0] p1_concat_5870_comb;
  wire p1_bit_slice_5883_comb;
  wire p1_bit_slice_5884_comb;
  wire p1_bit_slice_5905_comb;
  wire p1_bit_slice_5906_comb;
  wire [15:0] p1_concat_5911_comb;
  wire [15:0] p1_concat_5912_comb;
  wire [15:0] p1_concat_5913_comb;
  wire [15:0] p1_concat_5914_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [15:0] p1_concat_5917_comb;
  wire [15:0] p1_concat_5918_comb;
  wire [15:0] p1_concat_5919_comb;
  wire [15:0] p1_concat_5920_comb;
  wire [23:0] p1_add_5923_comb;
  assign p1_array_index_5639_comb = p0_x[3'h0];
  assign p1_array_index_5648_comb = p0_x[3'h2];
  assign p1_array_index_5650_comb = p0_x[3'h5];
  assign p1_array_index_5645_comb = p0_x[3'h7];
  assign p1_array_index_5641_comb = p0_x[3'h1];
  assign p1_array_index_5654_comb = p0_x[3'h3];
  assign p1_array_index_5656_comb = p0_x[3'h4];
  assign p1_array_index_5643_comb = p0_x[3'h6];
  assign p1_smul_3326_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5639_comb, 9'h0d5);
  assign p1_smul_3324_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h105);
  assign p1_smul_3321_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5650_comb, 9'h0fb);
  assign p1_smul_3319_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5645_comb, 9'h12b);
  assign p1_smul_3309_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5641_comb, 9'h105);
  assign p1_smul_3307_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5654_comb, 9'h0d5);
  assign p1_smul_3306_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5656_comb, 9'h0d5);
  assign p1_smul_3304_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5643_comb, 9'h105);
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
  assign p1_smul_3342_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5639_comb, 9'h0fb);
  assign p1_smul_3341_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5641_comb, 9'h0d5);
  assign p1_smul_3336_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5643_comb, 9'h12b);
  assign p1_smul_3335_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5645_comb, 9'h105);
  assign p1_smul_3292_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5648_comb, 9'h0d5);
  assign p1_smul_3291_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5654_comb, 9'h105);
  assign p1_smul_3290_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5656_comb, 9'h105);
  assign p1_smul_3289_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5650_comb, 9'h0d5);
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
  assign p1_smul_3334_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5639_comb, 7'h3b);
  assign p1_bit_slice_5800_comb = p1_smul_3333_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5801_comb = p1_smul_3332_NarrowedMult__comb[14:1];
  assign p1_smul_3331_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5654_comb, 7'h45);
  assign p1_smul_3330_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5656_comb, 7'h45);
  assign p1_bit_slice_5804_comb = p1_smul_3329_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5805_comb = p1_smul_3328_NarrowedMult__comb[14:1];
  assign p1_smul_3327_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5645_comb, 7'h3b);
  assign p1_bit_slice_5831_comb = p1_smul_3302_NarrowedMult__comb[14:1];
  assign p1_smul_3301_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5641_comb, 7'h45);
  assign p1_bit_slice_5833_comb = p1_smul_3300_NarrowedMult__comb[14:1];
  assign p1_smul_3299_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5654_comb, 7'h3b);
  assign p1_smul_3298_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5656_comb, 7'h3b);
  assign p1_bit_slice_5836_comb = p1_smul_3297_NarrowedMult__comb[14:1];
  assign p1_smul_3296_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5643_comb, 7'h45);
  assign p1_bit_slice_5838_comb = p1_smul_3295_NarrowedMult__comb[14:1];
  assign p1_add_5879_comb = {{1{p1_array_index_5639_comb[7]}}, p1_array_index_5639_comb} + {{1{p1_array_index_5641_comb[7]}}, p1_array_index_5641_comb};
  assign p1_add_5880_comb = {{1{p1_array_index_5648_comb[7]}}, p1_array_index_5648_comb} + {{1{p1_array_index_5654_comb[7]}}, p1_array_index_5654_comb};
  assign p1_add_5881_comb = {{1{p1_array_index_5656_comb[7]}}, p1_array_index_5656_comb} + {{1{p1_array_index_5650_comb[7]}}, p1_array_index_5650_comb};
  assign p1_add_5882_comb = {{1{p1_array_index_5643_comb[7]}}, p1_array_index_5643_comb} + {{1{p1_array_index_5645_comb[7]}}, p1_array_index_5645_comb};
  assign p1_smul_3340_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5648_comb, 8'h47);
  assign p1_smul_3356_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5654_comb, 6'h19);
  assign p1_smul_3358_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5656_comb, 6'h27);
  assign p1_smul_3337_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5650_comb, 8'hb9);
  assign p1_smul_3545_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5639_comb, 6'h19);
  assign p1_smul_3293_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5641_comb, 8'hb9);
  assign p1_smul_3288_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5643_comb, 8'hb9);
  assign p1_smul_3573_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5645_comb, 6'h19);
  assign p1_add_5863_comb = {{1{p1_smul_3318_NarrowedMult__comb[15]}}, p1_smul_3318_NarrowedMult__comb} + {{1{p1_smul_3317_NarrowedMult__comb[15]}}, p1_smul_3317_NarrowedMult__comb};
  assign p1_add_5864_comb = {{1{p1_smul_3316_NarrowedMult__comb[15]}}, p1_smul_3316_NarrowedMult__comb} + {{1{p1_smul_3315_NarrowedMult__comb[15]}}, p1_smul_3315_NarrowedMult__comb};
  assign p1_add_5865_comb = {{1{p1_smul_3314_NarrowedMult__comb[15]}}, p1_smul_3314_NarrowedMult__comb} + {{1{p1_smul_3313_NarrowedMult__comb[15]}}, p1_smul_3313_NarrowedMult__comb};
  assign p1_add_5866_comb = {{1{p1_smul_3312_NarrowedMult__comb[15]}}, p1_smul_3312_NarrowedMult__comb} + {{1{p1_smul_3311_NarrowedMult__comb[15]}}, p1_smul_3311_NarrowedMult__comb};
  assign p1_add_5743_comb = {{1{p1_smul_3342_NarrowedMult__comb[15]}}, p1_smul_3342_NarrowedMult__comb} + {{1{p1_smul_3341_NarrowedMult__comb[15]}}, p1_smul_3341_NarrowedMult__comb};
  assign p1_add_5748_comb = {{1{p1_smul_3336_NarrowedMult__comb[15]}}, p1_smul_3336_NarrowedMult__comb} + {{1{p1_smul_3335_NarrowedMult__comb[15]}}, p1_smul_3335_NarrowedMult__comb};
  assign p1_add_5791_comb = {{1{p1_smul_3292_NarrowedMult__comb[15]}}, p1_smul_3292_NarrowedMult__comb} + {{1{p1_smul_3291_NarrowedMult__comb[15]}}, p1_smul_3291_NarrowedMult__comb};
  assign p1_add_5792_comb = {{1{p1_smul_3290_NarrowedMult__comb[15]}}, p1_smul_3290_NarrowedMult__comb} + {{1{p1_smul_3289_NarrowedMult__comb[15]}}, p1_smul_3289_NarrowedMult__comb};
  assign p1_add_5807_comb = {{1{p1_bit_slice_5707_comb[14]}}, p1_bit_slice_5707_comb} + {{2{p1_smul_3417_NarrowedMult__comb[13]}}, p1_smul_3417_NarrowedMult__comb};
  assign p1_add_5809_comb = {{1{p1_bit_slice_5709_comb[14]}}, p1_bit_slice_5709_comb} + {{1{p1_smul_3323_NarrowedMult__comb[14]}}, p1_smul_3323_NarrowedMult__comb};
  assign p1_add_5811_comb = {{1{p1_smul_3322_NarrowedMult__comb[14]}}, p1_smul_3322_NarrowedMult__comb} + {{1{p1_bit_slice_5712_comb[14]}}, p1_bit_slice_5712_comb};
  assign p1_add_5813_comb = {{2{p1_smul_3437_NarrowedMult__comb[13]}}, p1_smul_3437_NarrowedMult__comb} + {{1{p1_bit_slice_5714_comb[14]}}, p1_bit_slice_5714_comb};
  assign p1_add_5823_comb = {{1{p1_smul_3310_NarrowedMult__comb[14]}}, p1_smul_3310_NarrowedMult__comb} + {{1{p1_bit_slice_5724_comb[14]}}, p1_bit_slice_5724_comb};
  assign p1_add_5825_comb = {{2{p1_smul_3484_NarrowedMult__comb[13]}}, p1_smul_3484_NarrowedMult__comb} + {{1{p1_bit_slice_5726_comb[14]}}, p1_bit_slice_5726_comb};
  assign p1_add_5827_comb = {{1{p1_bit_slice_5727_comb[14]}}, p1_bit_slice_5727_comb} + {{2{p1_smul_3494_NarrowedMult__comb[13]}}, p1_smul_3494_NarrowedMult__comb};
  assign p1_add_5829_comb = {{1{p1_bit_slice_5729_comb[14]}}, p1_bit_slice_5729_comb} + {{1{p1_smul_3303_NarrowedMult__comb[14]}}, p1_smul_3303_NarrowedMult__comb};
  assign p1_add_5885_comb = {{1{p1_smul_3334_NarrowedMult__comb[13]}}, p1_smul_3334_NarrowedMult__comb} + {{1{p1_bit_slice_5800_comb[13]}}, p1_bit_slice_5800_comb};
  assign p1_add_5887_comb = {{1{p1_bit_slice_5801_comb[13]}}, p1_bit_slice_5801_comb} + {{1{p1_smul_3331_NarrowedMult__comb[13]}}, p1_smul_3331_NarrowedMult__comb};
  assign p1_add_5889_comb = {{1{p1_smul_3330_NarrowedMult__comb[13]}}, p1_smul_3330_NarrowedMult__comb} + {{1{p1_bit_slice_5804_comb[13]}}, p1_bit_slice_5804_comb};
  assign p1_add_5891_comb = {{1{p1_bit_slice_5805_comb[13]}}, p1_bit_slice_5805_comb} + {{1{p1_smul_3327_NarrowedMult__comb[13]}}, p1_smul_3327_NarrowedMult__comb};
  assign p1_sum__97_comb = {{8{p1_add_5863_comb[16]}}, p1_add_5863_comb};
  assign p1_sum__98_comb = {{8{p1_add_5864_comb[16]}}, p1_add_5864_comb};
  assign p1_sum__99_comb = {{8{p1_add_5865_comb[16]}}, p1_add_5865_comb};
  assign p1_sum__100_comb = {{8{p1_add_5866_comb[16]}}, p1_add_5866_comb};
  assign p1_add_5897_comb = {{1{p1_bit_slice_5831_comb[13]}}, p1_bit_slice_5831_comb} + {{1{p1_smul_3301_NarrowedMult__comb[13]}}, p1_smul_3301_NarrowedMult__comb};
  assign p1_add_5899_comb = {{1{p1_bit_slice_5833_comb[13]}}, p1_bit_slice_5833_comb} + {{1{p1_smul_3299_NarrowedMult__comb[13]}}, p1_smul_3299_NarrowedMult__comb};
  assign p1_add_5901_comb = {{1{p1_smul_3298_NarrowedMult__comb[13]}}, p1_smul_3298_NarrowedMult__comb} + {{1{p1_bit_slice_5836_comb[13]}}, p1_bit_slice_5836_comb};
  assign p1_add_5903_comb = {{1{p1_smul_3296_NarrowedMult__comb[13]}}, p1_smul_3296_NarrowedMult__comb} + {{1{p1_bit_slice_5838_comb[13]}}, p1_bit_slice_5838_comb};
  assign p1_add_5921_comb = {{15{p1_add_5879_comb[8]}}, p1_add_5879_comb} + {{15{p1_add_5880_comb[8]}}, p1_add_5880_comb};
  assign p1_add_5922_comb = {{15{p1_add_5881_comb[8]}}, p1_add_5881_comb} + {{15{p1_add_5882_comb[8]}}, p1_add_5882_comb};
  assign p1_bit_slice_5795_comb = p1_add_5743_comb[16:1];
  assign p1_add_5796_comb = {{1{p1_smul_3340_NarrowedMult__comb[14]}}, p1_smul_3340_NarrowedMult__comb} + {{2{p1_smul_3356_NarrowedMult__comb[13]}}, p1_smul_3356_NarrowedMult__comb};
  assign p1_add_5797_comb = {{2{p1_smul_3358_NarrowedMult__comb[13]}}, p1_smul_3358_NarrowedMult__comb} + {{1{p1_smul_3337_NarrowedMult__comb[14]}}, p1_smul_3337_NarrowedMult__comb};
  assign p1_bit_slice_5798_comb = p1_add_5748_comb[16:1];
  assign p1_add_5839_comb = {{2{p1_smul_3545_NarrowedMult__comb[13]}}, p1_smul_3545_NarrowedMult__comb} + {{1{p1_smul_3293_NarrowedMult__comb[14]}}, p1_smul_3293_NarrowedMult__comb};
  assign p1_bit_slice_5840_comb = p1_add_5791_comb[16:1];
  assign p1_bit_slice_5841_comb = p1_add_5792_comb[16:1];
  assign p1_add_5842_comb = {{1{p1_smul_3288_NarrowedMult__comb[14]}}, p1_smul_3288_NarrowedMult__comb} + {{2{p1_smul_3573_NarrowedMult__comb[13]}}, p1_smul_3573_NarrowedMult__comb};
  assign p1_concat_5859_comb = {p1_add_5807_comb, p1_smul_3326_NarrowedMult__comb[0]};
  assign p1_concat_5860_comb = {p1_add_5809_comb, p1_smul_3324_NarrowedMult__comb[0]};
  assign p1_concat_5861_comb = {p1_add_5811_comb, p1_smul_3321_NarrowedMult__comb[0]};
  assign p1_concat_5862_comb = {p1_add_5813_comb, p1_smul_3319_NarrowedMult__comb[0]};
  assign p1_concat_5867_comb = {p1_add_5823_comb, p1_smul_3309_NarrowedMult__comb[0]};
  assign p1_concat_5868_comb = {p1_add_5825_comb, p1_smul_3307_NarrowedMult__comb[0]};
  assign p1_concat_5869_comb = {p1_add_5827_comb, p1_smul_3306_NarrowedMult__comb[0]};
  assign p1_concat_5870_comb = {p1_add_5829_comb, p1_smul_3304_NarrowedMult__comb[0]};
  assign p1_bit_slice_5883_comb = p1_add_5743_comb[0];
  assign p1_bit_slice_5884_comb = p1_add_5748_comb[0];
  assign p1_bit_slice_5905_comb = p1_add_5791_comb[0];
  assign p1_bit_slice_5906_comb = p1_add_5792_comb[0];
  assign p1_concat_5911_comb = {p1_add_5885_comb, p1_smul_3333_NarrowedMult__comb[0]};
  assign p1_concat_5912_comb = {p1_add_5887_comb, p1_smul_3332_NarrowedMult__comb[0]};
  assign p1_concat_5913_comb = {p1_add_5889_comb, p1_smul_3329_NarrowedMult__comb[0]};
  assign p1_concat_5914_comb = {p1_add_5891_comb, p1_smul_3328_NarrowedMult__comb[0]};
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_concat_5917_comb = {p1_add_5897_comb, p1_smul_3302_NarrowedMult__comb[0]};
  assign p1_concat_5918_comb = {p1_add_5899_comb, p1_smul_3300_NarrowedMult__comb[0]};
  assign p1_concat_5919_comb = {p1_add_5901_comb, p1_smul_3297_NarrowedMult__comb[0]};
  assign p1_concat_5920_comb = {p1_add_5903_comb, p1_smul_3295_NarrowedMult__comb[0]};
  assign p1_add_5923_comb = p1_add_5921_comb + p1_add_5922_comb;

  // Registers for pipe stage 1:
  reg [15:0] p1_bit_slice_5795;
  reg [15:0] p1_add_5796;
  reg [15:0] p1_add_5797;
  reg [15:0] p1_bit_slice_5798;
  reg [15:0] p1_add_5839;
  reg [15:0] p1_bit_slice_5840;
  reg [15:0] p1_bit_slice_5841;
  reg [15:0] p1_add_5842;
  reg [16:0] p1_concat_5859;
  reg [16:0] p1_concat_5860;
  reg [16:0] p1_concat_5861;
  reg [16:0] p1_concat_5862;
  reg [16:0] p1_concat_5867;
  reg [16:0] p1_concat_5868;
  reg [16:0] p1_concat_5869;
  reg [16:0] p1_concat_5870;
  reg p1_bit_slice_5883;
  reg p1_bit_slice_5884;
  reg p1_bit_slice_5905;
  reg p1_bit_slice_5906;
  reg [15:0] p1_concat_5911;
  reg [15:0] p1_concat_5912;
  reg [15:0] p1_concat_5913;
  reg [15:0] p1_concat_5914;
  reg [24:0] p1_sum__77;
  reg [24:0] p1_sum__78;
  reg [15:0] p1_concat_5917;
  reg [15:0] p1_concat_5918;
  reg [15:0] p1_concat_5919;
  reg [15:0] p1_concat_5920;
  reg [23:0] p1_add_5923;
  always @ (posedge clk) begin
    p1_bit_slice_5795 <= p1_bit_slice_5795_comb;
    p1_add_5796 <= p1_add_5796_comb;
    p1_add_5797 <= p1_add_5797_comb;
    p1_bit_slice_5798 <= p1_bit_slice_5798_comb;
    p1_add_5839 <= p1_add_5839_comb;
    p1_bit_slice_5840 <= p1_bit_slice_5840_comb;
    p1_bit_slice_5841 <= p1_bit_slice_5841_comb;
    p1_add_5842 <= p1_add_5842_comb;
    p1_concat_5859 <= p1_concat_5859_comb;
    p1_concat_5860 <= p1_concat_5860_comb;
    p1_concat_5861 <= p1_concat_5861_comb;
    p1_concat_5862 <= p1_concat_5862_comb;
    p1_concat_5867 <= p1_concat_5867_comb;
    p1_concat_5868 <= p1_concat_5868_comb;
    p1_concat_5869 <= p1_concat_5869_comb;
    p1_concat_5870 <= p1_concat_5870_comb;
    p1_bit_slice_5883 <= p1_bit_slice_5883_comb;
    p1_bit_slice_5884 <= p1_bit_slice_5884_comb;
    p1_bit_slice_5905 <= p1_bit_slice_5905_comb;
    p1_bit_slice_5906 <= p1_bit_slice_5906_comb;
    p1_concat_5911 <= p1_concat_5911_comb;
    p1_concat_5912 <= p1_concat_5912_comb;
    p1_concat_5913 <= p1_concat_5913_comb;
    p1_concat_5914 <= p1_concat_5914_comb;
    p1_sum__77 <= p1_sum__77_comb;
    p1_sum__78 <= p1_sum__78_comb;
    p1_concat_5917 <= p1_concat_5917_comb;
    p1_concat_5918 <= p1_concat_5918_comb;
    p1_concat_5919 <= p1_concat_5919_comb;
    p1_concat_5920 <= p1_concat_5920_comb;
    p1_add_5923 <= p1_add_5923_comb;
  end

  // ===== Pipe stage 2:
  wire [24:0] p2_sum__101_comb;
  wire [24:0] p2_sum__102_comb;
  wire [24:0] p2_sum__103_comb;
  wire [24:0] p2_sum__104_comb;
  wire [24:0] p2_sum__93_comb;
  wire [24:0] p2_sum__94_comb;
  wire [24:0] p2_sum__95_comb;
  wire [24:0] p2_sum__96_comb;
  wire [24:0] p2_sum__67_comb;
  wire [24:0] p2_sum__79_comb;
  wire [24:0] p2_sum__80_comb;
  wire [24:0] p2_sum__75_comb;
  wire [24:0] p2_sum__76_comb;
  wire [23:0] p2_add_6034_comb;
  wire [23:0] p2_add_6035_comb;
  wire [24:0] p2_add_6037_comb;
  wire [23:0] p2_add_6039_comb;
  wire [23:0] p2_add_6040_comb;
  wire [23:0] p2_add_5994_comb;
  wire [23:0] p2_add_5995_comb;
  wire [23:0] p2_add_6004_comb;
  wire [23:0] p2_add_6005_comb;
  wire [24:0] p2_sum__68_comb;
  wire [24:0] p2_sum__66_comb;
  wire [23:0] p2_umul_2791_NarrowedMult__comb;
  wire [23:0] p2_add_6044_comb;
  wire [23:0] p2_add_6052_comb;
  wire [24:0] p2_sum__83_comb;
  wire [24:0] p2_sum__84_comb;
  wire [24:0] p2_sum__71_comb;
  wire [24:0] p2_sum__72_comb;
  wire [24:0] p2_add_6036_comb;
  wire [24:0] p2_add_6038_comb;
  wire [24:0] p2_sum__70_comb;
  wire [24:0] p2_sum__64_comb;
  wire [24:0] p2_add_6033_comb;
  wire [24:0] p2_add_6041_comb;
  wire p2_sgt_6063_comb;
  wire [8:0] p2_bit_slice_6064_comb;
  wire p2_sgt_6070_comb;
  wire [8:0] p2_bit_slice_6071_comb;
  wire p2_slt_6082_comb;
  wire p2_slt_6086_comb;
  wire [8:0] p2_clipped__16_comb;
  wire [8:0] p2_clipped__18_comb;
  wire [8:0] p2_clipped__20_comb;
  wire [8:0] p2_clipped__22_comb;
  assign p2_sum__101_comb = {{8{p1_concat_5859[16]}}, p1_concat_5859};
  assign p2_sum__102_comb = {{8{p1_concat_5860[16]}}, p1_concat_5860};
  assign p2_sum__103_comb = {{8{p1_concat_5861[16]}}, p1_concat_5861};
  assign p2_sum__104_comb = {{8{p1_concat_5862[16]}}, p1_concat_5862};
  assign p2_sum__93_comb = {{8{p1_concat_5867[16]}}, p1_concat_5867};
  assign p2_sum__94_comb = {{8{p1_concat_5868[16]}}, p1_concat_5868};
  assign p2_sum__95_comb = {{8{p1_concat_5869[16]}}, p1_concat_5869};
  assign p2_sum__96_comb = {{8{p1_concat_5870[16]}}, p1_concat_5870};
  assign p2_sum__67_comb = p1_sum__77 + p1_sum__78;
  assign p2_sum__79_comb = p2_sum__101_comb + p2_sum__102_comb;
  assign p2_sum__80_comb = p2_sum__103_comb + p2_sum__104_comb;
  assign p2_sum__75_comb = p2_sum__93_comb + p2_sum__94_comb;
  assign p2_sum__76_comb = p2_sum__95_comb + p2_sum__96_comb;
  assign p2_add_6034_comb = {{8{p1_concat_5911[15]}}, p1_concat_5911} + {{8{p1_concat_5912[15]}}, p1_concat_5912};
  assign p2_add_6035_comb = {{8{p1_concat_5913[15]}}, p1_concat_5913} + {{8{p1_concat_5914[15]}}, p1_concat_5914};
  assign p2_add_6037_comb = p2_sum__67_comb + 25'h000_0001;
  assign p2_add_6039_comb = {{8{p1_concat_5917[15]}}, p1_concat_5917} + {{8{p1_concat_5918[15]}}, p1_concat_5918};
  assign p2_add_6040_comb = {{8{p1_concat_5919[15]}}, p1_concat_5919} + {{8{p1_concat_5920[15]}}, p1_concat_5920};
  assign p2_add_5994_comb = {{8{p1_bit_slice_5795[15]}}, p1_bit_slice_5795} + {{8{p1_add_5796[15]}}, p1_add_5796};
  assign p2_add_5995_comb = {{8{p1_add_5797[15]}}, p1_add_5797} + {{8{p1_bit_slice_5798[15]}}, p1_bit_slice_5798};
  assign p2_add_6004_comb = {{8{p1_add_5839[15]}}, p1_add_5839} + {{8{p1_bit_slice_5840[15]}}, p1_bit_slice_5840};
  assign p2_add_6005_comb = {{8{p1_bit_slice_5841[15]}}, p1_bit_slice_5841} + {{8{p1_add_5842[15]}}, p1_add_5842};
  assign p2_sum__68_comb = p2_sum__79_comb + p2_sum__80_comb;
  assign p2_sum__66_comb = p2_sum__75_comb + p2_sum__76_comb;
  assign p2_umul_2791_NarrowedMult__comb = umul24b_24b_x_7b(p1_add_5923, 7'h5b);
  assign p2_add_6044_comb = p2_add_6034_comb + p2_add_6035_comb;
  assign p2_add_6052_comb = p2_add_6039_comb + p2_add_6040_comb;
  assign p2_sum__83_comb = {p2_add_5994_comb, p1_bit_slice_5883};
  assign p2_sum__84_comb = {p2_add_5995_comb, p1_bit_slice_5884};
  assign p2_sum__71_comb = {p2_add_6004_comb, p1_bit_slice_5905};
  assign p2_sum__72_comb = {p2_add_6005_comb, p1_bit_slice_5906};
  assign p2_add_6036_comb = p2_sum__68_comb + 25'h000_0001;
  assign p2_add_6038_comb = p2_sum__66_comb + 25'h000_0001;
  assign p2_sum__70_comb = p2_sum__83_comb + p2_sum__84_comb;
  assign p2_sum__64_comb = p2_sum__71_comb + p2_sum__72_comb;
  assign p2_add_6033_comb = p2_sum__70_comb + 25'h000_0001;
  assign p2_add_6041_comb = p2_sum__64_comb + 25'h000_0001;
  assign p2_sgt_6063_comb = $signed(p2_add_6036_comb[24:1]) > $signed(24'h00_7fff);
  assign p2_bit_slice_6064_comb = p2_add_6036_comb[16:8];
  assign p2_sgt_6070_comb = $signed(p2_add_6038_comb[24:1]) > $signed(24'h00_7fff);
  assign p2_bit_slice_6071_comb = p2_add_6038_comb[16:8];
  assign p2_slt_6082_comb = $signed(p2_add_6036_comb[24:1]) < $signed(24'hff_8000);
  assign p2_slt_6086_comb = $signed(p2_add_6038_comb[24:1]) < $signed(24'hff_8000);
  assign p2_clipped__16_comb = $signed(p2_umul_2791_NarrowedMult__comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_umul_2791_NarrowedMult__comb) > $signed(24'h00_7fff) ? 9'h0ff : p2_umul_2791_NarrowedMult__comb[15:7]);
  assign p2_clipped__18_comb = $signed(p2_add_6044_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_add_6044_comb) > $signed(24'h00_7fff) ? 9'h0ff : p2_add_6044_comb[15:7]);
  assign p2_clipped__20_comb = $signed(p2_add_6037_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_add_6037_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p2_add_6037_comb[16:8]);
  assign p2_clipped__22_comb = $signed(p2_add_6052_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_add_6052_comb) > $signed(24'h00_7fff) ? 9'h0ff : p2_add_6052_comb[15:7]);

  // Registers for pipe stage 2:
  reg [24:0] p2_add_6033;
  reg [24:0] p2_add_6041;
  reg p2_sgt_6063;
  reg [8:0] p2_bit_slice_6064;
  reg p2_sgt_6070;
  reg [8:0] p2_bit_slice_6071;
  reg p2_slt_6082;
  reg p2_slt_6086;
  reg [8:0] p2_clipped__16;
  reg [8:0] p2_clipped__18;
  reg [8:0] p2_clipped__20;
  reg [8:0] p2_clipped__22;
  always @ (posedge clk) begin
    p2_add_6033 <= p2_add_6033_comb;
    p2_add_6041 <= p2_add_6041_comb;
    p2_sgt_6063 <= p2_sgt_6063_comb;
    p2_bit_slice_6064 <= p2_bit_slice_6064_comb;
    p2_sgt_6070 <= p2_sgt_6070_comb;
    p2_bit_slice_6071 <= p2_bit_slice_6071_comb;
    p2_slt_6082 <= p2_slt_6082_comb;
    p2_slt_6086 <= p2_slt_6086_comb;
    p2_clipped__16 <= p2_clipped__16_comb;
    p2_clipped__18 <= p2_clipped__18_comb;
    p2_clipped__20 <= p2_clipped__20_comb;
    p2_clipped__22 <= p2_clipped__22_comb;
  end

  // ===== Pipe stage 3:
  wire [8:0] p3_clipped__19_comb;
  wire [8:0] p3_clipped__21_comb;
  wire [9:0] p3_add_6162_comb;
  wire [9:0] p3_add_6164_comb;
  wire [9:0] p3_add_6166_comb;
  wire [9:0] p3_add_6168_comb;
  wire [8:0] p3_clipped__17_comb;
  wire [8:0] p3_clipped__23_comb;
  wire [9:0] p3_add_6165_comb;
  wire [9:0] p3_add_6167_comb;
  wire [9:0] p3_add_6163_comb;
  wire [9:0] p3_add_6169_comb;
  wire p3_not_6178_comb;
  wire p3_not_6180_comb;
  wire [7:0] p3_bit_slice_6186_comb;
  wire [7:0] p3_bit_slice_6189_comb;
  wire [7:0] p3_clipped__8_comb;
  wire [7:0] p3_clipped__10_comb;
  wire [7:0] p3_clipped__12_comb;
  wire [7:0] p3_clipped__14_comb;
  assign p3_clipped__19_comb = p2_slt_6082 ? 9'h100 : (p2_sgt_6063 ? 9'h0ff : p2_bit_slice_6064);
  assign p3_clipped__21_comb = p2_slt_6086 ? 9'h100 : (p2_sgt_6070 ? 9'h0ff : p2_bit_slice_6071);
  assign p3_add_6162_comb = {{1{p2_clipped__16[8]}}, p2_clipped__16} + 10'h001;
  assign p3_add_6164_comb = {{1{p2_clipped__18[8]}}, p2_clipped__18} + 10'h001;
  assign p3_add_6166_comb = {{1{p2_clipped__20[8]}}, p2_clipped__20} + 10'h001;
  assign p3_add_6168_comb = {{1{p2_clipped__22[8]}}, p2_clipped__22} + 10'h001;
  assign p3_clipped__17_comb = $signed(p2_add_6033[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_add_6033[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p2_add_6033[16:8]);
  assign p3_clipped__23_comb = $signed(p2_add_6041[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p2_add_6041[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p2_add_6041[16:8]);
  assign p3_add_6165_comb = {{1{p3_clipped__19_comb[8]}}, p3_clipped__19_comb} + 10'h001;
  assign p3_add_6167_comb = {{1{p3_clipped__21_comb[8]}}, p3_clipped__21_comb} + 10'h001;
  assign p3_add_6163_comb = {{1{p3_clipped__17_comb[8]}}, p3_clipped__17_comb} + 10'h001;
  assign p3_add_6169_comb = {{1{p3_clipped__23_comb[8]}}, p3_clipped__23_comb} + 10'h001;
  assign p3_not_6178_comb = ~p3_add_6165_comb[9];
  assign p3_not_6180_comb = ~p3_add_6167_comb[9];
  assign p3_bit_slice_6186_comb = p3_add_6165_comb[8:1];
  assign p3_bit_slice_6189_comb = p3_add_6167_comb[8:1];
  assign p3_clipped__8_comb = p3_add_6162_comb[8:1] & {8{~p3_add_6162_comb[9]}};
  assign p3_clipped__10_comb = p3_add_6164_comb[8:1] & {8{~p3_add_6164_comb[9]}};
  assign p3_clipped__12_comb = p3_add_6166_comb[8:1] & {8{~p3_add_6166_comb[9]}};
  assign p3_clipped__14_comb = p3_add_6168_comb[8:1] & {8{~p3_add_6168_comb[9]}};

  // Registers for pipe stage 3:
  reg [9:0] p3_add_6163;
  reg [9:0] p3_add_6169;
  reg p3_not_6178;
  reg p3_not_6180;
  reg [7:0] p3_bit_slice_6186;
  reg [7:0] p3_bit_slice_6189;
  reg [7:0] p3_clipped__8;
  reg [7:0] p3_clipped__10;
  reg [7:0] p3_clipped__12;
  reg [7:0] p3_clipped__14;
  always @ (posedge clk) begin
    p3_add_6163 <= p3_add_6163_comb;
    p3_add_6169 <= p3_add_6169_comb;
    p3_not_6178 <= p3_not_6178_comb;
    p3_not_6180 <= p3_not_6180_comb;
    p3_bit_slice_6186 <= p3_bit_slice_6186_comb;
    p3_bit_slice_6189 <= p3_bit_slice_6189_comb;
    p3_clipped__8 <= p3_clipped__8_comb;
    p3_clipped__10 <= p3_clipped__10_comb;
    p3_clipped__12 <= p3_clipped__12_comb;
    p3_clipped__14 <= p3_clipped__14_comb;
  end

  // ===== Pipe stage 4:
  wire [7:0] p4_clipped__9_comb;
  wire [7:0] p4_clipped__11_comb;
  wire [7:0] p4_clipped__13_comb;
  wire [7:0] p4_clipped__15_comb;
  wire [7:0] p4_result_comb[0:7];
  assign p4_clipped__9_comb = p3_add_6163[8:1] & {8{~p3_add_6163[9]}};
  assign p4_clipped__11_comb = p3_bit_slice_6186 & {8{p3_not_6178}};
  assign p4_clipped__13_comb = p3_bit_slice_6189 & {8{p3_not_6180}};
  assign p4_clipped__15_comb = p3_add_6169[8:1] & {8{~p3_add_6169[9]}};
  assign p4_result_comb[0] = p3_clipped__8;
  assign p4_result_comb[1] = p4_clipped__9_comb;
  assign p4_result_comb[2] = p3_clipped__10;
  assign p4_result_comb[3] = p4_clipped__11_comb;
  assign p4_result_comb[4] = p3_clipped__12;
  assign p4_result_comb[5] = p4_clipped__13_comb;
  assign p4_result_comb[6] = p3_clipped__14;
  assign p4_result_comb[7] = p4_clipped__15_comb;

  // Registers for pipe stage 4:
  reg [7:0] p4_result[0:7];
  always @ (posedge clk) begin
    p4_result[0] <= p4_result_comb[0];
    p4_result[1] <= p4_result_comb[1];
    p4_result[2] <= p4_result_comb[2];
    p4_result[3] <= p4_result_comb[3];
    p4_result[4] <= p4_result_comb[4];
    p4_result[5] <= p4_result_comb[5];
    p4_result[6] <= p4_result_comb[6];
    p4_result[7] <= p4_result_comb[7];
  end
  assign out = {p4_result[7], p4_result[6], p4_result[5], p4_result[4], p4_result[3], p4_result[2], p4_result[1], p4_result[0]};
endmodule
