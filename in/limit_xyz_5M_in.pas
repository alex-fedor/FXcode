program find_qV_limit_XYZ; {for BuyLimit and SellLimit}
uses crt,strings;
{const spread=0.0003;}
       {z_max=1970;}
var
z,z_min,z_max,p,p_min,p_max,l,l_min,l_max:word;
find,BuyLimit_Active,SellLimit_Active,Status_DONE:byte;

k,END_of_time,tau_0:word;
i,code:integer;

Day,S,week_day,Date,PositionX,week_day_ini,Profit_ini,Loss_ini,calendar,history,z_min_ini,z_max_ini,p_min_ini,p_max_ini,l_min_ini,l_max_ini,spread_ini,tau_0_ini,week:string;
OpenP,MaxP,MinP,CloseP,VolumeP:array[0..287]of real;

 BuyLimit_Open, BuyLimit_Profit, BuyLimit_Loss:real;
SellLimit_Open,SellLimit_Profit,SellLimit_Loss:real;

found_entries,missed_entries,volat_daily:string;

 BuyLimit_Active_Time, BuyLimit_Profit_Time, BuyLimit_Loss_Time:word;
SellLimit_Active_Time,SellLimit_Profit_Time,SellLimit_Loss_Time:word;

 BuyLimit_Profit_R, BuyLimit_Loss_R:string;
SellLimit_Profit_R,SellLimit_Loss_R:string;

 BuyLimit_Active_Time_R, BuyLimit_Profit_Time_R, BuyLimit_Loss_Time_R:string;
SellLimit_Active_Time_R,SellLimit_Profit_time_R,SellLimit_Loss_Time_R:string;

Report,Operation_type_R:string;

q_Volat,Volatility,Profit,Loss,spread:real;

BuyLimit_Floating_PL,SellLimit_Floating_PL:real;

f,f2,f3,f_ini:text;

Total_Profit,Daily_Profit:real;

BEGIN
{find day and creation of quotes DB}
clrscr;
assign(f_ini,'ini');
reset(f_ini);
readln(f_ini,spread_ini);      spread_ini:=Copy(spread_ini,14,Length(spread_ini));         val(spread_ini,spread,code);
readln(f_ini,tau_0_ini);        tau_0_ini:=Copy(tau_0_ini,14,Length(tau_0_ini));           val(tau_0_ini,tau_0,code);
readln(f_ini,calendar);          calendar:=Copy(calendar,14,Length(calendar));             week:=Copy(calendar,29,3);
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
{assign(f3,'limit_xyz_' +'tau'+ tau_0_ini + '_d' + week_day_ini + '.csv');}
if (tau_0<  10)                  then tau_0_ini:='000'+tau_0_ini;
if (tau_0>= 10) and (tau_0< 100) then tau_0_ini:='00'+tau_0_ini;
if (tau_0>=100) and (tau_0<1000) then tau_0_ini:='0'+tau_0_ini;
assign(f3,'d' + week_day_ini + '_t'+ tau_0_ini + '_limit_xyz_{' + week + '}.csv');
rewrite(f3);


for p:=p_min to p_max do
begin
Profit:=p*0.00001;

for l:=l_min to l_max do
begin
Loss:=l*0.00001;


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
writeln('Number of missed entries = ',287-END_of_time);
writeln;}
str(END_of_time,found_entries);
str(287-END_of_time,missed_entries);
Report:=Concat(S,',',found_entries,',',missed_entries);
{writeln(Report);}
{find day and creation of quotes DB}


q_Volat:=Volatility;

BuyLimit_Open:=OpenP[tau_0] - q_Volat + spread;
BuyLimit_Profit:=BuyLimit_Open + Profit;
BuyLimit_Loss:=  BuyLimit_Open - Loss;

SellLimit_Open:=OpenP[tau_0] + q_Volat;
SellLimit_Profit:=SellLimit_Open - Profit;
SellLimit_Loss:=  SellLimit_Open + Loss;

str(Volatility:5:5,volat_daily);
Report:=Concat(Report,',',volat_daily);
{writeln(Report);}
{writeln('Volatility = ',Volatility:5:5);
writeln('OpenP = ',OpenP[0]:5:5);
writeln;
writeln('BuyLimit_Open = ',BuyLimit_Open:5:5);
writeln('BuyLimit_Profit = ',BuyLimit_Profit:5:5);
writeln('BuyLimit_Loss = ',BuyLimit_Loss:5:5);
writeln;
writeln('SellLimit_Open = ',SellLimit_Open:5:5);
writeln('SellLimit_Profit = ',SellLimit_Profit:5:5);
writeln('SellLimit_Loss = ',SellLimit_Loss:5:5);
}





