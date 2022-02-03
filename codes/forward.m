function f = forward(m_true, m,r,n,omega,lamb,m_f,C_obs,unc,lf,ll)
%% calculate the penalty function
%  m: log10( 1-D conductivity profile )
%  r: boundary of each layer
%  n: spherical harmonic degree
%  omega: angular frequency
%  C_obs: observed C-responses

m_comb  = m_true;
m_comb(lf:ll) = m;
sigma   = 10.^m_comb;
% C_exp   = conj(admittance_vectorized(r,sigma,omega,n));

%% 1-D Cn-response solution 
mu = 4*pi*1e-7;
N = length(sigma);

%Preallocate
nf = length(omega);
Y       = zeros(nf,1);

%Loop over all layers (from core to surface)
for k = N:-1:1
    %Compute temporary scalars
    bk  = sqrt((n+0.5)^2-1i*omega*mu*sigma(k)*r(k)^2);
    bkp = bk + 0.5;
    bkm = bk - 0.5;
    qk  = 1i*omega*mu*r(k);
    
    if k==N
        %Admittance (and derivative wrt. conductivity) for core
        Y    = -bkp./qk;
%         dYds(k) = r(k)/(2*bk);
    else
        %Compute temporary scalars
        etak  = r(k)/r(k+1);
        zetak = etak.^(2*bk);
        
        % tackle overflow
        tauk  = (1-zetak)./(1+zetak);
        tauk(isnan(tauk)) = -1;
        
        qk    = 1i*omega*mu*r(k);
        qk1   = 1i*omega*mu*r(k+1);
        qY    = qk1.*Y;
        
        %Admittance for this layer
        Y = 1./qk.*(qY.*(bk-0.5.*tauk)+bkp.*bkm.*tauk)./(bk+tauk.*(0.5+qY));
        
    end
end

%Compute the C-response
C = -1./(1i.*omega.*mu.*Y);

C_exp = conj(C)/1000.0;

f = 0.5*lamb*sum(abs(m-m_f).^2);

% f       = 0.5*(C_exp-C_obs)./abs(unc)*(C_exp-C_obs)' + 0.5*lamb*(m-m_f)'*(m-m_f)
% f=0;
temp=0;
for j=1:length(C_exp)
    temp = temp+0.5*(C_exp(j)-C_obs(j))*conj((C_exp(j)-C_obs(j)))/(unc(j)*unc(j));
end
% f
% temp
f = f+temp;
% f = f + 0.5*lamb*(m-m_f)'*(m-m_f);

end