 %������뽫�ش����ݶ��������浽mat�ļ���������ݶ��������浽����mat�ļ�
%��ʱ��Ҫ������ƴ���������ݵĺ��档����Ҫȷ��ƴ���ϵ�������ǰ��������������ģ�
%���������������ô���������ݲ���Ҫ����ô��ǰ��������ݾͲ�����ƴ���ˡ�����
%���ݽ������������������塣rwguo 2020 5 10

clear;
%Data used by Alan is from 09 02 000000 to 09 07 000000
[FileName,PathName]=uigetfile('kak191312dhor.hor');%('*.hor','Input the file you want read')
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
%FormatString='%d- %d- %d  %d:%d:%d.%d %d %f %f %f %f %*[^\n]';
 %Ctr = textscan(fid, FormatString, 12, 'HeaderLines', 20, 'delimiter', ' ');

 line = fgetl(fid); % data format
 mid=line(8:end);
 mid(find(isspace(mid)))=[];
 dataformat=mid(1:end-1);
 line = fgetl(fid); % souce of data
 mid=line(18:end);
 mid(find(isspace(mid)))=[];
 datasource=mid(1:end-1);
 line = fgetl(fid); % station name
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Nstation=mid(1:end-1);
 line = fgetl(fid); % station code
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Cstation=mid(1:end-1)
 
 line = fgetl(fid); % Geodetic latitude
 mid=line(20:end);
 mid(find(isspace(mid)))=[];
 Lat=str2num(mid(1:end-1));
 
 line = fgetl(fid); % Geodetic longitude
 mid=line(20:end);
 mid(find(isspace(mid)))=[];
Long=str2num(mid(1:end-1));
 
 line = fgetl(fid); % elevation
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Ele=str2num(mid(1:end-1));
 
 line = fgetl(fid); % elevation
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Rep=mid(1:end-1);
 
  line = fgetl(fid); % sensor orientation
 mid=line(20:end);
 mid(find(isspace(mid)))=[];
Sor=mid(1:end-1);

 line = fgetl(fid); %sampling rate
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Srate=str2num(mid(1));
 
  line = fgetl(fid); % data interval type
 mid=line(16:end);
 mid(find(isspace(mid)))=[];
 Dinttyp=mid(1:end-1);
 % more information if you want
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
 line = fgetl(fid);
% line=  fgetl(fid);
 FormatString='%d- %d- %d  %d:%d:%f %f %f %f %f %f %*[^\n]';
 Ctr = textscan(fid, FormatString,  'HeaderLines', 1, 'delimiter', '');
 
 year2=Ctr{1};
 month2=Ctr{2};
 day2=Ctr{3};
 hour2=Ctr{4}; % this code is only used to handle hourly data.
 Deviation2=Ctr{8};
 BH2=Ctr{9};
 BZ2=Ctr{10};
 
 
  % ��ѽ����������
%  figure;
%  subplot(2,2,1)
%  plot(BH2);
%  subplot(2,2,2)
%  subplot(2,2,3)
%  plot(BZ2);
%  subplot(2,2,4)
%  plot(Deviation2)

 
 %������û�л����ݣ�Ŀǰֻ�г��ֻ����� �ͽ��������ݲ�Ҫ��ͬʱ��һ�����ݿ�Ͳ��ܱ���
 %�������ļ��ˡ�
 erro_d1=find(Deviation2==99999.0);
 erro_BH1=find(BH2==99999.0);
 erro_BZ1=find(BZ2==99999.0);
    
 if (~isempty(erro_d1))|| (~isempty(erro_BH1))||(~isempty(erro_BZ1))
   error('Bad Points in the data!!, it is better to drop all data');
 end
 
%�������Ƿ񱣴浽�������ݵĺ��棬����Ǿ�ѡ��1��������ǵ�һ�������ݣ�����Ҫ�½�
%�ļ�ѡ2�������ǰ�����������л��ģ���Ҳ��Ҫ�����½������ļ���
%   defaultanswer={'2'};
%  iflag=inputdlg({'�Ƿ����������ݺϲ�:1-�ϲ���2-�½�'},'',1,defaultanswer);
% 
%  if(iflag{1}=='1')
   [FileName,PathName]=uigetfile('*.mat');%('*.hor','Input the file you want rea
   file=strcat(PathName,FileName);  
   load(file);
   timed=day1(end);
   timem=month1(end);
   timey=year1(end);
   timeh=hour1(end);
   %���´�����Ҫ����ȷ�������Ƿ�����ǰ���������������ģ�������ǾͲ��ܱ��档
% if (timem==12)
%       if ((timey==year2(1)-1)&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==1)&&...
%                 (timed==31)&&(day2(1)==1))
%            
%       else
%          error('data is not consistent please check!!!') 
%       end
%        
%    elseif (timem==2)
%        if(mod(timey,4)==0)
%           if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==28)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%           end
%               
%        else
%            if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==29)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%           end
%        end
%    elseif(timem<=7)
%        if (mod(timem,2)==1)
%          if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==31)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%          end
%        else
%          if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==30)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%          end
%        end
%    else
%        if (mod(timem,2)==1)
%          if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==30)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%          end
%        else
%          if ((timey==year2(1))&&(timeh==23)&&(hour2(1)==0)&&(month2(1)==timem+1)&&...
%                 (timed==31)&&(day2(1)==1))
%           else 
%             error('data is not consistent please check!!!')   
%          end
%        end  
%     end
   
   year1=[year1;year2];
   month1=[month1;month2];
   day1=[day1;day2];
   hour1=[hour1;hour2]; % this code is only used to handle hourly data.
   Deviation1=[ Deviation1; Deviation2];
   BH1=[ BH1; BH2];
   BZ1=[BZ1;BZ2];
   save( file, 'year1','month1','day1','hour1','Deviation1','BH1','BZ1');
   disp('data is combined to file:');
   disp(file);
%  else
%    filed=[FileName(1:5),'.mat'];
%    defaultanswer={filed};
%    fflag=inputdlg({'���뱣��mat�ļ�����'},'',1,defaultanswer);
%    filei=fflag{1};
%     year1=year2;
%    month1=month2;
%    day1=day2;
%    hour1=hour2; % this code is only used to handle hourly data.
%    Deviation1=Deviation2;
%    BH1= BH2;
%    BZ1=BZ2;
%    save ( filei,  'year1','month1','day1','hour1','Deviation1','BH1','BZ1');
%    disp('data is saved to file:');
%    disp(filei);
%  end