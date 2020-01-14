// Name: Jonathan Hall
// Pipelined RISC-V Processor

module top #(
  parameter ADDRESS_BITS = 16
) (
  input clock,
  input reset,
  output [31:0] wb_data
);

//
wire DUMP; //Wire to Dump contents of CPU in occasion that branch is taken or jump
wire STALL; //If data hazard, stall.

//Instruction Decode to Execution Stage
reg [ADDRESS_BITS-1:0] PC_REG_EX;
reg [31:0] data_1_reg_EX;
reg [31:0] data_2_reg_EX;
reg [4:0] writeback_reg_EX;
reg [31:0] IMM_reg_EX;

//Instruction Execution to Memory Stage
reg [31:0] ALU_reg_MEM;
reg [4:0] writeback_reg_MEM;
reg memtoReg_MEM;
reg memRead_MEM;
reg memWrite_MEM;

//Memory to Writeback Stage
reg [31:0] ALU_reg_WRITE;
reg [4:0] writeback_reg_WRITE;
reg memtoReg_WRITE;
reg [31:0] memRead_WRITE;
    


// Fetch Wires
    // OUTPUT OF FETCH into FDM
wire [ADDRESS_BITS-1:0] PC_Out_Fetch;
wire [ADDRESS_BITS-1:0] PC_In_Decode;
wire [ADDRESS_BITS-1:0] PC_In_Execute;
// Decode Wires ----------------------------------------------------------------------------------------------------------
    //OUTPUT FROM DECODE -- Into Registers
wire next_PC_Select; //TO FETCH
wire [ADDRESS_BITS-1:0] Target_PC; //TO FETCH
wire [1:0] op_A_sel; //TO ALU MUX
wire op_B_sel;
wire [31:0] imm32;
wire [5:0] ALU_Control;

//From decode registers into

//To Reg File
wire [4:0] read_Sel_1;
wire [4:0] read_Sel_2;
wire wEn;
wire [4:0] write_Sel;
wire mem_wEn;
wire branch_OP;
// Reg File Wires -----------------------------------------------------------------
wire [31:0] read_Data_1_Out; 
wire [31:0] read_Data_1_In; //TO ALU A MUX
wire [31:0] read_Data_2_Out; 
wire [31:0] read_Data_2_In; //TO ALU B MUX
//mem write back wires
wire wb_Sel;
// Execute Wires
wire [31:0] JALR_target_long;
wire [ADDRESS_BITS-1:0] JALR_target; // Assigned outside of ALU
wire [31:0] ALU_Res;
wire branch;
//wire for writeback to REG
wire [31:0] reg_WB_Data;

//OP A WIRE
wire [31:0] OP_A_IN;
wire [31:0] OP_B_IN;

// Memory Wires

wire [31:0] Instruction_Out;//OUTPUT FROM RAM to FDM- INSTRUCTION
wire[31:0] Instruction_In;//Output FROM FDM to DECODE

wire [31:0] d_Read_Data;

assign wb_data = reg_WB_Data; 

assign JALR_target_long = imm32 + read_Data_1_Out;
assign JALR_target = JALR_target_long[ADDRESS_BITS-1:0];

//mux for OP A and OP B - ask if in the right place
//These values are input into ALU.
assign OP_A_IN = (op_A_sel === 2'b00) ? read_Data_1_In:
                 (op_A_sel === 2'b01) ? PC_In_Execute: //check this
                 (op_A_sel === 2'b10) ? PC_In_Execute+4: //check this
                 read_Data_1_In;
assign OP_B_IN = (op_B_sel === 1'b0) ? read_Data_2_In:
                 (op_B_sel === 1'b1) ? imm32:
                 imm32;
//assign mux to what is written back to REG
assign reg_WB_Data = (wb_Sel === 1'b0) ? ALU_Res:
                     (wb_Sel === 1'b1) ? d_Read_Data: //only from a load instruction.
                      ALU_Res;
  
//where the assignments to registers are held.
//FETCH TO DECODE

//DONE but needs to be checked
fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) fetch_inst (
  .clock(clock),
  .reset(reset),
  .next_PC_select(next_PC_Select),
  .target_PC(Target_PC),
  .PC(PC_Out_Fetch)
);

Fetch_Decode_Moderator FDM (
    .clock(clock),
    .Instruction_Out(Instruction_Out), //output from RAM into FDM
    
    .PC_Out_Fetch(PC_Out_Fetch),
    .STALL(STALL),
    .DUMP(DUMP),
    
    .Instruction_In(Instruction_In),
    .PC_In_Decode(PC_In_Decode)
);

decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) decode_unit (

  // Inputs from Fetch
  .PC(PC_In_Decode),
  .instruction(Instruction_In),

  // Inputs from Execute/ALU
  .JALR_target(JALR_target), 
  .branch(branch),

  // Outputs to Fetch
  .next_PC_select(next_PC_Select),
  .target_PC(Target_PC),

  // Outputs to Reg File
  .read_sel1(read_Sel_1),
  .read_sel2(read_Sel_2),
  .write_sel(write_Sel),
  .wEn(wEn),

  // Outputs to Execute/ALU
  .branch_op(branch_OP),
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_Sel)

);

Decode_Execute_Moderator DEM (
   .clock(clock),
   .STALL(STALL),
   .DUMP(DUMP),
   .PC_Out_Decode(PC_In_Decode),
   .read_Data_1_Out(read_Data_1_Out),
   .read_Data_2_Out(read_Data_2_Out),

   .read_Data_1_In(read_Data_1_In),
   .read_Data_2_In(read_Data_2_In),
   .PC_In_Execute(PC_In_Execute)
);

//DONE but needs to be checked
regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(reg_WB_Data),
  .read_sel1(read_Sel_1),
  .read_sel2(read_Sel_2),
  .write_sel(write_Sel),
  .read_data1(read_Data_1_Out), //output of reg file to DEM
  .read_data2(read_Data_2_Out) //output of reg file to DEM
);



ALU alu_inst(
  .branch_op(branch_OP),
  .ALU_Control(ALU_Control),
  .operand_A(OP_A_IN),
  .operand_B(OP_B_IN),
  .ALU_result(ALU_Res),
  .ALU_branch(branch)
);


ram #(
  .ADDR_WIDTH(ADDRESS_BITS)
) main_memory (
  .clock(clock),

  // Instruction Port
  .i_address(PC_Out_Fetch >> 2),
  .i_read_data(Instruction_Out),

  // Data Port
  .wEn(mem_wEn),
  .d_address(ALU_Res[15:0]),    //ALU_Res is 32 bits but d_address is 16 bits
  .d_write_data(read_Data_2),   //write data comes from rs2 for load/store operations
  .d_read_data(d_Read_Data)
);

endmodule
