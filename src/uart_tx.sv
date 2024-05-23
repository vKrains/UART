module uart_tx #(DATA_WIDTH = 8)(
    //
    input logic clk_i,
    input logic rst_n_i,

    input logic [16:0] boudrate_i,

    input  logic [7:0] slv_axis_tdata_i,
    input  logic slv_axis_tvalid_i,
    input  logic slv_axis_tlast_i,
    output logic slv_axis_tready_o,

    output logic tx_o
);

    logic bit_done;
    logic boudgenerate;
    logic [ 7: 0] reg_data;
    logic [15: 0] cfg_div;
    logic [15: 0] counter;
    logic [ 3: 0] bit_count;

    enum {IDLE, START_BIT, DATA_BIT, PARITY_BIT, STOP_BIT_M} state, next_state;

    always_comb begin
        case(boudrate_i)
            17'd9600:   cfg_div = 104;
            17'd19200:  cfg_div = 52;
            17'd38400:  cfg_div = 26;
            17'd57600:  cfg_div = 17;
            17'd115200: cfg_div = 8;
            default:    cfg_div = 104;
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        boudgenerate = 0;
        tx_o = 1;
        case(state)
            IDLE:
            begin
                if(slv_axis_tvalid_i) begin
                    next_state = START_BIT;
                end else begin
                    next_state = IDLE;
                end
            end
            START_BIT:
            begin
                tx_o = 0;
                boudgenerate = 1;
                if (bit_done) begin
                    next_state = DATA_BIT;
                end else begin
                    next_state = START_BIT;
                end
            end
            DATA_BIT:
            begin
                tx_o = reg_data[7];
                boudgenerate = 1;
                if(bit_done) begin
                    if(bit_count == 8) begin
                        next_state = PARITY_BIT;
                    end else begin
                        next_state = DATA_BIT;
                    end
                end
            end
            PARITY_BIT:
            begin
                tx_o = ^reg_data;
                boudgenerate = 1;
                if(bit_done) begin
                    next_state = STOP_BIT_M;
                end else begin
                    next_state = PARITY_BIT;
                end
            end
            STOP_BIT_M:
            begin
                tx_o = 1;
                boudgenerate = 1;
                if(bit_done) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_M;
                end
            end
            default:
            begin
                next_state = IDLE;
            end
        endcase
    end


    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            counter <= 0;
            bit_done <= 0;
        end else begin
            if(boudgenerate) begin
                if(counter == cfg_div) begin
                    counter <= 0;
                    bit_done <= 1;
                end else begin
                    counter <= counter + 1;
                    bit_done <= 0;
                end
            end else begin
                counter <= 0;
                bit_done <= 0;
            end
        end
    end
    
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            bit_count <= 0;
        end else if (state == DATA_BIT) begin
            if(bit_done) begin
                bit_count <= bit_count + 1;
            end
        end else begin
            bit_count <= 0;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            reg_data <= 0;
        end else if(state == IDLE && slv_axis_tvalid_i) begin
            reg_data <= slv_axis_tdata_i;
        end else if(state == DATA_BIT) begin
            if(bit_done) begin
                reg_data <= {reg_data[6:0], 1'b0};
            end
        end
    end
    
    assign slv_axis_tready_o = (state == IDLE);

endmodule