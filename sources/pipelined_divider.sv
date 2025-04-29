`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2025 03:41:24
// Design Name: 
// Module Name: pipelined_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipelined_divider #(
    parameter WIDTH = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [WIDTH-1:0] dividend,
    input  logic [WIDTH-1:0] divisor,
    output logic [WIDTH-1:0] quotient,
    output logic valid
);

    // Pipeline register arrays
    logic [WIDTH-1:0] rem   [0:WIDTH];
    logic [WIDTH-1:0] quot  [0:WIDTH];
    logic [WIDTH-1:0] div   [0:WIDTH];
    
    integer i;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i <= WIDTH; i++) begin
                rem[i]  <= 0;
                quot[i] <= 0;
                div[i]  <= 0;
            end
        end
        else begin
            if (start) begin
                rem[0]  <= 0;
                quot[0] <= 0;
                div[0]  <= divisor;
            end

            for (i = 0; i < WIDTH; i++) begin
                // Shift remainder left and bring in next dividend bit
                rem[i+1]  <= {rem[i][WIDTH-2:0], dividend[WIDTH-1-i]};

                if ({rem[i][WIDTH-2:0], dividend[WIDTH-1-i]} >= div[i]) begin
                    rem[i+1] <= {rem[i][WIDTH-2:0], dividend[WIDTH-1-i]} - div[i];
                    quot[i+1] <= {quot[i][WIDTH-2:0], 1'b1};
                end else begin
                    quot[i+1] <= {quot[i][WIDTH-2:0], 1'b0};
                end

                div[i+1] <= div[i];
            end
        end
    end

    assign quotient = quot[WIDTH];
    assign valid = (rst == 0);

endmodule
