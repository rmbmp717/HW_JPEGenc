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
  wire [7:0] p1_array_index_5509_comb;
  wire [7:0] p1_array_index_5511_comb;
  wire [7:0] p1_array_index_5513_comb;
  wire [7:0] p1_array_index_5515_comb;
  wire [7:0] p1_array_index_5518_comb;
  wire [7:0] p1_array_index_5520_comb;
  wire [7:0] p1_array_index_5524_comb;
  wire [7:0] p1_array_index_5526_comb;
  wire [15:0] p1_smul_3212_NarrowedMult__comb;
  wire [15:0] p1_smul_3211_NarrowedMult__comb;
  wire [15:0] p1_smul_3206_NarrowedMult__comb;
  wire [15:0] p1_smul_3205_NarrowedMult__comb;
  wire [15:0] p1_smul_3196_NarrowedMult__comb;
  wire [15:0] p1_smul_3194_NarrowedMult__comb;
  wire [15:0] p1_smul_3191_NarrowedMult__comb;
  wire [15:0] p1_smul_3189_NarrowedMult__comb;
  wire [15:0] p1_smul_3179_NarrowedMult__comb;
  wire [15:0] p1_smul_3177_NarrowedMult__comb;
  wire [15:0] p1_smul_3176_NarrowedMult__comb;
  wire [15:0] p1_smul_3174_NarrowedMult__comb;
  wire [15:0] p1_smul_3162_NarrowedMult__comb;
  wire [15:0] p1_smul_3161_NarrowedMult__comb;
  wire [15:0] p1_smul_3160_NarrowedMult__comb;
  wire [15:0] p1_smul_3159_NarrowedMult__comb;
  wire [14:0] p1_smul_3210_NarrowedMult__comb;
  wire [13:0] p1_smul_3226_NarrowedMult__comb;
  wire [13:0] p1_smul_3228_NarrowedMult__comb;
  wire [14:0] p1_smul_3207_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5577_comb;
  wire [13:0] p1_smul_3287_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5579_comb;
  wire [14:0] p1_smul_3193_NarrowedMult__comb;
  wire [14:0] p1_smul_3192_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5582_comb;
  wire [13:0] p1_smul_3307_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5584_comb;
  wire [14:0] p1_smul_3180_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5594_comb;
  wire [13:0] p1_smul_3354_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5596_comb;
  wire [14:0] p1_bit_slice_5597_comb;
  wire [13:0] p1_smul_3364_NarrowedMult__comb;
  wire [14:0] p1_bit_slice_5599_comb;
  wire [14:0] p1_smul_3173_NarrowedMult__comb;
  wire [13:0] p1_smul_3415_NarrowedMult__comb;
  wire [14:0] p1_smul_3163_NarrowedMult__comb;
  wire [14:0] p1_smul_3158_NarrowedMult__comb;
  wire [13:0] p1_smul_3443_NarrowedMult__comb;
  wire [16:0] p1_add_5613_comb;
  wire [16:0] p1_add_5618_comb;
  wire [14:0] p1_smul_3203_NarrowedMult__comb;
  wire [14:0] p1_smul_3202_NarrowedMult__comb;
  wire [14:0] p1_smul_3199_NarrowedMult__comb;
  wire [14:0] p1_smul_3198_NarrowedMult__comb;
  wire [15:0] p1_smul_3188_NarrowedMult__comb;
  wire [15:0] p1_smul_3187_NarrowedMult__comb;
  wire [15:0] p1_smul_3186_NarrowedMult__comb;
  wire [15:0] p1_smul_3185_NarrowedMult__comb;
  wire [15:0] p1_smul_3184_NarrowedMult__comb;
  wire [15:0] p1_smul_3183_NarrowedMult__comb;
  wire [15:0] p1_smul_3182_NarrowedMult__comb;
  wire [15:0] p1_smul_3181_NarrowedMult__comb;
  wire [14:0] p1_smul_3172_NarrowedMult__comb;
  wire [14:0] p1_smul_3170_NarrowedMult__comb;
  wire [14:0] p1_smul_3167_NarrowedMult__comb;
  wire [14:0] p1_smul_3165_NarrowedMult__comb;
  wire [16:0] p1_add_5661_comb;
  wire [16:0] p1_add_5662_comb;
  wire [15:0] p1_bit_slice_5665_comb;
  wire [15:0] p1_add_5666_comb;
  wire [15:0] p1_add_5667_comb;
  wire [15:0] p1_bit_slice_5668_comb;
  wire [13:0] p1_smul_3204_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5670_comb;
  wire [13:0] p1_bit_slice_5671_comb;
  wire [13:0] p1_smul_3201_NarrowedMult__comb;
  wire [13:0] p1_smul_3200_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5674_comb;
  wire [13:0] p1_bit_slice_5675_comb;
  wire [13:0] p1_smul_3197_NarrowedMult__comb;
  wire [15:0] p1_add_5677_comb;
  wire [15:0] p1_add_5679_comb;
  wire [15:0] p1_add_5681_comb;
  wire [15:0] p1_add_5683_comb;
  wire [15:0] p1_add_5693_comb;
  wire [15:0] p1_add_5695_comb;
  wire [15:0] p1_add_5697_comb;
  wire [15:0] p1_add_5699_comb;
  wire [13:0] p1_bit_slice_5701_comb;
  wire [13:0] p1_smul_3171_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5703_comb;
  wire [13:0] p1_smul_3169_NarrowedMult__comb;
  wire [13:0] p1_smul_3168_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5706_comb;
  wire [13:0] p1_smul_3166_NarrowedMult__comb;
  wire [13:0] p1_bit_slice_5708_comb;
  wire [15:0] p1_add_5709_comb;
  wire [15:0] p1_bit_slice_5710_comb;
  wire [15:0] p1_bit_slice_5711_comb;
  wire [15:0] p1_add_5712_comb;
  wire [16:0] p1_concat_5733_comb;
  wire [16:0] p1_concat_5734_comb;
  wire [16:0] p1_concat_5735_comb;
  wire [16:0] p1_concat_5736_comb;
  wire [16:0] p1_add_5737_comb;
  wire [16:0] p1_add_5738_comb;
  wire [16:0] p1_add_5739_comb;
  wire [16:0] p1_add_5740_comb;
  wire [16:0] p1_concat_5741_comb;
  wire [16:0] p1_concat_5742_comb;
  wire [16:0] p1_concat_5743_comb;
  wire [16:0] p1_concat_5744_comb;
  wire [8:0] p1_add_5757_comb;
  wire [8:0] p1_add_5758_comb;
  wire [8:0] p1_add_5759_comb;
  wire [8:0] p1_add_5760_comb;
  wire [23:0] p1_add_5761_comb;
  wire [23:0] p1_add_5763_comb;
  wire [14:0] p1_add_5765_comb;
  wire [14:0] p1_add_5767_comb;
  wire [14:0] p1_add_5769_comb;
  wire [14:0] p1_add_5771_comb;
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
  wire [14:0] p1_add_5785_comb;
  wire [14:0] p1_add_5787_comb;
  wire [14:0] p1_add_5789_comb;
  wire [14:0] p1_add_5791_comb;
  wire [23:0] p1_add_5793_comb;
  wire [23:0] p1_add_5795_comb;
  wire [24:0] p1_sum__83_comb;
  wire [24:0] p1_sum__84_comb;
  wire [15:0] p1_concat_5803_comb;
  wire [15:0] p1_concat_5804_comb;
  wire [15:0] p1_concat_5805_comb;
  wire [15:0] p1_concat_5806_comb;
  wire [24:0] p1_sum__79_comb;
  wire [24:0] p1_sum__80_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [24:0] p1_sum__75_comb;
  wire [24:0] p1_sum__76_comb;
  wire [15:0] p1_concat_5813_comb;
  wire [15:0] p1_concat_5814_comb;
  wire [15:0] p1_concat_5815_comb;
  wire [15:0] p1_concat_5816_comb;
  wire [24:0] p1_sum__71_comb;
  wire [24:0] p1_sum__72_comb;
  wire [23:0] p1_add_5819_comb;
  wire [23:0] p1_add_5820_comb;
  wire [24:0] p1_sum__70_comb;
  wire [24:0] p1_sum__68_comb;
  wire [24:0] p1_sum__67_comb;
  wire [24:0] p1_sum__66_comb;
  wire [24:0] p1_sum__64_comb;
  wire [23:0] p1_add_5839_comb;
  wire [24:0] p1_add_5841_comb;
  wire [23:0] p1_add_5842_comb;
  wire [23:0] p1_add_5843_comb;
  wire [24:0] p1_add_5844_comb;
  wire [24:0] p1_add_5845_comb;
  wire [24:0] p1_add_5846_comb;
  wire [23:0] p1_add_5847_comb;
  wire [23:0] p1_add_5848_comb;
  wire [24:0] p1_add_5849_comb;
  wire [23:0] p1_umul_2661_NarrowedMult__comb;
  wire [23:0] p1_add_5854_comb;
  wire [23:0] p1_add_5862_comb;
  wire [8:0] p1_clipped__16_comb;
  wire [8:0] p1_clipped__17_comb;
  wire [8:0] p1_clipped__18_comb;
  wire [8:0] p1_clipped__19_comb;
  wire [8:0] p1_clipped__20_comb;
  wire [8:0] p1_clipped__21_comb;
  wire [8:0] p1_clipped__22_comb;
  wire [8:0] p1_clipped__23_comb;
  wire [9:0] p1_add_5946_comb;
  wire [9:0] p1_add_5947_comb;
  wire [9:0] p1_add_5948_comb;
  wire [9:0] p1_add_5949_comb;
  wire [9:0] p1_add_5950_comb;
  wire [9:0] p1_add_5951_comb;
  wire [9:0] p1_add_5952_comb;
  wire [9:0] p1_add_5953_comb;
  wire [7:0] p1_clipped__8_comb;
  wire [7:0] p1_clipped__9_comb;
  wire [7:0] p1_clipped__10_comb;
  wire [7:0] p1_clipped__11_comb;
  wire [7:0] p1_clipped__12_comb;
  wire [7:0] p1_clipped__13_comb;
  wire [7:0] p1_clipped__14_comb;
  wire [7:0] p1_clipped__15_comb;
  wire [7:0] p1_result_comb[0:7];
  assign p1_array_index_5509_comb = p0_x[3'h0];
  assign p1_array_index_5511_comb = p0_x[3'h1];
  assign p1_array_index_5513_comb = p0_x[3'h6];
  assign p1_array_index_5515_comb = p0_x[3'h7];
  assign p1_array_index_5518_comb = p0_x[3'h2];
  assign p1_array_index_5520_comb = p0_x[3'h5];
  assign p1_array_index_5524_comb = p0_x[3'h3];
  assign p1_array_index_5526_comb = p0_x[3'h4];
  assign p1_smul_3212_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5509_comb, 9'h0fb);
  assign p1_smul_3211_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5511_comb, 9'h0d5);
  assign p1_smul_3206_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5513_comb, 9'h12b);
  assign p1_smul_3205_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5515_comb, 9'h105);
  assign p1_smul_3196_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5509_comb, 9'h0d5);
  assign p1_smul_3194_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5518_comb, 9'h105);
  assign p1_smul_3191_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5520_comb, 9'h0fb);
  assign p1_smul_3189_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5515_comb, 9'h12b);
  assign p1_smul_3179_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5511_comb, 9'h105);
  assign p1_smul_3177_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5524_comb, 9'h0d5);
  assign p1_smul_3176_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5526_comb, 9'h0d5);
  assign p1_smul_3174_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5513_comb, 9'h105);
  assign p1_smul_3162_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5518_comb, 9'h0d5);
  assign p1_smul_3161_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5524_comb, 9'h105);
  assign p1_smul_3160_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5526_comb, 9'h105);
  assign p1_smul_3159_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5520_comb, 9'h0d5);
  assign p1_smul_3210_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5518_comb, 8'h47);
  assign p1_smul_3226_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5524_comb, 6'h19);
  assign p1_smul_3228_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5526_comb, 6'h27);
  assign p1_smul_3207_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5520_comb, 8'hb9);
  assign p1_bit_slice_5577_comb = p1_smul_3196_NarrowedMult__comb[15:1];
  assign p1_smul_3287_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5511_comb, 6'h27);
  assign p1_bit_slice_5579_comb = p1_smul_3194_NarrowedMult__comb[15:1];
  assign p1_smul_3193_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5524_comb, 8'hb9);
  assign p1_smul_3192_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5526_comb, 8'h47);
  assign p1_bit_slice_5582_comb = p1_smul_3191_NarrowedMult__comb[15:1];
  assign p1_smul_3307_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5513_comb, 6'h19);
  assign p1_bit_slice_5584_comb = p1_smul_3189_NarrowedMult__comb[15:1];
  assign p1_smul_3180_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5509_comb, 8'h47);
  assign p1_bit_slice_5594_comb = p1_smul_3179_NarrowedMult__comb[15:1];
  assign p1_smul_3354_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5518_comb, 6'h27);
  assign p1_bit_slice_5596_comb = p1_smul_3177_NarrowedMult__comb[15:1];
  assign p1_bit_slice_5597_comb = p1_smul_3176_NarrowedMult__comb[15:1];
  assign p1_smul_3364_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5520_comb, 6'h27);
  assign p1_bit_slice_5599_comb = p1_smul_3174_NarrowedMult__comb[15:1];
  assign p1_smul_3173_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5515_comb, 8'h47);
  assign p1_smul_3415_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5509_comb, 6'h19);
  assign p1_smul_3163_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5511_comb, 8'hb9);
  assign p1_smul_3158_NarrowedMult__comb = smul15b_8b_x_8b(p1_array_index_5513_comb, 8'hb9);
  assign p1_smul_3443_NarrowedMult__comb = smul14b_8b_x_6b(p1_array_index_5515_comb, 6'h19);
  assign p1_add_5613_comb = {{1{p1_smul_3212_NarrowedMult__comb[15]}}, p1_smul_3212_NarrowedMult__comb} + {{1{p1_smul_3211_NarrowedMult__comb[15]}}, p1_smul_3211_NarrowedMult__comb};
  assign p1_add_5618_comb = {{1{p1_smul_3206_NarrowedMult__comb[15]}}, p1_smul_3206_NarrowedMult__comb} + {{1{p1_smul_3205_NarrowedMult__comb[15]}}, p1_smul_3205_NarrowedMult__comb};
  assign p1_smul_3203_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5511_comb, 7'h31);
  assign p1_smul_3202_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5518_comb, 7'h4f);
  assign p1_smul_3199_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5520_comb, 7'h4f);
  assign p1_smul_3198_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5513_comb, 7'h31);
  assign p1_smul_3188_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5509_comb, 9'h0b5);
  assign p1_smul_3187_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5511_comb, 9'h14b);
  assign p1_smul_3186_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5518_comb, 9'h14b);
  assign p1_smul_3185_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5524_comb, 9'h0b5);
  assign p1_smul_3184_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5526_comb, 9'h0b5);
  assign p1_smul_3183_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5520_comb, 9'h14b);
  assign p1_smul_3182_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5513_comb, 9'h14b);
  assign p1_smul_3181_NarrowedMult__comb = smul16b_8b_x_9b(p1_array_index_5515_comb, 9'h0b5);
  assign p1_smul_3172_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5509_comb, 7'h31);
  assign p1_smul_3170_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5518_comb, 7'h31);
  assign p1_smul_3167_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5520_comb, 7'h31);
  assign p1_smul_3165_NarrowedMult__comb = smul15b_8b_x_7b(p1_array_index_5515_comb, 7'h31);
  assign p1_add_5661_comb = {{1{p1_smul_3162_NarrowedMult__comb[15]}}, p1_smul_3162_NarrowedMult__comb} + {{1{p1_smul_3161_NarrowedMult__comb[15]}}, p1_smul_3161_NarrowedMult__comb};
  assign p1_add_5662_comb = {{1{p1_smul_3160_NarrowedMult__comb[15]}}, p1_smul_3160_NarrowedMult__comb} + {{1{p1_smul_3159_NarrowedMult__comb[15]}}, p1_smul_3159_NarrowedMult__comb};
  assign p1_bit_slice_5665_comb = p1_add_5613_comb[16:1];
  assign p1_add_5666_comb = {{1{p1_smul_3210_NarrowedMult__comb[14]}}, p1_smul_3210_NarrowedMult__comb} + {{2{p1_smul_3226_NarrowedMult__comb[13]}}, p1_smul_3226_NarrowedMult__comb};
  assign p1_add_5667_comb = {{2{p1_smul_3228_NarrowedMult__comb[13]}}, p1_smul_3228_NarrowedMult__comb} + {{1{p1_smul_3207_NarrowedMult__comb[14]}}, p1_smul_3207_NarrowedMult__comb};
  assign p1_bit_slice_5668_comb = p1_add_5618_comb[16:1];
  assign p1_smul_3204_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5509_comb, 7'h3b);
  assign p1_bit_slice_5670_comb = p1_smul_3203_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5671_comb = p1_smul_3202_NarrowedMult__comb[14:1];
  assign p1_smul_3201_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5524_comb, 7'h45);
  assign p1_smul_3200_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5526_comb, 7'h45);
  assign p1_bit_slice_5674_comb = p1_smul_3199_NarrowedMult__comb[14:1];
  assign p1_bit_slice_5675_comb = p1_smul_3198_NarrowedMult__comb[14:1];
  assign p1_smul_3197_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5515_comb, 7'h3b);
  assign p1_add_5677_comb = {{1{p1_bit_slice_5577_comb[14]}}, p1_bit_slice_5577_comb} + {{2{p1_smul_3287_NarrowedMult__comb[13]}}, p1_smul_3287_NarrowedMult__comb};
  assign p1_add_5679_comb = {{1{p1_bit_slice_5579_comb[14]}}, p1_bit_slice_5579_comb} + {{1{p1_smul_3193_NarrowedMult__comb[14]}}, p1_smul_3193_NarrowedMult__comb};
  assign p1_add_5681_comb = {{1{p1_smul_3192_NarrowedMult__comb[14]}}, p1_smul_3192_NarrowedMult__comb} + {{1{p1_bit_slice_5582_comb[14]}}, p1_bit_slice_5582_comb};
  assign p1_add_5683_comb = {{2{p1_smul_3307_NarrowedMult__comb[13]}}, p1_smul_3307_NarrowedMult__comb} + {{1{p1_bit_slice_5584_comb[14]}}, p1_bit_slice_5584_comb};
  assign p1_add_5693_comb = {{1{p1_smul_3180_NarrowedMult__comb[14]}}, p1_smul_3180_NarrowedMult__comb} + {{1{p1_bit_slice_5594_comb[14]}}, p1_bit_slice_5594_comb};
  assign p1_add_5695_comb = {{2{p1_smul_3354_NarrowedMult__comb[13]}}, p1_smul_3354_NarrowedMult__comb} + {{1{p1_bit_slice_5596_comb[14]}}, p1_bit_slice_5596_comb};
  assign p1_add_5697_comb = {{1{p1_bit_slice_5597_comb[14]}}, p1_bit_slice_5597_comb} + {{2{p1_smul_3364_NarrowedMult__comb[13]}}, p1_smul_3364_NarrowedMult__comb};
  assign p1_add_5699_comb = {{1{p1_bit_slice_5599_comb[14]}}, p1_bit_slice_5599_comb} + {{1{p1_smul_3173_NarrowedMult__comb[14]}}, p1_smul_3173_NarrowedMult__comb};
  assign p1_bit_slice_5701_comb = p1_smul_3172_NarrowedMult__comb[14:1];
  assign p1_smul_3171_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5511_comb, 7'h45);
  assign p1_bit_slice_5703_comb = p1_smul_3170_NarrowedMult__comb[14:1];
  assign p1_smul_3169_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5524_comb, 7'h3b);
  assign p1_smul_3168_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5526_comb, 7'h3b);
  assign p1_bit_slice_5706_comb = p1_smul_3167_NarrowedMult__comb[14:1];
  assign p1_smul_3166_NarrowedMult__comb = smul14b_8b_x_7b(p1_array_index_5513_comb, 7'h45);
  assign p1_bit_slice_5708_comb = p1_smul_3165_NarrowedMult__comb[14:1];
  assign p1_add_5709_comb = {{2{p1_smul_3415_NarrowedMult__comb[13]}}, p1_smul_3415_NarrowedMult__comb} + {{1{p1_smul_3163_NarrowedMult__comb[14]}}, p1_smul_3163_NarrowedMult__comb};
  assign p1_bit_slice_5710_comb = p1_add_5661_comb[16:1];
  assign p1_bit_slice_5711_comb = p1_add_5662_comb[16:1];
  assign p1_add_5712_comb = {{1{p1_smul_3158_NarrowedMult__comb[14]}}, p1_smul_3158_NarrowedMult__comb} + {{2{p1_smul_3443_NarrowedMult__comb[13]}}, p1_smul_3443_NarrowedMult__comb};
  assign p1_concat_5733_comb = {p1_add_5677_comb, p1_smul_3196_NarrowedMult__comb[0]};
  assign p1_concat_5734_comb = {p1_add_5679_comb, p1_smul_3194_NarrowedMult__comb[0]};
  assign p1_concat_5735_comb = {p1_add_5681_comb, p1_smul_3191_NarrowedMult__comb[0]};
  assign p1_concat_5736_comb = {p1_add_5683_comb, p1_smul_3189_NarrowedMult__comb[0]};
  assign p1_add_5737_comb = {{1{p1_smul_3188_NarrowedMult__comb[15]}}, p1_smul_3188_NarrowedMult__comb} + {{1{p1_smul_3187_NarrowedMult__comb[15]}}, p1_smul_3187_NarrowedMult__comb};
  assign p1_add_5738_comb = {{1{p1_smul_3186_NarrowedMult__comb[15]}}, p1_smul_3186_NarrowedMult__comb} + {{1{p1_smul_3185_NarrowedMult__comb[15]}}, p1_smul_3185_NarrowedMult__comb};
  assign p1_add_5739_comb = {{1{p1_smul_3184_NarrowedMult__comb[15]}}, p1_smul_3184_NarrowedMult__comb} + {{1{p1_smul_3183_NarrowedMult__comb[15]}}, p1_smul_3183_NarrowedMult__comb};
  assign p1_add_5740_comb = {{1{p1_smul_3182_NarrowedMult__comb[15]}}, p1_smul_3182_NarrowedMult__comb} + {{1{p1_smul_3181_NarrowedMult__comb[15]}}, p1_smul_3181_NarrowedMult__comb};
  assign p1_concat_5741_comb = {p1_add_5693_comb, p1_smul_3179_NarrowedMult__comb[0]};
  assign p1_concat_5742_comb = {p1_add_5695_comb, p1_smul_3177_NarrowedMult__comb[0]};
  assign p1_concat_5743_comb = {p1_add_5697_comb, p1_smul_3176_NarrowedMult__comb[0]};
  assign p1_concat_5744_comb = {p1_add_5699_comb, p1_smul_3174_NarrowedMult__comb[0]};
  assign p1_add_5757_comb = {{1{p1_array_index_5509_comb[7]}}, p1_array_index_5509_comb} + {{1{p1_array_index_5511_comb[7]}}, p1_array_index_5511_comb};
  assign p1_add_5758_comb = {{1{p1_array_index_5518_comb[7]}}, p1_array_index_5518_comb} + {{1{p1_array_index_5524_comb[7]}}, p1_array_index_5524_comb};
  assign p1_add_5759_comb = {{1{p1_array_index_5526_comb[7]}}, p1_array_index_5526_comb} + {{1{p1_array_index_5520_comb[7]}}, p1_array_index_5520_comb};
  assign p1_add_5760_comb = {{1{p1_array_index_5513_comb[7]}}, p1_array_index_5513_comb} + {{1{p1_array_index_5515_comb[7]}}, p1_array_index_5515_comb};
  assign p1_add_5761_comb = {{8{p1_bit_slice_5665_comb[15]}}, p1_bit_slice_5665_comb} + {{8{p1_add_5666_comb[15]}}, p1_add_5666_comb};
  assign p1_add_5763_comb = {{8{p1_add_5667_comb[15]}}, p1_add_5667_comb} + {{8{p1_bit_slice_5668_comb[15]}}, p1_bit_slice_5668_comb};
  assign p1_add_5765_comb = {{1{p1_smul_3204_NarrowedMult__comb[13]}}, p1_smul_3204_NarrowedMult__comb} + {{1{p1_bit_slice_5670_comb[13]}}, p1_bit_slice_5670_comb};
  assign p1_add_5767_comb = {{1{p1_bit_slice_5671_comb[13]}}, p1_bit_slice_5671_comb} + {{1{p1_smul_3201_NarrowedMult__comb[13]}}, p1_smul_3201_NarrowedMult__comb};
  assign p1_add_5769_comb = {{1{p1_smul_3200_NarrowedMult__comb[13]}}, p1_smul_3200_NarrowedMult__comb} + {{1{p1_bit_slice_5674_comb[13]}}, p1_bit_slice_5674_comb};
  assign p1_add_5771_comb = {{1{p1_bit_slice_5675_comb[13]}}, p1_bit_slice_5675_comb} + {{1{p1_smul_3197_NarrowedMult__comb[13]}}, p1_smul_3197_NarrowedMult__comb};
  assign p1_sum__101_comb = {{8{p1_concat_5733_comb[16]}}, p1_concat_5733_comb};
  assign p1_sum__102_comb = {{8{p1_concat_5734_comb[16]}}, p1_concat_5734_comb};
  assign p1_sum__103_comb = {{8{p1_concat_5735_comb[16]}}, p1_concat_5735_comb};
  assign p1_sum__104_comb = {{8{p1_concat_5736_comb[16]}}, p1_concat_5736_comb};
  assign p1_sum__97_comb = {{8{p1_add_5737_comb[16]}}, p1_add_5737_comb};
  assign p1_sum__98_comb = {{8{p1_add_5738_comb[16]}}, p1_add_5738_comb};
  assign p1_sum__99_comb = {{8{p1_add_5739_comb[16]}}, p1_add_5739_comb};
  assign p1_sum__100_comb = {{8{p1_add_5740_comb[16]}}, p1_add_5740_comb};
  assign p1_sum__93_comb = {{8{p1_concat_5741_comb[16]}}, p1_concat_5741_comb};
  assign p1_sum__94_comb = {{8{p1_concat_5742_comb[16]}}, p1_concat_5742_comb};
  assign p1_sum__95_comb = {{8{p1_concat_5743_comb[16]}}, p1_concat_5743_comb};
  assign p1_sum__96_comb = {{8{p1_concat_5744_comb[16]}}, p1_concat_5744_comb};
  assign p1_add_5785_comb = {{1{p1_bit_slice_5701_comb[13]}}, p1_bit_slice_5701_comb} + {{1{p1_smul_3171_NarrowedMult__comb[13]}}, p1_smul_3171_NarrowedMult__comb};
  assign p1_add_5787_comb = {{1{p1_bit_slice_5703_comb[13]}}, p1_bit_slice_5703_comb} + {{1{p1_smul_3169_NarrowedMult__comb[13]}}, p1_smul_3169_NarrowedMult__comb};
  assign p1_add_5789_comb = {{1{p1_smul_3168_NarrowedMult__comb[13]}}, p1_smul_3168_NarrowedMult__comb} + {{1{p1_bit_slice_5706_comb[13]}}, p1_bit_slice_5706_comb};
  assign p1_add_5791_comb = {{1{p1_smul_3166_NarrowedMult__comb[13]}}, p1_smul_3166_NarrowedMult__comb} + {{1{p1_bit_slice_5708_comb[13]}}, p1_bit_slice_5708_comb};
  assign p1_add_5793_comb = {{8{p1_add_5709_comb[15]}}, p1_add_5709_comb} + {{8{p1_bit_slice_5710_comb[15]}}, p1_bit_slice_5710_comb};
  assign p1_add_5795_comb = {{8{p1_bit_slice_5711_comb[15]}}, p1_bit_slice_5711_comb} + {{8{p1_add_5712_comb[15]}}, p1_add_5712_comb};
  assign p1_sum__83_comb = {p1_add_5761_comb, p1_add_5613_comb[0]};
  assign p1_sum__84_comb = {p1_add_5763_comb, p1_add_5618_comb[0]};
  assign p1_concat_5803_comb = {p1_add_5765_comb, p1_smul_3203_NarrowedMult__comb[0]};
  assign p1_concat_5804_comb = {p1_add_5767_comb, p1_smul_3202_NarrowedMult__comb[0]};
  assign p1_concat_5805_comb = {p1_add_5769_comb, p1_smul_3199_NarrowedMult__comb[0]};
  assign p1_concat_5806_comb = {p1_add_5771_comb, p1_smul_3198_NarrowedMult__comb[0]};
  assign p1_sum__79_comb = p1_sum__101_comb + p1_sum__102_comb;
  assign p1_sum__80_comb = p1_sum__103_comb + p1_sum__104_comb;
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_sum__75_comb = p1_sum__93_comb + p1_sum__94_comb;
  assign p1_sum__76_comb = p1_sum__95_comb + p1_sum__96_comb;
  assign p1_concat_5813_comb = {p1_add_5785_comb, p1_smul_3172_NarrowedMult__comb[0]};
  assign p1_concat_5814_comb = {p1_add_5787_comb, p1_smul_3170_NarrowedMult__comb[0]};
  assign p1_concat_5815_comb = {p1_add_5789_comb, p1_smul_3167_NarrowedMult__comb[0]};
  assign p1_concat_5816_comb = {p1_add_5791_comb, p1_smul_3165_NarrowedMult__comb[0]};
  assign p1_sum__71_comb = {p1_add_5793_comb, p1_add_5661_comb[0]};
  assign p1_sum__72_comb = {p1_add_5795_comb, p1_add_5662_comb[0]};
  assign p1_add_5819_comb = {{15{p1_add_5757_comb[8]}}, p1_add_5757_comb} + {{15{p1_add_5758_comb[8]}}, p1_add_5758_comb};
  assign p1_add_5820_comb = {{15{p1_add_5759_comb[8]}}, p1_add_5759_comb} + {{15{p1_add_5760_comb[8]}}, p1_add_5760_comb};
  assign p1_sum__70_comb = p1_sum__83_comb + p1_sum__84_comb;
  assign p1_sum__68_comb = p1_sum__79_comb + p1_sum__80_comb;
  assign p1_sum__67_comb = p1_sum__77_comb + p1_sum__78_comb;
  assign p1_sum__66_comb = p1_sum__75_comb + p1_sum__76_comb;
  assign p1_sum__64_comb = p1_sum__71_comb + p1_sum__72_comb;
  assign p1_add_5839_comb = p1_add_5819_comb + p1_add_5820_comb;
  assign p1_add_5841_comb = p1_sum__70_comb + 25'h000_0001;
  assign p1_add_5842_comb = {{8{p1_concat_5803_comb[15]}}, p1_concat_5803_comb} + {{8{p1_concat_5804_comb[15]}}, p1_concat_5804_comb};
  assign p1_add_5843_comb = {{8{p1_concat_5805_comb[15]}}, p1_concat_5805_comb} + {{8{p1_concat_5806_comb[15]}}, p1_concat_5806_comb};
  assign p1_add_5844_comb = p1_sum__68_comb + 25'h000_0001;
  assign p1_add_5845_comb = p1_sum__67_comb + 25'h000_0001;
  assign p1_add_5846_comb = p1_sum__66_comb + 25'h000_0001;
  assign p1_add_5847_comb = {{8{p1_concat_5813_comb[15]}}, p1_concat_5813_comb} + {{8{p1_concat_5814_comb[15]}}, p1_concat_5814_comb};
  assign p1_add_5848_comb = {{8{p1_concat_5815_comb[15]}}, p1_concat_5815_comb} + {{8{p1_concat_5816_comb[15]}}, p1_concat_5816_comb};
  assign p1_add_5849_comb = p1_sum__64_comb + 25'h000_0001;
  assign p1_umul_2661_NarrowedMult__comb = umul24b_24b_x_7b(p1_add_5839_comb, 7'h5b);
  assign p1_add_5854_comb = p1_add_5842_comb + p1_add_5843_comb;
  assign p1_add_5862_comb = p1_add_5847_comb + p1_add_5848_comb;
  assign p1_clipped__16_comb = $signed(p1_umul_2661_NarrowedMult__comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_umul_2661_NarrowedMult__comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_umul_2661_NarrowedMult__comb[15:7]);
  assign p1_clipped__17_comb = $signed(p1_add_5841_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5841_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5841_comb[16:8]);
  assign p1_clipped__18_comb = $signed(p1_add_5854_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5854_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5854_comb[15:7]);
  assign p1_clipped__19_comb = $signed(p1_add_5844_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5844_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5844_comb[16:8]);
  assign p1_clipped__20_comb = $signed(p1_add_5845_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5845_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5845_comb[16:8]);
  assign p1_clipped__21_comb = $signed(p1_add_5846_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5846_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5846_comb[16:8]);
  assign p1_clipped__22_comb = $signed(p1_add_5862_comb) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5862_comb) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5862_comb[15:7]);
  assign p1_clipped__23_comb = $signed(p1_add_5849_comb[24:1]) < $signed(24'hff_8000) ? 9'h100 : ($signed(p1_add_5849_comb[24:1]) > $signed(24'h00_7fff) ? 9'h0ff : p1_add_5849_comb[16:8]);
  assign p1_add_5946_comb = {{1{p1_clipped__16_comb[8]}}, p1_clipped__16_comb} + 10'h001;
  assign p1_add_5947_comb = {{1{p1_clipped__17_comb[8]}}, p1_clipped__17_comb} + 10'h001;
  assign p1_add_5948_comb = {{1{p1_clipped__18_comb[8]}}, p1_clipped__18_comb} + 10'h001;
  assign p1_add_5949_comb = {{1{p1_clipped__19_comb[8]}}, p1_clipped__19_comb} + 10'h001;
  assign p1_add_5950_comb = {{1{p1_clipped__20_comb[8]}}, p1_clipped__20_comb} + 10'h001;
  assign p1_add_5951_comb = {{1{p1_clipped__21_comb[8]}}, p1_clipped__21_comb} + 10'h001;
  assign p1_add_5952_comb = {{1{p1_clipped__22_comb[8]}}, p1_clipped__22_comb} + 10'h001;
  assign p1_add_5953_comb = {{1{p1_clipped__23_comb[8]}}, p1_clipped__23_comb} + 10'h001;
  assign p1_clipped__8_comb = p1_add_5946_comb[8:1] & {8{~p1_add_5946_comb[9]}};
  assign p1_clipped__9_comb = p1_add_5947_comb[8:1] & {8{~p1_add_5947_comb[9]}};
  assign p1_clipped__10_comb = p1_add_5948_comb[8:1] & {8{~p1_add_5948_comb[9]}};
  assign p1_clipped__11_comb = p1_add_5949_comb[8:1] & {8{~p1_add_5949_comb[9]}};
  assign p1_clipped__12_comb = p1_add_5950_comb[8:1] & {8{~p1_add_5950_comb[9]}};
  assign p1_clipped__13_comb = p1_add_5951_comb[8:1] & {8{~p1_add_5951_comb[9]}};
  assign p1_clipped__14_comb = p1_add_5952_comb[8:1] & {8{~p1_add_5952_comb[9]}};
  assign p1_clipped__15_comb = p1_add_5953_comb[8:1] & {8{~p1_add_5953_comb[9]}};
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
