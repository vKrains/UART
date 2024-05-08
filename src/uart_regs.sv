module uart_regs (
    input logic clk_i,
    input logic rst_n_i,
    
    input logic psel_i,
    input logic penable_i,

    input logic [31:0] padrr_i,
    input logic [31:0] pwdata_i,
    output logic pready_o,
    output logic pslverr_o,
    output logic [31:0] prdata_o,

    output logic [31:0] uart_clk_o
);
    
    
endmodule