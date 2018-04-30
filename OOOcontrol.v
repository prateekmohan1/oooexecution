module OOOControl
	#(parameter REGID_BITS = 5,	//This is number of bits for storage
	  parameter CODE_BITS = 5,
	  parameter ROBID_BITS = 7,
	  parameter VALUE_SIZE = 32,
	  parameter NUM_STATIONS = 3,
	  parameter TYPE_INSTR = 4,
	  parameter NUM_ROWS_ROB = 7,
	  parameter OPCODE_SIZE = 20
	)
	(
	  input logic [REGID_BITS-1:0] r1addr,
	  input logic [REGID_BITS-1:0] r2addr,
	  input logic [REGID_BITS-1:0] waddr,
	  input logic [TYPE_INSTR-1:0] type_instr,			//0-ADD,XOR,etc;1-ADDI,SLTI,etc.;2-LW,SW;3-BEQ,BGTZ,etc.
	  input logic [VALUE_SIZE-1:0] immed_val,
	  input logic [VALUE_SIZE-1:0] instr,
	  input logic clk,
	  input logic rst,
	  output logic stall
	);

	logic [ROBID_BITS-1:0] robidr1, robidr2;
	logic [ROBID_BITS-1:0] alu_instr_robid;
	logic [ROBID_BITS-1:0] mem_instr_robid;
	logic [ROBID_BITS-1:0] rs_tag1, rs_tag2;
	logic [VALUE_SIZE-1:0] val1_inp, val2_inp;
	logic [VALUE_SIZE-1:0] rat_src0, rat_src1;
	logic [VALUE_SIZE-1:0] rob_src0, rob_src1;
	logic [VALUE_SIZE-1:0] rat_wval;
	logic [NUM_STATIONS-1:0] stations;

	logic [OPCODE_SIZE-1:0] alu_op;
	logic [OPCODE_SIZE-1:0] alu_op_in;

	logic [VALUE_SIZE-1:0] alu_inp1, alu_inp2;

	logic [REGID_BITS-1:0] rob_waddr;
	logic [REGID_BITS-1:0] rat_rdaddr1, rat_rdaddr2;
	
	logic [ROBID_BITS-1:0] curr_ROBid;
	logic [ROBID_BITS+VALUE_SIZE-1:0] CDB;
	logic [ROBID_BITS+VALUE_SIZE-1:0] CDB_alu;
	logic [ROBID_BITS+VALUE_SIZE-1:0] CDB_mem;
	logic [REGID_BITS-1:0] waddr_RAT;
	logic [VALUE_SIZE-1:0] wdata_RAT;

	logic [5:0] opcode, special;

	logic [15:0] all_bids, all_wins;

	logic w_ROB;

	logic rat_v1, rat_v2, rs_v1, rs_v2, rat_wr;

	logic res_alu_pick, res_mem_pick, branch_pick;
	logic res_alu_full, res_mem_full, branch_full;

	logic rob_full, alu_busy;

	logic rs_valid;

	logic alu_instr_ready, alu_done;
	logic mem_instr_ready, mem_done;
	logic branch_ready, branch_done;

	//assign res_alu_pick = stations[2];
	//assign res_mem_pick = stations[1];
	//assign branch_pick = stations[0];

	assign rs_valid = alu_done;

	always_comb begin
		opcode = instr[31:26];
		special = instr[5:0];
		unique case(opcode)
		6'b000000: begin
			unique case(special)
				6'b100000: begin 
					alu_op = 20'b10000000000000000000; //ADD
				end
				6'b100100: begin 
					alu_op = 20'b01000000000000000000; //AND
				end
                6'b000000: begin
                    alu_op = 20'b00000000000000000111; //SLL
                end
				6'b100111: begin 
					alu_op = 20'b00100000000000000000; //NOR
				end
				6'b100101: begin 
					alu_op = 20'b00010000000000000000; //OR
				end
				6'b101010: begin 
					alu_op = 20'b00001000000000000000; //SLT
				end
				6'b100010: begin 
					alu_op = 20'b00000100000000000000; //SUB
				end
				6'b100110: begin 
					alu_op = 20'b00000010000000000000; //XOR
				end
				6'b000011: begin 
					alu_op = 20'b00000001000000000000; //SRA
				end
				6'b001000: begin
					alu_op = 20'b00000000100000000000; //JR
				end
                6'b100001: begin
                    alu_op = 20'b10000000000000000000; //ADDU, same as ADD
                end
			endcase
		end
		6'b001000: begin 
			alu_op = 20'b00000000010000000000; //ADDI 
		end
		6'b001100: begin 
			alu_op = 20'b00000000001000000000; //ANDI
		end
        6'b001001: begin
            alu_op = 20'b00000000010000000000; //ADDIU, same as ADDI
        end
		6'b001101: begin 
			alu_op = 20'b00000000000100000000; //ORI
		end
		6'b001010: begin 
			alu_op = 20'b00000000000010000000; //SLTI
		end
		6'b001110: begin 
			alu_op = 20'b00000000000001000000; //XORI
		end
		6'b100011: begin
			alu_op = 20'b00000000000000100000; //LW
		end
        6'b001111: begin
        	alu_op = 20'b00000000000000000011;      //LUI
        end
		6'b101011: begin 
			alu_op = 20'b00000000000000010000; //SW
		end
		6'b000100: begin 
			alu_op = 20'b00000000000000001000; //BEQ
		end
		6'b000111: begin 
			alu_op = 20'b00000000000000000100; //BGTZ
		end
		6'b000101: begin 
			alu_op = 20'b00000000000000000010; //BNE
		end
		6'b000010: begin 
			alu_op = 20'b00000000000000000001; //J
		end
		endcase
	end



	always_comb begin

		//Check if the rob is full
		if (rob_full != 1) begin
			//The instruction of type ADD, XOR, etc.
			//ie. add r1, r2, r3
			if (type_instr == 0) begin
				if (res_alu_full != 1) begin
					rob_waddr = waddr;
					rat_rdaddr1 = r1addr;
					rat_rdaddr2 = r2addr;

					rs_v1 = rat_v1;
					rs_v2 = rat_v2;

					rs_tag1 = robidr1;
					rs_tag2 = robidr2;

					stations = 3'b100;

					if (rat_v1 == 1) begin
						val1_inp = rat_src0;
					end
					else begin
						val1_inp = rob_src0;
					end

					if (rat_v2 == 1) begin
						val2_inp = rat_src1;
					end
					else begin
						val2_inp = rob_src1;
					end

					w_ROB = 1;
					res_alu_pick = 1;
					stall = 0;
					rat_wr = 1;
					res_mem_pick = 0;
				end
				else begin
					w_ROB = 0;
					res_alu_pick = 0;
					stall = 1;
					rat_wr = 0;
					res_mem_pick = 0;
				end

			end
			//The instruction of type ADDI, XORI, SRA, etc
			//ie. addi r1, r2, 25
			else if (type_instr == 1) begin
				if (res_alu_full != 1) begin
					rob_waddr = waddr;
					rat_rdaddr1 = r1addr;
					val2_inp = immed_val;

					rs_v1 = rat_v1;
					rs_v2 = 1'b1;

					rs_tag1 = robidr1;
					rs_tag2 = {ROBID_BITS{1'bx}};

					stations = 3'b100;

					if (rat_v1 == 1) begin
						val1_inp = rat_src0;
					end
					else begin
						val1_inp = rob_src0;
					end
				
					res_alu_pick = 1;
					stall = 0;
					w_ROB = 1;
					rat_wr = 1;
					res_mem_pick = 0;
				end
				else begin
					w_ROB = 0;
					res_alu_pick = 0;
					stall = 1;
					rat_wr = 1;
					res_mem_pick = 0;
				end
			end
			//The instruction is of type LW, or SW
			//ie. lw r1, 0(r2)
			else if (type_instr == 2) begin
				if (res_mem_full != 1) begin
					rob_waddr = waddr;
					val2_inp = immed_val;
					
					rs_v1 = rat_v1;
					rs_v2 = 1'b1;

					rs_tag1 = robidr1;
					rs_tag2 = {ROBID_BITS{1'bx}};

					stations = 3'b010;
	
					if (rat_v1 == 1) begin
						val1_inp = rat_src0;
					end
					else begin
						val1_inp = rob_src0;
					end

					res_alu_pick = 0;
					stall = 0;
					w_ROB = 1;
					rat_wr = 1;
					res_mem_pick = 1;
				end
				else begin
					w_ROB = 0;
					res_alu_pick = 0;
					stall = 1;
					rat_wr = 1;
					res_mem_pick = 0;
				end
			end
			//The instruction is of type BRANCH
			//ie. lw r1, 0(r2)
			else if (type_instr == 3) begin
				w_ROB = 0;
				res_alu_pick = 0;
				res_mem_pick = 0;
				rat_wr = 0;
			end
		end
		else begin
			w_ROB = 0;
			rat_wr = 0;
			res_alu_pick = 0;
			res_mem_pick = 0;
			stall = 1;
		end

		//Depending on if any of the reservation stations have finished, it will output data on the CDB
		//Arbitration needs to be done if multiple reservation stations have finished 


	end


	always_comb begin
		if (all_wins[0] == 1) begin
			CDB = CDB_alu;
		end
		else if (all_wins[1] == 1) begin
			CDB = CDB_mem;
		end
		else begin
			CDB = CDB_mem;
		end
	end

	fairArb arb_CDB(.bids(all_bids),
					.wins(all_wins),
					.clk(clk),
					.rst(rst)
					);

	res_station res_ALU(.robidDest(curr_ROBid),
						.tag1(rs_tag1),
						.tag2(rs_tag2),
						.val1(val1_inp),
						.val2(val2_inp),
						.valid1(rs_v1),
						.valid2(rs_v2),
						.clk(clk),
						.rst(rst),
						.robfull(rob_full),
						.CDB(CDB),
						.exc_busy(alu_busy),
						.exc_finish(alu_done),
						.rs_pick(res_alu_pick),
						.full(res_alu_full),
						.rdy_exc(alu_instr_ready),
						.exc_robid(alu_instr_robid),
						.in_opcode(alu_op),
						.out_val1(alu_inp1),
						.out_val2(alu_inp2),
						.out_opcode(alu_op_in)
					   );	

	res_station res_MEM(.robidDest(curr_ROBid),
						.tag1(rs_tag1),
						.tag2(rs_tag2),
						.val1(val1_inp),
						.val2(val2_inp),
						.valid1(rs_v1),
						.valid2(rs_v2),
						.clk(clk),
						.rst(rst),
						.robfull(rob_full),
						.CDB(CDB),
						.exc_busy(mem_busy),
						.exc_finish(mem_done),
						.rs_pick(res_mem_pick),
						.full(res_mem_full),
						.rdy_exc(mem_instr_ready),
						.exc_robid(mem_instr_robid),
						.out_val1(),
						.out_val2()
					   );	

	alu exec_ALU(.opcode(alu_op_in),
				 .rs(alu_inp1),
				 .rt(alu_inp2),
				 .CDB(CDB_alu),
				 .busy(alu_busy),
				 .done(alu_done),
				 .clk(clk),
				 .rst(rst),
				 .inp_ready(alu_instr_ready),
				 .robid_exc(alu_instr_robid),
				 .bid(all_bids[0]),
				 .win(all_wins[0])
				);

	//res_BRANCH res_station(.robidDest(curr_ROBid),
	//					   .tag1(rs_tag1),
	//					   .tag2(rs_tag2),
	//					   .val1(val1_inp),
	//					   .val2(val2_inp),
	//					   .valid1(rs_v1),
	//					   .valid2(rs_v2),
	//					   .clk(clk),
	//					   .rst(rst),
	//					   .CDB(),
	//					   .exc_finish(branch_done),
	//					   .rs_pick(branch_pick),
	//					   .full(branch_full),
	//					   .rdy_exc(branch_ready),
	//					   .exc_robid()
	//				      );	

 	rat rat_1(.r1addr(rat_rdaddr1),
			  .r2addr(rat_rdaddr2),
			  .waddr(waddr),
			  .clk(clk),
			  .rst(rst),
			  .robfull(rob_full),
			  .write_ROBid(rat_wr),
			  .currID(curr_ROBid),
			  .robIDr1(robidr1),
			  .robIDr2(robidr2),
			  .src0(rat_src0),
			  .src1(rat_src1),
			  .v1(rat_v1),
			  .v2(rat_v2),
			  .waddr_RAT(waddr_RAT),
			  .wdata_RAT(wdata_RAT)
			 );
	
	rob rob_sh(.waddr(rob_waddr),
			   .robIDr1(robidr1),
			   .robIDr2(robidr2),
			   .CDB(CDB),
			   .clk(clk),
			   .rst(rst),
			   .w_ROB(w_ROB),
		   	   .rs_valid(rs_valid),
			   .full(rob_full),
			   .curr_id(curr_ROBid),
			   .src0(rob_src0),
			   .src1(rob_src1),
			   .waddr_RAT(waddr_RAT),
			   .wdata_RAT(wdata_RAT)
			  );

	


endmodule: OOOControl

