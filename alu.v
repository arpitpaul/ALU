`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2024 19:18:55
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
input [3:0] data_in_a,
input [3:0] data_in_b,
input [2:0] op,
output reg[7:0] data_out
  );
  
  always@(*)
  begin
  case(op)
  3'd0: data_out=data_in_a + data_in_b;
  3'd1: data_out= data_in_a - data_in_b;
  3'd2: data_out= data_in_a * data_in_b;
  3'd3: data_out = data_in_a / data_in_b;
  3'd4: data_out = data_in_a << 2'd3;
  3'd5: data_out = data_in_a >> 2'd3;
  3'd6: data_out = data_in_b << 2'd3;
  3'd7: data_out = data_in_b >> 2'd3;
  default : $display("No operation is left out");
  endcase
  
  end
endmodule