i:=tau_0;
BuyLimit_Active:=0; SellLimit_Active:=0; Status_DONE:=0;
BuyLimit_Floating_PL:=0; SellLimit_Floating_PL:=0;
repeat
i:=i+1;

{******************      BuyLimit      ************************************************************}
if (MinP[i] + spread <= BuyLimit_Open) and (BuyLimit_Active=0) and (SellLimit_Active=0) then
begin
BuyLimit_Active:=1;
BuyLimit_Active_Time:=i;
{writeln;
writeln('BuyLimit activated at ',BuyLimit_Active_Time);}
str(BuyLimit_Active_Time,BuyLimit_Active_Time_R);
{Report:=Concat(Report,',',BuyLimit_active_Time_R);}
{writeln(Report);}
end;

if BuyLimit_Active=1 then
begin
if (MaxP[i] + spread >= BuyLimit_Open) then BuyLimit_Floating_PL:=MaxP[i] - BuyLimit_Open;
if (MaxP[i] + spread <  BuyLimit_Open) then BuyLimit_Floating_PL:=MinP[i] - BuyLimit_Open;
{writeln('BuyLimit_Floating_PL = ',BuyLimit_Floating_PL*10000:3:2);}
end;

{******************      BuyLimit      ************************************************************}
{===================================================================================================}
{******************      SellLimit      ************************************************************}


if (MaxP[i] >= SellLimit_Open) and (SellLimit_Active=0) and (BuyLimit_Active=0) then
begin
SellLimit_Active:=1;
SellLimit_Active_Time:=i;
{writeln;
writeln('SellLimit activated at ',SellLimit_Active_Time);}
str(SellLimit_Active_Time,SellLimit_Active_Time_R);
{Report:=Concat(Report,',',SellLimit_active_Time_R);}
{writeln(Report);}
end;

if SellLimit_Active=1 then
begin
if (MinP[i] <= SellLimit_Open) then SellLimit_Floating_PL:=SellLimit_Open - MinP[i] - spread;
if (MinP[i] >  SellLimit_Open) then SellLimit_Floating_PL:=SellLimit_Open - MaxP[i] - spread;
{writeln('SellLimit_Floating_PL = ',SellLimit_Floating_PL*10000:3:2);}
end;


{******************      SellLimit      ************************************************************}

until ((BuyLimit_Open + BuyLimit_Floating_PL >= BuyLimit_Profit ) and (BuyLimit_Active=1))    or
      ((BuyLimit_Floating_PL <= BuyLimit_Loss - BuyLimit_Open) and (BuyLimit_Active=1))       or
      ((i=END_of_Time) and (BuyLimit_Active=1) and
(BuyLimit_Open + BuyLimit_Floating_PL < BuyLimit_Profit ) and (BuyLimit_Floating_PL > BuyLimit_Loss - BuyLimit_Open)) or

      ((i=END_of_Time) and (BuyLimit_Active=0) and (SellLimit_Active=0))                      or

      ((SellLimit_Open - SellLimit_Floating_PL <= SellLimit_Profit) and (SellLimit_Active=1))  or
      ((SellLimit_Floating_PL <= SellLimit_Open - SellLimit_Loss) and (SellLimit_Active=1))    or
      ((i=END_of_Time) and (SellLimit_Active=1) and
(SellLimit_Open - SellLimit_Floating_PL > SellLimit_Profit) and (SellLimit_Floating_PL > SellLimit_Open - SellLimit_Loss));


if ((BuyLimit_Open + BuyLimit_Floating_PL >= BuyLimit_Profit ) and (BuyLimit_Active=1)) then
begin
BuyLimit_Profit_Time:=i; BuyLimit_Active:=0; Status_DONE:=1;
str(BuyLimit_Profit_Time,BuyLimit_Profit_Time_R);
Operation_type_R:='BUY';
str(Profit*10000:3:1,BuyLimit_Profit_R);
Daily_Profit:=Profit*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyLimit_Active_Time_R,',',BuyLimit_Profit_Time_R,',',BuyLimit_Profit_R);
{writeln(Report);}
end;

