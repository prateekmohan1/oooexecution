// mipsCore.vp
//; my $wl = parameter( name=>"wordLength", val=>32, doc=>"Width of input");

//; my $iW = parameter( name=>"issueWidth", val=>1, doc=>"Num of fetched instructions");

//; my $rP = parameter( name=>"rfReadPorts", val=>2, doc=>"Number of RF Read Ports");
//; my $wP = parameter( name=>"rfWritePorts", val=>1, doc=>"Number of RF Write Ports");
//; my $rC = parameter( name=>"rfEntryCount", val=>32, max=>128, doc=>"Number of RF Addresses");
//; my $rA = parameter( name=>"rfAddressWidth", val=>5, max=>7, doc=>"Bits for RF Address");

//; my $btb = parameter( name=>"enableBTB", val=>0, list=>[0,1], doc=>"Enable BTB");
//; my $btbW = parameter( name=>"entrySizeBTB", val=>34, max=>36, doc=>"BTB Entry Size");
//; my $btbC = parameter( name=>"entryCountBTB", val=>0, max=>256, doc=>"BTB entries");

//; my $mD = parameter( name=>"MipsMode", val => "Cyc1", list=>["Cyc1","Cyc5","Smp15","Fwd5","Dual"], doc=>"Iterative design state, testbench will ignore");

//; my $op = parameter( name=>"operations", val=>20, doc=>"Amoumt of ops decoded to ALU");
//; my $i1 = generate_base( 'alu_newcommands', 'my_alu_newcommands');

//; my $temp = 0;

// First level FFs
//; my $instr_f1 = generate('dffbW', 'dff_instr_f1', bitWidth=>32);
//; my $alu_op_f1 = generate('dffbW', 'dff_alu_op_f1', bitWidth=>20);
//; my $instr25_21Dec_f1 = generate('dffbW', 'dff_instr25_21Dec_f1', bitWidth=>5);
//; my $instr20_16Dec_f1 = generate('dffbW', 'dff_instr20_16Dec_f1', bitWidth=>5);
//; my $instr15_11Dec_f1 = generate('dffbW', 'dff_instr15_11Dec_f1', bitWidth=>5);
//; my $sF_f1 = generate('dffbW', 'dff_sF_f1', bitWidth=>1);
//; my $signext_f1 = generate('dffbW', 'dff_signext_f1', bitWidth=>32);
//; my $sC_f1 = generate('dffbW', 'dff_sC_f1', bitWidth=>1);
//; my $sH_f1 = generate('dffbW', 'dff_sH_f1', bitWidth=>1);
//; my $sD_f1 = generate('dffbW', 'dff_sD_f1', bitWidth=>1);
//; my $sE_f1 = generate('dffbW', 'dff_sE_f1', bitWidth=>1);
//; my $sA_f1 = generate('dffbW', 'dff_sA_f1', bitWidth=>1);
//; my $sB_f1 = generate('dffbW', 'dff_sB_f1', bitWidth=>1);
//; my $sG_f1 = generate('dffbW', 'dff_sG_f1', bitWidth=>1);
//; my $sraVal_f1 = generate('dffbW', 'dff_sraVal_f1', bitWidth=>5);
//; my $PC_f1 = generate('dffbW', 'dff_PC_f1', bitWidth=>32);

// Second Level FFs
//; my $alu_op_f2 = generate('dffbW', 'dff_alu_op_f2', bitWidth=>20);
//; my $instr20_16Dec_f2 = generate('dffbW', 'dff_instr20_16Dec_f2', bitWidth=>5);
//; my $instr15_11Dec_f2 = generate('dffbW', 'dff_instr15_11Dec_f2', bitWidth=>5);
//; my $sF_f2 = generate('dffbW', 'dff_sF_f2', bitWidth=>1);
//; my $signext_f2 = generate('dffbW', 'dff_signext_f2', bitWidth=>32);
//; my $sH_f2 = generate('dffbW', 'dff_sH_f2', bitWidth=>1);
//; my $sD_f2 = generate('dffbW', 'dff_sD_f2', bitWidth=>1);
//; my $sE_f2 = generate('dffbW', 'dff_sE_f2', bitWidth=>1);
//; my $sA_f2 = generate('dffbW', 'dff_sA_f2', bitWidth=>1);
//; my $sB_f2 = generate('dffbW', 'dff_sB_f2', bitWidth=>1);
//; my $sG_f2 = generate('dffbW', 'dff_sG_f2', bitWidth=>1);
//; my $sraVal_f2 = generate('dffbW', 'dff_sraVal_f2', bitWidth=>5);
//; my $src0_f1 = generate('dffbW', 'dff_src0_f1', bitWidth=>32);
//; my $src1_f1 = generate('dffbW', 'dff_src1_f1', bitWidth=>32);

