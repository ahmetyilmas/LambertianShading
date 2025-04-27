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
    input [15:0]dir_x, dir_y, dir_z,
    output [15:0]normal_x, normal_y, normal_z   // normalized directions
    );
    
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
    // len = max(Lx,Ly,Lz)
    always_comb begin
        max1 = (abs_x > abs_y) ? abs_x : abs_y;
        max2 = (max1 > abs_z) ? max1 : abs_z;
    end
    
endmodule
