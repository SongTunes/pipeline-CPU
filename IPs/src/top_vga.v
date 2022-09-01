`timescale 1 ns / 1 ns



// 423 
// 681 
// 570
module top_vga(
   input                      clk,
   input                      rst,

   input [31:0]               vga_addr,
   input                      vga_we,
   input [31:0]               vga_wdata,

   
   output                     hsync,
   output                     vsync,
   output [3:0]               vga_r,
   output [3:0]               vga_g,
   output [3:0]               vga_b
);

   reg[31:0]         pos2num[9:0];
   
   wire              pclk;
   wire              valid;
   wire [9:0]        h_cnt;
   wire [9:0]        v_cnt;
   reg [11:0]        vga_data;
   
   reg [19:0]        rom_addr;  

   wire [11:0]       douta;
   
   wire              logo_area[9:1];

   wire [9:0]        logo_x[9:1];  // one position left&up
   wire [9:0]        logo_y[9:1];

   parameter [9:0]   logo_length = 10'b001000_0010; //130
   parameter [9:0]   logo_hight  = 10'b001000_0010; //130
   

   reg rst_n;

   always @(posedge clk)
   begin
        rst_n <= ~rst;
   end 

   assign vga_r = vga_data[11:8];
   assign vga_g = vga_data[7:4];
   assign vga_b = vga_data[3:0];


   clk_wiz_0 clk0(
      // Clock in ports
      .clk_in1(clk),      // input clk_in1
      // Clock out ports
      .clk_out1(pclk),     // output clk_out1
      // Status and control signals
      .reset(rst_n)
   );   
	
   blk_mem_gen_0 mem(
      .clka(pclk),    // input wire clka
      .addra(rom_addr),  // input wire [13 : 0] addra
      .douta(douta)  // output wire [11 : 0] douta
   );

   vga_640x480 vga_640x480_0(
      .pclk(pclk), 
      .reset(rst_n), 
      .hsync(hsync), 
      .vsync(vsync), 
      .valid(valid), 
      .h_cnt(h_cnt), 
      .v_cnt(v_cnt)
   );



   // set the states

   always @(posedge clk) begin

      if(rst_n == 1'b1) begin
         pos2num[0] <= 32'h00000000;
         pos2num[1] <= 32'h00000000;
         pos2num[2] <= 32'h00000000;
         pos2num[3] <= 32'h00000000;
         pos2num[4] <= 32'h00000000;
         pos2num[5] <= 32'h00000000;
         pos2num[6] <= 32'h00000000;
         pos2num[7] <= 32'h00000000;
         pos2num[8] <= 32'h00000000;
         pos2num[9] <= 32'h00000000;

      end
      else begin 
         if(vga_wdata[31:16] == 16'h000a) begin
            pos2num[0] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0001) begin
            pos2num[1] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0002) begin
            pos2num[2] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0003) begin
            pos2num[3] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0004) begin
            pos2num[4] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0005) begin
            pos2num[5] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0006) begin
            pos2num[6] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0007) begin
            pos2num[7] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0008) begin
            pos2num[8] <= vga_wdata;
         end
         else if(vga_wdata[31:16] == 16'h0009) begin
            pos2num[9] <= vga_wdata;
         end
      end

   end
   // 

   wire [15:0]       idx[9:1];

   assign idx[1] = pos2num[1][15:0];
   assign idx[2] = pos2num[2][15:0];
   assign idx[3] = pos2num[3][15:0];
   assign idx[4] = pos2num[4][15:0];
   assign idx[5] = pos2num[5][15:0];
   assign idx[6] = pos2num[6][15:0];
   assign idx[7] = pos2num[7][15:0];
   assign idx[8] = pos2num[8][15:0];
   assign idx[9] = pos2num[9][15:0];

   // get the logox logoy

         
   assign logo_x[1] = 10'b0000000001;//
   assign logo_y[1] = 10'b0000000001;

   assign logo_x[2] = 10'b0010000011;
   assign logo_y[2] = 10'b0000000001;
   
   assign logo_x[3] = 10'b0100000101;
   assign logo_y[3] = 10'b0000000001;
   
   assign logo_x[4] = 10'b0000000001;//
   assign logo_y[4] = 10'b0010000011;
   
   assign logo_x[5] = 10'b0010000011;
   assign logo_y[5] = 10'b0010000011;
   
   assign logo_x[6] = 10'b0100000101;  // 261
   assign logo_y[6] = 10'b0010000011;  // 131
   
   assign logo_x[7] = 10'b0000000001;
   assign logo_y[7] = 10'b0100000101;
   
   assign logo_x[8] = 10'b0010000011;
   assign logo_y[8] = 10'b0100000101;
   
   assign logo_x[9] = 10'b0100000101;
   assign logo_y[9] = 10'b0100000101;
         
         
   
 
   assign logo_area[1] = ((v_cnt >= logo_y[1]) & (v_cnt <= logo_y[1] + logo_hight - 1) & (h_cnt >= logo_x[1]) & (h_cnt <= logo_x[1] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[2] = ((v_cnt >= logo_y[2]) & (v_cnt <= logo_y[2] + logo_hight - 1) & (h_cnt >= logo_x[2]) & (h_cnt <= logo_x[2] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[3] = ((v_cnt >= logo_y[3]) & (v_cnt <= logo_y[3] + logo_hight - 1) & (h_cnt >= logo_x[3]) & (h_cnt <= logo_x[3] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[4] = ((v_cnt >= logo_y[4]) & (v_cnt <= logo_y[4] + logo_hight - 1) & (h_cnt >= logo_x[4]) & (h_cnt <= logo_x[4] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[5] = ((v_cnt >= logo_y[5]) & (v_cnt <= logo_y[5] + logo_hight - 1) & (h_cnt >= logo_x[5]) & (h_cnt <= logo_x[5] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[6] = ((v_cnt >= logo_y[6]) & (v_cnt <= logo_y[6] + logo_hight - 1) & (h_cnt >= logo_x[6]) & (h_cnt <= logo_x[6] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[7] = ((v_cnt >= logo_y[7]) & (v_cnt <= logo_y[7] + logo_hight - 1) & (h_cnt >= logo_x[7]) & (h_cnt <= logo_x[7] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[8] = ((v_cnt >= logo_y[8]) & (v_cnt <= logo_y[8] + logo_hight - 1) & (h_cnt >= logo_x[8]) & (h_cnt <= logo_x[8] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   assign logo_area[9] = ((v_cnt >= logo_y[9]) & (v_cnt <= logo_y[9] + logo_hight - 1) & (h_cnt >= logo_x[9]) & (h_cnt <= logo_x[9] + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   



                     
   
   always @(posedge pclk)
   begin
      if (rst_n == 1'b1) begin
         vga_data <= 12'b000000000000;

      end
      else 
      begin
         if (valid == 1'b1)
         begin
            if (logo_area[1] == 1'b1) begin
               if(idx[1] != 16'h0000) begin
                  rom_addr <= ((idx[1]-1)*16900 + v_cnt * 130 + h_cnt);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
               
               
            end
            else if(logo_area[2] == 1'b1) begin
               if(idx[2] != 16'h0000) begin
                  rom_addr <= ((idx[2]-1)*16900 + v_cnt * 130 + h_cnt - 130);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[3] == 1'b1) begin
               if(idx[3] != 16'h0000) begin
                  rom_addr <= ((idx[3]-1)*16900 + v_cnt * 130 + h_cnt - 260);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[4] == 1'b1) begin
               if(idx[4] != 16'h0000) begin
                  rom_addr <= ((idx[4]-1)*16900 + (v_cnt-130) * 130 + h_cnt);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[5] == 1'b1) begin
               if(idx[5] != 16'h0000) begin
                  rom_addr <= ((idx[5]-1)*16900 + (v_cnt-130) * 130 + h_cnt - 130);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[6] == 1'b1) begin
               if(idx[6] != 16'h0000) begin
                  rom_addr <= ((idx[6]-1)*16900 + (v_cnt-130) * 130 + h_cnt - 260);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[7] == 1'b1) begin
               if(idx[7] != 16'h0000) begin
                  rom_addr <= ((idx[7]-1)*16900 + (v_cnt-260) * 130 + h_cnt);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[8] == 1'b1) begin
               if(idx[8] != 16'h0000) begin
                  rom_addr <= ((idx[8]-1)*16900 + (v_cnt-260) * 130 + h_cnt - 130);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else if(logo_area[9] == 1'b1) begin
               if(idx[9] != 16'h0000) begin
                  rom_addr <= ((idx[9]-1)*16900 + (v_cnt-260) * 130 + h_cnt - 260);
                  vga_data <= douta;
               end
               else begin
                  rom_addr <= rom_addr;
                  vga_data <= 12'b000000000000;
               end
            end
            else begin

               rom_addr <= rom_addr;
               vga_data <= 12'b000000000000;
            end
         end
         else
         begin
            vga_data <= 12'b111111111111;
            if (v_cnt == 0)
               rom_addr <= 20'b00000000000000000000;
         end
      end
   end
   
   
   

	
endmodule

