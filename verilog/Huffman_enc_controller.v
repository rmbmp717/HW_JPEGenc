`define Debug

module Huffman_enc_controller(
  input  wire               clock,
  input  wire               reset_n,
  input  wire               is_luminance,
  input  wire               Huffman_start,
  input  wire  [639:0]      zigzag_pix_in,
  output reg   [639:0]      dc_matrix,
  output reg   [639:0]      ac_matrix,
  output reg   [7:0]        start_pix,
  output reg   [7:0]        pre_start_pix,
  // from enc module
  input  wire  [8:0]        dc_out,       // 9 bits
  input  wire  [7:0]        dc_out_length,
  input  wire  [7:0]        dc_out_code_list,
  input  wire  [7:0]        dc_out_code_size,
  input  wire  [15:0]       ac_out,
  input  wire  [7:0]        length,
  input  wire  [7:0]        code,
  input  wire  [7:0]        code_size,
  input  wire  [9:0]        now_pix_data,
  input  wire  [7:0]        next_pix,
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
      pre_start_pix <= 0;
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
          pre_start_pix <= 0;
          state <= 2;
        end
        2: begin
          state <= 3;
        end
        // AC enc Start
        3: begin
          if(start_pix >= 63) begin
            state <= 0;
            Huffmanenc_active <= 0;
          end else begin
            jpeg_out_enable <= 0;
            ac_matrix <= zigzag_pix_in;
            state <= 4;
          end
        end
        4: begin
          state <= 5;
        end
        5: begin
          state <= 6;
        end
        6: begin
          // DC output 
          jpeg_dc_out <= dc_out;
          jpeg_dc_out_length <= dc_out_length;
          jpeg_dc_code_list <= dc_out_code_list;
          jpeg_dc_code_size <= dc_out_code_size;
          state <= 7;
        end
        7: begin
          state <= 8;
        end
        8: begin
          state <= 9;
        end
        9: begin
          start_pix <= start_pix + next_pix;
          pre_start_pix <= start_pix;
          //start_pix <= start_pix + 1;
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
            if(ac_out[3:0]==4'b1100 && length==8'd4 || start_pix >= 63) begin
              jpeg_out_enable <= 0;
              jpeg_out_end <= 0;
              state <= 0;
              start_pix <= 0;
              pre_start_pix <= 0;
              Huffmanenc_active <= 0;
            end else begin
              jpeg_out_enable <= 0;
              state <= 3;
            end
          end else begin
            if((ac_out[1:0]==2'b01 && length==8'd2) || start_pix >= 63) begin
              jpeg_out_enable <= 0;
              jpeg_out_end <= 0;
              state <= 0;
              start_pix <= 0;
              pre_start_pix <= 0;
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

  //Debug
  `ifdef Debug
  wire [9:0] dc_input = dc_matrix[9:0];

  wire [9:0] ac_input0  = ac_matrix[9:0];
  wire [9:0] ac_input1  = ac_matrix[19:10];
  wire [9:0] ac_input2  = ac_matrix[29:20];
  wire [9:0] ac_input3  = ac_matrix[39:30];
  wire [9:0] ac_input4  = ac_matrix[49:40];
  wire [9:0] ac_input5  = ac_matrix[59:50];
  wire [9:0] ac_input6  = ac_matrix[69:60];
  wire [9:0] ac_input7  = ac_matrix[79:70];
  wire [9:0] ac_input8  = ac_matrix[89:80];
  wire [9:0] ac_input9  = ac_matrix[99:90];
  wire [9:0] ac_input10 = ac_matrix[109:100];
  wire [9:0] ac_input11 = ac_matrix[119:110];
  wire [9:0] ac_input12 = ac_matrix[129:120];
  wire [9:0] ac_input13 = ac_matrix[139:130];
  wire [9:0] ac_input14 = ac_matrix[149:140];
  wire [9:0] ac_input15 = ac_matrix[159:150];
  wire [9:0] ac_input16 = ac_matrix[169:160];
  wire [9:0] ac_input17 = ac_matrix[179:170];
  wire [9:0] ac_input18 = ac_matrix[189:180];
  wire [9:0] ac_input19 = ac_matrix[199:190];
  wire [9:0] ac_input20 = ac_matrix[209:200];
  wire [9:0] ac_input21 = ac_matrix[219:210];
  wire [9:0] ac_input22 = ac_matrix[229:220];
  wire [9:0] ac_input23 = ac_matrix[239:230];
  wire [9:0] ac_input24 = ac_matrix[249:240];
  wire [9:0] ac_input25 = ac_matrix[259:250];
  wire [9:0] ac_input26 = ac_matrix[269:260];
  wire [9:0] ac_input27 = ac_matrix[279:270];
  wire [9:0] ac_input28 = ac_matrix[289:280];
  wire [9:0] ac_input29 = ac_matrix[299:290];
  wire [9:0] ac_input30 = ac_matrix[309:300];
  wire [9:0] ac_input31 = ac_matrix[319:310];
  wire [9:0] ac_input32 = ac_matrix[329:320];
  wire [9:0] ac_input33 = ac_matrix[339:330];
  wire [9:0] ac_input34 = ac_matrix[349:340];
  wire [9:0] ac_input35 = ac_matrix[359:350];
  wire [9:0] ac_input36 = ac_matrix[369:360];
  wire [9:0] ac_input37 = ac_matrix[379:370];
  wire [9:0] ac_input38 = ac_matrix[389:380];
  wire [9:0] ac_input39 = ac_matrix[399:390];
  wire [9:0] ac_input40 = ac_matrix[409:400];
  wire [9:0] ac_input41 = ac_matrix[419:410];
  wire [9:0] ac_input42 = ac_matrix[429:420];
  wire [9:0] ac_input43 = ac_matrix[439:430];
  wire [9:0] ac_input44 = ac_matrix[449:440];
  wire [9:0] ac_input45 = ac_matrix[459:450];
  wire [9:0] ac_input46 = ac_matrix[469:460];
  wire [9:0] ac_input47 = ac_matrix[479:470];
  wire [9:0] ac_input48 = ac_matrix[489:480];
  wire [9:0] ac_input49 = ac_matrix[499:490];
  wire [9:0] ac_input50 = ac_matrix[509:500];
  wire [9:0] ac_input51 = ac_matrix[519:510];
  wire [9:0] ac_input52 = ac_matrix[529:520];
  wire [9:0] ac_input53 = ac_matrix[539:530];
  wire [9:0] ac_input54 = ac_matrix[549:540];
  wire [9:0] ac_input55 = ac_matrix[559:550];
  wire [9:0] ac_input56 = ac_matrix[569:560];
  wire [9:0] ac_input57 = ac_matrix[579:570];
  wire [9:0] ac_input58 = ac_matrix[589:580];
  wire [9:0] ac_input59 = ac_matrix[599:590];
  wire [9:0] ac_input60 = ac_matrix[609:600];
  wire [9:0] ac_input61 = ac_matrix[619:610];
  wire [9:0] ac_input62 = ac_matrix[629:620];
  wire [9:0] ac_input63 = ac_matrix[639:630];

  `endif

endmodule
