module uart_rx #(DATA_WIDTH = 8)(
    input logic clk_i,
    input logic rst_n_i,

    input logic rx_i,
    input logic [16:0] boudrate_i,

    output logic [7:0] mst_axis_tdata_o, // один парити бит?
    output logic mst_axis_tvalid_o, 
    output logic mst_axis_tlast_o, // ?
    input  logic mst_axis_tready_i,

    output logic parity_check_error,
    output logic stop_bit_check_error
);
    enum {IDLE, START_BIT, DATA_BIT, PARITY_BIT, STOP_BIT_M} state, next_state;

    logic rx_d;
    logic rx_dd;
    logic [15: 0] cfg_div;
    logic [15: 0] counter;
    logic [ 3: 0] bit_count;

    logic parity_bit;
    logic stop_bit;

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
            rx_d <= 0;
        end else begin
            rx_d <= rx_i;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            rx_dd <= 0;
        end else begin
            rx_dd <= rx_d;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            counter <= 0;
        end else begin
            case(state)
                IDLE: counter <= cfg_div/2;
                START_BIT: 
                begin
                    counter <= counter - 1;
                    if(counter == 0) begin
                        counter <= cfg_div;
                    end
                end
                DATA_BIT: 
                begin
                    counter <= counter - 1;
                    if(counter == 0) begin
                        counter <= cfg_div;
                    end
                end
                PARITY_BIT:
                begin
                    counter <= counter - 1;
                    if (counter == 0) begin
                        counter <= cfg_div;
                    end
                end
                STOP_BIT_M: 
                begin
                    counter <= counter - 1;
                    if(counter == 0) begin
                        counter <= cfg_div;
                    end
                end
                default:
                begin
                    counter <= cfg_div;
                end
            endcase
        end 
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            bit_count <= 0;
        end else if(state == DATA_BIT) begin
            if (counter == 0) begin
                bit_count <= bit_count + 1;
            end
        end else begin
            bit_count <= 0;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            mst_axis_tdata_o <= 0;
        end else if (state == DATA_BIT) begin
            if(counter == 0 && bit_count <= 8) begin
                mst_axis_tdata_o <= {mst_axis_tdata_o[6:0], rx_i};
            end
        end
    end
    //
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            mst_axis_tvalid_o <= 0;
        end else if (state == STOP_BIT_M) begin
            if(counter == 0) begin
                mst_axis_tvalid_o <= 1;
            end else begin
                mst_axis_tvalid_o <= 0;
            end
        end else begin
            mst_axis_tvalid_o <= 0;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            parity_bit <= 0;
            parity_check_error <= 0;
        end else if(state == PARITY_BIT) begin
            if (counter == 0) begin
                parity_bit = rx_i;
                parity_check_error = (parity_bit == ^mst_axis_tdata_o) ? 0 : 1;
            end
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(~rst_n_i) begin
            stop_bit <= 0;
            stop_bit_check_error <= 0;
        end else begin
            if(state == STOP_BIT_M) begin
                if (counter == 0) begin
                    stop_bit = rx_i;
                    stop_bit_check_error = (1 == stop_bit) ? 0 : 1;
                end
            end
        end
    end

    always_comb begin
        case(state)
            IDLE: begin
                if(rx_d == 0 && rx_dd == 1) begin
                    next_state = START_BIT;
                end else begin
                    next_state = IDLE;
                end
            end
            START_BIT: begin
                if(counter == 0) begin
                    next_state = DATA_BIT;
                end else begin
                    next_state = START_BIT;
                end
            end
            DATA_BIT: begin
                if (bit_count == 8 && counter == 0) begin
                    next_state = PARITY_BIT;
                end else begin
                    next_state = DATA_BIT;
                end
            end
            PARITY_BIT: begin
                if(counter == 0) begin
                    next_state = STOP_BIT_M;
                end else begin
                    next_state = PARITY_BIT;
                end
            end
            STOP_BIT_M: begin
                if(counter == 0) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_M;
                end    
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule