program stop_CRC; {for BuyStop and SellStop}
uses crt,strings;
{const spread=0.0003;}
       {z_max=1970;}
var
z,z_min,z_max,p,p_min,p_max,l,l_min,l_max:word;
find,BuyStop_Active,SellStop_Active,Status_DONE:byte;

k,END_of_time,tau_0:word;
i,code:integer;

Day,S,week_day,Date,PositionX,week_day_ini,Profit_ini,Loss_ini,calendar,history,z_min_ini,z_max_ini,p_min_ini,p_max_ini,l_min_ini,l_max_ini,spread_ini,tau_0_ini,week:string;
OpenP,MaxP,MinP,CloseP,VolumeP:array[0..1439]of real;

 BuyStop_Open, BuyStop_Profit, BuyStop_Loss:real;
SellStop_Open,SellStop_Profit,SellStop_Loss:real;

found_entries,missed_entries,volat_daily:string;

 BuyStop_Active_Time, BuyStop_Profit_Time, BuyStop_Loss_Time:word;
SellStop_Active_Time,SellStop_Profit_Time,SellStop_Loss_Time:word;

 BuyStop_Profit_R, BuyStop_Loss_R:string;
SellStop_Profit_R,SellStop_Loss_R:string;

 BuyStop_Active_Time_R, BuyStop_Profit_Time_R, BuyStop_Loss_Time_R:string;
SellStop_Active_Time_R,SellStop_Profit_time_R,SellStop_Loss_Time_R:string;

Report,Operation_type_R:string;

q_Volat,Volatility,Profit,Loss,spread:real;

BuyStop_Floating_PL,SellStop_Floating_PL:real;

f,f2,f3,f_ini:text;

Total_Profit,Daily_Profit:real;

BEGIN
{find day and creation of quotes DB}
clrscr;
assign(f_ini,'ini');
reset(f_ini);
readln(f_ini,spread_ini);      spread_ini:=Copy(spread_ini,14,Length(spread_ini));         val(spread_ini,spread,code);
readln(f_ini,tau_0_ini);        tau_0_ini:=Copy(tau_0_ini,14,Length(tau_0_ini));           val(tau_0_ini,tau_0,code);
readln(f_ini,calendar);          calendar:=Copy(calendar,14,Length(calendar));             week:=Copy(calendar,32,3);
readln(f_ini,history);            history:=Copy( history,14,Length( history));
readln(f_ini,week_day_ini);  week_day_ini:=Copy(week_day_ini,14,14);
{readln(f_ini,coef_ini);          coef_ini:=Copy(coef_ini,14,Length(coef_ini));     val(coef_ini,Coef,code);}
readln(f_ini,Profit_ini);      Profit_ini:=Copy(Profit_ini,14,Length(Profit_ini)); val(Profit_ini,Profit,code);
readln(f_ini,Loss_ini);          Loss_ini:=Copy(Loss_ini,14,Length(Loss_ini));     val(Loss_ini,Loss,code);
readln(f_ini);
readln(f_ini,z_min_ini);          z_min_ini:=Copy(z_min_ini,14,Length(z_min_ini));     val(z_min_ini,z_min,code);
readln(f_ini,z_max_ini);          z_max_ini:=Copy(z_max_ini,14,Length(z_max_ini));     val(z_max_ini,z_max,code);
readln(f_ini,p_min_ini);          p_min_ini:=Copy(p_min_ini,14,Length(p_min_ini));     val(p_min_ini,p_min,code);
readln(f_ini,p_max_ini);          p_max_ini:=Copy(p_max_ini,14,Length(p_max_ini));     val(p_max_ini,p_max,code);
readln(f_ini,l_min_ini);          l_min_ini:=Copy(l_min_ini,14,Length(l_min_ini));     val(l_min_ini,l_min,code);
readln(f_ini,l_max_ini);          l_max_ini:=Copy(l_max_ini,14,Length(l_max_ini));     val(l_max_ini,l_max,code);
close(f_ini);

