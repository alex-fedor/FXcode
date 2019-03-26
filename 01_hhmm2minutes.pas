program quart_volat;
uses crt,strings;
const {S='2011.01.31';}
      {Volatility=0.0133;}
      Profit=0.001;
      spread=0.0003;
var
f,f2,f3:text;
Day,S,PositionX,Date,data,hourr_H_str,hourr_L_str,minut_H_str,minut_L_str:string;
hourr_H,hourr_L,minut_H,minut_L:integer;
minut_P:word; code:integer;

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
assign(f,'usjp_iR.csv');
{assign(f2,'c_y13_w37i.csv');}
assign(f3,'usjp_iR_minutes.csv');
rewrite(f3);

{reset(f2);}
{repeat
readln(f2,Day);}

reset(f);
repeat
readln(f,PositionX);

S:=Copy(PositionX,1,11);

hourr_H_str:=Copy(PositionX,12,1); val(hourr_H_str,hourr_H,code);
hourr_L_str:=Copy(PositionX,13,1); val(hourr_L_str,hourr_L,code);   
minut_H_str:=Copy(PositionX,15,1); val(minut_H_str,minut_H,code);  
minut_L_str:=Copy(PositionX,16,1); val(minut_L_str,minut_L,code);

data:=Copy(PositionX,17,Length(PositionX));

minut_P:= (hourr_H*10 + hourr_L)*60 + (minut_H*10 + minut_L) + 50000;

writeln(f3,S,minut_P,data);
until eof(f) ;

{until eof(f2)};{S='2011.01.05';}
{close(f2);}

close(f);
close(f3);

END.
