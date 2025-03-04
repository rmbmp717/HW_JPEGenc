module dct_1d_s12(
  input wire clk,
  input wire [95:0] x,
  output wire [95:0] out
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [20:0] smul21b_12b_x_9b (input reg [11:0] lhs, input reg [8:0] rhs);
    reg signed [11:0] signed_lhs;
    reg signed [8:0] signed_rhs;
    reg signed [20:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul21b_12b_x_9b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [19:0] smul20b_20b_x_8b (input reg [19:0] lhs, input reg [7:0] rhs);
    reg signed [19:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [19:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul20b_20b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [19:0] smul20b_20b_x_6b (input reg [19:0] lhs, input reg [5:0] rhs);
    reg signed [19:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [19:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul20b_20b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [19:0] smul20b_20b_x_7b (input reg [19:0] lhs, input reg [6:0] rhs);
    reg signed [19:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [19:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul20b_20b_x_7b = $unsigned(signed_result);
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
  // lint_off MULTIPLY
  function automatic [23:0] umul24b_24b_x_7b (input reg [23:0] lhs, input reg [6:0] rhs);
    begin
      umul24b_24b_x_7b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY
  wire [11:0] x_unflattened[0:7];
  assign x_unflattened[0] = x[11:0];
  assign x_unflattened[1] = x[23:12];
  assign x_unflattened[2] = x[35:24];
  assign x_unflattened[3] = x[47:36];
  assign x_unflattened[4] = x[59:48];
  assign x_unflattened[5] = x[71:60];
  assign x_unflattened[6] = x[83:72];
  assign x_unflattened[7] = x[95:84];

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [11:0] p0_x[0:7];
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
  wire [11:0] p1_array_index_5498_comb;
  wire [11:0] p1_array_index_5499_comb;
  wire [11:0] p1_array_index_5500_comb;
  wire [11:0] p1_array_index_5501_comb;
  wire [11:0] p1_array_index_5502_comb;
  wire [11:0] p1_array_index_5503_comb;
  wire [11:0] p1_array_index_5504_comb;
  wire [11:0] p1_array_index_5505_comb;
  wire [23:0] p1_sign_ext_5508_comb;
  wire [23:0] p1_sign_ext_5509_comb;
  wire [23:0] p1_sign_ext_5510_comb;
  wire [23:0] p1_sign_ext_5511_comb;
  wire [23:0] p1_sign_ext_5514_comb;
  wire [23:0] p1_sign_ext_5515_comb;
  wire [23:0] p1_sign_ext_5520_comb;
  wire [23:0] p1_sign_ext_5525_comb;
  wire [20:0] p1_smul_5664_comb;
  wire [20:0] p1_smul_5665_comb;
  wire [20:0] p1_smul_5666_comb;
  wire [20:0] p1_smul_5667_comb;
  wire [20:0] p1_smul_5668_comb;
  wire [20:0] p1_smul_5669_comb;
  wire [20:0] p1_smul_5670_comb;
  wire [20:0] p1_smul_5671_comb;
  wire [20:0] p1_smul_5530_comb;
  wire [20:0] p1_smul_5531_comb;
  wire [20:0] p1_smul_5540_comb;
  wire [20:0] p1_smul_5541_comb;
  wire [20:0] p1_smul_5548_comb;
  wire [20:0] p1_smul_5550_comb;
  wire [20:0] p1_smul_5553_comb;
  wire [20:0] p1_smul_5555_comb;
  wire [20:0] p1_smul_5558_comb;
  wire [20:0] p1_smul_5560_comb;
  wire [20:0] p1_smul_5561_comb;
  wire [20:0] p1_smul_5563_comb;
  wire [20:0] p1_smul_5572_comb;
  wire [20:0] p1_smul_5573_comb;
  wire [20:0] p1_smul_5574_comb;
  wire [20:0] p1_smul_5575_comb;
  wire [20:0] p1_add_5712_comb;
  wire [20:0] p1_add_5713_comb;
  wire [20:0] p1_add_5714_comb;
  wire [20:0] p1_add_5715_comb;
  wire [20:0] p1_add_5578_comb;
  wire [19:0] p1_smul_5579_comb;
  wire [19:0] p1_smul_5580_comb;
  wire [19:0] p1_smul_5581_comb;
  wire [19:0] p1_smul_5582_comb;
  wire [20:0] p1_add_5583_comb;
  wire [19:0] p1_smul_5586_comb;
  wire [19:0] p1_smul_5587_comb;
  wire [19:0] p1_smul_5592_comb;
  wire [19:0] p1_smul_5593_comb;
  wire [19:0] p1_smul_5597_comb;
  wire [19:0] p1_smul_5599_comb;
  wire [19:0] p1_smul_5600_comb;
  wire [19:0] p1_smul_5602_comb;
  wire [19:0] p1_smul_5612_comb;
  wire [19:0] p1_smul_5614_comb;
  wire [19:0] p1_smul_5617_comb;
  wire [19:0] p1_smul_5619_comb;
  wire [19:0] p1_smul_5620_comb;
  wire [19:0] p1_smul_5623_comb;
  wire [19:0] p1_smul_5626_comb;
  wire [19:0] p1_smul_5629_comb;
  wire [19:0] p1_smul_5630_comb;
  wire [19:0] p1_smul_5631_comb;
  wire [20:0] p1_add_5632_comb;
  wire [20:0] p1_add_5633_comb;
  wire [19:0] p1_smul_5634_comb;
  wire [19:0] p1_smul_5635_comb;
  wire [12:0] p1_add_5692_comb;
  wire [12:0] p1_add_5693_comb;
  wire [12:0] p1_add_5694_comb;
  wire [12:0] p1_add_5695_comb;
  wire [24:0] p1_sum__97_comb;
  wire [24:0] p1_sum__98_comb;
  wire [24:0] p1_sum__99_comb;
  wire [24:0] p1_sum__100_comb;
  wire [19:0] p1_bit_slice_5644_comb;
  wire [19:0] p1_add_5645_comb;
  wire [19:0] p1_add_5646_comb;
  wire [19:0] p1_bit_slice_5647_comb;
  wire [18:0] p1_smul_5648_comb;
  wire [18:0] p1_smul_5651_comb;
  wire [18:0] p1_smul_5652_comb;
  wire [18:0] p1_smul_5655_comb;
  wire [19:0] p1_add_5656_comb;
  wire [19:0] p1_add_5658_comb;
  wire [19:0] p1_add_5660_comb;
  wire [19:0] p1_add_5662_comb;
  wire [19:0] p1_add_5672_comb;
  wire [19:0] p1_add_5674_comb;
  wire [19:0] p1_add_5676_comb;
  wire [19:0] p1_add_5678_comb;
  wire [18:0] p1_smul_5681_comb;
  wire [18:0] p1_smul_5683_comb;
  wire [18:0] p1_smul_5684_comb;
  wire [18:0] p1_smul_5686_comb;
  wire [19:0] p1_add_5688_comb;
  wire [19:0] p1_bit_slice_5689_comb;
  wire [19:0] p1_bit_slice_5690_comb;
  wire [19:0] p1_add_5691_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [23:0] p1_sign_ext_5696_comb;
  wire [23:0] p1_sign_ext_5697_comb;
  wire [23:0] p1_sign_ext_5698_comb;
  wire [23:0] p1_sign_ext_5699_comb;
  wire [18:0] p1_add_5700_comb;
  wire p1_bit_slice_5701_comb;
  wire [18:0] p1_add_5702_comb;
  wire p1_bit_slice_5703_comb;
  wire [18:0] p1_add_5704_comb;
  wire p1_bit_slice_5705_comb;
  wire [18:0] p1_add_5706_comb;
  wire p1_bit_slice_5707_comb;
  wire [20:0] p1_concat_5708_comb;
  wire [20:0] p1_concat_5709_comb;
  wire [20:0] p1_concat_5710_comb;
  wire [20:0] p1_concat_5711_comb;
  wire [20:0] p1_concat_5716_comb;
  wire [20:0] p1_concat_5717_comb;
  wire [20:0] p1_concat_5718_comb;
  wire [20:0] p1_concat_5719_comb;
  wire [18:0] p1_add_5720_comb;
  wire p1_bit_slice_5721_comb;
  wire [18:0] p1_add_5722_comb;
  wire p1_bit_slice_5723_comb;
  wire [18:0] p1_add_5724_comb;
  wire p1_bit_slice_5725_comb;
  wire [18:0] p1_add_5726_comb;
  wire p1_bit_slice_5727_comb;
  wire [23:0] p1_sign_ext_5728_comb;
  wire [23:0] p1_sign_ext_5729_comb;
  wire [23:0] p1_sign_ext_5730_comb;
  wire [23:0] p1_sign_ext_5731_comb;
  wire p1_bit_slice_5736_comb;
  wire p1_bit_slice_5737_comb;
  wire p1_bit_slice_5742_comb;
  wire p1_bit_slice_5743_comb;
  wire [23:0] p1_add_5744_comb;
  wire [23:0] p1_add_5745_comb;
  wire [24:0] p1_sum__67_comb;
  assign p1_array_index_5498_comb = p0_x[3'h2];
  assign p1_array_index_5499_comb = p0_x[3'h3];
  assign p1_array_index_5500_comb = p0_x[3'h4];
  assign p1_array_index_5501_comb = p0_x[3'h5];
  assign p1_array_index_5502_comb = p0_x[3'h1];
  assign p1_array_index_5503_comb = p0_x[3'h6];
  assign p1_array_index_5504_comb = p0_x[3'h0];
  assign p1_array_index_5505_comb = p0_x[3'h7];
  assign p1_sign_ext_5508_comb = {{12{p1_array_index_5498_comb[11]}}, p1_array_index_5498_comb};
  assign p1_sign_ext_5509_comb = {{12{p1_array_index_5499_comb[11]}}, p1_array_index_5499_comb};
  assign p1_sign_ext_5510_comb = {{12{p1_array_index_5500_comb[11]}}, p1_array_index_5500_comb};
  assign p1_sign_ext_5511_comb = {{12{p1_array_index_5501_comb[11]}}, p1_array_index_5501_comb};
  assign p1_sign_ext_5514_comb = {{12{p1_array_index_5502_comb[11]}}, p1_array_index_5502_comb};
  assign p1_sign_ext_5515_comb = {{12{p1_array_index_5503_comb[11]}}, p1_array_index_5503_comb};
  assign p1_sign_ext_5520_comb = {{12{p1_array_index_5504_comb[11]}}, p1_array_index_5504_comb};
  assign p1_sign_ext_5525_comb = {{12{p1_array_index_5505_comb[11]}}, p1_array_index_5505_comb};
  assign p1_smul_5664_comb = smul21b_12b_x_9b(p1_array_index_5504_comb, 9'h0b5);
  assign p1_smul_5665_comb = smul21b_12b_x_9b(p1_array_index_5502_comb, 9'h14b);
  assign p1_smul_5666_comb = smul21b_12b_x_9b(p1_array_index_5498_comb, 9'h14b);
  assign p1_smul_5667_comb = smul21b_12b_x_9b(p1_array_index_5499_comb, 9'h0b5);
  assign p1_smul_5668_comb = smul21b_12b_x_9b(p1_array_index_5500_comb, 9'h0b5);
  assign p1_smul_5669_comb = smul21b_12b_x_9b(p1_array_index_5501_comb, 9'h14b);
  assign p1_smul_5670_comb = smul21b_12b_x_9b(p1_array_index_5503_comb, 9'h14b);
  assign p1_smul_5671_comb = smul21b_12b_x_9b(p1_array_index_5505_comb, 9'h0b5);
  assign p1_smul_5530_comb = smul21b_12b_x_9b(p1_array_index_5504_comb, 9'h0fb);
  assign p1_smul_5531_comb = smul21b_12b_x_9b(p1_array_index_5502_comb, 9'h0d5);
  assign p1_smul_5540_comb = smul21b_12b_x_9b(p1_array_index_5503_comb, 9'h12b);
  assign p1_smul_5541_comb = smul21b_12b_x_9b(p1_array_index_5505_comb, 9'h105);
  assign p1_smul_5548_comb = smul21b_12b_x_9b(p1_array_index_5504_comb, 9'h0d5);
  assign p1_smul_5550_comb = smul21b_12b_x_9b(p1_array_index_5498_comb, 9'h105);
  assign p1_smul_5553_comb = smul21b_12b_x_9b(p1_array_index_5501_comb, 9'h0fb);
  assign p1_smul_5555_comb = smul21b_12b_x_9b(p1_array_index_5505_comb, 9'h12b);
  assign p1_smul_5558_comb = smul21b_12b_x_9b(p1_array_index_5502_comb, 9'h105);
  assign p1_smul_5560_comb = smul21b_12b_x_9b(p1_array_index_5499_comb, 9'h0d5);
  assign p1_smul_5561_comb = smul21b_12b_x_9b(p1_array_index_5500_comb, 9'h0d5);
  assign p1_smul_5563_comb = smul21b_12b_x_9b(p1_array_index_5503_comb, 9'h105);
  assign p1_smul_5572_comb = smul21b_12b_x_9b(p1_array_index_5498_comb, 9'h0d5);
  assign p1_smul_5573_comb = smul21b_12b_x_9b(p1_array_index_5499_comb, 9'h105);
  assign p1_smul_5574_comb = smul21b_12b_x_9b(p1_array_index_5500_comb, 9'h105);
  assign p1_smul_5575_comb = smul21b_12b_x_9b(p1_array_index_5501_comb, 9'h0d5);
  assign p1_add_5712_comb = p1_smul_5664_comb + p1_smul_5665_comb;
  assign p1_add_5713_comb = p1_smul_5666_comb + p1_smul_5667_comb;
  assign p1_add_5714_comb = p1_smul_5668_comb + p1_smul_5669_comb;
  assign p1_add_5715_comb = p1_smul_5670_comb + p1_smul_5671_comb;
  assign p1_add_5578_comb = p1_smul_5530_comb + p1_smul_5531_comb;
  assign p1_smul_5579_comb = smul20b_20b_x_8b(p1_sign_ext_5508_comb[19:0], 8'h47);
  assign p1_smul_5580_comb = smul20b_20b_x_6b(p1_sign_ext_5509_comb[19:0], 6'h19);
  assign p1_smul_5581_comb = smul20b_20b_x_6b(p1_sign_ext_5510_comb[19:0], 6'h27);
  assign p1_smul_5582_comb = smul20b_20b_x_8b(p1_sign_ext_5511_comb[19:0], 8'hb9);
  assign p1_add_5583_comb = p1_smul_5540_comb + p1_smul_5541_comb;
  assign p1_smul_5586_comb = smul20b_20b_x_7b(p1_sign_ext_5514_comb[19:0], 7'h31);
  assign p1_smul_5587_comb = smul20b_20b_x_7b(p1_sign_ext_5508_comb[19:0], 7'h4f);
  assign p1_smul_5592_comb = smul20b_20b_x_7b(p1_sign_ext_5511_comb[19:0], 7'h4f);
  assign p1_smul_5593_comb = smul20b_20b_x_7b(p1_sign_ext_5515_comb[19:0], 7'h31);
  assign p1_smul_5597_comb = smul20b_20b_x_6b(p1_sign_ext_5514_comb[19:0], 6'h27);
  assign p1_smul_5599_comb = smul20b_20b_x_8b(p1_sign_ext_5509_comb[19:0], 8'hb9);
  assign p1_smul_5600_comb = smul20b_20b_x_8b(p1_sign_ext_5510_comb[19:0], 8'h47);
  assign p1_smul_5602_comb = smul20b_20b_x_6b(p1_sign_ext_5515_comb[19:0], 6'h19);
  assign p1_smul_5612_comb = smul20b_20b_x_8b(p1_sign_ext_5520_comb[19:0], 8'h47);
  assign p1_smul_5614_comb = smul20b_20b_x_6b(p1_sign_ext_5508_comb[19:0], 6'h27);
  assign p1_smul_5617_comb = smul20b_20b_x_6b(p1_sign_ext_5511_comb[19:0], 6'h27);
  assign p1_smul_5619_comb = smul20b_20b_x_8b(p1_sign_ext_5525_comb[19:0], 8'h47);
  assign p1_smul_5620_comb = smul20b_20b_x_7b(p1_sign_ext_5520_comb[19:0], 7'h31);
  assign p1_smul_5623_comb = smul20b_20b_x_7b(p1_sign_ext_5508_comb[19:0], 7'h31);
  assign p1_smul_5626_comb = smul20b_20b_x_7b(p1_sign_ext_5511_comb[19:0], 7'h31);
  assign p1_smul_5629_comb = smul20b_20b_x_7b(p1_sign_ext_5525_comb[19:0], 7'h31);
  assign p1_smul_5630_comb = smul20b_20b_x_6b(p1_sign_ext_5520_comb[19:0], 6'h19);
  assign p1_smul_5631_comb = smul20b_20b_x_8b(p1_sign_ext_5514_comb[19:0], 8'hb9);
  assign p1_add_5632_comb = p1_smul_5572_comb + p1_smul_5573_comb;
  assign p1_add_5633_comb = p1_smul_5574_comb + p1_smul_5575_comb;
  assign p1_smul_5634_comb = smul20b_20b_x_8b(p1_sign_ext_5515_comb[19:0], 8'hb9);
  assign p1_smul_5635_comb = smul20b_20b_x_6b(p1_sign_ext_5525_comb[19:0], 6'h19);
  assign p1_add_5692_comb = p1_sign_ext_5520_comb[12:0] + p1_sign_ext_5514_comb[12:0];
  assign p1_add_5693_comb = p1_sign_ext_5508_comb[12:0] + p1_sign_ext_5509_comb[12:0];
  assign p1_add_5694_comb = p1_sign_ext_5510_comb[12:0] + p1_sign_ext_5511_comb[12:0];
  assign p1_add_5695_comb = p1_sign_ext_5515_comb[12:0] + p1_sign_ext_5525_comb[12:0];
  assign p1_sum__97_comb = {{4{p1_add_5712_comb[20]}}, p1_add_5712_comb};
  assign p1_sum__98_comb = {{4{p1_add_5713_comb[20]}}, p1_add_5713_comb};
  assign p1_sum__99_comb = {{4{p1_add_5714_comb[20]}}, p1_add_5714_comb};
  assign p1_sum__100_comb = {{4{p1_add_5715_comb[20]}}, p1_add_5715_comb};
  assign p1_bit_slice_5644_comb = p1_add_5578_comb[20:1];
  assign p1_add_5645_comb = p1_smul_5579_comb + p1_smul_5580_comb;
  assign p1_add_5646_comb = p1_smul_5581_comb + p1_smul_5582_comb;
  assign p1_bit_slice_5647_comb = p1_add_5583_comb[20:1];
  assign p1_smul_5648_comb = smul19b_19b_x_7b(p1_sign_ext_5520_comb[18:0], 7'h3b);
  assign p1_smul_5651_comb = smul19b_19b_x_7b(p1_sign_ext_5509_comb[18:0], 7'h45);
  assign p1_smul_5652_comb = smul19b_19b_x_7b(p1_sign_ext_5510_comb[18:0], 7'h45);
  assign p1_smul_5655_comb = smul19b_19b_x_7b(p1_sign_ext_5525_comb[18:0], 7'h3b);
  assign p1_add_5656_comb = p1_smul_5548_comb[20:1] + p1_smul_5597_comb;
  assign p1_add_5658_comb = p1_smul_5550_comb[20:1] + p1_smul_5599_comb;
  assign p1_add_5660_comb = p1_smul_5600_comb + p1_smul_5553_comb[20:1];
  assign p1_add_5662_comb = p1_smul_5602_comb + p1_smul_5555_comb[20:1];
  assign p1_add_5672_comb = p1_smul_5612_comb + p1_smul_5558_comb[20:1];
  assign p1_add_5674_comb = p1_smul_5614_comb + p1_smul_5560_comb[20:1];
  assign p1_add_5676_comb = p1_smul_5561_comb[20:1] + p1_smul_5617_comb;
  assign p1_add_5678_comb = p1_smul_5563_comb[20:1] + p1_smul_5619_comb;
  assign p1_smul_5681_comb = smul19b_19b_x_7b(p1_sign_ext_5514_comb[18:0], 7'h45);
  assign p1_smul_5683_comb = smul19b_19b_x_7b(p1_sign_ext_5509_comb[18:0], 7'h3b);
  assign p1_smul_5684_comb = smul19b_19b_x_7b(p1_sign_ext_5510_comb[18:0], 7'h3b);
  assign p1_smul_5686_comb = smul19b_19b_x_7b(p1_sign_ext_5515_comb[18:0], 7'h45);
  assign p1_add_5688_comb = p1_smul_5630_comb + p1_smul_5631_comb;
  assign p1_bit_slice_5689_comb = p1_add_5632_comb[20:1];
  assign p1_bit_slice_5690_comb = p1_add_5633_comb[20:1];
  assign p1_add_5691_comb = p1_smul_5634_comb + p1_smul_5635_comb;
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_sign_ext_5696_comb = {{4{p1_bit_slice_5644_comb[19]}}, p1_bit_slice_5644_comb};
  assign p1_sign_ext_5697_comb = {{4{p1_add_5645_comb[19]}}, p1_add_5645_comb};
  assign p1_sign_ext_5698_comb = {{4{p1_add_5646_comb[19]}}, p1_add_5646_comb};
  assign p1_sign_ext_5699_comb = {{4{p1_bit_slice_5647_comb[19]}}, p1_bit_slice_5647_comb};
  assign p1_add_5700_comb = p1_smul_5648_comb + p1_smul_5586_comb[19:1];
  assign p1_bit_slice_5701_comb = p1_smul_5586_comb[0];
  assign p1_add_5702_comb = p1_smul_5587_comb[19:1] + p1_smul_5651_comb;
  assign p1_bit_slice_5703_comb = p1_smul_5587_comb[0];
  assign p1_add_5704_comb = p1_smul_5652_comb + p1_smul_5592_comb[19:1];
  assign p1_bit_slice_5705_comb = p1_smul_5592_comb[0];
  assign p1_add_5706_comb = p1_smul_5593_comb[19:1] + p1_smul_5655_comb;
  assign p1_bit_slice_5707_comb = p1_smul_5593_comb[0];
  assign p1_concat_5708_comb = {p1_add_5656_comb, p1_smul_5548_comb[0]};
  assign p1_concat_5709_comb = {p1_add_5658_comb, p1_smul_5550_comb[0]};
  assign p1_concat_5710_comb = {p1_add_5660_comb, p1_smul_5553_comb[0]};
  assign p1_concat_5711_comb = {p1_add_5662_comb, p1_smul_5555_comb[0]};
  assign p1_concat_5716_comb = {p1_add_5672_comb, p1_smul_5558_comb[0]};
  assign p1_concat_5717_comb = {p1_add_5674_comb, p1_smul_5560_comb[0]};
  assign p1_concat_5718_comb = {p1_add_5676_comb, p1_smul_5561_comb[0]};
  assign p1_concat_5719_comb = {p1_add_5678_comb, p1_smul_5563_comb[0]};
  assign p1_add_5720_comb = p1_smul_5620_comb[19:1] + p1_smul_5681_comb;
  assign p1_bit_slice_5721_comb = p1_smul_5620_comb[0];
  assign p1_add_5722_comb = p1_smul_5623_comb[19:1] + p1_smul_5683_comb;
  assign p1_bit_slice_5723_comb = p1_smul_5623_comb[0];
  assign p1_add_5724_comb = p1_smul_5684_comb + p1_smul_5626_comb[19:1];
  assign p1_bit_slice_5725_comb = p1_smul_5626_comb[0];
  assign p1_add_5726_comb = p1_smul_5686_comb + p1_smul_5629_comb[19:1];
  assign p1_bit_slice_5727_comb = p1_smul_5629_comb[0];
  assign p1_sign_ext_5728_comb = {{4{p1_add_5688_comb[19]}}, p1_add_5688_comb};
  assign p1_sign_ext_5729_comb = {{4{p1_bit_slice_5689_comb[19]}}, p1_bit_slice_5689_comb};
  assign p1_sign_ext_5730_comb = {{4{p1_bit_slice_5690_comb[19]}}, p1_bit_slice_5690_comb};
  assign p1_sign_ext_5731_comb = {{4{p1_add_5691_comb[19]}}, p1_add_5691_comb};
  assign p1_bit_slice_5736_comb = p1_add_5578_comb[0];
  assign p1_bit_slice_5737_comb = p1_add_5583_comb[0];
  assign p1_bit_slice_5742_comb = p1_add_5632_comb[0];
  assign p1_bit_slice_5743_comb = p1_add_5633_comb[0];
  assign p1_add_5744_comb = {{11{p1_add_5692_comb[12]}}, p1_add_5692_comb} + {{11{p1_add_5693_comb[12]}}, p1_add_5693_comb};
  assign p1_add_5745_comb = {{11{p1_add_5694_comb[12]}}, p1_add_5694_comb} + {{11{p1_add_5695_comb[12]}}, p1_add_5695_comb};
  assign p1_sum__67_comb = p1_sum__77_comb + p1_sum__78_comb;

  // Registers for pipe stage 1:
  reg [23:0] p1_sign_ext_5696;
  reg [23:0] p1_sign_ext_5697;
  reg [23:0] p1_sign_ext_5698;
  reg [23:0] p1_sign_ext_5699;
  reg [18:0] p1_add_5700;
  reg p1_bit_slice_5701;
  reg [18:0] p1_add_5702;
  reg p1_bit_slice_5703;
  reg [18:0] p1_add_5704;
  reg p1_bit_slice_5705;
  reg [18:0] p1_add_5706;
  reg p1_bit_slice_5707;
  reg [20:0] p1_concat_5708;
  reg [20:0] p1_concat_5709;
  reg [20:0] p1_concat_5710;
  reg [20:0] p1_concat_5711;
  reg [20:0] p1_concat_5716;
  reg [20:0] p1_concat_5717;
  reg [20:0] p1_concat_5718;
  reg [20:0] p1_concat_5719;
  reg [18:0] p1_add_5720;
  reg p1_bit_slice_5721;
  reg [18:0] p1_add_5722;
  reg p1_bit_slice_5723;
  reg [18:0] p1_add_5724;
  reg p1_bit_slice_5725;
  reg [18:0] p1_add_5726;
  reg p1_bit_slice_5727;
  reg [23:0] p1_sign_ext_5728;
  reg [23:0] p1_sign_ext_5729;
  reg [23:0] p1_sign_ext_5730;
  reg [23:0] p1_sign_ext_5731;
  reg p1_bit_slice_5736;
  reg p1_bit_slice_5737;
  reg p1_bit_slice_5742;
  reg p1_bit_slice_5743;
  reg [23:0] p1_add_5744;
  reg [23:0] p1_add_5745;
  reg [24:0] p1_sum__67;
  always @ (posedge clk) begin
    p1_sign_ext_5696 <= p1_sign_ext_5696_comb;
    p1_sign_ext_5697 <= p1_sign_ext_5697_comb;
    p1_sign_ext_5698 <= p1_sign_ext_5698_comb;
    p1_sign_ext_5699 <= p1_sign_ext_5699_comb;
    p1_add_5700 <= p1_add_5700_comb;
    p1_bit_slice_5701 <= p1_bit_slice_5701_comb;
    p1_add_5702 <= p1_add_5702_comb;
    p1_bit_slice_5703 <= p1_bit_slice_5703_comb;
    p1_add_5704 <= p1_add_5704_comb;
    p1_bit_slice_5705 <= p1_bit_slice_5705_comb;
    p1_add_5706 <= p1_add_5706_comb;
    p1_bit_slice_5707 <= p1_bit_slice_5707_comb;
    p1_concat_5708 <= p1_concat_5708_comb;
    p1_concat_5709 <= p1_concat_5709_comb;
    p1_concat_5710 <= p1_concat_5710_comb;
    p1_concat_5711 <= p1_concat_5711_comb;
    p1_concat_5716 <= p1_concat_5716_comb;
    p1_concat_5717 <= p1_concat_5717_comb;
    p1_concat_5718 <= p1_concat_5718_comb;
    p1_concat_5719 <= p1_concat_5719_comb;
    p1_add_5720 <= p1_add_5720_comb;
    p1_bit_slice_5721 <= p1_bit_slice_5721_comb;
    p1_add_5722 <= p1_add_5722_comb;
    p1_bit_slice_5723 <= p1_bit_slice_5723_comb;
    p1_add_5724 <= p1_add_5724_comb;
    p1_bit_slice_5725 <= p1_bit_slice_5725_comb;
    p1_add_5726 <= p1_add_5726_comb;
    p1_bit_slice_5727 <= p1_bit_slice_5727_comb;
    p1_sign_ext_5728 <= p1_sign_ext_5728_comb;
    p1_sign_ext_5729 <= p1_sign_ext_5729_comb;
    p1_sign_ext_5730 <= p1_sign_ext_5730_comb;
    p1_sign_ext_5731 <= p1_sign_ext_5731_comb;
    p1_bit_slice_5736 <= p1_bit_slice_5736_comb;
    p1_bit_slice_5737 <= p1_bit_slice_5737_comb;
    p1_bit_slice_5742 <= p1_bit_slice_5742_comb;
    p1_bit_slice_5743 <= p1_bit_slice_5743_comb;
    p1_add_5744 <= p1_add_5744_comb;
    p1_add_5745 <= p1_add_5745_comb;
    p1_sum__67 <= p1_sum__67_comb;
  end

  // ===== Pipe stage 2:
  wire [23:0] p2_add_5827_comb;
  wire [23:0] p2_add_5828_comb;
  wire [19:0] p2_concat_5829_comb;
  wire [19:0] p2_concat_5830_comb;
  wire [19:0] p2_concat_5831_comb;
  wire [19:0] p2_concat_5832_comb;
  wire [24:0] p2_sum__101_comb;
  wire [24:0] p2_sum__102_comb;
  wire [24:0] p2_sum__103_comb;
  wire [24:0] p2_sum__104_comb;
  wire [24:0] p2_sum__93_comb;
  wire [24:0] p2_sum__94_comb;
  wire [24:0] p2_sum__95_comb;
  wire [24:0] p2_sum__96_comb;
  wire [19:0] p2_concat_5841_comb;
  wire [19:0] p2_concat_5842_comb;
  wire [19:0] p2_concat_5843_comb;
  wire [19:0] p2_concat_5844_comb;
  wire [23:0] p2_add_5845_comb;
  wire [23:0] p2_add_5846_comb;
  wire [24:0] p2_add_5882_comb;
  wire [24:0] p2_sum__83_comb;
  wire [24:0] p2_sum__84_comb;
  wire [24:0] p2_sum__79_comb;
  wire [24:0] p2_sum__80_comb;
  wire [24:0] p2_sum__75_comb;
  wire [24:0] p2_sum__76_comb;
  wire [24:0] p2_sum__71_comb;
  wire [24:0] p2_sum__72_comb;
  wire [23:0] p2_add_5863_comb;
  wire [16:0] p2_bit_slice_5890_comb;
  wire [24:0] p2_sum__70_comb;
  wire [23:0] p2_add_5867_comb;
  wire [23:0] p2_add_5868_comb;
  wire [24:0] p2_sum__68_comb;
  wire [24:0] p2_sum__66_comb;
  wire [23:0] p2_add_5874_comb;
  wire [23:0] p2_add_5875_comb;
  wire [24:0] p2_sum__64_comb;
  wire [23:0] p2_umul_2622_NarrowedMult__comb;
  wire [24:0] p2_add_5879_comb;
  wire [23:0] p2_add_5880_comb;
  wire [24:0] p2_add_5881_comb;
  wire [24:0] p2_add_5883_comb;
  wire [23:0] p2_add_5884_comb;
  wire [24:0] p2_add_5885_comb;
  wire [16:0] p2_bit_slice_5886_comb;
  wire [17:0] p2_add_5905_comb;
  wire [16:0] p2_bit_slice_5887_comb;
  wire [16:0] p2_bit_slice_5888_comb;
  wire [16:0] p2_bit_slice_5889_comb;
  wire [16:0] p2_bit_slice_5891_comb;
  wire [16:0] p2_bit_slice_5892_comb;
  wire [16:0] p2_bit_slice_5893_comb;
  wire [17:0] p2_sign_ext_5896_comb;
  wire [17:0] p2_sign_ext_5897_comb;
  wire [17:0] p2_sign_ext_5898_comb;
  wire [17:0] p2_sign_ext_5901_comb;
  wire [17:0] p2_sign_ext_5902_comb;
  wire [17:0] p2_sign_ext_5903_comb;
  wire [17:0] p2_add_5904_comb;
  wire p2_sgt_5909_comb;
  wire [11:0] p2_bit_slice_5910_comb;
  wire p2_slt_5911_comb;
  assign p2_add_5827_comb = p1_sign_ext_5696 + p1_sign_ext_5697;
  assign p2_add_5828_comb = p1_sign_ext_5698 + p1_sign_ext_5699;
  assign p2_concat_5829_comb = {p1_add_5700, p1_bit_slice_5701};
  assign p2_concat_5830_comb = {p1_add_5702, p1_bit_slice_5703};
  assign p2_concat_5831_comb = {p1_add_5704, p1_bit_slice_5705};
  assign p2_concat_5832_comb = {p1_add_5706, p1_bit_slice_5707};
  assign p2_sum__101_comb = {{4{p1_concat_5708[20]}}, p1_concat_5708};
  assign p2_sum__102_comb = {{4{p1_concat_5709[20]}}, p1_concat_5709};
  assign p2_sum__103_comb = {{4{p1_concat_5710[20]}}, p1_concat_5710};
  assign p2_sum__104_comb = {{4{p1_concat_5711[20]}}, p1_concat_5711};
  assign p2_sum__93_comb = {{4{p1_concat_5716[20]}}, p1_concat_5716};
  assign p2_sum__94_comb = {{4{p1_concat_5717[20]}}, p1_concat_5717};
  assign p2_sum__95_comb = {{4{p1_concat_5718[20]}}, p1_concat_5718};
  assign p2_sum__96_comb = {{4{p1_concat_5719[20]}}, p1_concat_5719};
  assign p2_concat_5841_comb = {p1_add_5720, p1_bit_slice_5721};
  assign p2_concat_5842_comb = {p1_add_5722, p1_bit_slice_5723};
  assign p2_concat_5843_comb = {p1_add_5724, p1_bit_slice_5725};
  assign p2_concat_5844_comb = {p1_add_5726, p1_bit_slice_5727};
  assign p2_add_5845_comb = p1_sign_ext_5728 + p1_sign_ext_5729;
  assign p2_add_5846_comb = p1_sign_ext_5730 + p1_sign_ext_5731;
  assign p2_add_5882_comb = p1_sum__67 + 25'h000_0001;
  assign p2_sum__83_comb = {p2_add_5827_comb, p1_bit_slice_5736};
  assign p2_sum__84_comb = {p2_add_5828_comb, p1_bit_slice_5737};
  assign p2_sum__79_comb = p2_sum__101_comb + p2_sum__102_comb;
  assign p2_sum__80_comb = p2_sum__103_comb + p2_sum__104_comb;
  assign p2_sum__75_comb = p2_sum__93_comb + p2_sum__94_comb;
  assign p2_sum__76_comb = p2_sum__95_comb + p2_sum__96_comb;
  assign p2_sum__71_comb = {p2_add_5845_comb, p1_bit_slice_5742};
  assign p2_sum__72_comb = {p2_add_5846_comb, p1_bit_slice_5743};
  assign p2_add_5863_comb = p1_add_5744 + p1_add_5745;
  assign p2_bit_slice_5890_comb = p2_add_5882_comb[24:8];
  assign p2_sum__70_comb = p2_sum__83_comb + p2_sum__84_comb;
  assign p2_add_5867_comb = {{4{p2_concat_5829_comb[19]}}, p2_concat_5829_comb} + {{4{p2_concat_5830_comb[19]}}, p2_concat_5830_comb};
  assign p2_add_5868_comb = {{4{p2_concat_5831_comb[19]}}, p2_concat_5831_comb} + {{4{p2_concat_5832_comb[19]}}, p2_concat_5832_comb};
  assign p2_sum__68_comb = p2_sum__79_comb + p2_sum__80_comb;
  assign p2_sum__66_comb = p2_sum__75_comb + p2_sum__76_comb;
  assign p2_add_5874_comb = {{4{p2_concat_5841_comb[19]}}, p2_concat_5841_comb} + {{4{p2_concat_5842_comb[19]}}, p2_concat_5842_comb};
  assign p2_add_5875_comb = {{4{p2_concat_5843_comb[19]}}, p2_concat_5843_comb} + {{4{p2_concat_5844_comb[19]}}, p2_concat_5844_comb};
  assign p2_sum__64_comb = p2_sum__71_comb + p2_sum__72_comb;
  assign p2_umul_2622_NarrowedMult__comb = umul24b_24b_x_7b(p2_add_5863_comb, 7'h5b);
  assign p2_add_5879_comb = p2_sum__70_comb + 25'h000_0001;
  assign p2_add_5880_comb = p2_add_5867_comb + p2_add_5868_comb;
  assign p2_add_5881_comb = p2_sum__68_comb + 25'h000_0001;
  assign p2_add_5883_comb = p2_sum__66_comb + 25'h000_0001;
  assign p2_add_5884_comb = p2_add_5874_comb + p2_add_5875_comb;
  assign p2_add_5885_comb = p2_sum__64_comb + 25'h000_0001;
  assign p2_bit_slice_5886_comb = p2_umul_2622_NarrowedMult__comb[23:7];
  assign p2_add_5905_comb = {{1{p2_bit_slice_5890_comb[16]}}, p2_bit_slice_5890_comb} + 18'h0_0001;
  assign p2_bit_slice_5887_comb = p2_add_5879_comb[24:8];
  assign p2_bit_slice_5888_comb = p2_add_5880_comb[23:7];
  assign p2_bit_slice_5889_comb = p2_add_5881_comb[24:8];
  assign p2_bit_slice_5891_comb = p2_add_5883_comb[24:8];
  assign p2_bit_slice_5892_comb = p2_add_5884_comb[23:7];
  assign p2_bit_slice_5893_comb = p2_add_5885_comb[24:8];
  assign p2_sign_ext_5896_comb = {{1{p2_bit_slice_5887_comb[16]}}, p2_bit_slice_5887_comb};
  assign p2_sign_ext_5897_comb = {{1{p2_bit_slice_5888_comb[16]}}, p2_bit_slice_5888_comb};
  assign p2_sign_ext_5898_comb = {{1{p2_bit_slice_5889_comb[16]}}, p2_bit_slice_5889_comb};
  assign p2_sign_ext_5901_comb = {{1{p2_bit_slice_5891_comb[16]}}, p2_bit_slice_5891_comb};
  assign p2_sign_ext_5902_comb = {{1{p2_bit_slice_5892_comb[16]}}, p2_bit_slice_5892_comb};
  assign p2_sign_ext_5903_comb = {{1{p2_bit_slice_5893_comb[16]}}, p2_bit_slice_5893_comb};
  assign p2_add_5904_comb = {{1{p2_bit_slice_5886_comb[16]}}, p2_bit_slice_5886_comb} + 18'h0_0001;
  assign p2_sgt_5909_comb = $signed(p2_add_5905_comb[17:1]) > $signed(17'h0_07ff);
  assign p2_bit_slice_5910_comb = p2_add_5905_comb[12:1];
  assign p2_slt_5911_comb = $signed(p2_add_5905_comb[17:1]) < $signed(17'h1_f800);

  // Registers for pipe stage 2:
  reg [17:0] p2_sign_ext_5896;
  reg [17:0] p2_sign_ext_5897;
  reg [17:0] p2_sign_ext_5898;
  reg [17:0] p2_sign_ext_5901;
  reg [17:0] p2_sign_ext_5902;
  reg [17:0] p2_sign_ext_5903;
  reg [17:0] p2_add_5904;
  reg p2_sgt_5909;
  reg [11:0] p2_bit_slice_5910;
  reg p2_slt_5911;
  always @ (posedge clk) begin
    p2_sign_ext_5896 <= p2_sign_ext_5896_comb;
    p2_sign_ext_5897 <= p2_sign_ext_5897_comb;
    p2_sign_ext_5898 <= p2_sign_ext_5898_comb;
    p2_sign_ext_5901 <= p2_sign_ext_5901_comb;
    p2_sign_ext_5902 <= p2_sign_ext_5902_comb;
    p2_sign_ext_5903 <= p2_sign_ext_5903_comb;
    p2_add_5904 <= p2_add_5904_comb;
    p2_sgt_5909 <= p2_sgt_5909_comb;
    p2_bit_slice_5910 <= p2_bit_slice_5910_comb;
    p2_slt_5911 <= p2_slt_5911_comb;
  end

  // ===== Pipe stage 3:
  wire [17:0] p3_add_5938_comb;
  wire [17:0] p3_add_5939_comb;
  wire [17:0] p3_add_5940_comb;
  wire [17:0] p3_add_5941_comb;
  wire [17:0] p3_add_5942_comb;
  wire [17:0] p3_add_5943_comb;
  wire [11:0] p3_clipped__8_comb;
  wire [11:0] p3_clipped__9_comb;
  wire [11:0] p3_clipped__10_comb;
  wire [11:0] p3_clipped__11_comb;
  wire [11:0] p3_clipped__12_comb;
  wire [11:0] p3_clipped__13_comb;
  wire [11:0] p3_clipped__14_comb;
  wire [11:0] p3_clipped__15_comb;
  wire [11:0] p3_result_comb[0:7];
  assign p3_add_5938_comb = p2_sign_ext_5896 + 18'h0_0001;
  assign p3_add_5939_comb = p2_sign_ext_5897 + 18'h0_0001;
  assign p3_add_5940_comb = p2_sign_ext_5898 + 18'h0_0001;
  assign p3_add_5941_comb = p2_sign_ext_5901 + 18'h0_0001;
  assign p3_add_5942_comb = p2_sign_ext_5902 + 18'h0_0001;
  assign p3_add_5943_comb = p2_sign_ext_5903 + 18'h0_0001;
  assign p3_clipped__8_comb = $signed(p2_add_5904[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p2_add_5904[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p2_add_5904[12:1]);
  assign p3_clipped__9_comb = $signed(p3_add_5938_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5938_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5938_comb[12:1]);
  assign p3_clipped__10_comb = $signed(p3_add_5939_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5939_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5939_comb[12:1]);
  assign p3_clipped__11_comb = $signed(p3_add_5940_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5940_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5940_comb[12:1]);
  assign p3_clipped__12_comb = p2_slt_5911 ? 12'h800 : (p2_sgt_5909 ? 12'h7ff : p2_bit_slice_5910);
  assign p3_clipped__13_comb = $signed(p3_add_5941_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5941_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5941_comb[12:1]);
  assign p3_clipped__14_comb = $signed(p3_add_5942_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5942_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5942_comb[12:1]);
  assign p3_clipped__15_comb = $signed(p3_add_5943_comb[17:1]) < $signed(17'h1_f800) ? 12'h800 : ($signed(p3_add_5943_comb[17:1]) > $signed(17'h0_07ff) ? 12'h7ff : p3_add_5943_comb[12:1]);
  assign p3_result_comb[0] = p3_clipped__8_comb;
  assign p3_result_comb[1] = p3_clipped__9_comb;
  assign p3_result_comb[2] = p3_clipped__10_comb;
  assign p3_result_comb[3] = p3_clipped__11_comb;
  assign p3_result_comb[4] = p3_clipped__12_comb;
  assign p3_result_comb[5] = p3_clipped__13_comb;
  assign p3_result_comb[6] = p3_clipped__14_comb;
  assign p3_result_comb[7] = p3_clipped__15_comb;

  // Registers for pipe stage 3:
  reg [11:0] p3_result[0:7];
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
