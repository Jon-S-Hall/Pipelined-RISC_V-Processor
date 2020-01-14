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
//////////////////////////////////////////////////////////////////////////////////


module Fetch_Decode_Moderator(
        input clock,
        input [31:0] Instruction_Out,
        input [15:0] PC_Out_Fetch,
        
        input DUMP,
        input STALL,
        
        output [31:0] Instruction_In,
        output [15:0] PC_In_Decode
                
    );
    
reg [31:0] Instruction_Reg_ID;
wire [31:0] Instruction_Out_2;
wire [31:0] Instruction_Out_3;

reg [15:0] PC_Reg_ID; //PC that is used in the decode stage
wire [15:0] PC_OUT_2; //for stall

assign Instruction_Out_2 = (STALL === 1) ? Instruction_In:
                                           Instruction_Out;

assign Instruction_Out_3 = (DUMP === 1) ? 32'h00000013:    //dump data, make instruction "add R0 + 0 to R0;"
                                          Instruction_Out_2;

assign Instruction_In = Instruction_Reg_ID;

//Stall mux for the PC. If stall, we feed back the output PC from register back into register
//otherwise, get PC from Fetch
assign PC_OUT_2 = (STALL === 1) ? PC_In_Decode:
                                  PC_Out_Fetch; 
                          
assign PC_In_DECODE = PC_Reg_ID;

//registers only change at posedge
always @(posedge clock)
begin
    Instruction_Reg_ID = Instruction_Out_3;
    PC_Reg_ID = PC_OUT_2;
end

 
endmodule
