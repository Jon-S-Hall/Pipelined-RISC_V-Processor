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
//assign a register to each section of the bits that go through moderator
reg [5:0] ALU_Control_Reg;
reg next_PC_Reg; //PC Select
reg [15:0] target_PC_Reg;
reg op_B_Reg;
reg mem_wEn_Reg;
reg reg_wEn_Reg;
reg [15:0] PC_Reg;
reg [31:0] read_Data_1_Reg;
reg [31:0] read_Data_2_Reg;
reg [31:0] immediate_Reg;
reg [4:0] writeback_Reg_Reg;


//assign output equal to the registers

assign ALU_Control_In = ALU_Control_Reg;
assign next_PC_select_In = next_PC_Reg;
assign target_PC_In = target_PC_Reg;
assign PC_In_Execute = PC_Reg;
assign op_B_sel_in = op_B_Reg;
assign mem_wEn_in_Execute = mem_wEn_Reg;
assign reg_wEn_in_Execute = reg_wEn_Reg;
assign read_Data_1_In = read_Data_1_Reg;
assign read_Data_2_In = read_Data_2_Reg;
assign immediate_In_Execute = immediate_Reg;
assign writeback_Reg_In_Execute = writeback_Reg_Reg;

//assign wires for output of STALL and DUMP mux, input goes through stall mux
wire [5:0] ALU_Control_STALL;
wire [5:0] ALU_Control_DUMP;
wire next_PC_STALL;
wire next_PC_DUMP;
wire [15:0] target_PC_STALL;
wire [15:0] target_PC_DUMP;
wire op_B_STALL;
wire op_B_DUMP;
wire mem_wEn_STALL;
wire mem_wEn_DUMP;
wire reg_wEn_STALL;
wire reg_wEn_DUMP;
wire [15:0] PC_STALL;
wire [15:0] PC_DUMP;
wire [31:0] read_Data_1_STALL;
wire [31:0] read_Data_1_DUMP;
wire [31:0] read_Data_2_STALL;
wire [31:0] read_Data_1_DUMP;
wire [31:0] immediate_STALL;
wire [31:0] immediate_DUMP;
wire [4:0] writeback_Reg_STALL;
wire [4:0] writeback_Reg_DUMP;


assign  ALU_Control_STALL = (STALL === 1) ? ALU_Control_In:
                                            ALU_Control_Out;          
assign  ALU_Control_DUMP  = (DUMP === 1)  ? 6'b000000:
                                           ALU_Control_STALL;
assign next_PC_STALL      = (STALL === 1) ? next_PC_select_In:
                                            next_PC_select_Out;
assign next_PC_DUMP       = (DUMP === 1)  ? 1'b0:
                                             next_PC_STALL;
assign target_PC_STALL    = (STALL === 1) ? target_PC_In:
                                            target_PC_Out;
assign target_PC_DUMP     = (DUMP === 1)  ? 16'b1111111111111111:
                                           target_PC_STALL;
assign op_B_STALL         = (STALL === 1) ? op_B_sel_in:
                                            op_B_sel_Out;
assign op_B_DUMP          = (DUMP === 1)  ? 1'b0:
                                            op_B_STALL;
assign mem_wEn_STALL      = (STALL === 1) ? mem_wEn_Reg:    //might have to assign to reg rather than output
                                            mem_wEn_Out_Decode;
assign mem_wEn_DUMP       = (DUMP === 1) ? 1'b0:
                                           mem_wEn_STALL;
  
                                      


always @(posedge clock)
begin
    ALU_Control_Reg = ALU_Control_DUMP;
    next_PC_Reg     = next_PC_DUMP;
    target_PC_Reg   = target_PC_DUMP;
    op_B_Reg        = op_B_DUMP;
    mem_wEn_Reg     = mem_wEn_DUMP;
       
end

endmodule
