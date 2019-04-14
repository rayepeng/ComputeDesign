module pipeexe(ealuc, ealuimm, ea, eb, eimm, eshift, ern0, epc4, ejal, ern, ealu);

	input [31:0] ea, eb, eimm, epc4;
	input [4:0]  ern0;
	input [3:0]  ealuc;
	input        ealuimm, eshift, ejal;

	output [31:0] ealu;
	output [4:0]  ern;

	wire [31:0] alua, alub, sa, ealu0, epc8;
	wire z;
	assign sa = {eimm[5:0], eimm[31:6]};           //计算得出移位的数量shamt

	//cla32 ret_addr(epc4, 32'h4, 1'b0, epc8);       //这里使用的是pc+8， 也就是分支延迟槽?
	assign epc8 = epc4 + 4;
	mux2x32 alu_ina(ea, sa, eshift, alua);         //选择ALU的a输入端

	mux2x32 alu_inb(eb, eimm, ealuimm, alub);      //选择ALU的b输入端
	mux2x32 save_pc8(ealu0, epc8, ejal, ealu);

	assign ern = ern0 | {5{ejal}};
	alu al_unit(alua, alub, ealuc, ealu0, z);

endmodule

