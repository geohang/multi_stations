clear
load fw
load stat1

for ii=1:27
    
    
   clear X 
    
    
    n=0;
    for i=1
        Edata=Estat{i};
        Hdata=Hstat{i};
        II=ii;
        X(1,:)= Hdata{II}(1,:);
        X(2,:)= Hdata{II}(2,:);
        X(3,:)= Edata{II}(1,:);
        X(4,:)= Edata{II}(2,:);
        
        n=n+1;
    end
    
    
    S=X*X'/(length(X));
    var=sqrt(diag(S));
    [N,J]=size(X);
    var1=repmat(var,[1,J]);
    Z=X./var1;
    [U,S,V] = svd(Z,'econ');
    SNR1(ii,:)=diag(S);
end

semilogx(fw,SNR1(:,1))
hold on
semilogx(fw,SNR1(:,2))
hold on
semilogx(fw,SNR1(:,3))
hold on
semilogx(fw,SNR1(:,4))