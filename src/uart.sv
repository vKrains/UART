module uart #(DATA_WIDTH = 8)(
    //
    input logic clk,
    input logic rst_n,

    // axis interface
    // axis_slv for uart_tx
    input  logic [DATA_WIDTH-1:0] slv_axis_tdata_i,
    input  logic slv_axis_tvalid_i,
    input  logic slv_axis_tlast_i,
    output logic slv_axis_tready_o,
    // axis_mst for uart_rx
    output logic [DATA_WIDTH-1:0] mst_axis_tdata_o,
    output logic mst_axis_tvalid_o,
    output logic mst_axis_tlast_o,
    input  logic mst_axis_tready_i,

    // apb interface
    input  logic psel_i,
    input  logic penable_i,
    input  logic pwrite_i,
    input  logic [31:0] paddr_i,
    input  logic [31:0] pwdata_i,
    output logic [31:0] pedata_o,

    //uart
    input rx_i,
    output tx_o
);

    logic uart_clk;

    // подключение модулей
    
    uart_rx uart_rx2axis (
        .uart_clk           (clk_i),
        .rst_n              (rst_n_i),
        .rx_i               (rx_i),
        .mst_axis_tdata_o   (mst_axis_tdata_o),
        .mst_axis_tvalid_o  (mst_axis_tvalid_o),
        .mst_axis_tlast_o   (mst_axis_tlast_o),
        .mst_axis_tready_i  (mst_axis_tready_i)
    );

    uart_tx axis2uart_tx (
        .uart_clk           (clk_i),
        .rst_n              (rst_n_i),
        .slv_axis_tready_i  (slv_axis_tready_i),
        .slv_axis_tdata_o   (slv_axis_tdata_o),
        .slv_axis_tvalid_o  (slv_axis_tvalid_o),
        .slv_axis_tlast_o   (slv_axis_tlast_o),
        .tx_o               (tx_o)
    );

    uart_regs apb_uart_regs (
        .clk        (clk_i),
        .rst_n      (rst_n_i),
        .psel_i     (psel_i),
        .penable_i  (penable_i),
        .pwrite_i   (pwrite_i),
        .paddr_i    (paddr_i),
        .pwdata_i   (pwdata_i),
        .prdata_o   (prdata_o),
        .uart_clk   (uart_clk_o)
    );
    
endmodule