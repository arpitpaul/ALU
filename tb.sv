`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2024 19:32:59
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


class transaction;
randc bit [3:0] data_in_a;
randc bit [3:0] data_in_b;
randc bit [2:0] op;
bit [7:0] data_out;
endclass



interface alu_intf();
logic [3:0] data_in_a;
logic [3:0] data_in_b;
logic [2:0] op;
logic [7:0] data_out;
endinterface



class generator;
transaction t;
mailbox mbx;
integer i;
event done;


function new(mailbox mbx);
this.mbx=mbx;
endfunction


task run();
t=new();
for(i=0; i<30; i++)
begin
t.randomize();
mbx.put(t);
@(done);
#10;
end
endtask
endclass


class driver;
transaction t;
virtual alu_intf vif;
event done;
mailbox mbx;
function new(mailbox mbx);
this.mbx= mbx;
endfunction

task run();
forever
begin
t=new();
mbx.get(t);
vif.data_in_a=t.data_in_a;
vif.data_in_b=t.data_in_b;
vif.op=t.op;
->done;
#10;
end
endtask
endclass


class monitor;
virtual alu_intf vif;
transaction t;
mailbox mbx;


function new(mailbox mbx);
this.mbx=mbx;
endfunction



task run();
t=new();
forever begin
t.data_in_a=vif.data_in_a;
t.data_in_b=vif.data_in_b;
t.op = vif.op;
t.data_out=vif.data_out;
mbx.put(t);
#10;
end
endtask
endclass



class scoreboard;
mailbox mbx;
transaction t;
bit [7:0] res;

function new(mailbox mbx);
this.mbx=mbx;
endfunction


task run();
forever begin
mbx.get(t);

if(t.op==3'd0)
begin
res = t.data_in_a+t.data_in_b;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end

else if(t.op==3'd1)
begin
res = t.data_in_a-t.data_in_b;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end

else if(t.op==3'd2)
begin
res = t.data_in_a*t.data_in_b;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end


else if(t.op==3'd3)
begin
res = t.data_in_a/t.data_in_b;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end

else if(t.op==3'd4)
begin
res = t.data_in_a<<2'd3;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end

else if(t.op==3'd5)
begin
res = t.data_in_a>>2'd3;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end

else if(t.op==3'd6)
begin
res = t.data_in_b<<2'd3;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end


else if(t.op==3'd7)
begin
res = t.data_in_b>>2'd3;

if(res==t.data_out)
 $display("[SCO]: Test passed");
else
 $display("[SCO]: Test failed");
end


else
  begin
   $display("No operation is available, failed");
  end
#10;
end
endtask
endclass


class environment;
generator gen;
driver drv;

monitor mon;
scoreboard sco;

event gddone;

mailbox gdmbx, msmbx;

virtual alu_intf vif;

function new(mailbox gdmbx, mailbox msmbx);
this.gdmbx= gdmbx;
this.msmbx= msmbx;

gen = new(gdmbx);
drv = new(gdmbx);

mon= new(msmbx);
sco = new(msmbx);
endfunction


task run();
gen.done=gddone;
drv.done=gddone;

drv.vif=vif;
mon.vif=vif;


fork

gen.run();
drv.run();
mon.run();
sco.run();

join_any
endtask
endclass


module tb;
environment env;
alu_intf vif();
mailbox gdmbx;
mailbox msmbx;
alu dut(vif.data_in_a, vif.data_in_b, vif.op, vif.data_out);

initial begin
gdmbx= new();
msmbx=new();

env= new(gdmbx,msmbx);
env.vif=vif;

env.run();
#200;
$finish;


end
endmodule