//Third Level FFs
//; my $instr20_16Dec_f3 = generate('dffbW', 'dff_instr20_16Dec_f3', bitWidth=>5);
//; my $instr15_11Dec_f3 = generate('dffbW', 'dff_instr15_11Dec_f3', bitWidth=>5);
//; my $sF_f3 = generate('dffbW', 'dff_sF_f3', bitWidth=>1);
//; my $sH_f3 = generate('dffbW', 'dff_sH_f3', bitWidth=>1);
//; my $sD_f3 = generate('dffbW', 'dff_sD_f3', bitWidth=>1);
//; my $sE_f3 = generate('dffbW', 'dff_sE_f3', bitWidth=>1);
//; my $sG_f3 = generate('dffbW', 'dff_sG_f3', bitWidth=>1);
//; my $sB_f3 = generate('dffbW', 'dff_sB_f3', bitWidth=>1);
//; my $alu_o_f1 = generate('dffbW', 'dff_alu_o_f1', bitWidth=>32);
//; my $src1_f2 = generate('dffbW', 'dff_src1_f2', bitWidth=>32);

//Fourth Level FFs
//; my $instr20_16Dec_f4 = generate('dffbW', 'dff_instr20_16Dec_f4', bitWidth=>5);
//; my $instr15_11Dec_f4 = generate('dffbW', 'dff_instr15_11Dec_f4', bitWidth=>5);
//; my $sF_f4 = generate('dffbW', 'dff_sF_f4', bitWidth=>1);
//; my $sH_f4 = generate('dffbW', 'dff_sH_f4', bitWidth=>1);
//; my $sG_f4 = generate('dffbW', 'dff_sG_f4', bitWidth=>1);
//; my $alu_o_f2 = generate('dffbW', 'dff_alu_o_f2', bitWidth=>32);
//; my $dCacheReadData_f1 = generate('dffbW', 'dff_dCacheReadData_f1', bitWidth=>32);

