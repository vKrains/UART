interface apb_if #(
  parameter WIDTH      = 32
)(
  input logic clk,
  input logic rst_n
);

  logic [5:0] paddr;
  logic psel = 0;
  logic penable = 0;
  logic pwrite = 0;
  logic pready = 0;
  logic pslverr = 0;
  logic [WIDTH-1:0] prdata;
  logic [WIDTH-1:0] pwdata;

  task write(input logic [4:0] addr, input logic [WIDTH-1:0] data);
    @(posedge clk);
    paddr <= addr;
    psel <= 1;
    pwrite <= 1;
    penable <= 0;
    pwdata <= data;
    @(posedge clk);
    penable <= 1;
    while(~pready) begin
      @(posedge clk);
    end
    @(posedge clk);
    psel <= 0;
    penable <= 0;
  endtask

  task read(input logic [4:0] addr, ref logic [WIDTH-1:0] data);
    paddr <= addr;
    psel <= 1;
    pwrite <= 0;
    penable <= 0;
    @(posedge clk);
    penable <= 1;
    while(~pready) begin
      @(posedge clk);
    end
    data = prdata;
    @(posedge clk);
    psel <= 0;
    penable <= 0;
  endtask

endinterface