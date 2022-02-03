function [allnoise] = addnoise1(ef,theta)
n=length(ef);

[ef,index]=sort(ef);

nsize=floor(n/2);


allnoise(index)=[stablernd(nsize,theta).*abs(ef(1:nsize))/sqrt(2)*0.2 ...
    ,stablernd(length(ef(nsize+1:end)),theta).*abs(ef(nsize+1:end)/sqrt(2)*0.4)];
    
%     ,stablernd(nsize,theta).*abs(ef(2*nsize+1:3*nsize))/sqrt(2)*0.3 ...
%     ,stablernd(nsize,theta).*abs(ef(3*nsize+1:4*nsize))/sqrt(2)*0.4 ...
%     ,stablernd(length(ef(4*nsize+1:end)),theta).*abs(ef(4*nsize+1:end))/sqrt(2)*0.5
end

