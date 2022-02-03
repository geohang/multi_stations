function [allnoise] = addnoise2(ef,theta)
n=length(ef);

[ef,index]=sort(ef);

nsize=floor(n/2);


allnoise(index)=[stablernd(nsize,theta).*abs(ef(1:nsize))/sqrt(2)*0.1 ...
    ,stablernd(length(ef(nsize+1:end)),theta).*abs(ef(nsize+1:end))/sqrt(2)*0.5];
end