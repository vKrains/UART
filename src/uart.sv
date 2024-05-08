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

    input logic [16:0] boudrate,

    //uart
    input rx_i,
    output tx_o
);
//draw.io | yEd Graph Editor
//uvm tlm
    // подключение модулей
    uart_rx uart_rx2axis (
        .clk_i (clk),
        .rst_n_i (rst_n),
        .rx_i (rx_i),
        .boudrate_i (boudrate),
        .mst_axis_tdata_o (mst_axis_tdata_o),
        .mst_axis_tvalid_o (mst_axis_tvalid_o),
        .mst_axis_tlast_o (mst_axis_tlast_o),
        .mst_axis_tready_i (mst_axis_tready_i),
        .parity_check_error (parity_check_error),
        .stop_bit_check_error (stop_bit_check_error)
    );

    uart_tx axis2uart_tx (
        .clk_i (clk),
        .rst_n_i (rst_n),
        .boudrate_i (boudrate),
        .slv_axis_tdata_i (slv_axis_tdata_i),
        .slv_axis_tvalid_i (slv_axis_tvalid_i),
        .slv_axis_tready_o (slv_axis_tready_o),
        .tx_o (tx_o)
    );

    // uart_regs apb_uart_regs (
    //     .clk        (clk_i),
    //     .rst_n      (rst_n_i),
    //     .psel_i     (psel_i),
    //     .penable_i  (penable_i),
    //     .pwrite_i   (pwrite_i),
    //     .paddr_i    (paddr_i),
    //     .pwdata_i   (pwdata_i),
    //     .prdata_o   (prdata_o)
    // );
    
endmodule

// rx
// tx
// схема
// axis_agent найти почитать посмотреть 
// apb_agent найти почитать посмотреть 
// uart_agent найти почитать посмотреть 