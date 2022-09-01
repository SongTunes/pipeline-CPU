`timescale 1ns / 1ps

`define RST_ENABLE 1'b1

`define DIGITAL_NUM_ADDR    16'h8000 // 0xbfaf_8000
`define SWITCH_ADDR         16'h8004 // 0xbfaf_8004
`define LED_ADDR            16'h8008 // 0xbfaf_8008
`define MID_BTN_KEY_ADDR    16'h800c // 0xbfaf_800c
`define LEFT_BTN_KEY_ADDR   16'h8010 // 0xbfaf_8010
`define RIGHT_BTN_KEY_ADDR  16'h8014 // 0xbfaf_8014
`define UP_BTN_KEY_ADDR     16'h8018 // 0xbfaf_8018
`define DOWN_BTN_KEY_ADDR   16'h801c // 0xbfaf_801c

module pipeline_CPU(
    input   wire    rstn,
    input   wire    clk,

    /********* confreg *********/
    // output  wire[6:0]   digital_num0,
    // output  wire[6:0]   digital_num1,
    // output  wire[7:0]   digital_cs,
    // output  wire[7:0]   led,
    // input   wire[7:0]   switch,

    input   wire        left_btn_key,
    input   wire        right_btn_key,
    input   wire        up_btn_key,
    input   wire        down_btn_key,

    output          hsync,
   output          vsync,
   output [3:0]    vga_r,
   output [3:0]    vga_g,
   output [3:0]    vga_b


    );

    wire[31:0]  inst_rom_addr;
    wire[31:0]  inst_rom_rdata;
    wire[31:0]  data_ram_addr;
    wire[31:0]  data_ram_wdata;
    wire        data_ram_wen;
    wire[31:0]  data_ram_rdata;


    // vga
    

    assign rst = rstn;

    wire[3:0]   nums[15:0];

    mycpu mycpu0(
        .rstn(rstn),                                  // input
        .clk(clk),                                  // input

        .inst_rom_addr(inst_rom_addr),              // output
        .inst_rom_rdata(inst_rom_rdata),            // input

        .data_ram_addr(data_ram_addr),              // output
        .data_ram_wdata(data_ram_wdata),            // output
        .data_ram_wen(data_ram_wen),                // output
        .data_ram_rdata(data_ram_rdata)             // input

        //.vga_in(nums)
    );

    inst_rom inst_rom_4k(
        .a(inst_rom_addr[11:2]),                    // input wire [9 : 0] a
        .spo(inst_rom_rdata)                        // output wire [31 : 0] spo
    );

    wire ram_wen, confreg_wen, vga_wen;
    //wire ram_wen;




    wire[31:0] ram_addr, confreg_addr, vga_addr;
    wire[31:0] ram_wdata, confreg_wdata, vga_wdata;
    wire[31:0] ram_rdata, confreg_rdata, vga_rdata;

    assign ram_addr = data_ram_addr;
    assign confreg_addr = data_ram_addr;
    assign vga_addr = data_ram_addr;

    assign ram_wdata = data_ram_wdata;
    //assign confreg_wdata = data_ram_wdata;
    assign vga_wdata = data_ram_wdata;

    wire is_confreg_addr;
    assign is_confreg_addr = data_ram_addr[31:12] == 20'hbfaf8 ? 1'b1 : 1'b0;
   

    wire is_vga_addr;
    assign is_vga_addr = data_ram_addr[31:12] == 20'hbfaf9 ? 1'b1 : 1'b0;


    assign confreg_wen = data_ram_wen & is_confreg_addr;
    assign vga_wen = data_ram_wen & is_vga_addr;
    assign ram_wen = data_ram_wen & !is_confreg_addr & !is_vga_addr;

    assign data_ram_rdata = is_confreg_addr == 1'b1 ? confreg_rdata : (is_vga_addr == 1'b1 ? vga_rdata : ram_rdata);


    // MEM
    data_ram data_ram_4k(
        .a(ram_addr[11:2]),                         // input wire [9 : 0] a
        .d(ram_wdata),                              // input wire [31 : 0] d
        .clk(clk),                                  // input wire clk
        .we(ram_wen),                               // input wire we
        .spo(ram_rdata)                             // output wire [31 : 0] spo
    );

  




   confreg confreg0(
      .clk(clk),
      .rst(~rstn),

      .confreg_wen(confreg_wen),
      //.confreg_write_data(confreg_wdata),
      .confreg_addr(confreg_addr),
      .confreg_read_data(confreg_rdata),


      .left_btn_key(left_btn_key),
      .right_btn_key(right_btn_key),
      .up_btn_key(up_btn_key),
      .down_btn_key(down_btn_key)
   );




   myip_top_vga_0 top_vga0(
      .clk(clk),
      .rst(rstn),

      .vga_addr(vga_addr),
      .vga_we(vga_wen),
      //.vga_rdata(vga_rdata),
      .vga_wdata(vga_wdata),
      
      .hsync(hsync),
      .vsync(vsync),
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b)



      
    );
    


endmodule
