`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2024 01:35:19
// Design Name: 
// Module Name: tb
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
`include "axis_if.sv"
`include "apb_if.sv"

module tb();

    localparam CLK_PERIOD = 10;

    logic rst_n = 1;
    logic clk   = 0;
    logic rx;
    logic [16:0] boudrate;
    logic [7:0] mst_axis_tdata; // один парити бит?
    logic mst_axis_tvalid; 
    logic mst_axis_tlast; // ?
    logic mst_axis_tready;
    logic parity_check_error;
    logic stop_bit_check_error;

    logic [7:0] slv_axis_tdata;
    logic slv_axis_tvalid;
    logic slv_axis_tlast;
    logic slv_axis_tready;
    logic tx;

    logic rx_tx;

    always #(CLK_PERIOD) clk = ~clk;
    assign rx = tx;
    initial begin
        #5
        rst_n = 0;
        #5
        rst_n = 1;
        #20
        boudrate <= 9600;
        
        slv_axis_tdata <= 8'b10101010;
        slv_axis_tvalid <= 1;
        #20
        slv_axis_tvalid <= 0;
    end

    

    uart DUT
    (
        .clk (clk),
        .rst_n (rst_n),
        .boudrate (boudrate),
        .slv_axis_tdata_i (slv_axis_tdata),
        .slv_axis_tvalid_i (slv_axis_tvalid),
        .slv_axis_tready_o (slv_axis_tready),
        .tx_o (tx),
        .rx_i (rx),
        .mst_axis_tdata_o (mst_axis_tdata),
        .mst_axis_tvalid_o (mst_axis_tvalid),
        .mst_axis_tready_i (mst_axis_tready)
    );

    // uart_rx DUT_RX
    // (
    //     .clk_i (clk),
    //     .rst_n_i (rst_n),
    //     .rx_i (tx),
    //     .boudrate_i (boudrate),
    //     .mst_axis_tdata_o (mst_axis_tdata),
    //     .mst_axis_tvalid_o (mst_axis_tvalid),
    //     .mst_axis_tlast_o (mst_axis_tlast),
    //     .mst_axis_tready_i (mst_axis_tready),
    //     .parity_check_error (parity_check_error),
    //     .stop_bit_check_error (stop_bit_check_error)
    // );

    // uart_tx DUT_TX
    // (
    //     .clk_i (clk),
    //     .rst_n_i (rst_n),
    //     .boudrate_i (boudrate),
    //     .slv_axis_tdata_i (slv_axis_tdata),
    //     .slv_axis_tvalid_i (slv_axis_tvalid),
    //     .slv_axis_tready_o (slv_axis_tready),
    //     .tx_o (tx)
    // );

endmodule
