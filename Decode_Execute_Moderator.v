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
// Additional Comments: I provided a lengthy but simple way of commuting control bits. Plan to later simplify.
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module Decode_Execute_Moderator(
        input clock,
        
        input [5:0] ALU_Control_Out,
        input next_PC_select_Out,
        input [15:0] target_PC_Out,
        input op_B_sel_Out, //if output moderator is not included, bits are used in next stage
        input mem_wEn_Out_Decode, //if output stage is included, bits used in further stage
        input reg_wEn_Out_Decode,
        input [15:0] PC_Out_Decode,
        
        input [31:0] read_Data_1_Out,
        input [31:0] read_Data_2_Out,
        
        input [31:0] immediate_Out_Decode,
        input [4:0] writeback_Reg_Out_Decode,
        
        
        input DUMP,
        input STALL,
        
        output [5:0] ALU_Control_In,
        output next_PC_select_In,
        output [15:0] target_PC_In,
        output [15:0] PC_In_Execute,
        output op_B_sel_in,
        output mem_wEn_in_Execute,
        output reg_wEn_in_Execute,
        output [31:0] read_Data_1_In,
        output [31:0] read_Data_2_In,
        output [31:0] immediate_In_Execute,
        output [4:0] writeback_Reg_In_Execute
        
    );


always @(posedge clock)
begin

end

endmodule