assign(f2,calendar);{assign(f2,'calendar_20110221-20120217.csv');}
assign(f,history);{assign(f,'EURUSD_M1_20110221-20120217.csv');}
{assign(f3,'stop_xyz_' +'tau'+ tau_0_ini + '_d' + week_day_ini + '.csv');}
if (tau_0<  10)                  then tau_0_ini:='000'+tau_0_ini;
if (tau_0>= 10) and (tau_0< 100) then tau_0_ini:='00'+tau_0_ini;
if (tau_0>=100) and (tau_0<1000) then tau_0_ini:='0'+tau_0_ini;
assign(f3,'d' + week_day_ini + {'_t'+ tau_0_ini + }'_stop_CRC_{' + week + '}.csv');
rewrite(f3);


for p:=p_min to p_max do
begin
Profit:=p*0.00001;

{for l:=l_min to l_max do
begin
Loss:=l*0.00001;} Loss:=10;


for z:=z_min to z_max do
begin
append(f3);
Total_profit:=0;
Volatility:=z*0.00001;
reset(f2);


repeat
reset(f);
readln(f2,Day);
S:=Copy(Day,1,10);
week_day:=Copy(Day,12,12);
if week_day=week_day_ini{'4'} then
begin

k:=0; i:=-1;

repeat
k:=k+1;
readln(f,PositionX);
Date:=Copy(PositionX,1,10);
if (Date=S) then
begin
find:=1;
i:=i+1;
val(PositionX[18..24],OpenP[i],code);
val(PositionX[26..32],MaxP[i],code);
val(PositionX[34..40],MinP[i],code);
val(PositionX[42..48],CloseP[i],code);
val(PositionX[50..Length(PositionX)],VolumeP[i],code);
{writeln(i,' ',PositionX);}
end;

until ((Date<>S) and (find=1)) or (eof(f) and (find=0));

if (eof(f)) and (find=0) then
begin
close(f);
Report:=Concat(S,',0,0,0,NO_DATA,0,0,0');
{writeln(Report);}
end;

if ((Date<>S) and (find=1)) then
begin
close(f);
find:=0;
END_of_time:=i;

{writeln('Date: ',S);
writeln('Number of  found entries = ',END_of_time);
writeln('Number of missed entries = ',1439-END_of_time);
writeln;}
str(END_of_time,found_entries);
str(1439-END_of_time,missed_entries);
Report:=Concat(S,',',found_entries,',',missed_entries);
{writeln(Report);}
{find day and creation of quotes DB}
repeat
END_of_Time:=tau_0 + l_max;

q_Volat:=Volatility;

BuyStop_Open:=OpenP[tau_0] + q_Volat + spread;
BuyStop_Profit:=BuyStop_Open + Profit;
BuyStop_Loss:=  BuyStop_Open - Loss;

SellStop_Open:=OpenP[tau_0] - q_Volat;
SellStop_Profit:=SellStop_Open - Profit;
SellStop_Loss:=  SellStop_Open + Loss;

str(Volatility:5:5,volat_daily);
Report:=Concat(Report,',',volat_daily);
{writeln(Report);}
{writeln('Volatility = ',Volatility:5:5);
writeln('OpenP = ',OpenP[0]:5:5);
writeln;
writeln('BuyStop_Open = ',BuyStop_Open:5:5);
writeln('BuyStop_Profit = ',BuyStop_Profit:5:5);
writeln('BuyStop_Loss = ',BuyStop_Loss:5:5);
writeln;
writeln('SellStop_Open = ',SellStop_Open:5:5);
writeln('SellStop_Profit = ',SellStop_Profit:5:5);
writeln('SellStop_Loss = ',SellStop_Loss:5:5);
}





i:=tau_0;
BuyStop_Active:=0; SellStop_Active:=0; Status_DONE:=0;
BuyStop_Floating_PL:=0; SellStop_Floating_PL:=0;
repeat
i:=i+1;

{******************      BuyStop      ************************************************************}
if (MaxP[i] + spread >= BuyStop_Open) and (BuyStop_Active=0) and (SellStop_Active=0) then
begin
BuyStop_Active:=1;
BuyStop_Active_Time:=i;
{writeln;
writeln('BuyStop activated at ',BuyStop_Active_Time);}
str(BuyStop_Active_Time,BuyStop_Active_Time_R);
Report:=Concat(Report,',',BuyStop_active_Time_R);
{writeln(Report);}
end;

