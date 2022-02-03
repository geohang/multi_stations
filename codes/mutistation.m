clear
load fw
load stat1

ii=18;


minvalue=length(Estat{1}{ii});
for i=2:9
    Edata=Estat{i};
    Hdata=Hstat{i}; 
    
    if (length(Estat{i}{ii})<minvalue)
        minvalue=length(Estat{i}{ii});
    end
    
end



n=0;
for i=1:9
    Edata=Estat{i};
    Hdata=Hstat{i}; 
    for II=18  
        X(1+n*4,:)= Hdata{II}(1,1:minvalue);
        X(2+n*4,:)= Hdata{II}(2,1:minvalue);
        X(3+n*4,:)= Edata{II}(1,1:minvalue);
        X(4+n*4,:)= Edata{II}(2,1:minvalue);        
    end
    n=n+1;
end
nt=4*9;
epsilon=1e-4;
r0=1.5*nt;
[N,J]=size(X);
L=min([N,J]);

S=X*X'/(length(X));
% S1=1/(length(X))*X*X';
var=sqrt(diag(S));
var1=repmat(var,[1,J]);

y=X./var1;
% d=eig(S)
% isposdef = all(d) > 0

for i=1:500
[S] = stablels(S,nt,epsilon);

R = chol(S,'lower');

y=R\y;

r=diag(y'*y);

w=ones(1,length(r));
for j=1:length(w)
 
    if(r(j)>r0)
        w(j)=r0/r(j);
    end
end


wtot=sum(w);

ww=repmat(w,36,1);
wy=ww.*y;

S=wy*y';
S=round(S,8) ;


S=S/wtot;

schk = sum(sum(abs(triu(S,1)).^2))+sum(sum(abs(1-diag(S)).^2));

if(schk<=0.001)
    break
end

end


r=diag(y'*y);

w=ones(1,length(r));
for j=1:length(w)
 
    if(r(j)>r0)
        w(j)=r0/r(j);
    end
end


wtot=sum(w);
ww=repmat(w,36,1);
wx=ww.*X;

S=wx*X'/wtot;
