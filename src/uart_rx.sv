module uart_rx #(DATA_WIDTH = 8)(
    input logic clk_i,
    input logic rst_n_i,

    input logic rx_i,

    output logic [8:0] mst_axis_tdata_o, // один парити бит?
    output logic mst_axis_tvalid_o, 
    output logic mst_axis_tlast_o, // ?
    input  logic mst_axis_tready_i
);

    logic [3:0 ]counter;

    enum {IDLE, START_BIT, DATA_BIT, PARITY_BIT, STOP_BIT} state, next_state;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (~rst_n_i) begin
            mst_axis_tdata_o  <= 0;
            mst_axis_tvalid_o <= 0;
            mst_axis_tlast_o  <= 0;
        end else begin
            case(state)
                START_BIT: begin
                    mst_axis_tdata_o <= 0;
                    mst_axis_tvalid_o <= 0;
                    mst_axis_tlast_o <= 0;
                end
                DATA_BIT: begin
                    mst_axis_tdata_o <= {mst_axis_tdata_o[8:1], rx_i};
                    
                end
                PARITY_BIT: begin
                    mst_axis_tdata_o <= {mst_axis_tdata_o[8:1], rx_i};
                end
                STOP_BIT: begin
                    if (^mst_axis_tdata_o[8:1] == mst_axis_tdata_o[0]) begin
                        mst_axis_tvalid_o <= 1;
                    end else begin
                        mst_axis_tvalid_o <= 0;
                    end
                end
            endcase
        end
    end

    // или always_ff?
    always_comb begin
        case(state)
            IDLE: begin
                if(~rx_i) begin
                    next_state = START_BIT;
                end else begin
                    next_state = IDLE;
                end
            end
            START_BIT: begin
                next_state = DATA_BIT;
            end
            DATA_BIT: begin
                if (counter == 8) begin
                    next_state = PARITY_BIT;
                end else begin
                    next_state = DATA_BIT;
                end
            end
            PARITY_BIT: begin
                next_state = STOP_BIT;
            end
            STOP_BIT: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule