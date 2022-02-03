clear
load fw
load stat1
addpath('D:\research\dataprocessing\噪声谱\聚类去噪方法')
%bad 3 8 9

% I=[1,2,3,4,5,6,7,9,10];%1:length(Estat);%
I=7;%2
for i=I
    Edata=Estat{i};
    Hdata=Hstat{i};   
    for II=18                    %choose the frequence of the data
        iter = IterControl;
        iter.rdscnd = true;
        iter.iterMax = 50;
        iter.iterRmax = 1;
        Header.Sites = {' matlab RME'};
        % ImpedRobust = TTrFunZ(Header,1);
        b = Hdata{II}.';
        e = Edata{II}.';
        obj= TRME(b,e,iter);
        impedancet{II}=conj(obj.Estimate)';
        
        impedancetrue=impedancet{II};
        ef=impedancetrue*Hdata{II};  % Generate synthetic electrical data
        
        %--------------------------------------------------------%
        eerr_level=0.6;          %error number
        [a,sizenumber]= size(Hdata{II});      %the number of bf
        theta=[2,0,1,0];
        fun=@(n,theta)stablernd(n,theta);
        %-----------------------------------add noise--------------------------------------------------
        npoint=sizenumber;
        
        real_temp1=real(ef(1,1:sizenumber))+addnoise1(ef(1,1:sizenumber),theta);
        imag_temp1=imag(ef(1,1:sizenumber))+addnoise1(ef(1,1:sizenumber),theta);
        real_temp2=real(ef(2,1:sizenumber))+addnoise1(ef(2,1:sizenumber),theta);
        imag_temp2=imag(ef(2,1:sizenumber))+addnoise1(ef(2,1:sizenumber),theta);
        efnoise{II}=[complex(real_temp1,imag_temp1);complex(real_temp2,imag_temp2)];
        
        [Q,R] = qr(Hdata{II}',0);
        QTY = Q'*efnoise{II}';
        impedance = (R\QTY)';
%         b = Hdata{II}.';
%         e =  efnoise{II}.';
%         obj= TRME(b,e,iter);
%         impedance=conj(obj.Estimate)';
        data_residual{II}=efnoise{II}-impedance*Hdata{II};
        
        Residual=abs(data_residual{II}).^2;
        Hfield=abs(Hdata{II}).^2;
    end
    
    
end
subplot(1,2,1)
loglog(Hfield(1,:),Residual(1,:),'.')
brobx1 = robustfit(Hfield(1,:),Residual(1,:));
hold on

loglog(sort(Hfield(1,:)),brobx1(1)+brobx1(2)*sort(Hfield(1,:)),'r','LineWidth',2);

subplot(1,2,2)
loglog(Hfield(2,:),Residual(2,:),'.')
hold on
broby1 = robustfit(Hfield(2,:),Residual(2,:));
loglog(sort(Hfield(2,:)),broby1(1)+broby1(2)*sort(Hfield(2,:)),'r','LineWidth',2);

% loglog([1:100],[1:100])

% [Xnew1,Ynew1] = returnres(data_residual,II,2);
% 
% 
% figure(2)
% 
% subplot(2,3,1)
% hold on
% [~,a]=qq_plot(Xnew1,'Rayleigh');
% set(gca,'FontSize',15)
% set(gca,'ticklength',[0.02 0.02])
% xlim([0,3])
% box on;
% subplot(2,3,4)
% spp_plot(Ynew1,'norm');
% set(gca,'FontSize',15)
% set(gca,'ticklength',[0.02 0.02])
% [p1] = testKS(Ynew1);
% 
% 
