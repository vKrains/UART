
interface automatic axis_if #(
    parameter DATA_WIDTH = 8
  )(input logic clk, input logic rst_n);

    logic [DATA_WIDTH-1:0] tdata;
    logic tvalid = 0;
    logic tready = 0;
    logic tlast =0;

    task automatic send_frame(ref bit [DATA_WIDTH-1:0] send_data []);
        logic tmp_valid;
        int i;
        tlast <= 0;
        i = 0;
        while (i < send_data.size()) begin
            tmp_valid = $urandom();
            tvalid <= tmp_valid;
            if (tmp_valid) begin
                tdata <= send_data[i];
                tlast <= (i == send_data.size()-1) ? 1 : 0;
                do begin
                    tready = $urandom();
                    @(posedge clk);
                end while (!tready);
                i = i + 1;
            end else @(posedge clk);
        end 
        tlast <= 0;
        tvalid<= 0;
        @(posedge clk);
    endtask

    task get_frame (ref bit [DATA_WIDTH-1:0] get_data []);
        int j;
        j = 0;
        get_data = new[j];
        do begin
            @(posedge clk);
            if(tvalid) begin
                if (tready) begin
                    get_data = {get_data, tdata};
                end
            end
        end while (~tlast);
    endtask

endinterface