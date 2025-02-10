module rgb_to_ycbcr(
  input wire clk,
  input wire [7:0] r,
  input wire [7:0] g,
  input wire [7:0] b,
  output wire [23:0] out
);
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
  // lint_off MULTIPLY
  function automatic [14:0] umul15b_8b_x_7b (input reg [7:0] lhs, input reg [6:0] rhs);
    begin
      umul15b_8b_x_7b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY
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
  // lint_off MULTIPLY
  function automatic [12:0] umul13b_8b_x_5b (input reg [7:0] lhs, input reg [4:0] rhs);
    begin
      umul13b_8b_x_5b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY

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
  wire p1_umul_128_TrailingBits___1_comb;
  wire p1_umul_128_TrailingBits__comb;
  wire [8:0] p1_concat_252_comb;
  wire [8:0] p1_concat_255_comb;
  wire [15:0] p1_smul_258_comb;
  wire p1_umul_128_TrailingBits___2_comb;
  wire [14:0] p1_umul_260_comb;
  wire [15:0] p1_smul_261_comb;
  wire [15:0] p1_smul_262_comb;
  wire [8:0] p1_concat_264_comb;
  wire p1_umul_128_TrailingBits___3_comb;
  wire [15:0] p1_add_269_comb;
  wire [8:0] p1_add_270_comb;
  wire [14:0] p1_smul_272_comb;
  wire [14:0] p1_umul_128_NarrowedMult__comb;
  wire [14:0] p1_add_279_comb;
  wire [12:0] p1_umul_282_comb;
  wire [8:0] p1_add_283_comb;
  wire [15:0] p1_add_284_comb;
  wire [15:0] p1_add_289_comb;
  wire [7:0] p1_y_comb;
  wire [7:0] p1_cb__1_comb;
  wire [7:0] p1_cr__1_comb;
  wire [23:0] p1_tuple_297_comb;
  assign p1_umul_128_TrailingBits___1_comb = 1'h0;
  assign p1_umul_128_TrailingBits__comb = 1'h0;
  assign p1_concat_252_comb = {p1_umul_128_TrailingBits___1_comb, p0_g};
  assign p1_concat_255_comb = {p1_umul_128_TrailingBits__comb, p0_r};
  assign p1_smul_258_comb = smul16b_9b_x_8b(p1_concat_252_comb, 8'h95);
  assign p1_umul_128_TrailingBits___2_comb = 1'h0;
  assign p1_umul_260_comb = umul15b_8b_x_7b(p0_r, 7'h4d);
  assign p1_smul_261_comb = smul16b_9b_x_7b(p1_concat_255_comb, 7'h55);
  assign p1_smul_262_comb = smul16b_9b_x_8b(p1_concat_252_comb, 8'hab);
  assign p1_concat_264_comb = {p1_umul_128_TrailingBits___2_comb, p0_b};
  assign p1_umul_128_TrailingBits___3_comb = 1'h0;
  assign p1_add_269_comb = p1_smul_261_comb + p1_smul_262_comb;
  assign p1_add_270_comb = p1_concat_255_comb + p1_smul_258_comb[15:7];
  assign p1_smul_272_comb = smul15b_9b_x_6b(p1_concat_264_comb, 6'h2b);
  assign p1_umul_128_NarrowedMult__comb = umul15b_8b_x_7b(p0_g, 7'h4b);
  assign p1_add_279_comb = {p1_umul_128_TrailingBits___3_comb, p1_umul_260_comb[14:1]} + p1_umul_128_NarrowedMult__comb;
  assign p1_umul_282_comb = umul13b_8b_x_5b(p0_b, 5'h1d);
  assign p1_add_283_comb = p1_add_269_comb[15:7] + p1_concat_264_comb;
  assign p1_add_284_comb = {p1_add_270_comb, p1_smul_258_comb[6:0]} + {{1{p1_smul_272_comb[14]}}, p1_smul_272_comb};
  assign p1_add_289_comb = {p1_add_279_comb, p1_umul_260_comb[0]} + {3'h0, p1_umul_282_comb};
  assign p1_y_comb = p1_add_289_comb[15:8];
  assign p1_cb__1_comb = {~p1_add_283_comb[8], p1_add_283_comb[7:1]};
  assign p1_cr__1_comb = {~p1_add_284_comb[15], p1_add_284_comb[14:8]};
  assign p1_tuple_297_comb = {p1_y_comb, p1_cb__1_comb, p1_cr__1_comb};

  // Registers for pipe stage 1:
  reg [23:0] p1_tuple_297;
  always @ (posedge clk) begin
    p1_tuple_297 <= p1_tuple_297_comb;
  end
  assign out = p1_tuple_297;
endmodule
