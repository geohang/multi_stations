function [allnoise] = addnoise3(ef,theta)
n=length(ef);

[ef,index]=sort(ef);

allnoise=stablernd(n,theta).*abs(ef)/sqrt(2)*0.3;

end