module sigma_delta_counter #(
	parameter NUMBER_OF_SAMPLES = 1000
	)(
	input wire clk,
	input wire rst,
	input wire pulse,
    output reg [$clog2(NUMBER_OF_SAMPLES+1)-1:0] ones,
	output reg ready
	);
	
	// wire active = |counter;

	reg [$clog2(NUMBER_OF_SAMPLES)-1:0] counter;
	wire [$clog2(NUMBER_OF_SAMPLES)-1:0] counter_next;
	wire [$clog2(NUMBER_OF_SAMPLES+1)-1:0] ones_next;
	wire ready_next;
	
    assign counter_next = (counter == NUMBER_OF_SAMPLES - 1) ? 'b0 : counter + 'b1;
	assign ones_next = ready ? (pulse ? 'b1 : 'b0) : (pulse ? ones + 'b1 : ones);
    assign ready_next = (counter == NUMBER_OF_SAMPLES - 1);

	always_ff @(posedge clk) begin
		if (rst) begin
			counter <= 'b0;
			ones <= 'b0;
			ready <= 'b0;
		end else begin
			counter <= counter_next;
			ones <= ones_next;
			ready <= ready_next;
		end
	end
endmodule
