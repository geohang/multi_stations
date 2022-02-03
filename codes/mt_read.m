clear;
na={'01','02','04','10','11','13'};
for nnn=1:6
%Data used by Alan is from 09 02 000000 to 09 07 000000

file=['emsl',na{nnn},'.asc'];
datablock=0;
datablock_read=0;
max_end=0;
erro_times=0;
read_start=0;
%out_fild=zeros(6,100000);

% Get time period included in the data%
%-------------------------------------%
fid=fopen(file,'r');
while (~feof(fid))
datablock=datablock+1;
%Read 6 charater site information and 10 start time information 
data_inf=textscan(fid,'%16s',1);
% test isempty(data_inf{1});
if isempty(data_inf{1})
    end_month=month_inf;
    end_day=day_inf;
    end_hour=hour_inf;
    end_minite=minite_inf;
    end_second=second_inf;
    break;
end
a=data_inf{1}{1};
site_inf=a(1:6);
year_inf=a(7:8);
month_inf=a(9:10);
day_inf=a(11:12);
hour_inf=a(13:14);
minite_inf=a(15:16);
second_inf='00';
if (datablock==1)
    start_month=month_inf;
    start_day=day_inf;
    start_hour=hour_inf;
    start_minite=minite_inf;
    start_second=second_inf;
end
b=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',60);
end

fclose(fid);


     
input_start_month=07;
input_start_day=25;
input_start_hour=00;
input_start_minite=00;
input_start_second=00;

input_end_month=09;
input_end_day=20;
input_end_hour=19;
input_end_minite=00;
input_end_second=00;
       
     
% input_start_time=input('Input the start time you want display:(mm dd hour minite second)','s');
% %
% input_start_month=str2num(input_start_time(1:2));
% input_start_day=str2num(input_start_time(3:4));
% input_start_hour=str2num(input_start_time(5:6));
% input_start_minite=str2num(input_start_time(7:8));
% input_start_second=str2num(input_start_time(9:10));
% input_end_time=input('Input the end point you want display:','s');
% input_end_month=str2num(input_end_time(1:2));
% input_end_day=str2num(input_end_time(3:4));
% input_end_hour=str2num(input_end_time(5:6));
% input_end_minite=str2num(input_end_time(7:8));
% input_end_second=str2num(input_end_time(9:10));
%======start to read the data=======$
%Data discription
% The 5 fild components were sampled at 20 s,data block looks like 
% EMSL018509161300
% 26  615   53   93  195   21  615   53   97  195   24  617   56   93  187
% where at 13:00:20, the Hx in units of 1/10 nT is 2.6 nT,Hy is 61.5 nT ...
% Hz is 5.3nT, Ex in uints of 1/10 mV/km is 9.3 mV/km, Ey=19.5mV/km.


fid=fopen(file,'r');
while (~feof(fid))
%Read 6 charater site information and 10 start time information 
data_inf=textscan(fid,'%16s',1);
% test isempty(data_inf{1});
if isempty(data_inf{1})
    disp('end of file!');
    break;
end
a=data_inf{1}{1};
site_inf=a(1:6);
year_inf=str2num(a(7:8));
month_inf=str2num(a(9:10));
day_inf=str2num(a(11:12));
hour_inf=str2num(a(13:14));
minite_inf=str2num(a(15:16));
second_inf=0;
% Read the field components, Hx, Hy,Hz,Ex,Ey at sequence! 
b=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',60);
% Output data from time set by the user%
if ((input_start_month==month_inf)&&(input_start_day==day_inf)&&(input_start_hour==hour_inf))
% Find the start point for reading
   total_time=input_start_minite*60+input_start_second;
   data_start=round(total_time/20)+1;
   input_start_second_true=data_start*20;
   Hx1=[b{1};b{6};b{11}];% 1,6,11 columns are
   Hy1=[b{2};b{7};b{12}];
   Hz1=[b{3};b{8};b{13}];
   Ex1=[b{4};b{9};b{14}];
   Ey1=[b{5};b{10};b{15}];
   %Read data from the set time
   Hx1_mid=Hx1(data_start:end);
   Hy1_mid=Hy1(data_start:end);
   Hz1_mid=Hz1(data_start:end);
   Ex1_mid=Ex1(data_start:end);
   Ey1_mid=Ey1(data_start:end);
   read_start=1;
   %Read data into a variable
   out_Hx1=Hx1_mid;
   out_Hy1=Hy1_mid;
   out_Hz1=Hz1_mid;
   out_Ex1=Ex1_mid;
   out_Ey1=Ey1_mid;
   n_time=length(Ex1);
   out_time=(0:20:(n_time-data_start)*20);
elseif((input_end_month==month_inf)&&(input_end_day==day_inf)&&(input_end_hour==hour_inf))
   %Find the end point for reading
   total_time=input_end_minite*60+input_end_second;
   data_end=round(total_time/20);
   input_end_second_true=data_end*20;
   if data_end==0
      disp('At last point of the data, set by user') 
      break;
   end
   Hx1=[b{1};b{6};b{11}];% 1,6,11 columns are
   Hy1=[b{2};b{7};b{12}];
   Hz1=[b{3};b{8};b{13}];
   Ex1=[b{4};b{9};b{14}];
   Ey1=[b{5};b{10};b{15}];
   %Read data until the end point is arrived
   Hx1_mid=Hx1(data_end:end);
   Hy1_mid=Hy1(data_end:end);
   Hz1_mid=Hz1(data_end:end);
   Ex1_mid=Ex1(data_end:end);
   Ey1_mid=Ey1(data_end:end);
   %Read data to a global variable
   out_Hx1=[out_Hx1;Hx1_mid];
   out_Hy1=[out_Hy1;Hy1_mid];
   out_Hz1=[out_Hz1;Hz1_mid];
   out_Ex1=[out_Ex1;Ex1_mid];
   out_Ey1=[out_Ey1;Ey1_mid];
   out_time=[out_time,(out_time(end)+20):20:(out_time(end)+20*data_end)];
   break;
elseif ((input_start_month<=month_inf)&&(read_start==1))
    % Read data in the blocks
   datablock_read=datablock_read+1;
   Hx1=[b{1};b{6};b{11}];% 1,6,11 columns are
   Hy1=[b{2};b{7};b{12}];
   Hz1=[b{3};b{8};b{13}];
   Ex1=[b{4};b{9};b{14}];
   Ey1=[b{5};b{10};b{15}]; 
   out_Hx1=[out_Hx1;Hx1];
   out_Hy1=[out_Hy1;Hy1];
   out_Hz1=[out_Hz1;Hz1];
   out_Ex1=[out_Ex1;Ex1];
   out_Ey1=[out_Ey1;Ey1];
   if(length(Ex1)~=180)
       disp('Less than one hour');
       disp(length(Ex1));
       fprintf('Less data happened in %i %i %i ',month_inf,day_inf,hour_inf)
   end
   out_time=[out_time,(out_time(end)+20):20:(out_time(end)+20*180)];
end

% Find out the continuous data blocks or bad data  in the reading file
if read_start==1
   erro_n=find(Hx1(:)==-9999);
   if ~isempty(erro_n)
     mid_start=min(erro_n);
     mid_end=max(erro_n);
     erro_times=erro_times+1;
   end
end
%Find the starting point of bad data
end
figure(1);
 plot(out_time,out_Hx1+4000);
 hold on;
 plot(out_time,out_Hy1+3000);
 plot(out_time,out_Hz1);
 plot(out_time,out_Ex1+2000);
 plot(out_time,out_Ey1+1000);
 out_time1=out_time';
% fid1=fopen('rawdata_9_13.dat','wt');
% fprintf(fid1,'%12.2f %12.2f %12.2f %12.2f %12.2f %12.2f\n',[out_time;out_Hx1';out_Hy1';out_Hz1';out_Ex1';out_Ey1']);
% fclose(fid1);

if(feof(fid))
disp('file reading finished');
end
 disp('bad data blocks in the file');
 disp(erro_times);
 fclose(fid);
%plot out the time series%

 
%Data processing
%find the erroneous data points in the components
 n_Hx1_error=find(out_Hx1(:)==-9999);
 n_Hy1_error=find(out_Hy1(:)==-9999);
 n_Hz1_error=find(out_Hz1(:)==-9999);
 n_Ex1_error=find(out_Ex1(:)==-9999);
 n_Ey1_error=find(out_Ey1(:)==-9999);
 %erroneous points in the data
 n_Hx1=length(n_Hx1_error);
 n_Hy1=length(n_Hy1_error);
 n_Hz1=length(n_Hz1_error);
 n_Ex1=length(n_Ex1_error);
 n_Ey1=length(n_Ey1_error);
 % Erroneous data are interpolated based on a five-point median filter
 % approach
 %for out_Ex1
 for i=1:n_Ex1
   n_i=n_Ex1_error(i);
   out_Ex1(n_i)=median(out_Ex1(n_i-2:n_i+2));
 end
  %for out_Ey1
   for i=1:n_Ey1
     n_i=n_Ey1_error(i);
     out_Ey1(n_i)=median(out_Ey1(n_i-2:n_i+2));
   end
   %for out_Hx1
   for i=1:n_Hx1
     n_i=n_Hx1_error(i);
     out_Hx1(n_i)=median(out_Hx1(n_i-2:n_i+2));
   end
   %for out_Hy1
  for i=1:n_Hy1
    n_i=n_Hy1_error(i);
    out_Hy1(n_i)=median(out_Hy1(n_i-2:n_i+2));
  end
   %for out_Hz1
  for i=1:n_Hz1
    n_i=n_Hz1_error(i);
    out_Hz1(n_i)=median(out_Hz1(n_i-2:n_i+2));
  end
  
  
ts=20;
Lw=128;
level=4;
overlap=32;
load B.mat
[Extemp,Eytemp,Hxtemp,Hytemp,fw] = MTfourier(out_Ex1,out_Ey1,out_Hx1,out_Hy1,bstest,level,Lw,overlap);

Exstat{nnn}=Extemp;
Eystat{nnn}=Eytemp;
Hxstat{nnn}=Hxtemp;
Hystat{nnn}=Hytemp;
end
  
  
  
  
  
% figure(2);
%  plot(out_time,out_Hx1+4000);
%  hold on;
%  plot(out_time,out_Hy1+3000);
%  plot(out_time,out_Hz1);
%  plot(out_time,out_Ex1+2000);
%  plot(out_time,out_Ey1+1000);
 
% fid1=fopen('data_9_13.dat','wt');
% fprintf(fid1,'%12.2f %12.2f %12.2f %12.2f %12.2f %12.2f\n',[out_time;out_Hx1';out_Hy1';out_Hz1';out_Ex1';out_Ey1']);
% fclose(fid1);
 %Fourier transformation

 %==Divid the data into n_segment sections ===%
 %==calculate the fft coefficients for n_segment sections%
 %calculation for crossspectra and autospectra for ExHy and neighboring harmonics
 %are windowerd by parzen frequency window
 
 
% fft_Ex1=fft_model1(out_Ex1,1440);
% fft_Hy1=fft_model1(out_Hy1,1440);
% fft_Hx1=fft_model1(out_Hx1,1440);
% fft_Ey1=fft_model1(out_Ey1,1440);
% %fft_Hz1=fft_model1(out_Hz1,1440);
% n_segment=size(fft_Hy1,1);
% n_data=size(fft_Ex1,2);
%parzen frequency averaged crosspectra
% [powexby_temp,center_f]=parzenwin_frequency(fft_Ex1,fft_Hy1,ts);
% %parzen frequency averaged autospectra
% [powbxbx_temp,center_f]=parzenwin_frequency(fft_Hx1,fft_Hx1,ts);
% [powexbx_temp,center_f]=parzenwin_frequency(fft_Ex1,fft_Hx1,ts);
% [powbxby_temp,center_f]=parzenwin_frequency(fft_Hx1,fft_Hy1,ts);
% [powbyby_temp,center_f]=parzenwin_frequency(fft_Hy1,fft_Hy1,ts);
% [powbybx_temp,center_f]=parzenwin_frequency(fft_Hy1,fft_Hx1,ts);
% ===used to calculate the impedance and the apparent resistivity and phase
%
% [z,rho,pha,fre_out]=impedance(fft_Ex1,fft_Ey1,fft_Hx1,fft_Hy1,ts);


% 
% for i=1:n_segment
%     powxy_temp=parzenwin_frequency(fft_Ex1,fft_Hy1,ts);
%     powxy(i,:)=powxy_temp;
% end
%     
%  n_data1=2^nextpow2(n_data);
%  x=fft(out_Ex1,n_data1);
%  pxx=x.*conj(x)/n_data1;
%  f=1*(0:(n_data1/2))/(ts*n_data1);
%  T=1./f(2:(n_data1/2));
%  figure(2);
%  semilogx(f,pxx(1:n_data1/2+1));
 