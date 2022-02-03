clear;
%Data used by Alan is from 09 02 000000 to 09 07 000000
[FileName,PathName]=uigetfile('*.asc','Input the file you want read');
file=strcat(PathName,FileName);
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

fileID = fopen('time.txt','a');


%Decide the time period you want to output
fprintf(fileID,'The data measureed from %s (mm) - %s (dd) %s (h) : %s (m) :%s (s) \n', start_month, start_day,...
        start_hour, start_minite,  start_second );
hour_mid=str2num(end_hour)+1;
end_hour= num2str(hour_mid);
fprintf(fileID,'to %s (mm) - %s (dd) %s (h) : %s (m) :%s (s) \n', end_month,  end_day,...
         end_hour,  end_minite,   end_second );

fclose(fileID);    

input_start_month=07;
input_start_day=24;
input_start_hour=22;
input_start_minite=00;
input_start_second=00;

input_end_month=07;
input_end_day=20;
input_end_hour=19;
input_end_minite=00;
input_end_second=00;
     