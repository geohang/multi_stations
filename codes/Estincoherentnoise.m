function [StdErr,Ts,XC] = Estincoherentnoise(X,A_in)

[N,J]=size(X);
% Section 3.4 Estimation of incoherent noise variance
for i=1:N
    idd=ones(1,N);
    
    idd(i)=0;
    idd=logical(idd);
    
    Xs=X(idd,:).';
    As=A_in(idd,:).';
    
    [u,s,v] = svd(Xs,'econ');
    sInv = 1./diag(s);
    Us= v*diag(sInv)*u'*As;
    
    Xs1=X(~idd,:).';
    
    iter = IterControl;
    iter.rdscnd = true;
    iter.iterMax = 50;
    iter.iterRmax = 1;
    Header.Sites = {'matlab RME'};
    Header.NBands = 1;
    ImpedRobust = TTrFunZ(Header,1);
    
    obj = TRME(As,Xs1,iter);
    obj.Estimate;
    StdErr(i,:) = sqrt(obj.Cov_NN);
    Ts1 = obj.b;
    Ts(i,:)=Ts1'*Us';
    XC(:,i)=obj.Yc;
end


end

