function [Exf1,Eyf1,Hxf1,Hyf1,fw] = getMTdatadecimate(Ex,Ey,Hx,Hy,Fs,para,sseg)



total=length(Ex);
dt=1/Fs;
%---------------------------------------------------------------------------
% Ԥ�׻�����֣�
ex=diff1(total,Ex)/dt;%��ֺ��EX
ey=diff1(total,Ey)/dt;%��ֺ��EY
hx=diff1(total,Hx)/dt;%��ֺ��HX
hy=diff1(total,Hy)/dt;%��ֺ��HY
total=total-1;
%---------------------------------------------------------------------------
%�趨���ڲ������β���1
Lwnum=length(para.Lw);
overlap=para.overlap;



Lw=para.Lw;
%�趨����Ƶ��
%�����Ƶ�ʣ����Լ�ѡ���ļ�����л���Ƶ�ʣ�ֱ���Լ��趨�����Ƶ��Ϊֹ��
%ֵ��ע����ǣ���ͬ���ڳ���ѡ��Ƶ�ʿ�������ͬ�ġ�

for n=1:length(sseg)
    
Wk(1,n)=(sseg(n,1)+sseg(n,2))/2/Lw*Fs;

Li(1,n)=sseg(n,1);
Ri(1,n)=sseg(n,2);

end
fsegnum=length(sseg);

%�趨���ڲ������β���2
maxfsegnum=total;

spa=Lw-overlap;%����������ļ��


Exf1=cell(1,max(fsegnum));
%---------------------------------------------------------------------------
%���ڴ���������
wnum=zeros(1,Lwnum);%���ڳ��Ȼ��ֶ���
num_chose=zeros(1,max(fsegnum));



for nowwindow=1

    seg_start=1;%�����

    while seg_start+Lw(nowwindow)-1<=total
        wnum(nowwindow)=wnum(nowwindow)+1;
        %FFT���Ӵ��������������������Ӱ��
        fex=fft(ex( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fey=fft(ey( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fhx=fft(hx( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        fhy=fft(hy( seg_start:seg_start+Lw(nowwindow)-1 ).*hamming(Lw(nowwindow)),Lw(nowwindow)).'./1j./(([1:Lw(nowwindow)]-1)*Fs/Lw(nowwindow))/(Lw(nowwindow)/2);
        %Ƶ�ʶδ���
        for j=1:fsegnum(nowwindow) %��ǰ���ڸ�Ƶ�ʶε����׺ͻ��ף��������ס����׵�ֵ���밴Ƶ�ʶδ洢�����ס�������ֵ������
            %��ض�ɸѡ
            
            Exf=fex(Li(nowwindow,j):Ri(nowwindow,j));%ѡ��ָ��Ƶ�ʵ����ݶΣ���Ϊһ��������FFT������ݺ��в�ͬƵ�ʵ����ݡ�
            Eyf=fey(Li(nowwindow,j):Ri(nowwindow,j));
            Hxf=fhx(Li(nowwindow,j):Ri(nowwindow,j));
            Hyf=fhy(Li(nowwindow,j):Ri(nowwindow,j));
            

                      
            mapfac=j+max(fsegnum)-fsegnum(nowwindow);%������Ƕ�ӦƵ�ʵ���
            
            num_chose(mapfac)=num_chose(mapfac)+1;%ÿ�η���Ҫ����ͬƵ������ݸ���
            Exf1{mapfac}{num_chose(mapfac)}=Exf;
            Eyf1{mapfac}{num_chose(mapfac)}=Eyf;
            Hxf1{mapfac}{num_chose(mapfac)}=Hxf;
            Hyf1{mapfac}{num_chose(mapfac)}=Hyf;
            fw(mapfac)=Wk(1,j);
            
            
        end
        seg_start=seg_start+spa(nowwindow);%������һ�������
    end
    
end

end

