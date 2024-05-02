module uart_tx #(DATA_WIDTH = 8)(
    //
    input logic clk_i,
    input logic rst_n_i,

    input  logic [DATA_WIDTH-1:0] slv_axis_tdata_i,
    input  logic slv_axis_tvalid_i,
    input  logic slv_axis_tlast_i,
    output logic slv_axis_tready_o,

    output logic tx_o
);
    
endmodule