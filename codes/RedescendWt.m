%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [YC,E_psiPrime,W] = RedescendWt(Y,YP,sig,u0)

%   inputs are data (Y) and predicted (YP), estiamted
%   error variances (for each column) and Huber parameter u0
%   allows for multiple columns of data

  [nData,K] = size(Y);
  YC = Y;
  E_psiPrime = zeros(K,1);
  for k = 1:K
    r = abs(Y(:,k)-YP(:,k))/sqrt(sig(k));
    t = -exp(u0*(r-u0));
    w = exp(t);
   %  cleaned data
    YC(:,k) = w.*Y(:,k)+(1-w).*YP(:,k);
    W(:,k)=w;
   %   computation of E(psi')
    t= u0*t.*r;
    t = w.*(1+t);
    t(isnan(t)==1)=0;
    t(t<0) = 0;
    E_psiPrime(k) = sum(t)/nData;
  end
end
