function [A_in,U_in,S] = Robustcovest(X,var)
% Section 3.1 Robust covariance estimation

nt=4*6;
epsilon=1e-4;
r0=1.5;

[N,J]=size(X);
L=min([N,J]);


var1=repmat(var,[1,J]);

    

Z1=X./var1;
Z=Z1;
% Z=X;

[U,S,V] = svd(Z,'econ');

for i=1:50
    [S] = stablels(S,nt,epsilon);
    Y=inv(S)*U'*Z;
    %通道之间的残差
    r=diag(Y'*Y)*J/L;
    w=ones(1,length(r));
    for j=1:length(w)
        
        if(r(j)>r0)
            w(j)=r0/r(j);
        end
    end
    
    ww=repmat(w,N,1);
    wy=ww.*Y;
    [U,S,V] = svd(wy,'econ');
    error=norm(U*S*S*U'-eye(N));
    
    if(error<0.001)
        break;
    end
    
    Z=U*S*V';
end


wz=w.*Z1;
[U,S,V] = svd(wz,'econ');
A_in=S*V';
U_in=U*diag(var);


end