if BuyStop_Active=1 then
begin
if (MaxP[i] + spread >= BuyStop_Open) then BuyStop_Floating_PL:=MaxP[i]{ + spread} - BuyStop_Open;
if (MaxP[i] + spread <  BuyStop_Open) then BuyStop_Floating_PL:=MinP[i]{ + spread} - BuyStop_Open;
{writeln('BuyStop_Floating_PL = ',BuyStop_Floating_PL*10000:3:2);}
end;

{******************      BuyStop      ************************************************************}
{===================================================================================================}
{******************      SellStop      ************************************************************}


if (MinP[i] <= SellStop_Open) and (SellStop_Active=0) and (BuyStop_Active=0) then
begin
SellStop_Active:=1;
SellStop_Active_Time:=i;
{writeln;
writeln('SellStop activated at ',SellStop_Active_Time);}
str(SellStop_Active_Time,SellStop_Active_Time_R);
Report:=Concat(Report,',',SellStop_active_Time_R);
{writeln(Report);}
end;

if SellStop_Active=1 then
begin
if (MinP[i] <= SellStop_Open) then SellStop_Floating_PL:=SellStop_Open - MinP[i] - spread;
if (MinP[i] >  SellStop_Open) then SellStop_Floating_PL:=SellStop_Open - MaxP[i] - spread;
{writeln('SellStop_Floating_PL = ',SellStop_Floating_PL*10000:3:2);}
end;


{******************      SellStop      ************************************************************}

until ((BuyStop_Open + BuyStop_Floating_PL >= BuyStop_Profit ) and (BuyStop_Active=1))    or
      ((BuyStop_Floating_PL <= BuyStop_Loss - BuyStop_Open) and (BuyStop_Active=1))       or
      ((i=END_of_Time) and (BuyStop_Active=1) and
(BuyStop_Open + BuyStop_Floating_PL < BuyStop_Profit) and (BuyStop_Floating_PL > BuyStop_Loss - BuyStop_Open)) or

      ((i=END_of_Time) and (BuyStop_Active=0) and (SellStop_Active=0))                     or

      ((SellStop_Open - SellStop_Floating_PL <= SellStop_Profit) and (SellStop_Active=1))  or
      ((SellStop_Floating_PL <= SellStop_Open - SellStop_Loss) and (SellStop_Active=1))    or
      ((i=END_of_Time) and (SellStop_Active=1) and
(SellStop_Open - SellStop_Floating_PL > SellStop_Profit) and (SellStop_Floating_PL > SellStop_Open - SellStop_Loss));


if ((BuyStop_Open + BuyStop_Floating_PL >= BuyStop_Profit ) and (BuyStop_Active=1)) then
begin
BuyStop_Profit_Time:=i; BuyStop_Active:=0; Status_DONE:=1;
str(BuyStop_Profit_Time,BuyStop_Profit_Time_R);
Operation_type_R:='BUY';
str(Profit*10000:3:1,BuyStop_Profit_R);
Daily_Profit:=Profit*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyStop_Active_Time_R,',',BuyStop_Profit_Time_R,',',BuyStop_Profit_R);
{writeln(Report);}
end;

if ((BuyStop_Floating_PL <= BuyStop_Loss - BuyStop_Open) and (BuyStop_Active=1)) then
begin
BuyStop_Loss_Time:=i; BuyStop_Active:=0; Status_DONE:=1;
str(BuyStop_Loss_Time,BuyStop_Loss_Time_R);
Operation_type_R:='BUY';
str((BuyStop_Loss-BuyStop_Open)*10000:3:1,BuyStop_Loss_R);
Daily_profit:=(BuyStop_Loss-BuyStop_Open)*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyStop_Active_Time_R,',',BuyStop_Loss_Time_R,',',BuyStop_Loss_R);
{writeln(Report);}
end;

