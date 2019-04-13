module pipeidcu (mwreg, mrn, ern, ewreg, em2reg, mm2reg, rsrtequ, func, op, rs, rt, wreg, m2reg, 
	wmem, aluc, regrt, aluimm, fwda, fwdb, nostall, sext, pcsource, shift, jal);


	
	input mwreg, ewreg, em2reg, mm2reg, rsrtequ;
	input [4:0] mrn, ern, rs, rt;
	input [5:0] func, op;

	output     wreg, m2reg, wmem, regrt, aluimm, sext, shift, jal;
	output [3:0] func;
	output [1:0] pcsource;
	output [1:0] fwda, fwdb;
	output nostall;

	reg [1:0] fwda, fwdb;

	wire r_type, i_add, i_sub, i_and, i_or, i_xor, i_sll, i_sra, i_jr;
	wire i_addi, i_andi, i_ori, i_xori, i_lw, i_sw, i_beq, i_bne, i_lui, i_j, i_jal;

	/*
	具体指令的实现
	 */
	
	and(r_type, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	and(i_add, r_type, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
	and(i_sub, r_type, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);


	and(i_addi, ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);


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

	assign wreg = (i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl | i_sra | i_addi | i_andi | i_ori | i_xori | i_lw | i_lw | i_lui | i_jal) & nostall;
	
	assign regrt = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;

	assign jal = i_jal;	
	assign m2reg = i_lw;
	assign shift = i_sll | i_srl | i_sra;
	assign aluimm = i_addi | i_lw | i_sw | i_beq | i_bne;
	assign aluc[3] = i_sra;
	assign aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui;
	assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq | i_bne | i_lui;
	assign aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
	assign wmem = i_sw & nostall;
	assign pcsource[1] = i_jr | i_j | i_jal;
	assign pcsource[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;
	
endmodule