module `mname`(

	//ICache IFC
	input logic [`$iW*$wl-1`:0] iCacheReadData,
	output logic [`$wl-1`:0] iCacheReadAddr,
	
	//DCache Ifc
	input logic [`$wl-1`:0] dCacheReadData,
	output logic [`$wl-1`:0] dCacheWriteData,
	output logic [`$wl-1`:0] dCacheAddr,
	output logic dCacheWriteEn,
	output logic dCacheReadEn,
	
	//Register File Ifc
	//; for (my $i = 0; $i < $rP; $i++) {
	input logic [`$wl-1`:0] rfReadData_p`$i`,
	output logic [`$rA-1`:0] rfReadAddr_p`$i`,
	output logic rfReadEn_p`$i`,
	//; }
	//; for (my $i = 0; $i < $wP; $i++) {
	output logic [`$wl-1`:0] rfWriteData_p`$i`,
	output logic [`$rA-1`:0] rfWriteAddr_p`$i`,
	output logic rfWriteEn_p`$i`,
	//; }
	
	//BTB Ifc
	//; if ($btb) {
	input logic [`$btbW-1`:0] btbReadData,
	output logic [`$btbW-1`:0] btbWriteData,
	output logic [`$wl-1`:0] btbWriteAddr,
	output logic [`$wl-1`:0] btbReadAddr,
	output logic btbWriteEn,
	output logic btbReadEn,
	//; }
	
	//Globals
	input logic clk,
	input logic rst
	
	);

	//PC Counter
	logic [`$wl-1`:0] PC;
	logic [`$wl-1`:0] PC_Next;
	
	//Decode input instr.
	logic [5:0]opcode;
	logic [5:0]special;
	logic [`$op-1`:0]alu_op;
	logic sA, sB, sC, sD, sE, sF, sG, sH, sK;
	logic [2:0] sI;
	logic [2:0] sI_Flag;
	logic [`$wl-1`:0]rs;
	logic [`$wl-1`:0]rt;
	logic [`$wl-1`:0]alu_o;
	logic [`$wl-1`:0]signext;
	logic [`$wl-1`:0]instr;
	logic [`$wl-1`:0] original_instr;

	logic [`$rA-1`:0] instr25_21Dec;
	logic [`$rA-1`:0] instr20_16Dec;
	logic [`$rA-1`:0] instr15_11Dec;

	logic [`$wl-1`:0] src0;
	logic [`$wl-1`:0] src1;

	logic [4:0] sraVal;
	logic data_hazFlag;
	logic jump_Flag;
	logic one_cycle, two_cycle,back_to_back;

	logic [1:0] sCnt;
	

	//Flops
	logic [`$wl-1`:0] instr_f1;
	logic [`$op-1`:0] alu_op_f1;
	logic [`$rA-1`:0] instr25_21Dec_f1;
	logic [`$rA-1`:0] instr20_16Dec_f1;
	logic [`$rA-1`:0] instr15_11Dec_f1;
	logic sF_f1;
	logic [`$wl-1`:0] signext_f1;
	logic sC_f1;
	logic sH_f1;
	logic sD_f1;
	logic sE_f1;
	logic [4:0] sraVal_f1;
	logic sA_f1;
	logic sB_f1;
	logic sG_f1;
	logic [`$wl-1`:0] PC_f1;

	logic [`$op-1`:0] alu_op_f1_d;
	logic [`$rA-1`:0] instr25_21Dec_f1_d;
	logic [`$rA-1`:0] instr20_16Dec_f1_d;
	logic [`$rA-1`:0] instr15_11Dec_f1_d;
	logic sF_f1_d;
	logic [`$wl-1`:0] signext_f1_d;
	logic sC_f1_d;
	logic sH_f1_d;
	logic sD_f1_d;
	logic sE_f1_d;
	logic [4:0] sraVal_f1_d;
	logic sA_f1_d;
	logic sB_f1_d;
	logic sG_f1_d;
	
	logic [`$op-1`:0] alu_op_f2;
	logic [`$rA-1`:0] instr20_16Dec_f2;
	logic [`$rA-1`:0] instr15_11Dec_f2;
	logic sF_f2;
	logic [`$wl-1`:0] signext_f2;
	logic [`$wl-1`:0] src0_f1;
	logic [`$wl-1`:0] src1_f1;
	logic sH_f2;
	logic sD_f2;
	logic sE_f2;
	logic [4:0] sraVal_f2;
	logic sA_f2;
	logic sB_f2;
	logic sG_f2;
	
	logic [`$wl-1`:0] alu_o_f1;
	logic [`$rA-1`:0] instr20_16Dec_f3;
	logic [`$rA-1`:0] instr15_11Dec_f3;
	logic sF_f3;
	logic [`$wl-1`:0] src1_f2;
	logic sH_f3;
	logic sD_f3;
	logic sE_f3;
	logic sG_f3;
	logic sB_f3;

	logic [`$wl-1`:0] alu_o_f2;
	logic [`$wl-1`:0] dCacheReadData_f1;
	logic [`$rA-1`:0] instr20_16Dec_f4;
	logic [`$rA-1`:0] instr15_11Dec_f4;
	logic sF_f4;
	logic sH_f4;
	logic sG_f4;

	logic [1:0] sJ_in;
	logic sJ;
	logic cnt;
	logic [2:0] cnt_in;

	logic [1:0] bType;

	`$i1 -> instantiate ()`(
	.opcode(alu_op_f2),
	.rs(rs),
	.rt(rt),
	.alu_out(alu_o)
	);

	`$PC_f1 -> instantiate()`(.d(PC),.clk(clk),.rst(rst),.q(PC_f1));	
	`$instr_f1 -> instantiate()`(.d(instr),.clk(clk),.rst(rst),.q(instr_f1));	
	`$alu_op_f1 -> instantiate()`(.d(alu_op_f1_d),.clk(clk),.rst(rst),.q(alu_op_f1));	
	`$instr25_21Dec_f1 -> instantiate()`(.d(instr25_21Dec_f1_d),.clk(clk),.rst(rst),.q(instr25_21Dec_f1));	
	`$instr20_16Dec_f1 -> instantiate()`(.d(instr20_16Dec_f1_d),.clk(clk),.rst(rst),.q(instr20_16Dec_f1));	
	`$instr15_11Dec_f1 -> instantiate()`(.d(instr15_11Dec_f1_d),.clk(clk),.rst(rst),.q(instr15_11Dec_f1));	
	`$sF_f1 -> instantiate()`(.d(sF_f1_d),.clk(clk),.rst(rst),.q(sF_f1));	
	`$signext_f1 -> instantiate()`(.d(signext_f1_d),.clk(clk),.rst(rst),.q(signext_f1));	
	`$sC_f1 -> instantiate()`(.d(sC_f1_d),.clk(clk),.rst(rst),.q(sC_f1));	
	`$sH_f1 -> instantiate()`(.d(sH_f1_d),.clk(clk),.rst(rst),.q(sH_f1));	
	`$sD_f1 -> instantiate()`(.d(sD_f1_d),.clk(clk),.rst(rst),.q(sD_f1));	
	`$sE_f1 -> instantiate()`(.d(sE_f1_d),.clk(clk),.rst(rst),.q(sE_f1));	
	`$sA_f1 -> instantiate()`(.d(sA_f1_d),.clk(clk),.rst(rst),.q(sA_f1));	
	`$sB_f1 -> instantiate()`(.d(sB_f1_d),.clk(clk),.rst(rst),.q(sB_f1));	
	`$sG_f1 -> instantiate()`(.d(sG_f1_d),.clk(clk),.rst(rst),.q(sG_f1));	
	`$sraVal_f1 -> instantiate()`(.d(sraVal_f1_d),.clk(clk),.rst(rst),.q(sraVal_f1));	
	
	`$alu_op_f2 -> instantiate()`(.d(alu_op_f1),.clk(clk),.rst(rst),.q(alu_op_f2));	
	`$instr20_16Dec_f2 -> instantiate()`(.d(instr20_16Dec_f1),.clk(clk),.rst(rst),.q(instr20_16Dec_f2));	
	`$instr15_11Dec_f2 -> instantiate()`(.d(instr15_11Dec_f1),.clk(clk),.rst(rst),.q(instr15_11Dec_f2));	
	`$sF_f2 -> instantiate()`(.d(sF_f1),.clk(clk),.rst(rst),.q(sF_f2));	
	`$signext_f2 -> instantiate()`(.d(signext_f1),.clk(clk),.rst(rst),.q(signext_f2));	
	`$sH_f2 -> instantiate()`(.d(sH_f1),.clk(clk),.rst(rst),.q(sH_f2));	
	`$sD_f2 -> instantiate()`(.d(sD_f1),.clk(clk),.rst(rst),.q(sD_f2));	
	`$sE_f2 -> instantiate()`(.d(sE_f1),.clk(clk),.rst(rst),.q(sE_f2));	
	`$sA_f2 -> instantiate()`(.d(sA_f1),.clk(clk),.rst(rst),.q(sA_f2));	
	`$sB_f2 -> instantiate()`(.d(sB_f1),.clk(clk),.rst(rst),.q(sB_f2));	
	`$sG_f2 -> instantiate()`(.d(sG_f1),.clk(clk),.rst(rst),.q(sG_f2));	
	`$sraVal_f2 -> instantiate()`(.d(sraVal_f1),.clk(clk),.rst(rst),.q(sraVal_f2));	
	`$src0_f1 -> instantiate()`(.d(src0),.clk(clk),.rst(rst),.q(src0_f1));	
	`$src1_f1 -> instantiate()`(.d(src1),.clk(clk),.rst(rst),.q(src1_f1));	

	`$instr20_16Dec_f3 -> instantiate()`(.d(instr20_16Dec_f2),.clk(clk),.rst(rst),.q(instr20_16Dec_f3));	
	`$instr15_11Dec_f3 -> instantiate()`(.d(instr15_11Dec_f2),.clk(clk),.rst(rst),.q(instr15_11Dec_f3));	
	`$sF_f3 -> instantiate()`(.d(sF_f2),.clk(clk),.rst(rst),.q(sF_f3));	
	`$sH_f3 -> instantiate()`(.d(sH_f2),.clk(clk),.rst(rst),.q(sH_f3));	
	`$sD_f3 -> instantiate()`(.d(sD_f2),.clk(clk),.rst(rst),.q(sD_f3));	
	`$sE_f3 -> instantiate()`(.d(sE_f2),.clk(clk),.rst(rst),.q(sE_f3));	
	`$sG_f3 -> instantiate()`(.d(sG_f2),.clk(clk),.rst(rst),.q(sG_f3));	
	`$sB_f3 -> instantiate()`(.d(sB_f2),.clk(clk),.rst(rst),.q(sB_f3));	
	`$alu_o_f1 -> instantiate()`(.d(alu_o),.clk(clk),.rst(rst),.q(alu_o_f1));
	`$src1_f2 -> instantiate()`(.d(src1_f1),.clk(clk),.rst(rst),.q(src1_f2));	

	`$instr20_16Dec_f4 -> instantiate()`(.d(instr20_16Dec_f3),.clk(clk),.rst(rst),.q(instr20_16Dec_f4));	
	`$instr15_11Dec_f4 -> instantiate()`(.d(instr15_11Dec_f3),.clk(clk),.rst(rst),.q(instr15_11Dec_f4));	
	`$sF_f4 -> instantiate()`(.d(sF_f3),.clk(clk),.rst(rst),.q(sF_f4));	
	`$sH_f4 -> instantiate()`(.d(sH_f3),.clk(clk),.rst(rst),.q(sH_f4));	
	`$sG_f4 -> instantiate()`(.d(sG_f3),.clk(clk),.rst(rst),.q(sG_f4));	
	`$alu_o_f2 -> instantiate()`(.d(alu_o_f1),.clk(clk),.rst(rst),.q(alu_o_f2));
	`$dCacheReadData_f1 -> instantiate()`(.d(dCacheReadData),.clk(clk),.rst(rst),.q(dCacheReadData_f1));

	//////////////PC Flops///////////
        //Flip Flop for state
        always_ff @ (posedge clk) begin
                if (~rst) begin
                        PC <= 0;
                end
                else begin
                        PC <= PC_Next;
                end
        end
	//////////////PC Flops///////////

	//////////////cnt Flops///////////
        always_ff @ (posedge clk) begin
                if (~rst) begin
                        cnt <= 0;
                end
                else begin
                        cnt <= 1;
                end
        end
	//////////////cnt Flops///////////

	always_comb begin

		back_to_back = ( 
			(((instr15_11Dec_f1 == instr20_16Dec) || (instr15_11Dec_f1 == instr25_21Dec)) && !sB_f1 && !sB) ||   //NORM->NORM
			((instr15_11Dec_f1 == instr25_21Dec) && !sB_f1 && sB) || 						//IMMEDIATE | NORM | 
			((instr20_16Dec_f1 == instr25_21Dec) && sB_f1 && sB) ||    					// IMMEDIATE | IMMEDIATE/LW | 
			(((instr20_16Dec_f1 == instr20_16Dec) || (instr20_16Dec_f1 == instr25_21Dec)) && sB_f1 && !sB ) ||  // NORM | IMMEDIATE/LW
			(((instr15_11Dec_f1 == instr20_16Dec) || (instr20_16Dec_f1 == instr20_16Dec)) && sE) // SW | NORM/IMMEDIATE or SW | LW
			);
		one_cycle = ( 
			(((instr15_11Dec_f2 == instr20_16Dec) || (instr15_11Dec_f2 == instr25_21Dec)) && !sB_f2 && !sB) ||   //NORM->NORM
			((instr15_11Dec_f2 == instr25_21Dec) && !sB_f2 && sB) || 						//IMMEDIATE | NORM | 
			((instr20_16Dec_f2 == instr25_21Dec) && sB_f2 && sB) ||    					// IMMEDIATE | IMMEDIATE | 
			(((instr20_16Dec_f2 == instr20_16Dec) || (instr20_16Dec_f2 == instr25_21Dec)) && sB_f2 && !sB )  || // NORM | IMMEDIATE
			(((instr15_11Dec_f2 == instr20_16Dec) || (instr20_16Dec_f2 == instr20_16Dec)) && sE) // SW | NORM/IMMEDIATE or SW | LW
			);
		two_cycle = ( 
			(((instr15_11Dec_f3 == instr20_16Dec) || (instr15_11Dec_f3 == instr25_21Dec)) && !sB_f3 && !sB) ||   //NORM->NORM
			((instr15_11Dec_f3 == instr25_21Dec) && !sB_f3 && sB) || 						//IMMEDIATE | NORM | 
			((instr20_16Dec_f3 == instr25_21Dec) && sB_f3 && sB) ||    					// IMMEDIATE | IMMEDIATE | 
			(((instr20_16Dec_f3 == instr20_16Dec) || (instr20_16Dec_f3 == instr25_21Dec)) && sB_f3 && !sB ) ||  // NORM | IMMEDIATE
			(((instr15_11Dec_f3 == instr20_16Dec) || (instr20_16Dec_f3 == instr20_16Dec)) && sE) // SW | NORM/IMMEDIATE or SW | LW
			);

		//Data Hazard Checking
		if ( back_to_back && (sH_f1 == 1)) begin //If back to back data hazard
			sI = 3'b0;
			sJ = 0;	
			data_hazFlag = 1;
		end
		else if ( one_cycle && (sH_f2 == 1)) begin //If One cycle separated data hazard
			sI = 3'b0;
			sJ = 0;	
			data_hazFlag = 1;
		end
		else if ( two_cycle && (sH_f3 == 1)) begin //If Two cycle separated data hazard
			sI = 3'b0;
			sJ = 0;	
			data_hazFlag = 1;
		end
		else begin
			sI = 3'b001;
			sJ = 1;
			data_hazFlag = 0;
		end


		//Jump instruction
		if (alu_op == 20'b00000000000000000001) begin
			jump_Flag = 1;
			sI = 3;
			sJ = 0;
		end
		else begin
			jump_Flag = 0;
		end


		//Branch hazard checking and JR checking
		if (alu_op_f1 == 20'b00000000000000001000 || alu_op_f1 == 20'b00000000000000000100 || alu_op_f1 == 20'b00000000000000000010 || alu_op_f1 == 20'b00000000100000000000) begin
			if (alu_op_f1 == 20'b00000000000000001000) begin // BEQ
				if (src0 == src1) begin
					sI = 3'b010;
					sJ = 0;	
				end
				else begin
					if (data_hazFlag == 1'b0 && jump_Flag == 1'b0) begin
						sI = 3'b001;
						sJ = 1;
					end
				end
			end
			else if (alu_op_f1 == 20'b00000000000000000100) begin // BGTZ
				if (src0 > 0) begin
					sI = 3'b010;
					sJ = 0;	
				end
				else begin
					if (data_hazFlag == 1'b0 && jump_Flag == 1'b0) begin
						sI = 3'b001;
						sJ = 1;
					end
				end
			end
			else if (alu_op_f1 == 20'b00000000000000000010) begin	//BNE
        	                if (src0 != src1) begin
        	                        sI = 3'b010;
        	                        sJ = 0;
        	                end
        	                else begin
        	                        if (data_hazFlag == 1'b0 && jump_Flag == 1'b0) begin
        	                                sI = 3'b001;
        	                                sJ = 1;
        	                        end
        	                end
			end
			else begin				//JR
				sI = 4;
				sJ = 0;	
			end
		end
	end
	

	always_comb begin
		unique case (sJ)
		1'b0: begin
			alu_op_f1_d = 20'b00000000010000000000;			//For an ADDI instruction
			instr25_21Dec_f1_d = `$rA-1`'b0;
			instr20_16Dec_f1_d = `$rA-1`'b0;
			instr15_11Dec_f1_d = `$rA-1`'b0;
			sF_f1_d = 1'b0;
			signext_f1_d = `$wl-1`'b0;
			sC_f1_d = 1'b0;
			sH_f1_d = 1'b0;
			sD_f1_d = 1'b0;
			sE_f1_d = 1'b0;
			sraVal_f1_d = 5'b0;
			sA_f1_d = 1'b0;
			sB_f1_d = 1'b0;
			sG_f1_d = 1'b0;
		end
		1'b1: begin
			alu_op_f1_d = alu_op;
			instr25_21Dec_f1_d = instr25_21Dec;
			instr20_16Dec_f1_d = instr20_16Dec;
			instr15_11Dec_f1_d = instr15_11Dec;
			sF_f1_d = sF;
			signext_f1_d = signext;
			sC_f1_d = sC;
			sH_f1_d = sH;
			sD_f1_d = sD;
			sE_f1_d = sE;
			sraVal_f1_d = sraVal;
			sA_f1_d = sA;
			sB_f1_d = sB;
			sG_f1_d = sG;
		end
		default: begin
			alu_op_f1_d = alu_op;
			instr25_21Dec_f1_d = instr25_21Dec;
			instr20_16Dec_f1_d = instr20_16Dec;
			instr15_11Dec_f1_d = instr15_11Dec;
			sF_f1_d = sF;
			signext_f1_d = signext;
			sC_f1_d = sC;
			sH_f1_d = sH;
			sD_f1_d = sD;
			sE_f1_d = sE;
			sraVal_f1_d = sraVal;
			sA_f1_d = sA;
			sB_f1_d = sB;
			sG_f1_d = sG;
		end
		endcase
	end

	always_comb begin
		if (instr[15] == 1'b1) begin
                        signext = {{16{1'b1}},instr[15:0]};
		end
		else begin
			signext = {16'b0,instr[15:0]};
		end
	end

	always_comb begin
		if (cnt == 0) begin
			instr = 32'hffffffff;
		end
		else begin
			instr = iCacheReadData;
		end
		iCacheReadAddr = PC;
		
		instr25_21Dec = instr[25:21];
		instr20_16Dec = instr[20:16];
		instr15_11Dec = instr[15:11];

		rfReadAddr_p0 = instr25_21Dec_f1;
		rfReadAddr_p1 = instr20_16Dec_f1;
		
		sraVal = instr[10:6];
		src0 = rfReadData_p0;
		src1 = rfReadData_p1;

		dCacheWriteData = src1_f2;
		dCacheAddr = alu_o_f1;

	end

	always_comb begin
		unique case (sA_f2) 
			1'b0: rs = src0_f1;
			1'b1: rs = sraVal_f2;
			default: rs = 0;
		endcase
	end

	always_comb begin
		unique case (sB_f2)
			1'b0: rt = src1_f1;
			1'b1: rt = signext_f2;
			default: rt = 0;
		endcase
	end
	
	always_comb begin
		unique case (sC_f1)
			1'b0: begin
  				//; for (my $i = 0; $i < $rP; $i++) {
				rfReadEn_p`$i` = 0;
				//; }
			end
			1'b1: begin
  				//; for (my $i = 0; $i < $rP; $i++) {
				rfReadEn_p`$i` = 1;
				//; }
			end 
			default: begin
  				//; for (my $i = 0; $i < $rP; $i++) {
				rfReadEn_p`$i` = 0;
				//; }
			end
		endcase
	end

	always_comb begin
		unique case (sD_f3)
			1'b0: dCacheReadEn = 0;
			1'b1: dCacheReadEn = 1;
			default: dCacheReadEn = 0;
		endcase
	end

	always_comb begin
		unique case (sE_f3) 
			1'b0: dCacheWriteEn = 0;
			1'b1: dCacheWriteEn = 1;
			default: dCacheWriteEn = 0;
		endcase
	end

	always_comb begin
		unique case (sF_f4)
			1'b0: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteAddr_p`$i` = instr15_11Dec_f4;
				//; }
			end
			1'b1: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteAddr_p`$i` = instr20_16Dec_f4;
				//; }
			end
			default: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteAddr_p`$i` = 0;
				//; }
			end
		endcase
	end

	always_comb begin
		unique case (sG_f4) 
			1'b0: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteData_p`$i` = dCacheReadData_f1;
				//; }
			end
			1'b1: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteData_p`$i` = alu_o_f2;
				//; }
			end
			default: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteData_p`$i` = 0;
				//; }
			end
		endcase
	end

	always_comb begin
		unique case (sH_f4) 
			1'b0: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteEn_p`$i` = 0;
				//; }
			end
			1'b1: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteEn_p`$i` = 1;
				//; }
			end 
			default: begin
  				//; for (my $i = 0; $i < $wP; $i++) {
				rfWriteEn_p`$i` = 0;
				//; }
			end
		endcase
	end

	always_comb begin
		if (cnt == 0) begin
			PC_Next = PC;
		end
		else begin
			unique case (sI)
				3'b000: begin
					PC_Next = PC;
				end
				3'b001: begin
					PC_Next = PC + 4;
				end
				3'b010: begin
					PC_Next = PC_f1 + {{14{instr_f1[15]}},{instr_f1[15:0]},{2'b0}};
				end
				3'b011: begin
					PC_Next = {{PC[31:28]},{original_instr[25:0]},{2'b0}};
				end
				3'b100: begin
					PC_Next = src0 + PC_f1;
				end
				default: begin
					PC_Next = PC;
				end
			endcase
		end
	end

	always_comb begin
		opcode = instr[31:26];
		special = instr[5:0];
		unique case(opcode)
		6'b000000: begin
			unique case(special)
				6'b100000: begin 
					alu_op = 20'b10000000000000000000; //ADD
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b100100: begin 
					alu_op = 20'b01000000000000000000; //AND
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
                                6'b000000: begin
                                        alu_op = 20'b00000000000000000111; //SLL
                                        sA = 1;
                                        sB = 0;
                                        sC = 1;
                                        sD = 0;
                                        sE = 0;
                                        sF = 0;
                                        sG = 1;
                                        sH = 1;
                                end
				6'b100111: begin 
					alu_op = 20'b00100000000000000000; //NOR
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b100101: begin 
					alu_op = 20'b00010000000000000000; //OR
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b101010: begin 
					alu_op = 20'b00001000000000000000; //SLT
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b100010: begin 
					alu_op = 20'b00000100000000000000; //SUB
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b100110: begin 
					alu_op = 20'b00000010000000000000; //XOR
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b000011: begin 
					alu_op = 20'b00000001000000000000; //SRA
					sA = 1;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 1;
					sH = 1;
				end
				6'b001000: begin
					alu_op = 20'b00000000100000000000; //JR
					sA = 0;
					sB = 0;
					sC = 1;
					sD = 0;
			                sE = 0;
					sF = 0;
					sG = 0;
					sH = 0;
				end
                                6'b100001: begin
                                        alu_op = 20'b10000000000000000000; //ADDU, same as ADD
                                        sA = 0;
                                        sB = 0;
                                        sC = 1;
                                        sD = 0;
                                        sE = 0;
                                        sF = 0;
                                        sG = 1;
                                        sH = 1;
                                end
			endcase
		end
		6'b001000: begin 
			alu_op = 20'b00000000010000000000; //ADDI 
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 1;
			sG = 1;
			sH = 1;
		end
		6'b001100: begin 
			alu_op = 20'b00000000001000000000; //ANDI
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 1;
			sG = 1;
			sH = 1;
		end
                6'b001001: begin
                        alu_op = 20'b00000000010000000000; //ADDIU, same as ADDI
                        sA = 0;
                        sB = 1;
                        sC = 1;
                        sD = 0;
                        sE = 0;
                        sF = 1;
                        sG = 1;
                        sH = 1;
                end
		6'b001101: begin 
			alu_op = 20'b00000000000100000000; //ORI
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 1;
			sG = 1;
			sH = 1;
		end
		6'b001010: begin 
			alu_op = 20'b00000000000010000000; //SLTI
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 1;
			sG = 1;
			sH = 1;
		end
		6'b001110: begin 
			alu_op = 20'b00000000000001000000; //XORI
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 1;
			sG = 1;
			sH = 1;
		end
		6'b100011: begin
			alu_op = 20'b00000000000000100000; //LW
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 1;
			sE = 0;
			sF = 1;
			sG = 0;
			sH = 1;
		end
                6'b001111: begin
                        alu_op = 20'b00000000000000000011;      //LUI
                        sA = 0;
                        sB = 1;
                        sC = 0;
                        sD = 0;
                        sE = 0;
                        sF = 1;
                        sG = 1;
                        sH = 1;
                end
		6'b101011: begin 
			alu_op = 20'b00000000000000010000; //SW
			sA = 0;
			sB = 1;
			sC = 1;
			sD = 0;
			sE = 1;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		6'b000100: begin 
			alu_op = 20'b00000000000000001000; //BEQ
			sA = 0;
			sB = 0;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		6'b000111: begin 
			alu_op = 20'b00000000000000000100; //BGTZ
			sA = 0;
			sB = 0;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		6'b000101: begin 
			alu_op = 20'b00000000000000000010; //BNE
			sA = 0;
			sB = 0;
			sC = 1;
			sD = 0;
			sE = 0;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		6'b000010: begin 
			alu_op = 20'b00000000000000000001; //J
			sA = 0;
			sB = 0;
			sC = 0;
			sD = 0;
			sE = 0;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		default: begin
			sK = 0;
			sA = 0;
			sB = 0;
			sC = 0;
			sD = 0;
			sE = 0;
			sF = 0;
			sG = 0;
			sH = 0;
		end
		endcase
	end


endmodule: `mname`

