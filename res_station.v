module res_station
	#(parameter NUM_ROWS = 4,		//Number of rows in reservation station
	  parameter VALID_SIZE = 1,		//Number of bits for VALID, TAG, VALUE
	  parameter ROBID_BITS = 7,		//This is the size of the tags, each contains an ID to the ROB
	  parameter VALUE_SIZE = 32,
	  parameter ROWS_BITS = 2,
	  parameter OPCODE_SIZE = 20
	)
	(
	  input logic [ROBID_BITS-1:0] robidDest,
	  input logic [ROBID_BITS-1:0] tag1,
	  input logic [ROBID_BITS-1:0] tag2,
	  input logic [VALUE_SIZE-1:0] val1,
	  input logic [VALUE_SIZE-1:0] val2,
	  input logic valid1,
	  input logic valid2,
	  input logic clk,
	  input logic rst,
	  input logic robfull,							//This will denote if the ROB is full. At that point, we cannot put anything 
													//else on the output to the ALU
	  input logic [ROBID_BITS+VALUE_SIZE-1:0] CDB,		//This is the common data bus, the data that is sent by the ex unit
	  input logic exc_finish,							//This denotes when the ALU has finished execution.
	  input logic rs_pick,									//This will be high if the current RS is chosen
	  input logic exc_busy,									//Checks if the execution unit is busy
	  input logic [OPCODE_SIZE-1:0] in_opcode,				//Opcode being sent from instruction unit
	  output logic full,				
	  output logic rdy_exc,									//This will signify there is an instruction ready to execute
	  output logic [ROBID_BITS-1:0] exc_robid,				//This is the execution ID for the instruction ready to execute
	  output logic [VALUE_SIZE-1:0] out_val1,				//This is the output going to the execution unit
	  output logic [VALUE_SIZE-1:0] out_val2,				//This is the output going to the execuition unit
	  output logic [OPCODE_SIZE-1:0] out_opcode					//This is the opcode being sent to the execution unit
	);

	//Actual memory entry
	logic [1+1+1+OPCODE_SIZE+ROBID_BITS+ROBID_BITS+VALUE_SIZE+VALUE_SIZE+ROBID_BITS-1:0] res_entry [NUM_ROWS-1:0];

	//[86:0]
	logic [ROWS_BITS-1:0] idx_curr, idx_curr_p1, idx_curr_p2, idx_curr_p3;

	logic [ROWS_BITS-1:0] idx_EXC; //This signifies the index that is being sent to the execution unit

	logic [1:0] row0_rdy, row1_rdy, row2_rdy, row3_rdy;

	//Set the value of full to 0
	always_ff @(negedge clk) begin
		if (~rst) begin
			full <= 0;
			idx_curr <= 0;
		end
		else begin
			if (exc_finish) begin
				//Here, you have picked the execution unit to write into for a read operation 
				//And the CDB has the entry on it
				if (rs_pick == 1) begin
					res_entry[idx_curr][6:0] <= robidDest;
					if (CDB[38:32] == tag1) begin
						res_entry[idx_curr][86] <= 1;
						res_entry[idx_curr][85:79] <= CDB[38:32];
						res_entry[idx_curr][78:47] <= CDB[31:0];
					end
					else begin
						if (res_entry[idx_curr_p1][85:79] == CDB[38:32]) begin
							res_entry[idx_curr_p1][86] <= 1'b1;
							res_entry[idx_curr_p1][78:47] <= CDB[31:0];
						end
						if (res_entry[idx_curr_p2][85:79] == CDB[38:32]) begin
							res_entry[idx_curr_p2][86] <= 1'b1;
							res_entry[idx_curr_p2][78:47] <= CDB[31:0];
						end
						if (res_entry[idx_curr_p3][85:79] == CDB[38:32]) begin
							res_entry[idx_curr_p3][86] <= 1'b1;
							res_entry[idx_curr_p3][78:47] <= CDB[31:0];
						end
					end

					if (CDB[38:32] == tag2) begin
						res_entry[idx_curr][46] <= 1;
						res_entry[idx_curr][45:39] <= CDB[38:32];
						res_entry[idx_curr][38:7] <= CDB[31:0];
					end
					else begin
						if (res_entry[idx_curr_p1][45:39] == CDB[38:32]) begin
							res_entry[idx_curr_p1][46] <= 1'b1;
							res_entry[idx_curr_p1][38:7] <= CDB[31:0];
						end
						if (res_entry[idx_curr_p2][45:39] == CDB[38:32]) begin
							res_entry[idx_curr_p2][46] <= 1'b1;
							res_entry[idx_curr_p2][38:7] <= CDB[31:0];
						end
						if (res_entry[idx_curr_p3][45:39] == CDB[38:32]) begin
							res_entry[idx_curr_p3][46] <= 1'b1;
							res_entry[idx_curr_p3][38:7] <= CDB[31:0];
						end
					end

					//If the tag in the CDB is the same as one of the input tags, you have replaced 
					//the new input. Thus, you need to find a new input row
					if (CDB[38:32] == tag2 || CDB[38:32] == tag1) begin
						if ((res_entry[idx_curr_p1][86] == 1'b1 && res_entry[idx_curr_p1][46] == 1'b1 && res_entry[idx_curr_p1][87] == 1'b1) || 
							(res_entry[idx_curr_p1][86] === 1'bx && res_entry[idx_curr_p1][46] === 1'bx && res_entry[idx_curr_p1][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p1;
							full <= 0;
						end
						else if ((res_entry[idx_curr_p2][86] == 1'b1 && res_entry[idx_curr_p2][46] == 1'b1 && res_entry[idx_curr_p2][87] == 1'b1) ||
								 (res_entry[idx_curr_p2][86] === 1'bx && res_entry[idx_curr_p2][46] === 1'bx && res_entry[idx_curr_p2][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p2;
							full <= 0;
						end
						else if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) ||
								 (res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p3;
							full <= 0;
						end
						else begin
							full <= 1;
						end
					end
					
					//Store the opcode for the input
					res_entry[idx_curr][107:88] <= in_opcode;
				
				end
				else begin
					//Here, you have not picked to write to the RS
					//Check if the CBD's tag is in the first source
					if (robfull == 0) begin
						if (res_entry[0][85:79] == CDB[38:32]) begin
							//Make the tag for the first source valid
							res_entry[0][86] <= 1'b1;
							res_entry[0][78:47] <= CDB[31:0];
						end
						if (res_entry[1][85:79] == CDB[38:32]) begin
							res_entry[1][86] <= 1'b1;
							res_entry[1][78:47] <= CDB[31:0];
						end
						if (res_entry[2][85:79] == CDB[38:32]) begin
							res_entry[2][86] <= 1'b1;
							res_entry[2][78:47] <= CDB[31:0];
						end
						if (res_entry[3][85:79] == CDB[38:32]) begin
							res_entry[3][86] <= 1'b1;
							res_entry[3][78:47] <= CDB[31:0];
						end

						//Check if the CBD's tag is in the second source
						if (res_entry[0][45:39] == CDB[38:32]) begin
							//Make the tag for the first source valid
							res_entry[0][46] <= 1'b1;
							res_entry[0][38:7] <= CDB[31:0];
						end
						if (res_entry[1][45:39] == CDB[38:32]) begin
							res_entry[1][46] <= 1'b1;
							res_entry[1][38:7] <= CDB[31:0];
						end
						if (res_entry[2][45:39] == CDB[38:32]) begin
							res_entry[2][46] <= 1'b1;
							res_entry[2][38:7] <= CDB[31:0];
						end
						if (res_entry[3][45:39] == CDB[38:32]) begin
							res_entry[3][46] <= 1'b1;
							res_entry[3][38:7] <= CDB[31:0];
						end
					end
				end

				//Now, you have to check if the CDB's output corresponds to one of the destinations. If it 
				//does, then the instruction has completed and will write to the ROB
				if (robfull == 0) begin
					if (CDB[38:32] == res_entry[0][6:0]) begin
						res_entry[0][87] <= 1;
						if (full == 1) begin
							full <= 0;
							idx_curr <= 0;
						end
					end
					if (CDB[38:32] == res_entry[1][6:0]) begin
						res_entry[1][87] <= 1;
						if (full == 1) begin
							full <= 0;
							idx_curr <= 1;
						end
					end
					if (CDB[38:32] == res_entry[2][6:0]) begin
						res_entry[2][87] <= 1;
						if (full == 1) begin
							full <= 0;
							idx_curr <= 1;
						end
					end
					if (CDB[38:32] == res_entry[3][6:0]) begin
						res_entry[3][87] <= 1;
						if (full == 1) begin
							full <= 0;
							idx_curr <= 1;
						end
					end
				end

			end
			else begin
				//Here, the CDB is not done, so we can just write to the reservation station 
				if (rs_pick == 1) begin
					if ((res_entry[idx_curr][86] == 1'b1 && res_entry[idx_curr][46] == 1'b1 && res_entry[idx_curr][87] == 1'b1) || 
						(res_entry[idx_curr][86] === 1'bx && res_entry[idx_curr][46] === 1'bx && res_entry[idx_curr][87] === 1'bx) ) begin

						res_entry[idx_curr][107:88] <= in_opcode;
						res_entry[idx_curr][87] <= 0;
						res_entry[idx_curr][86] <= valid1;
						res_entry[idx_curr][85:79] <= tag1;
						res_entry[idx_curr][78:47] <= val1;
						res_entry[idx_curr][46] <= valid2;
						res_entry[idx_curr][45:39] <= tag2;
						res_entry[idx_curr][38:7] <= val2;
						res_entry[idx_curr][6:0] <= robidDest;

						if ((res_entry[idx_curr_p1][86] == 1'b1 && res_entry[idx_curr_p1][46] == 1'b1 && res_entry[idx_curr_p1][87] == 1'b1) || 
							(res_entry[idx_curr_p1][86] === 1'bx && res_entry[idx_curr_p1][46] === 1'bx && res_entry[idx_curr_p1][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p1;
							full <= 0;
						end
						else if ((res_entry[idx_curr_p2][86] == 1'b1 && res_entry[idx_curr_p2][46] == 1'b1 && res_entry[idx_curr_p2][87] == 1'b1) ||
								 (res_entry[idx_curr_p2][86] === 1'bx && res_entry[idx_curr_p2][46] === 1'bx && res_entry[idx_curr_p2][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p2;
							full <= 0;
						end
						else if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) ||
								 (res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p3;
							full <= 0;
						end
						else begin
							full <= 1;
						end
					end
					else if ((res_entry[idx_curr_p1][86] == 1'b1 && res_entry[idx_curr_p1][46] == 1'b1 && res_entry[idx_curr_p1][87] == 1'b1) || 
						(res_entry[idx_curr_p1][86] === 1'bx && res_entry[idx_curr_p1][46] === 1'bx && res_entry[idx_curr_p1][87] === 1'bx) ) begin

						res_entry[idx_curr_p1][107:88] <= in_opcode;
						res_entry[idx_curr_p1][87] <= 0;
						res_entry[idx_curr_p1][86] <= valid1;
						res_entry[idx_curr_p1][85:79] <= tag1;
						res_entry[idx_curr_p1][78:47] <= val1;
						res_entry[idx_curr_p1][46] <= valid2;
						res_entry[idx_curr_p1][45:39] <= tag2;
						res_entry[idx_curr_p1][38:7] <= val2;
						res_entry[idx_curr_p1][6:0] <= robidDest;

						if ((res_entry[idx_curr_p2][86] == 1'b1 && res_entry[idx_curr_p2][46] == 1'b1 && res_entry[idx_curr_p2][87] == 1'b1) ||
								 (res_entry[idx_curr_p2][86] === 1'bx && res_entry[idx_curr_p2][46] === 1'bx && res_entry[idx_curr_p2][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p2;
							full <= 0;
						end
						else if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) ||
								 (res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p3;
							full <= 0;
						end
						else begin
							full <= 1;
						end
					end
					else if ((res_entry[idx_curr_p2][86] == 1'b1 && res_entry[idx_curr_p2][46] == 1'b1 && res_entry[idx_curr_p2][87] == 1'b1) || 
						(res_entry[idx_curr_p2][86] === 1'bx && res_entry[idx_curr_p2][46] === 1'bx && res_entry[idx_curr_p2][87] === 1'bx) ) begin

						res_entry[idx_curr_p2][107:88] <= in_opcode;
						res_entry[idx_curr_p2][87] <= 0;
						res_entry[idx_curr_p2][86] <= valid1;
						res_entry[idx_curr_p2][85:79] <= tag1;
						res_entry[idx_curr_p2][78:47] <= val1;
						res_entry[idx_curr_p2][46] <= valid2;
						res_entry[idx_curr_p2][45:39] <= tag2;
						res_entry[idx_curr_p2][38:7] <= val2;
						res_entry[idx_curr_p2][6:0] <= robidDest;

						if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) ||
								 (res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin
							idx_curr <= idx_curr_p3;
							full <= 0;
						end
						else begin
							full <= 1;
						end
					end
					else if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) || 
						(res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin

						res_entry[idx_curr_p3][107:88] <= in_opcode;
						res_entry[idx_curr_p3][87] <= 0;
						res_entry[idx_curr_p3][86] <= valid1;
						res_entry[idx_curr_p3][85:79] <= tag1;
						res_entry[idx_curr_p3][78:47] <= val1;
						res_entry[idx_curr_p3][46] <= valid2;
						res_entry[idx_curr_p3][45:39] <= tag2;
						res_entry[idx_curr_p3][38:7] <= val2;
						res_entry[idx_curr_p3][6:0] <= robidDest;

						full <= 1;
					end
					else begin
						full <= 1;
					end
				end
				else begin
					//Here, hou have not picked to write to the reservation station, but you need to check if there are any finished
					//entries. If there are, you can set full to 0 again.
					if ((res_entry[idx_curr][86] == 1'b1 && res_entry[idx_curr][46] == 1'b1 && res_entry[idx_curr][87] == 1'b1) || 
						(res_entry[idx_curr][86] === 1'bx && res_entry[idx_curr][46] === 1'bx && res_entry[idx_curr][87] === 1'bx) ) begin
						full <= 0;
					end
					else if ((res_entry[idx_curr_p1][86] == 1'b1 && res_entry[idx_curr_p1][46] == 1'b1 && res_entry[idx_curr_p1][87] == 1'b1) || 
						(res_entry[idx_curr_p1][86] === 1'bx && res_entry[idx_curr_p1][46] === 1'bx && res_entry[idx_curr_p1][87] === 1'bx) ) begin
						idx_curr <= idx_curr_p1;
						full <= 0;
					end
					else if ((res_entry[idx_curr_p2][86] == 1'b1 && res_entry[idx_curr_p2][46] == 1'b1 && res_entry[idx_curr_p2][87] == 1'b1) ||
							 (res_entry[idx_curr_p2][86] === 1'bx && res_entry[idx_curr_p2][46] === 1'bx && res_entry[idx_curr_p2][87] === 1'bx) ) begin
						idx_curr <= idx_curr_p2;
						full <= 0;
					end
					else if ((res_entry[idx_curr_p3][86] == 1'b1 && res_entry[idx_curr_p3][46] == 1'b1 && res_entry[idx_curr_p3][87] == 1'b1) ||
							 (res_entry[idx_curr_p3][86] === 1'bx && res_entry[idx_curr_p3][46] === 1'bx && res_entry[idx_curr_p3][87] === 1'bx) ) begin
						idx_curr <= idx_curr_p3;
						full <= 0;
					end
					else begin
						full <= 1;
					end
				end
			end
		end
	end

	always_comb begin
		row0_rdy = {res_entry[0][86],res_entry[0][46]};
		row1_rdy = {res_entry[1][86],res_entry[1][46]};
		row2_rdy = {res_entry[2][86],res_entry[2][46]};
		row3_rdy = {res_entry[3][86],res_entry[3][46]};
		idx_curr_p1 = idx_curr + 1;
		idx_curr_p2 = idx_curr + 2;
		idx_curr_p3 = idx_curr + 3;
	end

	//Need logic to point out an instruction that is ready to transmit to the ALU
	always_ff @(negedge clk) begin
		//Need to check every clock cycle the value of the indices
		if (~rst) begin
			rdy_exc <= 0;
		end
		else begin 
			if (robfull!= 1) begin
				if (row0_rdy === 2'b11 && res_entry[0][87] == 0 && CDB[38:32] !== res_entry[0][6:0]) begin
					rdy_exc <= 1;
					exc_robid <= res_entry[0][6:0];
					out_val1 <= res_entry[0][78:47];
					out_val2 <= res_entry[0][38:7];
					out_opcode <= res_entry[0][107:88];
					idx_EXC <= 0;
				end
				else if (row1_rdy === 2'b11 && res_entry[1][87] == 0 && CDB[38:32] !== res_entry[1][6:0]) begin
					rdy_exc <= 1;
					exc_robid <= res_entry[1][6:0];
					out_val1 <= res_entry[1][78:47];
					out_val2 <= res_entry[1][38:7];
					out_opcode <= res_entry[1][107:88];
					idx_EXC <= 1;
				end
				else if (row2_rdy === 2'b11 && res_entry[2][87] == 0 && CDB[38:32] !== res_entry[2][6:0]) begin
					rdy_exc <= 1;
					exc_robid <= res_entry[2][6:0];
					out_val1 <= res_entry[2][78:47];
					out_val2 <= res_entry[2][38:7];
					out_opcode <= res_entry[2][107:88];
					idx_EXC <= 2;
				end
				else if (row3_rdy === 2'b11 && res_entry[3][87] == 0 && CDB[38:32] !== res_entry[3][6:0]) begin
					rdy_exc <= 1;
					exc_robid <= res_entry[3][6:0];
					out_val1 <= res_entry[3][78:47];
					out_val2 <= res_entry[3][38:7];
					out_opcode <= res_entry[3][107:88];
					idx_EXC <= 3;
				end
				else begin
					rdy_exc <= 0;
				end
			end
			else begin
				//Here, the RS has denoted an output already, and needs to wait until the 
				//EXEC is finished. Once it is, this can be reset to 0
				rdy_exc <= 0;
			end
		end
	end

endmodule: res_station
