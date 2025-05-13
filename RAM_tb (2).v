module ram_tb();
parameter MEM_WIDTH=16,MEM_DEPTH=1024,ADDR_SIZE=10,
     ADDR_PIPELINE="TRUE",DOUT_PIPELINE="FALSE",PARITY_ENABLE=1;
reg clk,rst,addr_en,dout_en,blk_select,wr_en,rd_en;
reg [MEM_WIDTH-1:0]din;
reg [ADDR_SIZE-1:0]addr;
wire [MEM_WIDTH-1:0]dout; 
wire parity_out;
ram #(16,1024,10,"TRUE","FALSE",1)uut(din,addr,clk ,rst,blk_select,rd_en,wr_en,dout_en,addr_en,dout,parity_out);
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
initial begin
$readmemb("mem.dat",uut.mem);
rst=1;
@(negedge clk);
rst=0;

addr_en=1; 
dout_en=0;
//testing writing
wr_en=1;rd_en=0;
@(negedge clk);
repeat(1000)begin
  blk_select=1;
 addr=$random; din=$random;
@(negedge clk);
end 
//testing reading
rd_en=1; wr_en=0;
din=0;
@(negedge clk);
repeat(1000)begin 
blk_select=1;
addr=$random; 
@(negedge clk);
end 
end 

endmodule 