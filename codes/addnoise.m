function [allnoise] = addnoise(ef,theta)
n=length(ef);

noise1=stablernd(n,theta).*abs(ef)/sqrt(2)*0.1;
noise2=stablernd(n,theta).*abs(ef)/sqrt(2)*0.2;
noise3=stablernd(n,theta).*abs(ef)/sqrt(2)*0.3;
noise4=stablernd(n,theta).*abs(ef)/sqrt(2)*0.3;
noise5=stablernd(n,theta).*abs(ef)/sqrt(2)*0.3;

allnoise=noise1+noise2+noise3+noise4+noise5;
end

