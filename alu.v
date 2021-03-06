//
//--------------------------------------------------------------------------------
//          THIS FILE WAS AUTOMATICALLY GENERATED BY THE GENESIS2 ENGINE        
//  FOR MORE INFORMATION: OFER SHACHAM (CHIP GENESIS INC / STANFORD VLSI GROUP)
//    !! THIS VERSION OF GENESIS2 IS NOT FOR ANY COMMERCIAL USE !!
//     FOR COMMERCIAL LICENSE CONTACT SHACHAM@ALUMNI.STANFORD.EDU
//--------------------------------------------------------------------------------
//
//  
//	-----------------------------------------------
//	|            Genesis Release Info             |
//	|  $Change: 11904 $ --- $Date: 2013/08/03 $   |
//	-----------------------------------------------
//	
//
//  Source file: /afs/asu.edu/users/p/m/o/pmohan6/EEE591Brunhav/ProjPart4/Submission/primitives/alu.vp
//  Source template: alu
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Command Line input (priority=4):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From XML input (priority=3):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Config File input (priority=2):
//
// ---------------- End Pre-Generation Pramameters Status Report ----------------

// alu.vp
// bitWidth (_GENESIS2_DECLARATION_PRIORITY_) = 32
//
module alu
	#(parameter VALUE_SIZE=32,
	  parameter OPCODE_SIZE=20,
	  parameter ROBID_BITS=7
	)
	(
	  //input logic nd_valid,
	  //output logic nd_ready,
	  //output logic qr_valid,
	  //input logic ab_valid,
	  //output logic ab_ready,
	  //output logic z_valid,
	  input logic [OPCODE_SIZE-1:0] opcode,
	  input logic [VALUE_SIZE-1:0] rs,
	  input logic [VALUE_SIZE-1:0] rt,
	  input logic win,
	  output logic [ROBID_BITS+VALUE_SIZE-1:0] CDB,
	  output logic done,
	  output logic busy,
	  input logic clk,
	  input logic rst,
	  output logic bid,
	  input logic inp_ready,
	  input logic [ROBID_BITS-1:0] robid_exc
	);

	logic [OPCODE_SIZE-1:0] opcode_f1;
	logic [VALUE_SIZE-1:0] rs_f1;
	logic [VALUE_SIZE-1:0] rt_f1;
	logic [ROBID_BITS-1:0] robid_exc_f1;
	logic [VALUE_SIZE-1:0] alu_out;
	logic [VALUE_SIZE-1:0] inter;

	logic [1:0] counter;
	logic en;

	dffbW_unq6 #(OPCODE_SIZE) dff_opcode_f1(.d(opcode),.clk(clk),.rst(rst),.q(opcode_f1),.en(en));	
	dffbW_unq6 #(VALUE_SIZE) dff_rs_f1(.d(rs),.clk(clk),.rst(rst),.q(rs_f1),.en(en));	
	dffbW_unq6 #(VALUE_SIZE) dff_rt_f1(.d(rt),.clk(clk),.rst(rst),.q(rt_f1),.en(en));	
	dffbW_unq6 #(ROBID_BITS) dff_robidexc_f1(.d(robid_exc),.clk(clk),.rst(rst),.q(robid_exc_f1),.en(en));	

	always_comb begin
		if (!busy) begin
			if (inp_ready == 1) begin
				en = 1;
			end
			else begin
				en = 0;
			end
		end
		else begin
			en = 0;
		end
	end

	always_ff @(posedge clk) begin
		if (~rst) begin
			counter <= 0;
			busy <= 0;
			done <= 0;
			bid <= 0;
		end
		else begin
			if (en == 1 && busy == 0) begin
				busy <= 1;
				counter <= 0;
				done <= 0;
			end

			if (counter == 1) begin
				bid <= 1;
			end
	
			if (busy == 1) begin
				counter <= counter + 1;
			end

			if (counter >= 2) begin
				if (win != 1) begin
					counter <= 2;
					bid <= 1;
					busy <= 1;
					done <= 0;
				end
				else begin
					counter <= 0;
					busy <= 0;
					done <= 1;
					bid <= 0;
				end
			end
		end
	end


	//Decode input instr.
	logic [OPCODE_SIZE-1:0] op;
	logic sign_bit;
	logic [4:0] extend;
	//logic [31:0] inter;
	//logic [64:0] mult_out;
	//logic [31:0] div_quo_out;
	//logic [31:0] div_rem_out;
	
	//seqDiv  my_seqDiv(		//SeqDiv
	//.nd_valid(nd_valid),
	//.den(rt),
	//.num(rs),
	//.quo(div_quo_out),
	//.rem(div_rem_out),
	//.nd_ready(nd_ready),
	//.clk(clk),
	//.rst(rst),
	//.qr_valid(qr_valid)
	//);
	//
	//seqMult  my_seqMult(		//SeqMult
	//.ab_valid(ab_valid),
	//.a(rs),
	//.b(rt),
	//.z(mult_out),
	//.ab_ready(ab_ready),
	//.clk(clk),
	//.rst(rst),
	//.z_valid(z_valid)
	//);
	
	always_comb begin
		op = opcode_f1;
		
		if (busy == 1) begin
		  unique case(op)
		  	20'b10000000000000000000: begin						//ADD
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b01000000000000000000: begin						//AND
		  							alu_out = rs_f1 & rt_f1; 		//(bit-wise)
		  						end
		  	20'b00100000000000000000: begin						//NOR
		  							alu_out = ~(rs_f1 | rt_f1);
		  						end
		  	20'b00010000000000000000: begin						//OR
		  							alu_out = rs_f1 | rt_f1;
		  						end
		  	20'b00001000000000000000: begin						//SLT
		  							if (rs_f1[31] == 1'b1 && rt_f1[31] == 1'b0) begin
		  								alu_out = 1;
		  							end
		  							else if (rs_f1[31] == 1'b0 && rt_f1[31] == 1'b1) begin
		  								alu_out = 0;
		  							end
		  							else if (rs_f1[31] == 1'b0 && rt_f1[31] == 1'b0) begin
		  								if (rs_f1 < rt_f1) begin
		  									alu_out = 1;
		  								end
		  								else begin
		  									alu_out = 0;
		  								end
		  							end
		  							else begin
		  								//NEED TO ADD SOMETHING HERE
		  								alu_out = 0;
		  							end
		  						end
		  	20'b00000100000000000000: begin						//SUB
		  							alu_out = rs_f1 - rt_f1;
		  						end
		  	20'b00000010000000000000: begin						//XOR
		  							alu_out = rs_f1 ^ rt_f1;
		  						end
		  	20'b00000001000000000000: begin						//SRA
		  							sign_bit = rt_f1[31];
		  							extend = 31-rs_f1;
		  							inter = rt_f1 >>> rs_f1;
		  							//alu_out = { {extend{sign_bit}},inter };
		  							alu_out = inter;
		  							
		  						end
		  	20'b00000000100000000000: begin						//JR
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b00000000010000000000: begin						//ADDI
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b00000000001000000000: begin						//ANDI
		  							alu_out = rs_f1 & rt_f1;
		  						end
		  	20'b00000000000100000000: begin						//ORI
		  							alu_out = rs_f1 | rt_f1;
		  						end
		  	20'b00000000000010000000: begin						//SLTI
		  							if (rs_f1[31] == 1'b1 && rt_f1[31] == 1'b0) begin
		  								alu_out = 1;
		  							end
		  							else if (rs_f1[31] == 1'b0 && rt_f1[31] == 1'b1) begin
		  								alu_out = 0;
		  							end
		  							else if (rs_f1[31] == 1'b0 && rt_f1[31] == 1'b0) begin
		  								if (rs_f1 < rt_f1) begin
		  									alu_out = 1;
		  								end
		  								else begin
		  									alu_out = 0;
		  								end
		  							end
		  							else begin
		  								//NEED TO ADD SOMETHING HERE
		  								alu_out = 0;
		  							end
		  						end
		  	20'b00000000000001000000: begin					//XORI
		  							alu_out = rs_f1 ^ rt_f1;
		  						end
		  	20'b00000000000000100000: begin						//LW
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b00000000000000001111: begin						//SB
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b00000000000000010000: begin						//SW
		  							alu_out = rs_f1 + rt_f1;
		  						end
		  	20'b00000000000000001000: begin						//BEQ
		  							alu_out = rs_f1 + {14'b0,(rt_f1<<2)};
		  						end
		  	20'b00000000000000000100: begin						//BGTZ
		  							alu_out = rs_f1 + {14'b0,(rt_f1<<2)};
		  						end
		  	20'b00000000000000000010: begin						//BNE
		  							alu_out = rs_f1 + {14'b0,(rt_f1<<2)};
		  						end
		  	20'b00000000000000000001: begin						//J
		  							alu_out = {rs_f1[31:28],(rt_f1<<2)};
		  						end
		  	20'b00000000000000000011: begin						//LUI
		  							alu_out = (rt_f1<<16);
		  						end
		  	20'b00000000000000000111: begin						//SLL
		  							alu_out = rt_f1 << rs_f1;
		  						end
		  	//20'b00000000000000011111: begin						//MULT
		  	//						//ab_valid = 1;
		  	//						alu_out = mult_out;
		  	//					end
		  	//20'b00000000000000111111: begin						//DIV
		  	//						alu_out[31:0] = div_quo_out;
		  	//						alu_out[63:32] = div_rem_out;
		  	//					end
		  	default: begin
		  		alu_out = {{VALUE_SIZE}{1'bx}};
		  	end
		  endcase

		  CDB[31:0] = alu_out;
		  CDB[38:32] = robid_exc_f1;

		end
	
	end

endmodule: alu

