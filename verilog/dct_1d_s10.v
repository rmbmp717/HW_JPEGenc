module dct_1d_s10(
  input wire clk,
  input wire [79:0] x,
  output wire [79:0] out
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [18:0] smul19b_10b_x_9b (input reg [9:0] lhs, input reg [8:0] rhs);
    reg signed [9:0] signed_lhs;
    reg signed [8:0] signed_rhs;
    reg signed [18:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul19b_10b_x_9b = $unsigned(signed_result);
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
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [16:0] smul17b_17b_x_7b (input reg [16:0] lhs, input reg [6:0] rhs);
    reg signed [16:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [16:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul17b_17b_x_7b = $unsigned(signed_result);
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
  wire [9:0] p1_array_index_5498_comb;
  wire [9:0] p1_array_index_5499_comb;
  wire [9:0] p1_array_index_5500_comb;
  wire [9:0] p1_array_index_5501_comb;
  wire [9:0] p1_array_index_5502_comb;
  wire [9:0] p1_array_index_5503_comb;
  wire [9:0] p1_array_index_5504_comb;
  wire [9:0] p1_array_index_5505_comb;
  wire [23:0] p1_sign_ext_5508_comb;
  wire [23:0] p1_sign_ext_5509_comb;
  wire [23:0] p1_sign_ext_5510_comb;
  wire [23:0] p1_sign_ext_5511_comb;
  wire [23:0] p1_sign_ext_5514_comb;
  wire [23:0] p1_sign_ext_5515_comb;
  wire [23:0] p1_sign_ext_5520_comb;
  wire [23:0] p1_sign_ext_5525_comb;
  wire [18:0] p1_smul_5664_comb;
  wire [18:0] p1_smul_5665_comb;
  wire [18:0] p1_smul_5666_comb;
  wire [18:0] p1_smul_5667_comb;
  wire [18:0] p1_smul_5668_comb;
  wire [18:0] p1_smul_5669_comb;
  wire [18:0] p1_smul_5670_comb;
  wire [18:0] p1_smul_5671_comb;
  wire [18:0] p1_smul_5530_comb;
  wire [18:0] p1_smul_5531_comb;
  wire [18:0] p1_smul_5540_comb;
  wire [18:0] p1_smul_5541_comb;
  wire [18:0] p1_smul_5548_comb;
  wire [18:0] p1_smul_5550_comb;
  wire [18:0] p1_smul_5553_comb;
  wire [18:0] p1_smul_5555_comb;
  wire [18:0] p1_smul_5558_comb;
  wire [18:0] p1_smul_5560_comb;
  wire [18:0] p1_smul_5561_comb;
  wire [18:0] p1_smul_5563_comb;
  wire [18:0] p1_smul_5572_comb;
  wire [18:0] p1_smul_5573_comb;
  wire [18:0] p1_smul_5574_comb;
  wire [18:0] p1_smul_5575_comb;
  wire [18:0] p1_add_5712_comb;
  wire [18:0] p1_add_5713_comb;
  wire [18:0] p1_add_5714_comb;
  wire [18:0] p1_add_5715_comb;
  wire [18:0] p1_add_5578_comb;
  wire [17:0] p1_smul_5579_comb;
  wire [17:0] p1_smul_5580_comb;
  wire [17:0] p1_smul_5581_comb;
  wire [17:0] p1_smul_5582_comb;
  wire [18:0] p1_add_5583_comb;
  wire [17:0] p1_smul_5586_comb;
  wire [17:0] p1_smul_5587_comb;
  wire [17:0] p1_smul_5592_comb;
  wire [17:0] p1_smul_5593_comb;
  wire [17:0] p1_smul_5597_comb;
  wire [17:0] p1_smul_5599_comb;
  wire [17:0] p1_smul_5600_comb;
  wire [17:0] p1_smul_5602_comb;
  wire [17:0] p1_smul_5612_comb;
  wire [17:0] p1_smul_5614_comb;
  wire [17:0] p1_smul_5617_comb;
  wire [17:0] p1_smul_5619_comb;
  wire [17:0] p1_smul_5620_comb;
  wire [17:0] p1_smul_5623_comb;
  wire [17:0] p1_smul_5626_comb;
  wire [17:0] p1_smul_5629_comb;
  wire [17:0] p1_smul_5630_comb;
  wire [17:0] p1_smul_5631_comb;
  wire [18:0] p1_add_5632_comb;
  wire [18:0] p1_add_5633_comb;
  wire [17:0] p1_smul_5634_comb;
  wire [17:0] p1_smul_5635_comb;
  wire [24:0] p1_sum__97_comb;
  wire [24:0] p1_sum__98_comb;
  wire [24:0] p1_sum__99_comb;
  wire [24:0] p1_sum__100_comb;
  wire [17:0] p1_bit_slice_5644_comb;
  wire [17:0] p1_add_5645_comb;
  wire [17:0] p1_add_5646_comb;
  wire [17:0] p1_bit_slice_5647_comb;
  wire [16:0] p1_smul_5648_comb;
  wire [16:0] p1_smul_5651_comb;
  wire [16:0] p1_smul_5652_comb;
  wire [16:0] p1_smul_5655_comb;
  wire [17:0] p1_add_5656_comb;
  wire [17:0] p1_add_5658_comb;
  wire [17:0] p1_add_5660_comb;
  wire [17:0] p1_add_5662_comb;
  wire [17:0] p1_add_5672_comb;
  wire [17:0] p1_add_5674_comb;
  wire [17:0] p1_add_5676_comb;
  wire [17:0] p1_add_5678_comb;
  wire [16:0] p1_smul_5681_comb;
  wire [16:0] p1_smul_5683_comb;
  wire [16:0] p1_smul_5684_comb;
  wire [16:0] p1_smul_5686_comb;
  wire [17:0] p1_add_5688_comb;
  wire [17:0] p1_bit_slice_5689_comb;
  wire [17:0] p1_bit_slice_5690_comb;
  wire [17:0] p1_add_5691_comb;
  wire [24:0] p1_sum__77_comb;
  wire [24:0] p1_sum__78_comb;
  wire [10:0] p1_add_5692_comb;
  wire [10:0] p1_add_5693_comb;
  wire [10:0] p1_add_5694_comb;
  wire [10:0] p1_add_5695_comb;
  wire [23:0] p1_sign_ext_5696_comb;
  wire [23:0] p1_sign_ext_5697_comb;
  wire [23:0] p1_sign_ext_5698_comb;
  wire [23:0] p1_sign_ext_5699_comb;
  wire [16:0] p1_add_5700_comb;
  wire p1_bit_slice_5701_comb;
  wire [16:0] p1_add_5702_comb;
  wire p1_bit_slice_5703_comb;
  wire [16:0] p1_add_5704_comb;
  wire p1_bit_slice_5705_comb;
  wire [16:0] p1_add_5706_comb;
  wire p1_bit_slice_5707_comb;
  wire [18:0] p1_concat_5708_comb;
  wire [18:0] p1_concat_5709_comb;
  wire [18:0] p1_concat_5710_comb;
  wire [18:0] p1_concat_5711_comb;
  wire [18:0] p1_concat_5716_comb;
  wire [18:0] p1_concat_5717_comb;
  wire [18:0] p1_concat_5718_comb;
  wire [18:0] p1_concat_5719_comb;
  wire [16:0] p1_add_5720_comb;
  wire p1_bit_slice_5721_comb;
  wire [16:0] p1_add_5722_comb;
  wire p1_bit_slice_5723_comb;
  wire [16:0] p1_add_5724_comb;
  wire p1_bit_slice_5725_comb;
  wire [16:0] p1_add_5726_comb;
  wire p1_bit_slice_5727_comb;
  wire [23:0] p1_sign_ext_5728_comb;
  wire [23:0] p1_sign_ext_5729_comb;
  wire [23:0] p1_sign_ext_5730_comb;
  wire [23:0] p1_sign_ext_5731_comb;
  wire p1_bit_slice_5732_comb;
  wire p1_bit_slice_5733_comb;
  wire p1_bit_slice_5738_comb;
  wire p1_bit_slice_5739_comb;
  wire [24:0] p1_sum__67_comb;
  assign p1_array_index_5498_comb = p0_x[3'h2];
  assign p1_array_index_5499_comb = p0_x[3'h3];
  assign p1_array_index_5500_comb = p0_x[3'h4];
  assign p1_array_index_5501_comb = p0_x[3'h5];
  assign p1_array_index_5502_comb = p0_x[3'h1];
  assign p1_array_index_5503_comb = p0_x[3'h6];
  assign p1_array_index_5504_comb = p0_x[3'h0];
  assign p1_array_index_5505_comb = p0_x[3'h7];
  assign p1_sign_ext_5508_comb = {{14{p1_array_index_5498_comb[9]}}, p1_array_index_5498_comb};
  assign p1_sign_ext_5509_comb = {{14{p1_array_index_5499_comb[9]}}, p1_array_index_5499_comb};
  assign p1_sign_ext_5510_comb = {{14{p1_array_index_5500_comb[9]}}, p1_array_index_5500_comb};
  assign p1_sign_ext_5511_comb = {{14{p1_array_index_5501_comb[9]}}, p1_array_index_5501_comb};
  assign p1_sign_ext_5514_comb = {{14{p1_array_index_5502_comb[9]}}, p1_array_index_5502_comb};
  assign p1_sign_ext_5515_comb = {{14{p1_array_index_5503_comb[9]}}, p1_array_index_5503_comb};
  assign p1_sign_ext_5520_comb = {{14{p1_array_index_5504_comb[9]}}, p1_array_index_5504_comb};
  assign p1_sign_ext_5525_comb = {{14{p1_array_index_5505_comb[9]}}, p1_array_index_5505_comb};
  assign p1_smul_5664_comb = smul19b_10b_x_9b(p1_array_index_5504_comb, 9'h0b5);
  assign p1_smul_5665_comb = smul19b_10b_x_9b(p1_array_index_5502_comb, 9'h14b);
  assign p1_smul_5666_comb = smul19b_10b_x_9b(p1_array_index_5498_comb, 9'h14b);
  assign p1_smul_5667_comb = smul19b_10b_x_9b(p1_array_index_5499_comb, 9'h0b5);
  assign p1_smul_5668_comb = smul19b_10b_x_9b(p1_array_index_5500_comb, 9'h0b5);
  assign p1_smul_5669_comb = smul19b_10b_x_9b(p1_array_index_5501_comb, 9'h14b);
  assign p1_smul_5670_comb = smul19b_10b_x_9b(p1_array_index_5503_comb, 9'h14b);
  assign p1_smul_5671_comb = smul19b_10b_x_9b(p1_array_index_5505_comb, 9'h0b5);
  assign p1_smul_5530_comb = smul19b_10b_x_9b(p1_array_index_5504_comb, 9'h0fb);
  assign p1_smul_5531_comb = smul19b_10b_x_9b(p1_array_index_5502_comb, 9'h0d5);
  assign p1_smul_5540_comb = smul19b_10b_x_9b(p1_array_index_5503_comb, 9'h12b);
  assign p1_smul_5541_comb = smul19b_10b_x_9b(p1_array_index_5505_comb, 9'h105);
  assign p1_smul_5548_comb = smul19b_10b_x_9b(p1_array_index_5504_comb, 9'h0d5);
  assign p1_smul_5550_comb = smul19b_10b_x_9b(p1_array_index_5498_comb, 9'h105);
  assign p1_smul_5553_comb = smul19b_10b_x_9b(p1_array_index_5501_comb, 9'h0fb);
  assign p1_smul_5555_comb = smul19b_10b_x_9b(p1_array_index_5505_comb, 9'h12b);
  assign p1_smul_5558_comb = smul19b_10b_x_9b(p1_array_index_5502_comb, 9'h105);
  assign p1_smul_5560_comb = smul19b_10b_x_9b(p1_array_index_5499_comb, 9'h0d5);
  assign p1_smul_5561_comb = smul19b_10b_x_9b(p1_array_index_5500_comb, 9'h0d5);
  assign p1_smul_5563_comb = smul19b_10b_x_9b(p1_array_index_5503_comb, 9'h105);
  assign p1_smul_5572_comb = smul19b_10b_x_9b(p1_array_index_5498_comb, 9'h0d5);
  assign p1_smul_5573_comb = smul19b_10b_x_9b(p1_array_index_5499_comb, 9'h105);
  assign p1_smul_5574_comb = smul19b_10b_x_9b(p1_array_index_5500_comb, 9'h105);
  assign p1_smul_5575_comb = smul19b_10b_x_9b(p1_array_index_5501_comb, 9'h0d5);
  assign p1_add_5712_comb = p1_smul_5664_comb + p1_smul_5665_comb;
  assign p1_add_5713_comb = p1_smul_5666_comb + p1_smul_5667_comb;
  assign p1_add_5714_comb = p1_smul_5668_comb + p1_smul_5669_comb;
  assign p1_add_5715_comb = p1_smul_5670_comb + p1_smul_5671_comb;
  assign p1_add_5578_comb = p1_smul_5530_comb + p1_smul_5531_comb;
  assign p1_smul_5579_comb = smul18b_18b_x_8b(p1_sign_ext_5508_comb[17:0], 8'h47);
  assign p1_smul_5580_comb = smul18b_18b_x_6b(p1_sign_ext_5509_comb[17:0], 6'h19);
  assign p1_smul_5581_comb = smul18b_18b_x_6b(p1_sign_ext_5510_comb[17:0], 6'h27);
  assign p1_smul_5582_comb = smul18b_18b_x_8b(p1_sign_ext_5511_comb[17:0], 8'hb9);
  assign p1_add_5583_comb = p1_smul_5540_comb + p1_smul_5541_comb;
  assign p1_smul_5586_comb = smul18b_18b_x_7b(p1_sign_ext_5514_comb[17:0], 7'h31);
  assign p1_smul_5587_comb = smul18b_18b_x_7b(p1_sign_ext_5508_comb[17:0], 7'h4f);
  assign p1_smul_5592_comb = smul18b_18b_x_7b(p1_sign_ext_5511_comb[17:0], 7'h4f);
  assign p1_smul_5593_comb = smul18b_18b_x_7b(p1_sign_ext_5515_comb[17:0], 7'h31);
  assign p1_smul_5597_comb = smul18b_18b_x_6b(p1_sign_ext_5514_comb[17:0], 6'h27);
  assign p1_smul_5599_comb = smul18b_18b_x_8b(p1_sign_ext_5509_comb[17:0], 8'hb9);
  assign p1_smul_5600_comb = smul18b_18b_x_8b(p1_sign_ext_5510_comb[17:0], 8'h47);
  assign p1_smul_5602_comb = smul18b_18b_x_6b(p1_sign_ext_5515_comb[17:0], 6'h19);
  assign p1_smul_5612_comb = smul18b_18b_x_8b(p1_sign_ext_5520_comb[17:0], 8'h47);
  assign p1_smul_5614_comb = smul18b_18b_x_6b(p1_sign_ext_5508_comb[17:0], 6'h27);
  assign p1_smul_5617_comb = smul18b_18b_x_6b(p1_sign_ext_5511_comb[17:0], 6'h27);
  assign p1_smul_5619_comb = smul18b_18b_x_8b(p1_sign_ext_5525_comb[17:0], 8'h47);
  assign p1_smul_5620_comb = smul18b_18b_x_7b(p1_sign_ext_5520_comb[17:0], 7'h31);
  assign p1_smul_5623_comb = smul18b_18b_x_7b(p1_sign_ext_5508_comb[17:0], 7'h31);
  assign p1_smul_5626_comb = smul18b_18b_x_7b(p1_sign_ext_5511_comb[17:0], 7'h31);
  assign p1_smul_5629_comb = smul18b_18b_x_7b(p1_sign_ext_5525_comb[17:0], 7'h31);
  assign p1_smul_5630_comb = smul18b_18b_x_6b(p1_sign_ext_5520_comb[17:0], 6'h19);
  assign p1_smul_5631_comb = smul18b_18b_x_8b(p1_sign_ext_5514_comb[17:0], 8'hb9);
  assign p1_add_5632_comb = p1_smul_5572_comb + p1_smul_5573_comb;
  assign p1_add_5633_comb = p1_smul_5574_comb + p1_smul_5575_comb;
  assign p1_smul_5634_comb = smul18b_18b_x_8b(p1_sign_ext_5515_comb[17:0], 8'hb9);
  assign p1_smul_5635_comb = smul18b_18b_x_6b(p1_sign_ext_5525_comb[17:0], 6'h19);
  assign p1_sum__97_comb = {{6{p1_add_5712_comb[18]}}, p1_add_5712_comb};
  assign p1_sum__98_comb = {{6{p1_add_5713_comb[18]}}, p1_add_5713_comb};
  assign p1_sum__99_comb = {{6{p1_add_5714_comb[18]}}, p1_add_5714_comb};
  assign p1_sum__100_comb = {{6{p1_add_5715_comb[18]}}, p1_add_5715_comb};
  assign p1_bit_slice_5644_comb = p1_add_5578_comb[18:1];
  assign p1_add_5645_comb = p1_smul_5579_comb + p1_smul_5580_comb;
  assign p1_add_5646_comb = p1_smul_5581_comb + p1_smul_5582_comb;
  assign p1_bit_slice_5647_comb = p1_add_5583_comb[18:1];
  assign p1_smul_5648_comb = smul17b_17b_x_7b(p1_sign_ext_5520_comb[16:0], 7'h3b);
  assign p1_smul_5651_comb = smul17b_17b_x_7b(p1_sign_ext_5509_comb[16:0], 7'h45);
  assign p1_smul_5652_comb = smul17b_17b_x_7b(p1_sign_ext_5510_comb[16:0], 7'h45);
  assign p1_smul_5655_comb = smul17b_17b_x_7b(p1_sign_ext_5525_comb[16:0], 7'h3b);
  assign p1_add_5656_comb = p1_smul_5548_comb[18:1] + p1_smul_5597_comb;
  assign p1_add_5658_comb = p1_smul_5550_comb[18:1] + p1_smul_5599_comb;
  assign p1_add_5660_comb = p1_smul_5600_comb + p1_smul_5553_comb[18:1];
  assign p1_add_5662_comb = p1_smul_5602_comb + p1_smul_5555_comb[18:1];
  assign p1_add_5672_comb = p1_smul_5612_comb + p1_smul_5558_comb[18:1];
  assign p1_add_5674_comb = p1_smul_5614_comb + p1_smul_5560_comb[18:1];
  assign p1_add_5676_comb = p1_smul_5561_comb[18:1] + p1_smul_5617_comb;
  assign p1_add_5678_comb = p1_smul_5563_comb[18:1] + p1_smul_5619_comb;
  assign p1_smul_5681_comb = smul17b_17b_x_7b(p1_sign_ext_5514_comb[16:0], 7'h45);
  assign p1_smul_5683_comb = smul17b_17b_x_7b(p1_sign_ext_5509_comb[16:0], 7'h3b);
  assign p1_smul_5684_comb = smul17b_17b_x_7b(p1_sign_ext_5510_comb[16:0], 7'h3b);
  assign p1_smul_5686_comb = smul17b_17b_x_7b(p1_sign_ext_5515_comb[16:0], 7'h45);
  assign p1_add_5688_comb = p1_smul_5630_comb + p1_smul_5631_comb;
  assign p1_bit_slice_5689_comb = p1_add_5632_comb[18:1];
  assign p1_bit_slice_5690_comb = p1_add_5633_comb[18:1];
  assign p1_add_5691_comb = p1_smul_5634_comb + p1_smul_5635_comb;
  assign p1_sum__77_comb = p1_sum__97_comb + p1_sum__98_comb;
  assign p1_sum__78_comb = p1_sum__99_comb + p1_sum__100_comb;
  assign p1_add_5692_comb = p1_sign_ext_5520_comb[10:0] + p1_sign_ext_5514_comb[10:0];
  assign p1_add_5693_comb = p1_sign_ext_5508_comb[10:0] + p1_sign_ext_5509_comb[10:0];
  assign p1_add_5694_comb = p1_sign_ext_5510_comb[10:0] + p1_sign_ext_5511_comb[10:0];
  assign p1_add_5695_comb = p1_sign_ext_5515_comb[10:0] + p1_sign_ext_5525_comb[10:0];
  assign p1_sign_ext_5696_comb = {{6{p1_bit_slice_5644_comb[17]}}, p1_bit_slice_5644_comb};
  assign p1_sign_ext_5697_comb = {{6{p1_add_5645_comb[17]}}, p1_add_5645_comb};
  assign p1_sign_ext_5698_comb = {{6{p1_add_5646_comb[17]}}, p1_add_5646_comb};
  assign p1_sign_ext_5699_comb = {{6{p1_bit_slice_5647_comb[17]}}, p1_bit_slice_5647_comb};
  assign p1_add_5700_comb = p1_smul_5648_comb + p1_smul_5586_comb[17:1];
  assign p1_bit_slice_5701_comb = p1_smul_5586_comb[0];
  assign p1_add_5702_comb = p1_smul_5587_comb[17:1] + p1_smul_5651_comb;
  assign p1_bit_slice_5703_comb = p1_smul_5587_comb[0];
  assign p1_add_5704_comb = p1_smul_5652_comb + p1_smul_5592_comb[17:1];
  assign p1_bit_slice_5705_comb = p1_smul_5592_comb[0];
  assign p1_add_5706_comb = p1_smul_5593_comb[17:1] + p1_smul_5655_comb;
  assign p1_bit_slice_5707_comb = p1_smul_5593_comb[0];
  assign p1_concat_5708_comb = {p1_add_5656_comb, p1_smul_5548_comb[0]};
  assign p1_concat_5709_comb = {p1_add_5658_comb, p1_smul_5550_comb[0]};
  assign p1_concat_5710_comb = {p1_add_5660_comb, p1_smul_5553_comb[0]};
  assign p1_concat_5711_comb = {p1_add_5662_comb, p1_smul_5555_comb[0]};
  assign p1_concat_5716_comb = {p1_add_5672_comb, p1_smul_5558_comb[0]};
  assign p1_concat_5717_comb = {p1_add_5674_comb, p1_smul_5560_comb[0]};
  assign p1_concat_5718_comb = {p1_add_5676_comb, p1_smul_5561_comb[0]};
  assign p1_concat_5719_comb = {p1_add_5678_comb, p1_smul_5563_comb[0]};
  assign p1_add_5720_comb = p1_smul_5620_comb[17:1] + p1_smul_5681_comb;
  assign p1_bit_slice_5721_comb = p1_smul_5620_comb[0];
  assign p1_add_5722_comb = p1_smul_5623_comb[17:1] + p1_smul_5683_comb;
  assign p1_bit_slice_5723_comb = p1_smul_5623_comb[0];
  assign p1_add_5724_comb = p1_smul_5684_comb + p1_smul_5626_comb[17:1];
  assign p1_bit_slice_5725_comb = p1_smul_5626_comb[0];
  assign p1_add_5726_comb = p1_smul_5686_comb + p1_smul_5629_comb[17:1];
  assign p1_bit_slice_5727_comb = p1_smul_5629_comb[0];
  assign p1_sign_ext_5728_comb = {{6{p1_add_5688_comb[17]}}, p1_add_5688_comb};
  assign p1_sign_ext_5729_comb = {{6{p1_bit_slice_5689_comb[17]}}, p1_bit_slice_5689_comb};
  assign p1_sign_ext_5730_comb = {{6{p1_bit_slice_5690_comb[17]}}, p1_bit_slice_5690_comb};
  assign p1_sign_ext_5731_comb = {{6{p1_add_5691_comb[17]}}, p1_add_5691_comb};
  assign p1_bit_slice_5732_comb = p1_add_5578_comb[0];
  assign p1_bit_slice_5733_comb = p1_add_5583_comb[0];
  assign p1_bit_slice_5738_comb = p1_add_5632_comb[0];
  assign p1_bit_slice_5739_comb = p1_add_5633_comb[0];
  assign p1_sum__67_comb = p1_sum__77_comb + p1_sum__78_comb;

  // Registers for pipe stage 1:
  reg [10:0] p1_add_5692;
  reg [10:0] p1_add_5693;
  reg [10:0] p1_add_5694;
  reg [10:0] p1_add_5695;
  reg [23:0] p1_sign_ext_5696;
  reg [23:0] p1_sign_ext_5697;
  reg [23:0] p1_sign_ext_5698;
  reg [23:0] p1_sign_ext_5699;
  reg [16:0] p1_add_5700;
  reg p1_bit_slice_5701;
  reg [16:0] p1_add_5702;
  reg p1_bit_slice_5703;
  reg [16:0] p1_add_5704;
  reg p1_bit_slice_5705;
  reg [16:0] p1_add_5706;
  reg p1_bit_slice_5707;
  reg [18:0] p1_concat_5708;
  reg [18:0] p1_concat_5709;
  reg [18:0] p1_concat_5710;
  reg [18:0] p1_concat_5711;
  reg [18:0] p1_concat_5716;
  reg [18:0] p1_concat_5717;
  reg [18:0] p1_concat_5718;
  reg [18:0] p1_concat_5719;
  reg [16:0] p1_add_5720;
  reg p1_bit_slice_5721;
  reg [16:0] p1_add_5722;
  reg p1_bit_slice_5723;
  reg [16:0] p1_add_5724;
  reg p1_bit_slice_5725;
  reg [16:0] p1_add_5726;
  reg p1_bit_slice_5727;
  reg [23:0] p1_sign_ext_5728;
  reg [23:0] p1_sign_ext_5729;
  reg [23:0] p1_sign_ext_5730;
  reg [23:0] p1_sign_ext_5731;
  reg p1_bit_slice_5732;
  reg p1_bit_slice_5733;
  reg p1_bit_slice_5738;
  reg p1_bit_slice_5739;
  reg [24:0] p1_sum__67;
  always @ (posedge clk) begin
    p1_add_5692 <= p1_add_5692_comb;
    p1_add_5693 <= p1_add_5693_comb;
    p1_add_5694 <= p1_add_5694_comb;
    p1_add_5695 <= p1_add_5695_comb;
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
    p1_bit_slice_5732 <= p1_bit_slice_5732_comb;
    p1_bit_slice_5733 <= p1_bit_slice_5733_comb;
    p1_bit_slice_5738 <= p1_bit_slice_5738_comb;
    p1_bit_slice_5739 <= p1_bit_slice_5739_comb;
    p1_sum__67 <= p1_sum__67_comb;
  end

  // ===== Pipe stage 2:
  wire [23:0] p2_add_5829_comb;
  wire [23:0] p2_add_5830_comb;
  wire [17:0] p2_concat_5831_comb;
  wire [17:0] p2_concat_5832_comb;
  wire [17:0] p2_concat_5833_comb;
  wire [17:0] p2_concat_5834_comb;
  wire [24:0] p2_sum__101_comb;
  wire [24:0] p2_sum__102_comb;
  wire [24:0] p2_sum__103_comb;
  wire [24:0] p2_sum__104_comb;
  wire [24:0] p2_sum__93_comb;
  wire [24:0] p2_sum__94_comb;
  wire [24:0] p2_sum__95_comb;
  wire [24:0] p2_sum__96_comb;
  wire [17:0] p2_concat_5843_comb;
  wire [17:0] p2_concat_5844_comb;
  wire [17:0] p2_concat_5845_comb;
  wire [17:0] p2_concat_5846_comb;
  wire [23:0] p2_add_5847_comb;
  wire [23:0] p2_add_5848_comb;
  wire [24:0] p2_add_5886_comb;
  wire [23:0] p2_add_5849_comb;
  wire [23:0] p2_add_5850_comb;
  wire [24:0] p2_sum__83_comb;
  wire [24:0] p2_sum__84_comb;
  wire [24:0] p2_sum__79_comb;
  wire [24:0] p2_sum__80_comb;
  wire [24:0] p2_sum__75_comb;
  wire [24:0] p2_sum__76_comb;
  wire [24:0] p2_sum__71_comb;
  wire [24:0] p2_sum__72_comb;
  wire [16:0] p2_bit_slice_5894_comb;
  wire [23:0] p2_add_5867_comb;
  wire [24:0] p2_sum__70_comb;
  wire [23:0] p2_add_5871_comb;
  wire [23:0] p2_add_5872_comb;
  wire [24:0] p2_sum__68_comb;
  wire [24:0] p2_sum__66_comb;
  wire [23:0] p2_add_5878_comb;
  wire [23:0] p2_add_5879_comb;
  wire [24:0] p2_sum__64_comb;
  wire [23:0] p2_umul_2622_NarrowedMult__comb;
  wire [24:0] p2_add_5883_comb;
  wire [23:0] p2_add_5884_comb;
  wire [24:0] p2_add_5885_comb;
  wire [24:0] p2_add_5887_comb;
  wire [23:0] p2_add_5888_comb;
  wire [24:0] p2_add_5889_comb;
  wire [17:0] p2_add_5907_comb;
  wire [16:0] p2_bit_slice_5890_comb;
  wire [16:0] p2_bit_slice_5891_comb;
  wire [16:0] p2_bit_slice_5892_comb;
  wire [16:0] p2_bit_slice_5893_comb;
  wire [16:0] p2_bit_slice_5895_comb;
  wire [16:0] p2_bit_slice_5896_comb;
  wire [16:0] p2_bit_slice_5897_comb;
  wire [17:0] p2_sign_ext_5898_comb;
  wire [17:0] p2_sign_ext_5899_comb;
  wire [17:0] p2_sign_ext_5900_comb;
  wire [17:0] p2_sign_ext_5901_comb;
  wire [17:0] p2_sign_ext_5904_comb;
  wire [17:0] p2_sign_ext_5905_comb;
  wire [17:0] p2_sign_ext_5906_comb;
  wire p2_sgt_5911_comb;
  wire [9:0] p2_bit_slice_5912_comb;
  wire p2_slt_5913_comb;
  assign p2_add_5829_comb = p1_sign_ext_5696 + p1_sign_ext_5697;
  assign p2_add_5830_comb = p1_sign_ext_5698 + p1_sign_ext_5699;
  assign p2_concat_5831_comb = {p1_add_5700, p1_bit_slice_5701};
  assign p2_concat_5832_comb = {p1_add_5702, p1_bit_slice_5703};
  assign p2_concat_5833_comb = {p1_add_5704, p1_bit_slice_5705};
  assign p2_concat_5834_comb = {p1_add_5706, p1_bit_slice_5707};
  assign p2_sum__101_comb = {{6{p1_concat_5708[18]}}, p1_concat_5708};
  assign p2_sum__102_comb = {{6{p1_concat_5709[18]}}, p1_concat_5709};
  assign p2_sum__103_comb = {{6{p1_concat_5710[18]}}, p1_concat_5710};
  assign p2_sum__104_comb = {{6{p1_concat_5711[18]}}, p1_concat_5711};
  assign p2_sum__93_comb = {{6{p1_concat_5716[18]}}, p1_concat_5716};
  assign p2_sum__94_comb = {{6{p1_concat_5717[18]}}, p1_concat_5717};
  assign p2_sum__95_comb = {{6{p1_concat_5718[18]}}, p1_concat_5718};
  assign p2_sum__96_comb = {{6{p1_concat_5719[18]}}, p1_concat_5719};
  assign p2_concat_5843_comb = {p1_add_5720, p1_bit_slice_5721};
  assign p2_concat_5844_comb = {p1_add_5722, p1_bit_slice_5723};
  assign p2_concat_5845_comb = {p1_add_5724, p1_bit_slice_5725};
  assign p2_concat_5846_comb = {p1_add_5726, p1_bit_slice_5727};
  assign p2_add_5847_comb = p1_sign_ext_5728 + p1_sign_ext_5729;
  assign p2_add_5848_comb = p1_sign_ext_5730 + p1_sign_ext_5731;
  assign p2_add_5886_comb = p1_sum__67 + 25'h000_0001;
  assign p2_add_5849_comb = {{13{p1_add_5692[10]}}, p1_add_5692} + {{13{p1_add_5693[10]}}, p1_add_5693};
  assign p2_add_5850_comb = {{13{p1_add_5694[10]}}, p1_add_5694} + {{13{p1_add_5695[10]}}, p1_add_5695};
  assign p2_sum__83_comb = {p2_add_5829_comb, p1_bit_slice_5732};
  assign p2_sum__84_comb = {p2_add_5830_comb, p1_bit_slice_5733};
  assign p2_sum__79_comb = p2_sum__101_comb + p2_sum__102_comb;
  assign p2_sum__80_comb = p2_sum__103_comb + p2_sum__104_comb;
  assign p2_sum__75_comb = p2_sum__93_comb + p2_sum__94_comb;
  assign p2_sum__76_comb = p2_sum__95_comb + p2_sum__96_comb;
  assign p2_sum__71_comb = {p2_add_5847_comb, p1_bit_slice_5738};
  assign p2_sum__72_comb = {p2_add_5848_comb, p1_bit_slice_5739};
  assign p2_bit_slice_5894_comb = p2_add_5886_comb[24:8];
  assign p2_add_5867_comb = p2_add_5849_comb + p2_add_5850_comb;
  assign p2_sum__70_comb = p2_sum__83_comb + p2_sum__84_comb;
  assign p2_add_5871_comb = {{6{p2_concat_5831_comb[17]}}, p2_concat_5831_comb} + {{6{p2_concat_5832_comb[17]}}, p2_concat_5832_comb};
  assign p2_add_5872_comb = {{6{p2_concat_5833_comb[17]}}, p2_concat_5833_comb} + {{6{p2_concat_5834_comb[17]}}, p2_concat_5834_comb};
  assign p2_sum__68_comb = p2_sum__79_comb + p2_sum__80_comb;
  assign p2_sum__66_comb = p2_sum__75_comb + p2_sum__76_comb;
  assign p2_add_5878_comb = {{6{p2_concat_5843_comb[17]}}, p2_concat_5843_comb} + {{6{p2_concat_5844_comb[17]}}, p2_concat_5844_comb};
  assign p2_add_5879_comb = {{6{p2_concat_5845_comb[17]}}, p2_concat_5845_comb} + {{6{p2_concat_5846_comb[17]}}, p2_concat_5846_comb};
  assign p2_sum__64_comb = p2_sum__71_comb + p2_sum__72_comb;
  assign p2_umul_2622_NarrowedMult__comb = umul24b_24b_x_7b(p2_add_5867_comb, 7'h5b);
  assign p2_add_5883_comb = p2_sum__70_comb + 25'h000_0001;
  assign p2_add_5884_comb = p2_add_5871_comb + p2_add_5872_comb;
  assign p2_add_5885_comb = p2_sum__68_comb + 25'h000_0001;
  assign p2_add_5887_comb = p2_sum__66_comb + 25'h000_0001;
  assign p2_add_5888_comb = p2_add_5878_comb + p2_add_5879_comb;
  assign p2_add_5889_comb = p2_sum__64_comb + 25'h000_0001;
  assign p2_add_5907_comb = {{1{p2_bit_slice_5894_comb[16]}}, p2_bit_slice_5894_comb} + 18'h0_0001;
  assign p2_bit_slice_5890_comb = p2_umul_2622_NarrowedMult__comb[23:7];
  assign p2_bit_slice_5891_comb = p2_add_5883_comb[24:8];
  assign p2_bit_slice_5892_comb = p2_add_5884_comb[23:7];
  assign p2_bit_slice_5893_comb = p2_add_5885_comb[24:8];
  assign p2_bit_slice_5895_comb = p2_add_5887_comb[24:8];
  assign p2_bit_slice_5896_comb = p2_add_5888_comb[23:7];
  assign p2_bit_slice_5897_comb = p2_add_5889_comb[24:8];
  assign p2_sign_ext_5898_comb = {{1{p2_bit_slice_5890_comb[16]}}, p2_bit_slice_5890_comb};
  assign p2_sign_ext_5899_comb = {{1{p2_bit_slice_5891_comb[16]}}, p2_bit_slice_5891_comb};
  assign p2_sign_ext_5900_comb = {{1{p2_bit_slice_5892_comb[16]}}, p2_bit_slice_5892_comb};
  assign p2_sign_ext_5901_comb = {{1{p2_bit_slice_5893_comb[16]}}, p2_bit_slice_5893_comb};
  assign p2_sign_ext_5904_comb = {{1{p2_bit_slice_5895_comb[16]}}, p2_bit_slice_5895_comb};
  assign p2_sign_ext_5905_comb = {{1{p2_bit_slice_5896_comb[16]}}, p2_bit_slice_5896_comb};
  assign p2_sign_ext_5906_comb = {{1{p2_bit_slice_5897_comb[16]}}, p2_bit_slice_5897_comb};
  assign p2_sgt_5911_comb = $signed(p2_add_5907_comb[17:1]) > $signed(17'h0_01ff);
  assign p2_bit_slice_5912_comb = p2_add_5907_comb[10:1];
  assign p2_slt_5913_comb = $signed(p2_add_5907_comb[17:1]) < $signed(17'h1_fe01);

  // Registers for pipe stage 2:
  reg [17:0] p2_sign_ext_5898;
  reg [17:0] p2_sign_ext_5899;
  reg [17:0] p2_sign_ext_5900;
  reg [17:0] p2_sign_ext_5901;
  reg [17:0] p2_sign_ext_5904;
  reg [17:0] p2_sign_ext_5905;
  reg [17:0] p2_sign_ext_5906;
  reg p2_sgt_5911;
  reg [9:0] p2_bit_slice_5912;
  reg p2_slt_5913;
  always @ (posedge clk) begin
    p2_sign_ext_5898 <= p2_sign_ext_5898_comb;
    p2_sign_ext_5899 <= p2_sign_ext_5899_comb;
    p2_sign_ext_5900 <= p2_sign_ext_5900_comb;
    p2_sign_ext_5901 <= p2_sign_ext_5901_comb;
    p2_sign_ext_5904 <= p2_sign_ext_5904_comb;
    p2_sign_ext_5905 <= p2_sign_ext_5905_comb;
    p2_sign_ext_5906 <= p2_sign_ext_5906_comb;
    p2_sgt_5911 <= p2_sgt_5911_comb;
    p2_bit_slice_5912 <= p2_bit_slice_5912_comb;
    p2_slt_5913 <= p2_slt_5913_comb;
  end

  // ===== Pipe stage 3:
  wire [17:0] p3_add_5941_comb;
  wire [17:0] p3_add_5942_comb;
  wire [17:0] p3_add_5943_comb;
  wire [17:0] p3_add_5944_comb;
  wire [17:0] p3_add_5945_comb;
  wire [17:0] p3_add_5946_comb;
  wire [17:0] p3_add_5947_comb;
  wire [9:0] p3_clipped__8_comb;
  wire [9:0] p3_clipped__9_comb;
  wire [9:0] p3_clipped__10_comb;
  wire [9:0] p3_clipped__11_comb;
  wire [9:0] p3_clipped__12_comb;
  wire [9:0] p3_clipped__13_comb;
  wire [9:0] p3_clipped__14_comb;
  wire [9:0] p3_clipped__15_comb;
  wire [9:0] p3_result_comb[0:7];
  assign p3_add_5941_comb = p2_sign_ext_5898 + 18'h0_0001;
  assign p3_add_5942_comb = p2_sign_ext_5899 + 18'h0_0001;
  assign p3_add_5943_comb = p2_sign_ext_5900 + 18'h0_0001;
  assign p3_add_5944_comb = p2_sign_ext_5901 + 18'h0_0001;
  assign p3_add_5945_comb = p2_sign_ext_5904 + 18'h0_0001;
  assign p3_add_5946_comb = p2_sign_ext_5905 + 18'h0_0001;
  assign p3_add_5947_comb = p2_sign_ext_5906 + 18'h0_0001;
  assign p3_clipped__8_comb = $signed(p3_add_5941_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5941_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5941_comb[10:1]);
  assign p3_clipped__9_comb = $signed(p3_add_5942_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5942_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5942_comb[10:1]);
  assign p3_clipped__10_comb = $signed(p3_add_5943_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5943_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5943_comb[10:1]);
  assign p3_clipped__11_comb = $signed(p3_add_5944_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5944_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5944_comb[10:1]);
  assign p3_clipped__12_comb = p2_slt_5913 ? 10'h201 : (p2_sgt_5911 ? 10'h1ff : p2_bit_slice_5912);
  assign p3_clipped__13_comb = $signed(p3_add_5945_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5945_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5945_comb[10:1]);
  assign p3_clipped__14_comb = $signed(p3_add_5946_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5946_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5946_comb[10:1]);
  assign p3_clipped__15_comb = $signed(p3_add_5947_comb[17:1]) < $signed(17'h1_fe01) ? 10'h201 : ($signed(p3_add_5947_comb[17:1]) > $signed(17'h0_01ff) ? 10'h1ff : p3_add_5947_comb[10:1]);
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
