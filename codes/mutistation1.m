 clear
load fw
load alldata

ii=18;



n=0;
for i=1:6
    Exdata=Exstat{i}{ii};
    Eydata=Eystat{i}{ii};
    Hxdata=Hxstat{i}{ii};
    Hydata=Hystat{i}{ii};
    
    Extemp{i}=[];
    Eytemp{i}=[];
    Hxtemp{i}=[];
    Hytemp{i}=[];
    
    for nn=1:length(Exdata)
        Extemp{i}=[Extemp{i},Exdata{nn}];
        Eytemp{i}=[Eytemp{i},Eydata{nn}];
        Hxtemp{i}=[Hxtemp{i},Hxdata{nn}];
        Hytemp{i}=[Hytemp{i},Hydata{nn}];
    end
  
        X(1+n*4,:)= Hxtemp{i}(1,:);
        X(2+n*4,:)= Hytemp{i}(1,:);
        X(3+n*4,:)= Extemp{i}(1,:);
        X(4+n*4,:)= Eytemp{i}(1,:);

    n=n+1;
end
[N,J]=size(X);

S=X*X'/(length(X));
var=sqrt(diag(S));

%section 3.1
[A_in,U_in,STN] = Robustcovest(X,var);


%section 3.4
[StdErr,Ts,XC] = Estincoherentnoise(X,A_in);

%section 3.1
var=StdErr;
[A_in,U_in,STN] = Robustcovest(XC.',var);

%section 3.4
[StdErr,Ts,XC] = Estincoherentnoise(XC.',A_in);

% section 3.2 Estimation of the spatial modes
iter = IterControl;
iter.rdscnd = true;
iter.iterMax = 50;
iter.iterRmax = 1;
Header.Sites = {'matlab RME'};
Header.NBands = 1;
ImpedRobust = TTrFunZ(Header,1);
obj1 = TRME(A_in.',XC,iter);
obj1.Estimate;
U_next = obj1.b;


%Section 3.3 Estimation of polariztion parameters

[~,S,~] = svd(XC,'econ');

Cd=diag(StdErr);

for j=1:J
    [u,s,v] = svd(U_next,'econ');    
    a(:,j)=sqrt(S)*v*s*s./(s.^2+1)*inv(Cd)*XC(j,:).';    
end
[u,s,v] = svd(a,'econ');

A=s*v';
U=U_next*u;

% e = eig(U);

