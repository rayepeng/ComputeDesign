module dffe32_tb();

	reg [31:0] d;
	reg clk, clrn, e;

	wire [31:0] q;

	initial
		begin
			
			d = 32'h00000004;
			e = 0;
			
			clk = 0;

			# 20
			e = 1;
		end
	always begin
		# 10
		clk = ~clk;
	end

	

	dffe32 t1(
			.d(d),
			.clk(clk),
			.clrn(clrn),
			.e(e),
			.q(q)
		);
endmodule
