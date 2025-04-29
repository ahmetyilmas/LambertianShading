`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gazi University
// Engineer: Ahmet
// 
// Create Date: 27.04.2025 04:39:35
// Design Name: 
// Module Name: light_dir
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


module light_dir(
    input clk, reset,
    input [15:0]light_x,light_y,light_z,        // x,y,z coordinates of light source
    input [15:0]surface_x,surface_y,surface_z,  // coordinates of object
    output [15:0]dir_x,dir_y,dir_z              // light vectors
    );
    
    logic [15:0]vector_x,vector_y,vector_z;
    
    always_comb begin
        vector_x = light_x - surface_x;
        vector_y = light_y - surface_y;
        vector_z = light_z - surface_z;
    end
    
    assign dir_x = vector_x;
    assign dir_y = vector_y;
    assign dir_z = vector_z;
    
endmodule
