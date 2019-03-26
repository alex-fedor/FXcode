program quart_volat;
uses crt,strings;
const {S='2011.01.31';}
      {Volatility=0.0133;}
      Profit=0.001;
      spread=0.0003;
var
f,f2,f3:text;
Day,S,last_S,PositionX,Date,data,last_data,hourr_H_str,hourr_L_str,minut_H_str,minut_L_str,minut_P_str:string;
hourr_H,hourr_L,minut_H,minut_L:integer;
minut_P:word; code,i:longint;

{z:word;
find,BuyStop_Active,BuyStop_Done,SellStop_Active:byte;
k,END_of_time,BuyStop_Active_Time,SellStop_Active_Time,BuyStop_Profit_Time,BuyStop_Loss_Time,SellStop_Loss_Time,SellStop_Profit_Time:word;
i,code:integer;
PositionX,Date,Report,found_entries,missed_entries,volat_daily,BuyStop_Active_Time_R,SellStop_Active_Time_R,Day,S,week_day:string;
Operation_type_R,BuyStop_Profit_R,SellStop_Profit_R,BuyStop_Profit_Time_R,SellStop_Profit_time_R,BuyStop_Loss_Time_R,SellStop_Loss_Time_R,BuyStop_Loss_R,SellStop_Loss_R:string;}
{OpenP,MaxP,MinP,CloseP,VolumeP:array[0..1439]of real;
q_Volat,BuyStop_Open,BuyStop_Profit,SellStop_Profit,BuyStop_Loss:real;
SellStop_Open,SellStop_Loss:real;
BuyStop_Floating_PL,SellStop_Floating_PL,Volatility:real;}


{Total_Profit,Daily_Profit:real;}

BEGIN
clrscr;
assign(f,'usjp_iR_minutes.csv');
{assign(f2,'c_y13_w37i.csv');}
assign(f3,'usjp_iR_minutes_fill.csv');
rewrite(f3);

{reset(f2);}
{repeat
readln(f2,Day);}
reset(f);
readln(f,PositionX);
S:=Copy(PositionX,1,11);
last_S:=S;

reset(f);

repeat
i:=49999;
repeat

readln(f,PositionX);
i:=i+1;
S:=Copy(PositionX,1,11);
minut_P_str:=Copy(PositionX,12,5); val(minut_P_str,minut_P,code);
{writeln(minut_P);
writeln(i);
readln;
halt(0);}
data:=Copy(PositionX,17,Length(PositionX));

if (minut_P>i) and (S=last_S) then
begin
repeat
writeln(f3,S,i,last_data);
i:=i+1;
until minut_P=i;
{i:=i-1;}
end;

if minut_P=i then writeln(f3,S,minut_P,data);

last_data:=data;

until {i=51439}S<>last_S;
last_S:=S;

{if i=51439 then
begin
readln(f,PositionX);
writeln(f3,PositionX);
end;}

until eof(f) ;



{until eof(f2)};{S='2011.01.05';}
{close(f2);}

close(f);
close(f3);

END.
