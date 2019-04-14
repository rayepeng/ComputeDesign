module pipeif(pcsource, ins, pc, bpc, rpc, jpc, npc, pc4, inst);

	input [31:0] pc, bpc, rpc, jpc;  //待选择的PC
	input [1:0] pcsource;            //选择信号
	input [31:0] ins;                //读取的指令


	output [31:0] npc, pc4, inst;    //输出下一条PC,pc4, inst

	assign pc4 = pc + 4;
	assign inst = ins;              //指令就直接赋值了
	mux4x32 next_pc(pc4, bpc, rpc, jpc, pcsource, npc);

	//cla32 pc_plus4(pc, 32'h4, 1'b0, pc4);
	
endmodule