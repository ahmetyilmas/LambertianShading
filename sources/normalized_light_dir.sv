`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gazi University
// Engineer: Ahmet
// 
// Create Date: 27.04.2025 04:48:20
// Design Name: 
// Module Name: normalized_light_dir
// Project Name: LambertianShading
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


module normalized_light_dir(
    input clk,reset,start,
    input [15:0]dir_x, dir_y, dir_z,
    output  logic [15:0]normal_x, normal_y, normal_z   // normalized directions
    );
    
    localparam WIDTH = 16;
    
    // absolute calculation
    function automatic signed[15:0] abs16(input signed[15:0] x);
        if(x < 0)
            abs16 = -x;
        else
            abs16 = x;
    endfunction
            
    
    logic [15:0]abs_x,abs_y,abs_z;
    logic [15:0]max1,max2;
    
    assign abs_x = abs16(dir_x);
    assign abs_y = abs16(dir_y);
    assign abs_z = abs16(dir_z);
    
    
    
    // Since normalization with square root is time and resource consuming on fpga,
    // aproximate normal calculation using Newton-Raphson will be implemented.
    // L'x = Lx / len
    // L'y = Ly / len
    // L'z = Lz / len
    // len = max(Lx,Ly,Lz)
    
    assign max1 = (abs_x > abs_y) ? abs_x : abs_y;
    assign max2 = (max1 > abs_z) ? max1 : abs_z;
    
    
    logic [WIDTH-1:0]nLx,nLy,nLz;   // normalized light directions
    logic valid_x,valid_y,valid_z;
    
    
    pipelined_divider #(
        .WIDTH(WIDTH)) pdX (
        .clk(clk),
        .rst(reset),
        .start(start),
        .dividend(dir_x),
        .divisor(max2),
        .quotient(nLx),
        .valid(valid_x)
    );
    pipelined_divider #(
            .WIDTH(WIDTH)) pdY (
            .clk(clk),
            .rst(reset),
            .start(start),
            .dividend(dir_y),
            .divisor(max2),
            .quotient(nLy),
            .valid(valid_y)
    );
    pipelined_divider #(
            .WIDTH(WIDTH)) pdZ (
            .clk(clk),
            .rst(reset),
            .start(start),
            .dividend(dir_z),
            .divisor(max2),
            .quotient(nLz),
            .valid(valid_z)
    );
    
    
   always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            normal_x <= 0;
            normal_y <= 0;
            normal_z <= 0;
        end else begin
            if (valid_x) normal_x <= nLx;
            if (valid_y) normal_y <= nLy;
            if (valid_z) normal_z <= nLz;
        end
    end

endmodule
