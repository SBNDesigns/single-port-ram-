module ram #(parameter MEM_WIDTH=16,MEM_DEPTH=1024,ADDR_SIZE=10,
              ADDR_PIPELINE="FALSE",DOUT_PIPELINE="TRUE",PARITY_ENABLE=1)(


   input [MEM_WIDTH-1:0]din,
   input [ADDR_SIZE-1:0]addr,
   input clk,rst,blk_select,rd_en,wr_en,dout_en,addr_en,
   output  [MEM_WIDTH-1:0]dout,
   output reg parity_out
              );
   reg [MEM_WIDTH-1:0]mem[MEM_DEPTH-1:0];
   reg [ADDR_SIZE-1:0]addr_reg;
   wire[ADDR_SIZE-1:0]addr_wire;
   reg [MEM_WIDTH-1:0]dout_wire,dout_reg;
   always @(posedge clk)begin
     if(addr_en)addr_reg<=addr;
     else begin 
        addr_reg<=0;end end 
    generate 
      if( ADDR_PIPELINE=="TRUE") begin
       assign addr_wire=addr_reg;
      end 
     else if(ADDR_PIPELINE=="FALSE") begin  assign addr_wire=addr; end 
    endgenerate 
  
   always @(posedge clk )begin
     if(dout_en)dout_reg<=dout_wire;
     else begin  
     dout_reg<=0;end end
    generate 
     if(DOUT_PIPELINE=="TRUE")  begin assign dout=dout_reg; end 
     else if(DOUT_PIPELINE=="FALSE")begin assign dout=dout_wire; end 
    endgenerate 
   always @(posedge clk)begin
   if(rst)begin 
    dout_wire<=0; parity_out<=0;
   end 
   else begin 
      if(blk_select)begin
        if(wr_en) mem[addr_wire]<=din;
        if(rd_en) dout_wire<=mem[addr_wire];
        if(PARITY_ENABLE)parity_out=~(^dout_wire);
        else parity_out=0;
         end
      
   end 

   end 
   endmodule