if ((BuyLimit_Floating_PL <= BuyLimit_Loss - BuyLimit_Open) and (BuyLimit_Active=1)) then
begin
BuyLimit_Loss_Time:=i; BuyLimit_Active:=0; Status_DONE:=1;
str(BuyLimit_Loss_Time,BuyLimit_Loss_Time_R);
Operation_type_R:='BUY';
str((BuyLimit_Loss-BuyLimit_Open)*10000:3:1,BuyLimit_Loss_R);
Daily_profit:=(BuyLimit_Loss-BuyLimit_Open)*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyLimit_Active_Time_R,',',BuyLimit_Loss_Time_R,',',BuyLimit_Loss_R);
{writeln(Report);}
end;

if (i=END_of_Time) and (BuyLimit_Active=1) and
(BuyLimit_Open + BuyLimit_Floating_PL < BuyLimit_Profit ) and (BuyLimit_Floating_PL > BuyLimit_Loss - BuyLimit_Open) then
begin
BuyLimit_Loss_Time:=i; BuyLimit_Active:=0; Status_DONE:=1;
str(BuyLimit_Loss_Time,BuyLimit_Loss_Time_R);
Operation_type_R:='BUY';
str((BuyLimit_Floating_PL)*10000:3:1,BuyLimit_Loss_R);
Daily_profit:=(BuyLimit_Floating_PL)*10000;
Report:=Concat(Report,',',Operation_type_R,',',BuyLimit_Active_Time_R,',',BuyLimit_Loss_Time_R,',',BuyLimit_Loss_R);
{writeln(Report);}
end;





if (i=END_of_Time) and (BuyLimit_Active=0) and (SellLimit_Active=0) and (Status_DONE=0) then
begin;
Operation_type_R:='UNSPECIFIED';
Report:=Concat(Report,',',Operation_type_R,',0,0,0.0');
Daily_Profit:=0;
{writeln(Report);}
end;





if ((SellLimit_Open - SellLimit_Floating_PL <= SellLimit_Profit) and (SellLimit_Active=1)) then
begin
SellLimit_Profit_Time:=i; SellLimit_Active:=0; Status_DONE:=1;
str(SellLimit_Profit_Time,SellLimit_Profit_Time_R);
Operation_type_R:='SELL';
str(Profit*10000:3:1,SellLimit_Profit_R);
Daily_Profit:=Profit*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellLimit_Active_Time_R,',',SellLimit_Profit_Time_R,',',SellLimit_Profit_R);
{writeln(Report);}
end;

if ((SellLimit_Floating_PL <= SellLimit_Open - SellLimit_Loss) and (SellLimit_Active=1)) then
begin
{BuyLimit_Active:=0;}
SellLimit_Loss_Time:=i; SellLimit_Active:=0; Status_DONE:=1;
str(SellLimit_Loss_Time,SellLimit_Loss_Time_R);
Operation_type_R:='SELL';
str((SellLimit_Open-SellLimit_Loss)*10000:3:1,SellLimit_Loss_R);
Daily_Profit:=(SellLimit_Open-SellLimit_Loss)*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellLimit_Active_Time_R,',',SellLimit_Loss_Time_R,',',SellLimit_Loss_R);
{writeln(Report);}
end;

if (i=END_of_Time) and (SellLimit_Active=1) and
(SellLimit_Open - SellLimit_Floating_PL > SellLimit_Profit) and (SellLimit_Floating_PL > SellLimit_Open - SellLimit_Loss) then
begin
SellLimit_Loss_Time:=i; SellLimit_Active:=0; Status_DONE:=1;
str(SellLimit_Loss_Time,SellLimit_Loss_Time_R);
Operation_type_R:='SELL';
str((SellLimit_Floating_PL)*10000:3:1,SellLimit_Loss_R);
Daily_Profit:=(SellLimit_Floating_PL)*10000;
Report:=Concat(Report,',',Operation_type_R,',',SellLimit_Active_Time_R,',',SellLimit_Loss_Time_R,',',SellLimit_Loss_R);
{writeln(Report);}
end;

end;

Total_Profit:=Total_Profit + Daily_profit;
end;{week_day}


until eof(f2);{S='2011.01.31';}
close(f2);
{
clrscr;}

writeln(f3,Profit*10000:5:1,' ',Loss*10000:5:1,' ',Volatility:9:5,'  ',Total_Profit/(Profit*10000*52):9:3{,' || ',p/p_max*100:7:2,' ',l/l_max*100:7:2,' ',z/z_max*100:7:2});
end;{Current Volatility}
z:=z+1;


end;
l:=l+1;

end;
p:=p+1;

close(f3);

END.
