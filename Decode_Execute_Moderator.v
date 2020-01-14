`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Hall
// 
// Create Date: 01/12/2020 06:25:29 PM
// Design Name: Jonathan Hall
// Module Name: Fetch_Decode_Moderator
// Project Name: RISC-V Pipelined Processor
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module Decode_Execute_Moderator(
        input clock,
        input [15:0] PC_Out_Decode,
        input [31:0] read_Data_1_Out,
        input [31:0] read_Data_2_Out,
        
        input DUMP,
        input STALL,
        
        output [31:0] read_Data_1_In,
        output [31:0] read_Data_2_In,
        output [15:0] PC_In_Execute
    );
    
    
    
endmodule
