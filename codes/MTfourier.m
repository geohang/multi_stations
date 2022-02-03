function [Extemp,Eytemp,Hxtemp,Hytemp,fw] = MTfourier(Ex,Ey,Hx,Hy,B,level,Lw,overlap)
%UNTITLED11 此处显示有关此函数的摘要
%   此处显示详细说明


% file1='402C5.chn';
fc=[0.2154,0.1911,0.1307,0.0705];


rt=find(B(:,1)==1);
sseg=B(rt,2:3);

para.Lw=Lw;
para.overlap=overlap;
Fs=1/20;

[Exf2{1},Eyf2{1},Hxf2{1},Hyf2{1},fw2{1}] = getMTdatadecimate(Ex,Ey,Hx,Hy,Fs,para,sseg);


for i=2:level
    [Ex] = dcimte(Ex,fc);
    [Ey] = dcimte(Ey,fc);
    [Hx] = dcimte(Hx,fc);
    [Hy] = dcimte(Hy,fc);
    Fs=Fs/4;
    rt=find(B(:,1)==i);
    sseg=B(rt,2:3); 
    [Exf2{i},Eyf2{i},Hxf2{i},Hyf2{i},fw2{i}] = getMTdatadecimate(Ex,Ey,Hx,Hy,Fs,para,sseg);
end


n=1;
for j=1:length(fw2)
    for i=1:length(fw2{j})
        Extemp{n}=Exf2{j}{i};
        Eytemp{n}=Eyf2{j}{i};
        Hxtemp{n}=Hxf2{j}{i};
        Hytemp{n}=Hyf2{j}{i};
        fw(n)=fw2{j}(i);
        n=n+1;
    end
end



end

