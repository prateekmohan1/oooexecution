module rob
	#(parameter ROBID_BITS = 7,
	  parameter NUM_ROWS = 128,
	  parameter REGID_BITS = 5,
	  parameter VALUE_SIZE = 32
	)
	(
	  input logic [REGID_BITS-1:0] waddr,
	  input logic [ROBID_BITS-1:0] robIDr1,
	  input logic [ROBID_BITS-1:0] robIDr2,
	  input logic [ROBID_BITS+VALUE_SIZE-1:0] CDB,		//This is the common data bus, the data that is sent by the EX unit
	  input logic clk,
	  input logic rst,
	  input logic w_ROB,
	  input logic rs_valid,								//This means the execution station for the reservation station has finished
	  output logic full,
	  output logic [ROBID_BITS-1:0] curr_id,
	  output logic [VALUE_SIZE-1:0] src0,
	  output logic [VALUE_SIZE-1:0] src1,
	  output logic [REGID_BITS-1:0] waddr_RAT,
	  output logic [VALUE_SIZE-1:0] wdata_RAT
	);

	//Actual memory entry
	logic [REGID_BITS+VALUE_SIZE+1+1-1:0] rob_entry [NUM_ROWS-1:0];

	logic [ROBID_BITS-1:0] idx_curr;
	logic [ROBID_BITS-1:0] idx_wr_RAT;

	assign curr_id = idx_curr;

	always @ (negedge clk) begin
		if (~rst) begin
			full <= 0;
			idx_curr <=0;
			idx_wr_RAT <= 0;
		end
		else begin
			if (w_ROB && !full) begin
				rob_entry[idx_curr][38:34] <= waddr;
				rob_entry[idx_curr][1] <= 0;
				rob_entry[idx_curr][0] <= 1;
				idx_curr <= idx_curr + 1;
				if (idx_curr == 127) begin
					full <= 1;
					waddr_RAT <= rob_entry[idx_wr_RAT][38:34];
					wdata_RAT <= rob_entry[idx_wr_RAT][33:2];
				end
			end
			if (rs_valid && !full) begin
				rob_entry[CDB[38:32]][33:2] <= CDB[31:0];
				rob_entry[CDB[38:32]][1] <= 1;
			end
			if (full) begin
				idx_wr_RAT <= idx_wr_RAT + 1;
				if (rob_entry[idx_wr_RAT][1] == 1) begin
					if (rs_valid == 1) begin
						//If the ALU or something finishes execution during this procedure
						//check if the robid for the finished instruction is after the 
						//one you are currently writing - if it is, you can just overwrite it
						if (CDB[38:32] > idx_wr_RAT) begin
							rob_entry[CDB[38:32]][33:2] <= CDB[31:0];
							rob_entry[CDB[38:32]][1] <= 1;
						end
					end
					waddr_RAT <= rob_entry[idx_wr_RAT][38:34];
					wdata_RAT <= rob_entry[idx_wr_RAT][33:2];
				end
				if (idx_wr_RAT == 127) begin
					idx_wr_RAT <= 0;
					full <= 0;
				end
			end
		end
	end


	always_comb begin
		src0 = rob_entry[robIDr1][33:2];
		src1 = rob_entry[robIDr2][33:2];
	end

	


endmodule: rob
