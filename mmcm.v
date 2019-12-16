module MMCM (
    input wire in_clk,
    output wire out_clk
    );

    reg out = 0;
    reg [26:0] count = 0;

    always @(posedge in_clk) begin
        if (count == 27'b101111101011110000100000000) begin
            out <= ~out;
            count <= 27'd0;
        end
        else begin
            count <= count + 27'd1;
        end
    end

    assign out_clk = out;
endmodule
