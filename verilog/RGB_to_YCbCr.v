module RGB_to_YCbCr(
  input wire clk,
  input wire [7:0] r,
  input wire [7:0] g,
  input wire [7:0] b,
  output wire [35:0] out
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
  function automatic [49:0] smul50b_17b_x_33b (input reg [16:0] lhs, input reg [32:0] rhs);
    reg signed [16:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [49:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul50b_17b_x_33b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [50:0] smul51b_32b_x_33b (input reg [31:0] lhs, input reg [32:0] rhs);
    reg signed [31:0] signed_lhs;
    reg signed [32:0] signed_rhs;
    reg signed [50:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul51b_32b_x_33b = $unsigned(signed_result);
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
  wire p1_smul_293_TrailingBits__comb;
  wire [8:0] p1_concat_526_comb;
  wire p1_smul_293_TrailingBits___1_comb;
  wire [15:0] p1_smul_529_comb;
  wire [8:0] p1_concat_530_comb;
  wire [16:0] p1_smul_534_comb;
  wire [16:0] p1_smul_536_comb;
  wire p1_smul_293_TrailingBits___2_comb;
  wire [16:0] p1_add_539_comb;
  wire [8:0] p1_concat_542_comb;
  wire [16:0] p1_smul_544_comb;
  wire [9:0] p1_bit_slice_546_comb;
  wire [9:0] p1_add_548_comb;
  wire [14:0] p1_smul_550_comb;
  wire [15:0] p1_smul_293_NarrowedMult__comb;
  wire [15:0] p1_add_558_comb;
  wire [14:0] p1_smul_561_comb;
  wire [24:0] p1_add_562_comb;
  wire [16:0] p1_add_564_comb;
  wire [49:0] p1_smul_570_comb;
  wire [16:0] p1_add_571_comb;
  wire [50:0] p1_smul_573_comb;
  wire [10:0] p1_bit_slice_575_comb;
  wire [48:0] p1_smul_577_comb;
  wire [11:0] p1_cb_16__1_comb;
  wire [11:0] p1_cr_16__1_comb;
  wire [2:0] p1_add_588_comb;
  wire [9:0] p1_concat_596_comb;
  wire [11:0] p1_y_comb;
  wire [11:0] p1_cb_comb;
  wire [11:0] p1_cr_comb;
  wire [35:0] p1_tuple_606_comb;
  assign p1_smul_293_TrailingBits__comb = 1'h0;
  assign p1_concat_526_comb = {p1_smul_293_TrailingBits__comb, p0_r};
  assign p1_smul_293_TrailingBits___1_comb = 1'h0;
  assign p1_smul_529_comb = smul16b_9b_x_7b(p1_concat_526_comb, 7'h55);
  assign p1_concat_530_comb = {p1_smul_293_TrailingBits___1_comb, p0_g};
  assign p1_smul_534_comb = smul17b_9b_x_8b(p1_concat_530_comb, 8'hab);
  assign p1_smul_536_comb = smul17b_9b_x_8b(p1_concat_530_comb, 8'h95);
  assign p1_smul_293_TrailingBits___2_comb = 1'h0;
  assign p1_add_539_comb = {{1{p1_smul_529_comb[15]}}, p1_smul_529_comb} + p1_smul_534_comb;
  assign p1_concat_542_comb = {p1_smul_293_TrailingBits___2_comb, p0_b};
  assign p1_smul_544_comb = smul17b_9b_x_8b(p1_concat_526_comb, 8'h4d);
  assign p1_bit_slice_546_comb = p1_add_539_comb[16:7];
  assign p1_add_548_comb = {2'h0, p0_r} + p1_smul_536_comb[16:7];
  assign p1_smul_550_comb = smul15b_9b_x_6b(p1_concat_542_comb, 6'h2b);
  assign p1_smul_293_NarrowedMult__comb = smul16b_9b_x_8b(p1_concat_530_comb, 8'h4b);
  assign p1_add_558_comb = p1_smul_544_comb[16:1] + p1_smul_293_NarrowedMult__comb;
  assign p1_smul_561_comb = smul15b_9b_x_6b(p1_concat_542_comb, 6'h1d);
  assign p1_add_562_comb = {{15{p1_bit_slice_546_comb[9]}}, p1_bit_slice_546_comb} + {17'h0_0000, p0_b};
  assign p1_add_564_comb = {p1_add_548_comb, p1_smul_536_comb[6:0]} + {{2{p1_smul_550_comb[14]}}, p1_smul_550_comb};
  assign p1_smul_570_comb = smul50b_17b_x_33b(p1_add_564_comb, 33'h0_8080_8081);
  assign p1_add_571_comb = {p1_add_558_comb, p1_smul_544_comb[0]} + {2'h0, p1_smul_561_comb};
  assign p1_smul_573_comb = smul51b_32b_x_33b({p1_add_562_comb, p1_add_539_comb[6:0]}, 33'h0_8080_8081);
  assign p1_bit_slice_575_comb = p1_smul_570_comb[49:39];
  assign p1_smul_577_comb = smul49b_17b_x_33b(p1_add_571_comb, 33'h0_8080_8081);
  assign p1_cb_16__1_comb = p1_smul_573_comb[50:39] - {12{p1_add_562_comb[24]}};
  assign p1_cr_16__1_comb = {{1{p1_bit_slice_575_comb[10]}}, p1_bit_slice_575_comb} - {12{p1_add_564_comb[16]}};
  assign p1_add_588_comb = p1_smul_577_comb[48:46] + 3'h7;
  assign p1_concat_596_comb = {p1_add_588_comb, p1_smul_577_comb[45:39]};
  assign p1_y_comb = {{2{p1_concat_596_comb[9]}}, p1_concat_596_comb};
  assign p1_cb_comb = $signed(p1_cb_16__1_comb) > $signed(12'h1ff) ? 12'h1ff : ($signed(p1_cb_16__1_comb) < $signed(12'he01) ? 12'he01 : p1_cb_16__1_comb);
  assign p1_cr_comb = $signed(p1_cr_16__1_comb) > $signed(12'h1ff) ? 12'h1ff : ($signed(p1_cr_16__1_comb) < $signed(12'he01) ? 12'he01 : p1_cr_16__1_comb);
  assign p1_tuple_606_comb = {p1_y_comb, p1_cb_comb, p1_cr_comb};

  // Registers for pipe stage 1:
  reg [35:0] p1_tuple_606;
  always @ (posedge clk) begin
    p1_tuple_606 <= p1_tuple_606_comb;
  end
  assign out = p1_tuple_606;
endmodule
