module RGB_to_YCbCr(
  input wire clk,
  input wire [7:0] r,
  input wire [7:0] g,
  input wire [7:0] b,
  output wire [29:0] out
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [15:0] smul16b_9b_x_7b (input reg [8:0] lhs, input reg [6:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [6:0] signed_rhs;
    reg signed [15:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul16b_9b_x_7b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [16:0] smul17b_9b_x_8b (input reg [8:0] lhs, input reg [7:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [16:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul17b_9b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [47:0] smul48b_16b_x_33b (input reg [15:0] lhs, input reg [32:0] rhs);
    reg signed [15:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [47:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul48b_16b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [47:0] smul48b_17b_x_33b (input reg [16:0] lhs, input reg [32:0] rhs);
    reg signed [16:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [47:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul48b_17b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [14:0] smul15b_9b_x_6b (input reg [8:0] lhs, input reg [5:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [14:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul15b_9b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [41:0] smul42b_9b_x_33b (input reg [8:0] lhs, input reg [32:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [41:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul42b_9b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [48:0] smul49b_17b_x_33b (input reg [16:0] lhs, input reg [32:0] rhs);
    reg signed [16:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [48:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul49b_17b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [47:0] smul48b_15b_x_33b (input reg [14:0] lhs, input reg [32:0] rhs);
    reg signed [14:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [47:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul48b_15b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [13:0] smul14b_9b_x_6b (input reg [8:0] lhs, input reg [5:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [5:0] signed_rhs;
    reg signed [13:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul14b_9b_x_6b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [15:0] smul16b_9b_x_8b (input reg [8:0] lhs, input reg [7:0] rhs);
    reg signed [8:0] signed_lhs;
    reg signed [7:0] signed_rhs;
    reg signed [15:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul16b_9b_x_8b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [46:0] smul47b_14b_x_33b (input reg [13:0] lhs, input reg [32:0] rhs);
    reg signed [13:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [46:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul47b_14b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [46:0] smul47b_16b_x_33b (input reg [15:0] lhs, input reg [32:0] rhs);
    reg signed [15:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [46:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul47b_16b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE

  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [7:0] p0_r;
  reg [7:0] p0_g;
  reg [7:0] p0_b;
  always @ (posedge clk) begin
    p0_r <= r;
    p0_g <= g;
    p0_b <= b;
  end

  // ===== Pipe stage 1:
  wire [8:0] p1_concat_678_comb;
  wire [8:0] p1_concat_680_comb;
  wire [15:0] p1_smul_683_comb;
  wire [16:0] p1_smul_685_comb;
  wire [8:0] p1_concat_688_comb;
  wire [47:0] p1_smul_690_comb;
  wire [47:0] p1_smul_691_comb;
  wire [16:0] p1_smul_695_comb;
  wire [14:0] p1_smul_697_comb;
  wire [41:0] p1_smul_442_NarrowedMult__comb;
  wire [48:0] p1_smul_705_comb;
  wire [47:0] p1_smul_706_comb;
  wire [13:0] p1_smul_711_comb;
  wire [8:0] p1_add_713_comb;
  wire [1:0] p1_add_714_comb;
  wire [8:0] p1_bit_slice_718_comb;
  wire [15:0] p1_smul_721_comb;
  wire [15:0] p1_smul_379_NarrowedMult__comb;
  wire [46:0] p1_smul_725_comb;
  wire [41:0] p1_smul_364_NarrowedMult__comb;
  wire [9:0] p1_add_729_comb;
  wire [1:0] p1_add_731_comb;
  wire [47:0] p1_smul_732_comb;
  wire [46:0] p1_smul_733_comb;
  wire [7:0] p1_bit_slice_734_comb;
  wire [9:0] p1_sub_735_comb;
  wire [9:0] p1_outdata__11_comb;
  wire [9:0] p1_add_737_comb;
  wire [9:0] p1_cb_16__1_comb;
  wire [9:0] p1_cr_16__1_comb;
  wire [8:0] p1_add_747_comb;
  wire [8:0] p1_add_755_comb;
  wire [9:0] p1_y_comb;
  wire [9:0] p1_cb_comb;
  wire [9:0] p1_cr_comb;
  wire [29:0] p1_tuple_765_comb;
  assign p1_concat_678_comb = {1'h0, p0_r};
  assign p1_concat_680_comb = {1'h0, p0_g};
  assign p1_smul_683_comb = smul16b_9b_x_7b(p1_concat_678_comb, 7'h55);
  assign p1_smul_685_comb = smul17b_9b_x_8b(p1_concat_680_comb, 8'hab);
  assign p1_concat_688_comb = {1'h0, p0_b};
  assign p1_smul_690_comb = smul48b_16b_x_33b(p1_smul_683_comb, 33'h0_8080_8081);
  assign p1_smul_691_comb = smul48b_17b_x_33b(p1_smul_685_comb, 33'h0_8080_8081);
  assign p1_smul_695_comb = smul17b_9b_x_8b(p1_concat_680_comb, 8'h95);
  assign p1_smul_697_comb = smul15b_9b_x_6b(p1_concat_688_comb, 6'h2b);
  assign p1_smul_442_NarrowedMult__comb = smul42b_9b_x_33b(p1_concat_678_comb, 33'h0_8080_8081);
  assign p1_smul_705_comb = smul49b_17b_x_33b(p1_smul_695_comb, 33'h0_8080_8081);
  assign p1_smul_706_comb = smul48b_15b_x_33b(p1_smul_697_comb, 33'h0_8080_8081);
  assign p1_smul_711_comb = smul14b_9b_x_6b(p1_concat_688_comb, 6'h1d);
  assign p1_add_713_comb = p1_smul_690_comb[47:39] + p1_smul_691_comb[47:39];
  assign p1_add_714_comb = {2{p1_smul_683_comb[15]}} + {2{p1_smul_685_comb[16]}};
  assign p1_bit_slice_718_comb = p1_smul_706_comb[47:39];
  assign p1_smul_721_comb = smul16b_9b_x_8b(p1_concat_678_comb, 8'h4d);
  assign p1_smul_379_NarrowedMult__comb = smul16b_9b_x_8b(p1_concat_680_comb, 8'h4b);
  assign p1_smul_725_comb = smul47b_14b_x_33b(p1_smul_711_comb, 33'h0_8080_8081);
  assign p1_smul_364_NarrowedMult__comb = smul42b_9b_x_33b(p1_concat_688_comb, 33'h0_8080_8081);
  assign p1_add_729_comb = p1_smul_442_NarrowedMult__comb[41:32] + p1_smul_705_comb[48:39];
  assign p1_add_731_comb = {2{p1_smul_695_comb[16]}} + {2{p1_smul_697_comb[14]}};
  assign p1_smul_732_comb = smul48b_16b_x_33b(p1_smul_721_comb, 33'h0_8080_8081);
  assign p1_smul_733_comb = smul47b_16b_x_33b(p1_smul_379_NarrowedMult__comb, 33'h0_8080_8081);
  assign p1_bit_slice_734_comb = p1_smul_725_comb[46:39];
  assign p1_sub_735_comb = {{1{p1_add_713_comb[8]}}, p1_add_713_comb} - {{8{p1_add_714_comb[1]}}, p1_add_714_comb};
  assign p1_outdata__11_comb = p1_smul_364_NarrowedMult__comb[41:32];
  assign p1_add_737_comb = p1_add_729_comb + {{1{p1_bit_slice_718_comb[8]}}, p1_bit_slice_718_comb};
  assign p1_cb_16__1_comb = p1_sub_735_comb + p1_outdata__11_comb;
  assign p1_cr_16__1_comb = p1_add_737_comb - {{8{p1_add_731_comb[1]}}, p1_add_731_comb};
  assign p1_add_747_comb = p1_smul_732_comb[47:39] + p1_smul_733_comb[46:38];
  assign p1_add_755_comb = p1_add_747_comb + ({{1{p1_bit_slice_734_comb[7]}}, p1_bit_slice_734_comb} | 9'h180);
  assign p1_y_comb = {{1{p1_add_755_comb[8]}}, p1_add_755_comb};
  assign p1_cb_comb = $signed(p1_cb_16__1_comb) > $signed(10'h1ff) ? 10'h1ff : ($signed(p1_cb_16__1_comb) < $signed(10'h201) ? 10'h201 : p1_cb_16__1_comb);
  assign p1_cr_comb = $signed(p1_cr_16__1_comb) > $signed(10'h1ff) ? 10'h1ff : ($signed(p1_cr_16__1_comb) < $signed(10'h201) ? 10'h201 : p1_cr_16__1_comb);
  assign p1_tuple_765_comb = {p1_y_comb, p1_cb_comb, p1_cr_comb};

  // Registers for pipe stage 1:
  reg [29:0] p1_tuple_765;
  always @ (posedge clk) begin
    p1_tuple_765 <= p1_tuple_765_comb;
  end
  assign out = p1_tuple_765;
endmodule
