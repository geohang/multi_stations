function [s] = stablels(s,nt,epsilon)

trs=sum(diag(s));

trs=trs*epsilon/nt;

for i=1:nt
    s(i,i)=real(s(i,i))+trs;
    
end


end

