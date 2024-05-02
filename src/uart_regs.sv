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
    logic [31:0] baud_rate;
    logic [31:0] counter;

    // baud_rate = 1/v / T, где v - скорость передачи бит/с, а T - период (CLK_PERIOD)
    // for apb clk_period and v or just v?

    //apb start


    //apb end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            counter <= 0;
            uart_clk_o <= 0;
        end else if (counter == baud_rate) begin
            uart_clk_o <= ~uart_clk_o;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
    
endmodule