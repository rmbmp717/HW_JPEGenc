module Huffman_enc_controller(
  input  wire               clock,
  input  wire               reset_n,
  input  wire               is_luminance,
  input  wire               Huffman_start,
  input  wire  [639:0]      zigzag_pix_in,
  output reg   [639:0]      dc_matrix,
  output reg   [639:0]      ac_matrix,
  output reg   [7:0]        start_pix,
  // from enc module
  input  wire  [8:0]        dc_out,       // 9 bits
  input  wire  [7:0]        dc_out_length,
  input  wire  [7:0]        dc_out_code_list,
  input  wire  [7:0]        dc_out_code_size,
  input  wire  [15:0]       ac_out,
  input  wire  [7:0]        length,
  input  wire  [7:0]        code,
  input  wire  [7:0]        code_size,
  input  wire  [3:0]        run,
  // final output 
  output reg                Huffmanenc_active,
  output reg                jpeg_out_enable,
  output reg                jpeg_out_end,
  output reg   [8:0]        jpeg_dc_out,
  output reg   [7:0]        jpeg_dc_out_length,
  output reg   [7:0]        jpeg_dc_code_list,
  output reg   [7:0]        jpeg_dc_code_size,
  output reg   [15:0]       huffman_code,
  output reg   [7:0]        huffman_code_length,
  output reg   [7:0]        code_out,
  output reg   [7:0]        code_size_out
);

  // 状態レジスタ: 初回はDCを出力、その後はACを出力
  reg [3:0] state;  // 0: DC, 1: AC
  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      state <= 0;
      Huffmanenc_active <= 0;
      dc_matrix <= 0;
      ac_matrix <= 0;
      start_pix <= 0;
      jpeg_out_enable <= 0;
      jpeg_out_end <= 0;
      jpeg_dc_out <= 0;
      jpeg_dc_out_length <= 0;
      jpeg_dc_code_list <= 0;
      jpeg_dc_code_size <= 0;
      huffman_code <= 0;
      huffman_code_length <= 0;
      code_out <= 0;
      code_size_out <= 0;
    end else begin
      case(state)
        0: begin
          dc_matrix <= 0;
          jpeg_out_enable <= 0;
          jpeg_out_end <= 0;
          if(Huffman_start) begin
            state <= 1;
            Huffmanenc_active <= 1;
          end
        end
        // DC enc Start
        1: begin
          jpeg_out_enable <= 0;
          dc_matrix <= zigzag_pix_in;
          start_pix <= 1;
          state <= 2;
        end
        2: begin
          state <= 3;
        end
        // AC enc Start
        3: begin
          if(start_pix >= 63) begin
            state <= 0;
          end else begin
            jpeg_out_enable <= 0;
            ac_matrix <= zigzag_pix_in;
            state <= 4;
          end
        end
        4: begin
          // DC output 
          jpeg_dc_out <= dc_out;
          jpeg_dc_out_length <= dc_out_length;
          jpeg_dc_code_list <= dc_out_code_list;
          jpeg_dc_code_size <= dc_out_code_size;
          state <= 5;
        end
        5: begin
          state <= 6;
        end
        6: begin
          state <= 7;
        end
        7: begin
          state <= 8;
        end
        8: begin
          state <= 9;
        end
        9: begin
          start_pix <= start_pix + run + 1;
          huffman_code <= ac_out;
          huffman_code_length <= length;
          state <= 10;
          code_out <= code; 
          code_size_out <= code_size;
          jpeg_out_enable <= 1;
          if(is_luminance) begin
            if(ac_out[3:0]==4'b1100 && length==8'd4) begin
              jpeg_out_end <= 1;
            end
          end else begin
            if(ac_out[1:0]==2'b01 && length==8'd2) begin
              jpeg_out_end <= 1;
            end
          end
        end
        10: begin
          if(is_luminance) begin
            if(ac_out[3:0]==4'b1100 && length==8'd4) begin
              jpeg_out_enable <= 0;
              jpeg_out_end <= 0;
              state <= 0;
              Huffmanenc_active <= 0;
            end else begin
              jpeg_out_enable <= 0;
              state <= 3;
            end
          end else begin
            if(ac_out[1:0]==2'b01 && length==8'd2) begin
              jpeg_out_enable <= 0;
              jpeg_out_end <= 0;
              state <= 0;
              Huffmanenc_active <= 0;
            end else begin
              jpeg_out_enable <= 0;
              state <= 3;
            end
          end
        end
      endcase
    end
  end

  //assign jpeg_out = 0;
  //assign jpeg_data_bits = 0;

endmodule
