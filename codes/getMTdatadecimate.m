function [Exf1,Eyf1,Hxf1,Hyf1,fw] = getMTdatadecimate(Ex,Ey,Hx,Hy,Fs,para,sseg)



total=length(Ex);
dt=1/Fs;
%---------------------------------------------------------------------------
% 预白化（差分）
ex=diff1(total,Ex)/dt;%差分后的EX
ey=diff1(total,Ey)/dt;%差分后的EY
hx=diff1(total,Hx)/dt;%差分后的HX
hy=diff1(total,Hy)/dt;%差分后的HY
total=total-1;
%---------------------------------------------------------------------------
%设定窗口参数及段参数1
Lwnum=length(para.Lw);
overlap=para.overlap;



Lw=para.Lw;
%设定中心频率
%从最高频率，按自己选定的间隔进行划分频率，直到自己设定的最低频率为止。
%值得注意的是，不同窗口长度选的频率可以是相同的。

for n=1:length(sseg)
    
Wk(1,n)=(sseg(n,1)+sseg(n,2))/2/Lw*Fs;

Li(1,n)=sseg(n,1);
Ri(1,n)=sseg(n,2);

end
fsegnum=length(sseg);

%设定窗口参数及段参数2
maxfsegnum=total;

spa=Lw-overlap;%各窗口起点间的间隔


Exf1=cell(1,max(fsegnum));
%---------------------------------------------------------------------------
%窗口处理主过程
wnum=zeros(1,Lwnum);%窗口长度划分段数
num_chose=zeros(1,max(fsegnum));



for nowwindow=1

    seg_start=1;%段起点

    while seg_start+Lw(nowwindow)-1<=total
        wnum(nowwindow)=wnum(nowwindow)+1;
        %FFT、加窗（海明窗）并消除差分影响
        fex=fft(ex( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fey=fft(ey( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fhx=fft(hx( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fhy=fft(hy( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        %频率段处理
        for j=1:fsegnum(nowwindow) %求当前窗口该频率段的自谱和互谱，并将自谱、互谱的值加入按频率段存储的自谱、互谱数值集合中
            %相关度筛选
            
            Exf=fex(Li(nowwindow,j):Ri(nowwindow,j));%选定指定频率的数据段，因为一个窗口内FFT后的数据含有不同频率的数据。
            Eyf=fey(Li(nowwindow,j):Ri(nowwindow,j));
            Hxf=fhx(Li(nowwindow,j):Ri(nowwindow,j));
            Hyf=fhy(Li(nowwindow,j):Ri(nowwindow,j));
            

                      
            mapfac=j+max(fsegnum)-fsegnum(nowwindow);%代表的是对应频率的数
            
            num_chose(mapfac)=num_chose(mapfac)+1;%每次符合要求相同频点的数据个数
            Exf1{mapfac}{num_chose(mapfac)}=Exf;
            Eyf1{mapfac}{num_chose(mapfac)}=Eyf;
            Hxf1{mapfac}{num_chose(mapfac)}=Hxf;
            Hyf1{mapfac}{num_chose(mapfac)}=Hyf;
            fw(mapfac)=Wk(1,j);
            
            
        end
        seg_start=seg_start+spa(nowwindow);%移至下一窗口起点
    end
    
end

end

