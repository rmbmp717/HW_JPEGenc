module Huffman_enc_controller(
  input  wire               clock,
  input  wire               reset_n,
  input  wire               Huffman_start,
  input  wire  [511:0]      zigzag_pix_in,
  output wire  [511:0]      dc_matrix,
  output wire  [511:0]      ac_matrix,
  output wire  [7:0]        start_pix,
  // from enc module
  input  wire  [23:0]       dc_out,
  input  wire  [15:0]       ac_out,
  input  wire  [7:0]        length,
  input  wire  [7:0]        code,
  input  wire  [3:0]        run,
  // final output 
  output wire  [15:0]       jpeg_out,
  output wire  [3:0]        jpeg_data_bits
);

  // 状態レジスタ: 初回はDCを出力、その後はACを出力
  reg state;  // 0: DC, 1: AC
  always @(posedge clock or negedge reset_n) begin
    if (!reset_n)
      state <= 0;
    else
      state <= 1;  // 初回1クロック目はDC、以降はAC
  end

  // DC マトリックス: zigzag_pix_in の最上位 8ビット（DC成分）を残し、残りはゼロにする
  assign dc_matrix = (state == 0) ? { zigzag_pix_in[511:504], 504'b0 } : 512'b0;
  // AC マトリックス: zigzag_pix_in の DC 部分をゼロ化して残りを出力
  assign ac_matrix = (state == 1) ? { 8'b0, zigzag_pix_in[503:0] } : 512'b0;
  // AC 部分の最初のピクセル（zigzag_pix_in のビット503:496）を start_pix とする
  assign start_pix = zigzag_pix_in[503:496];

  // 最終 JPEG 出力: 状態に応じて Huffman DC エンコード結果または AC エンコード結果を出力
  assign jpeg_out = (state == 0) ? dc_out[23:16] : ac_out[15:8];
  // jpeg_data_bits は例として固定の8ビット出力とする（必要に応じて調整）
  assign jpeg_data_bits = 4'd8;

endmodule
