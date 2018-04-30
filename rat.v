module rat
	#(parameter NUM_ROWS = 32,		//This is total number of rows in register file
	  parameter VALUE_BITS = 32,	//This is number of bits for storage
	  parameter ROBID_BITS = 7,		//This is number of bits to index ROB (2^7 = 128 rows)
	  parameter REGID_BITS = 5
	)
	(
	  input logic [REGID_BITS-1:0] r1addr,
	  input logic [REGID_BITS-1:0] r2addr,
	  input logic [REGID_BITS-1:0] waddr,
	  input logic [REGID_BITS-1:0] waddr_RAT,
	  input logic [VALUE_BITS-1:0] wdata_RAT,
	  input logic clk,
	  input logic robfull,
	  input logic rst,
	  input logic write_ROBid,
	  input logic [ROBID_BITS-1:0] currID,
	  output logic [ROBID_BITS-1:0] robIDr1,
	  output logic [ROBID_BITS-1:0] robIDr2,
	  output logic [VALUE_BITS-1:0] src0,
	  output logic [VALUE_BITS-1:0] src1,
	  output logic v1,
	  output logic v2
	);

	//Memory entries
	logic [1+VALUE_BITS+ROBID_BITS-1:0]RAT_entry[NUM_ROWS-1:0];

	//Write to RAT for when rob is full
	always @ (posedge clk) begin
		if (robfull == 1) begin
			RAT_entry[waddr_RAT] <= wdata_RAT;
		end
	end

	//Initialize the entries at the beginning
	always @ (negedge clk) begin
		if (~rst) begin
			RAT_entry[0] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[1] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[2] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[3] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[4] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[5] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[6] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[7] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[8] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[9] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[10] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[11] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[12] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[13] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[14] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[15] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[16] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[17] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[18] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[19] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[20] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[21] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[22] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[23] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[24] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[25] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[26] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[27] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[28] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[29] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[30] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
			RAT_entry[31] <= {1'b1,{VALUE_BITS{1'b0}},{ROBID_BITS{1'bx}}};
		end
		else begin
			if (write_ROBid) begin
				RAT_entry[waddr][6:0] <= currID;
				RAT_entry[waddr][39] <= 0;
			end
		end
	end

	always_comb begin
	
		robIDr1 = RAT_entry[r1addr][6:0];
		robIDr2 = RAT_entry[r2addr][6:0];
		
		//Check if the ROBid is all x's - this means the register is untouched
		if (RAT_entry[r1addr][6:0] === {ROBID_BITS{1'bx}}) begin
			src0 = {VALUE_BITS{1'b0}};
		end
		else begin
			src0 = {VALUE_BITS{1'bx}};
		end

		if (RAT_entry[r2addr][6:0] === {ROBID_BITS{1'bx}}) begin
			src1 = {VALUE_BITS{1'b0}};
		end
		else begin
			src1 = {VALUE_BITS{1'bx}};
		end

		v1 = RAT_entry[r1addr][39];
		v2 = RAT_entry[r2addr][39];

	end



	//So in the decode stage, you have the entres r1addr, r2addr, and waddr being sent into the 
	//the RAT. THe first thing it has to do is find an empty reservation station and an empty
	//ROB slot for it to fill


endmodule: rat