if (i=END_of_Time) and (BuyStop_Active=1) and
(BuyStop_Open + BuyStop_Floating_PL < BuyStop_Profit) and (BuyStop_Floating_PL > BuyStop_Loss - BuyStop_Open) then
begin
BuyStop_Loss_Time:=i; BuyStop_Active:=0; Status_DONE:=1;
str(BuyStop_Loss_Time,BuyStop_Loss_Time_R);
Operation_type_R:='BUY';
str((BuyStop_Floating_PL)*10000:3:1,BuyStop_Loss_R);
Daily_profit:=(BuyStop_Floating_PL)*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyStop_Active_Time_R,',',BuyStop_Loss_Time_R,',',BuyStop_Loss_R);
{writeln(Report);}
end;





if (i=END_of_Time) and (BuyStop_Active=0) and (SellStop_Active=0) and (Status_DONE=0) then
begin;
Operation_type_R:='UNSPECIFIED';
Report:=Concat(Report,',',Operation_type_R,',0,0,0.0');
Daily_Profit:=0;
{writeln(Report);}
end;





if ((SellStop_Open - SellStop_Floating_PL <= SellStop_Profit) and (SellStop_Active=1)) then
begin
SellStop_Profit_Time:=i; SellStop_Active:=0; Status_DONE:=1;
str(SellStop_Profit_Time,SellStop_Profit_Time_R);
Operation_type_R:='SELL';
str(Profit*10000:3:1,SellStop_Profit_R);
Daily_Profit:=Profit*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellStop_Active_Time_R,',',SellStop_Profit_Time_R,',',SellStop_Profit_R);
{writeln(Report);}
end;

if ((SellStop_Floating_PL <= SellStop_Open - SellStop_Loss) and (SellStop_Active=1)) then
begin
{BuyStop_Active:=0;}
SellStop_Loss_Time:=i; SellStop_Active:=0; Status_DONE:=1;
str(SellStop_Loss_Time,SellStop_Loss_Time_R);
Operation_type_R:='SELL';
str((SellStop_Open-SellStop_Loss)*10000:3:1,SellStop_Loss_R);
Daily_Profit:=(SellStop_Open-SellStop_Loss)*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellStop_Active_Time_R,',',SellStop_Loss_Time_R,',',SellStop_Loss_R);
{writeln(Report);}
end;

if (i=END_of_Time) and (SellStop_Active=1) and
(SellStop_Open - SellStop_Floating_PL > SellStop_Profit) and (SellStop_Floating_PL > SellStop_Open - SellStop_Loss) then
begin
SellStop_Loss_Time:=i; SellStop_Active:=0; Status_DONE:=1;
str(SellStop_Loss_Time,SellStop_Loss_Time_R);
Operation_type_R:='SELL';
str((SellStop_Floating_PL)*10000:3:1,SellStop_Loss_R);
Daily_profit:=(SellStop_Floating_PL)*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellStop_Active_Time_R,',',SellStop_Loss_Time_R,',',SellStop_Loss_R);
{writeln(Report);}
end;

if ((Daily_profit>=0) and (Daily_profit<Profit*10000)) then Daily_profit:=0;
if Daily_profit<0 then Daily_profit:=-1;
if Daily_profit>=Profit*10000 then Daily_profit:=1;

writeln(f3,{Profit*10000:5:1,' ',Loss*10000:5:1,' ',Volatility:9:5,'  ',}Daily_profit:0:0{,' ',tau_0,' ',END_of_Time});
tau_0:=END_of_Time;
until (END_of_Time>=1439); tau_0:=0;

end;

Total_Profit:=Total_Profit + Daily_profit;
end;{week_day}


until eof(f2);{S='2011.01.31';}
close(f2);
{
clrscr;}

{writeln(f3,Profit*10000:5:1,' ',Loss*10000:5:1,' ',Volatility:9:5,'  ',Total_Profit/(Profit*10000*52):9:3
,' || ',p/p_max*100:7:2,' ',l/l_max*100:7:2,' ',z/z_max*100:7:2);}
end;{Current Volatility}
z:=z+1;


{end;
l:=l+1;}

end;
p:=p+1;

close(f3);

END.
