module uart_regs (
    input logic clk_i,
    input logic rst_n_i,
    
    input logic psel_i,
    input logic penable_i,
    input logic pwrite_i,
    input logic [31:0] paddr_i,
    input logic [31:0] pwdata_i,
    output logic pready_o,
    output logic pslverr_o,
    output logic [31:0] prdata_o,

    input stop_bit_check_error,
    input parity_check_error,

    output logic [16:0] boudrate_o
);

    localparam ADDR_STATUS_REG = 32'h00;
    localparam ADDR_CFG_REG = 32'h04;

    reg [31:0] status_reg;
    reg [31:0] cfg_reg; //[31:18] - kHz, [17:1] boud

    reg stop_bit_check;
    reg parity_check;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            stop_bit_check <= 0;
        end else if(stop_bit_check_error) begin
            stop_bit_check <= 1;
        end else if((pwrite_i && psel_i && penable_i && pready_o) && paddr_i == ADDR_STATUS_REG) begin
            if(pwdata_i[0]) begin
                stop_bit_check <= 0;
            end
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            parity_check <= 0;
        end else if(parity_check_error) begin
            parity_check <= 1;
        end else if((pwrite_i && psel_i && penable_i && pready_o) && paddr_i == ADDR_CFG_REG) begin
            if(pwdata_i[0]) begin
                parity_check <= 0;
            end
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            status_reg <= 0;
            cfg_reg    <= 0;
        end else if (pwrite_i && psel_i && penable_i && pready_o) begin
            case(paddr_i)
                ADDR_CFG_REG:    cfg_reg    <= pwdata_i;
                default: pslverr_o <= 1;
            endcase
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            prdata_o <= 0;
        end else if(~pwrite_i && psel_i && ~penable_i) begin
            case(paddr_i) 
                ADDR_STATUS_REG:    prdata_o <= status_reg;
                ADDR_CFG_REG:       prdata_o <= cfg_reg;
                default:            prdata_o <= 0;
            endcase
        end
    end

        always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            pready_o <= 0;
        end else if(psel_i && ~penable_i) begin
            pready_o <= 1;
        end else begin
            pready_o <= 0;
        end
    end


    assign boudrate_o = {cfg_reg[31:18], 3'd000}/cfg_reg[17:1];
    
endmodule