module Huffman_enc_controller(
  input  wire               clock,
  input  wire               reset_n,
  input  wire  [512-1:0]    zigzag_pix_in,
  output wire  [512-1:0]    dc_matrix,
  output wire  [512-1:0]    ac_matrix,
  output wire  [7:0]        start_pix,
  // from enc module
  input  wire  [24-1:0]     dc_out,
  input  wire  [16-1:0]     ac_out,
  input  wire  [8-1:0]      length,
  input  wire  [8-1:0]      code,
  input  wire  [4-1:0]      run,
  // final output 
  output wire  [7:0]        jpeg_out,
  output wire  [3:0]        jpeg_data_bits
);

endmodule