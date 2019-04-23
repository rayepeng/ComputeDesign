module pipeidcu (mwreg, mrn, ern, ewreg, em2reg, mm2reg, rsrtequ, func, op, rs, rt, wreg, m2reg, 
	wmem, aluc, regrt, aluimm, fwda, fwdb, nostall, sext, pcsource, shift, jal);


	
	input mwreg, ewreg, em2reg, mm2reg, rsrtequ;
	input [4:0] mrn, ern, rs, rt;
	input [5:0] func, op;

	output     wreg, m2reg, wmem, regrt, aluimm, sext, shift, jal;
	output [3:0] aluc;
	output [1:0] pcsource;
	output [1:0] fwda, fwdb;
	output nostall;

	reg [1:0] fwda, fwdb;

	// wire r_type, i_add, i_sub, i_and, i_or, i_xor, i_sll,i_srl, i_sra, i_jr;
	// wire i_addi, i_andi, i_ori, i_xori, i_lw, i_sw, i_beq, i_bne, i_lui, i_j, i_jal;

	/*
	具体指令的实现
	 */
	

	// and(r_type, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	// and(i_add, r_type, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
	// and(i_sub, r_type, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);


	// and(i_addi, ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);


   wire r_type  = ~|op;
   wire i_add  = r_type& func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0]; // add
   wire i_sub  = r_type& func[5]&~func[4]&~func[3]&~func[2]& func[1]&~func[0]; // sub
   wire i_and  = r_type& func[5]&~func[4]&~func[3]& func[2]&~func[1]&~func[0]; // and
   wire i_or   = r_type& func[5]&~func[4]&~func[3]& func[2]&~func[1]& func[0]; // or
   wire i_xor  = r_type& func[5]&~func[4]&~func[3]& func[2]& func[1]&~func[0];
   wire i_slt  = r_type& func[5]&~func[4]& func[3]&~func[2]& func[1]&~func[0]; // slt
   // wire i_sltu = r_type& func[5]&~func[4]& func[3]&~func[2]& func[1]& func[0]; // sltu
   // wire i_addu = r_type& func[5]&~func[4]&~func[3]&~func[2]&~func[1]& func[0]; // addu
   // wire i_subu = r_type& func[5]&~func[4]&~func[3]&~func[2]& func[1]& func[0]; // subu
   wire i_jr   = r_type&~func[5]&~func[4]& func[3]&~func[2]&~func[1]&~func[0]; //jr 001000
   // wire i_jalr = r_type&~func[5]&~func[4]& func[3]&~func[2]&~func[1]& func[0]; //jalr 001001
   wire i_nor  = r_type& func[5]&~func[4]&~func[3]& func[2]& func[1]& func[0]; //nor 100111
   wire i_sll  = r_type&~func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0]; //sll 000000
   wire i_srl  = r_type&~func[5]&~func[4]&~func[3]&~func[2]& func[1]&~func[0]; //srl 000010
   wire i_sra  = r_type&~func[5]&~func[4]&~func[3]&~func[2]& func[1]& func[0]; //sra 000011
   wire i_sllv = r_type&~func[5]&~func[4]&~func[3]& func[2]&~func[1]&~func[0]; //sllv 000100
   wire i_srlv = r_type&~func[5]&~func[4]&~func[3]& func[2]& func[1]&~func[0]; //srlv 000110
  // i format
   wire i_addi = ~op[5]&~op[4]& op[3]&~op[2]&~op[1]&~op[0]; // addi
   wire i_ori  = ~op[5]&~op[4]& op[3]& op[2]&~op[1]& op[0]; // ori
   wire i_xori = ~op[5]&~op[4]& op[3]& op[2]& op[1]&~op[0]; 
   wire i_lw   =  op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0]; // lw
   wire i_sw   =  op[5]&~op[4]& op[3]&~op[2]& op[1]& op[0]; // sw
   wire i_beq  = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]&~op[0]; // beq
   wire i_bne  = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]& op[0]; //bne 000101
   //wire i_slti = ~op[5]&~op[4]& op[3]&~op[2]& op[1]&~op[0]; //slti 001010
   wire i_lui  = ~op[5]&~op[4]& op[3]& op[2]& op[1]& op[0]; //lui 001111
   wire i_andi = ~op[5]&~op[4]& op[3]& op[2]&~op[1]&~op[0]; //001100
  // j format
   wire i_j    = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]&~op[0];  // j
   wire i_jal  = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0];  // jal




	wire i_rs = i_add | i_sub | i_and | i_or | i_xor | i_jr | i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq | i_bne;

	wire i_rt = i_add | i_sub | i_and | i_or | i_xor | i_sll | i_sllv | i_srl | i_srlv | i_sra | i_sw | i_beq | i_bne | i_nor | i_slt;


	assign nostall = ~(ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) | i_rt & (ern == rt)));

	always @(ewreg or mwreg or ern or mrn or em2reg or mm2reg or mm2reg or rs or rt)
	begin
		fwda = 2'b00;
		if(ewreg & (ern != 0) & (ern == rs) & ~em2reg)
		begin
			fwda = 2'b01;
		end else begin
			if(mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg)
			begin
				fwda = 2'b10;
			end else begin
				if(mwreg & (mrn != 0) & (mrn == rs) & mm2reg) begin
					fwda = 2'b11;
				end
			end
		end
	

	fwdb = 2'b00;
	if(ewreg & (ern != 0) & (ern == rt) & ~em2reg)begin
		fwdb = 2'b01;
	end else begin
		if(mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg)begin
			fwdb = 2'b10;
		end else begin
			if(mwreg & (mrn != 0) & (mrn == rt) & mm2reg)begin
				fwdb = 2'b11;
			end
		end
	end
end

	assign wreg = (i_add | i_sub | i_and | i_or | i_xor | i_sll | i_sllv | i_srlv | i_nor | i_slt| i_srl | i_sra | i_addi | i_andi | i_ori | i_xori | i_lw | i_lw | i_lui | i_jal) & nostall;
	
	assign regrt = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;

	assign jal = i_jal;	
	assign m2reg = i_lw;
	assign shift = i_sll | i_srl | i_sra ;
	assign aluimm = i_addi | i_lw | i_sw | i_beq | i_bne | i_lui | i_ori | i_andi;
	assign sext = i_addi | i_lw | i_sw | i_beq | i_bne;
    assign aluc[0] = i_add | i_lw | i_sw | i_addi | i_and   | i_srl  |i_lui | i_andi | i_sllv | i_nor | i_slt;
    assign aluc[1] = i_sub | i_beq | i_and | i_bne | i_sra  | i_andi | i_sllv | i_nor;
    assign aluc[2] = i_or | i_ori   | i_lui | i_srlv | i_nor | i_slt;
    assign aluc[3] = i_sll | i_sra | i_srl | i_lui | i_sllv | i_srlv;

	assign wmem = i_sw & nostall;
	assign pcsource[1] = i_jr | i_j | i_jal;
	assign pcsource[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;
	
endmodule









