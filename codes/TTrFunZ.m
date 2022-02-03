classdef TTrFunZ < TTransferFunction
    %  subclass for impedance objects
    properties
        Ndf
        rho
        phi
        rho_se
        phi_se
    end
    
    methods
        function obj = TTrFunZ(Header,Ns)
            %obj = obj@TTransferFunction;
            %  class constructor
            obj.TFType = 'TTrFunZ';
            if nargin >= 1
                obj.initialize(Header,Ns)
            end
        end
        %*****************************************************************
        function initialize(obj,Header,Ns)
            obj.NSites = Ns;
            obj.TF = zeros(2,2,Header.NBands,Ns);
            obj.Ndf = zeros(2,Header.NBands,Ns);
            obj.StdErr = zeros(2,2,Header.NBands,Ns);
            obj.T = zeros(Header.NBands,Ns);
            obj.Header = Header;
            obj.NPeriods = Header.NBands;
        end
        %*****************************************************************
        function setFullImpedance(obj,ib,TRegObj,T,iSite)
            if nargin ==  4
                iSite = 1;
            end
            [nData,~] = size(TRegObj.Y);
            %   use TRegObj to fill in full impedance, error bars
            if any(size(TRegObj.b)~=2)
                error('TRegObj not 2x2; conversion to impedance is ambiguous')
            else
                obj.TF(:,:,ib,iSite) = TRegObj.b.';
                N = diag(TRegObj.Cov_NN);
                S = diag(TRegObj.Cov_SS);
                obj.StdErr(:,:,ib,iSite) = sqrt(N*S');
                obj.T(ib,iSite) = T;
                obj.Ndf(1:2,ib,iSite) = nData;
            end
        end
        %******************************************************************
        function setImpedanceFromArray(obj,ib,Z,Zerr,T,ndf,iSite)
            if nargin ==  6
                iSite = 1;
            end
            obj.TF(:,:,ib,iSite) = Z;
            obj.StdErr(:,:,ib,iSite) = Zerr;
            obj.T(ib,iSite) = T;
            obj.Ndf(1:2,ib,iSite) = ndf;
        end
        %******************************************************************
        function setTFRow(obj,ib,ir,TRegObj,T,iSite)
            if nargin == 5
                iSite = 1;
            end
            [nData,~] = size(TRegObj.Y);
            [n,m] = size(TRegObj.b);
            
            if n==2 && m ==1
                obj.TF(ir,:,ib,iSite) = TRegObj.b;
                stdErr = sqrt(TRegObj.Cov_NN*diag(TRegObj.Cov_SS).');
                obj.StdErr(ir,:,ib,iSite) = stdErr;
                obj.T(ib,iSite) = T;
                obj.Ndf(ir,ib,iSite) = nData;
            else
                error('TRegObj not proper size for operation in setImpedanceRow');
            end
        end
        %******************************************************************
        function setFromStruct(obj,Z)
            i2 = Z.Nche;
            i1 = i2-1;
            obj.TF = Z.TF(:,i1:i2,:);
            obj.T  = Z.T';
            obj.NPeriods=length(obj.T);
            for ib = 1:obj.NPeriods
                N = diag(squeeze(Z.SIG_E(i1:i2,:,ib)));
                S = diag(squeeze(Z.SIG_S(:,:,ib)));
                obj.StdErr(:,:,ib) = sqrt(N*S');
            end
            obj.Header= TzFileHeader(Z);
            obj.TFType='TTrFunZ';
            obj.NPeriods=length(obj.T);
            obj.NSites=1;
            obj.Cov_SS =Z.SIG_S;
            obj.Cov_NN = Z.SIG_E;
            obj.Ndf = Z.ndf;

        end
        %******************************************************************
        function ModEMdata2TTrFunZ(obj,info,ista)
            %  inputs are handle object of class TTrfunZ, data strucrture
            %  created from ModEM data file (containing impedances for
            %  multiple sites) + site number to put into TTrfunZ object
            [nSta,nBands,nComp] = size(info.data);
            if ista > nSta
                error('ista out of range in  ModEMdata2TTrfunZ')
            end
            if nComp ~= 4
                error('i ModEMdata2TTrfunZ requires 4 component data structure')
            end
            iuse = zeros(nBands,1);
            for j = 1:nBands
                iuse(j) = ~any(isnan(info.data(ista,j,:)));
            end
            NBands = sum(iuse);
            obj.TF = zeros(2,2,NBands,1);
            obj.StdErr  = obj.TF;
            obj.T = zeros(NBands,1);
            k = 0;
            for j = 1:nBands
                if iuse(j)
                    k = k+1;
                    obj.T(k) = info.per(k);
                    for l = 1:4
                        switch info.comp(l,:)
                            case 'ZXX'
                                obj.TF(1,1,k,1) = info.data(ista,j,l);
                                obj.StdErr(1,1,k,1) = info.err(ista,j,l);
                            case 'ZXY'
                                obj.TF(1,2,k,1) = info.data(ista,j,l);
                                obj.StdErr(1,2,k,1) = info.err(ista,j,l);
                            case 'ZYX'
                                obj.TF(2,1,k,1) = info.data(ista,j,l);
                                obj.StdErr(2,1,k,1) = info.err(ista,j,l);
                            case 'ZYY'
                                obj.TF(2,2,k,1) = info.data(ista,j,l);
                                obj.StdErr(2,2,k,1) = info.err(ista,j,l);
                        end
                    end
                end
            end
            obj.NPeriods = NBands;
            obj.NSites = 1;
            %   I am creating a TFCheader object here ...
            Header = TFCHeader;
            Header = defaultHeaderOneSite(Header,4);
            Header.NBands = NBands;
            Header.stcor = [info.lat(ista);info.lon(ista)];
            Header.decl = 0;
            Header.sta = info.code(ista,:)';
            Header.Sites{1} = info.code(ista,:);
            Header.geogCor = 1;
            obj.Header = Header;
        end

      %  function rotate(obj,theta)
      %  end
        %******************************************************************
        function ap_res(obj)
            %ap_res(...) : computes app. res., phase, errors, given imped., cov.
            %USAGE: [rho,rho_se,ph,ph_se] = ap_res(z,sig_s,sig_e,periods) ;
            % Z = array of impedances (from Z_***** file)
            % sig_s = inverse signal covariance matrix (from Z_****** file)
            % sig_e = residual covariance matrix (from Z_****** file)
            % periods = array of periods (sec)
            
            rad_deg = 180/pi;
            %   off-diagonal impedances
            obj.rho = zeros(obj.NPeriods,2,obj.NSites);
            obj.rho_se = zeros(obj.NPeriods,2,obj.NSites);
            obj.phi = zeros(obj.NPeriods,2,obj.NSites);
            obj.phi_se = zeros(obj.NPeriods,2,obj.NSites);
            for iSite = 1:obj.NSites
                Zxy = squeeze(obj.TF(1,2,:,iSite));
                Zyx = squeeze(obj.TF(2,1,:,iSite));
                % standard deviation  of real and imaginary parts of impedance
                Zxy_se = squeeze(obj.StdErr(1,2,:,iSite))/sqrt(2);
                Zyx_se = squeeze(obj.StdErr(2,1,:,iSite))/sqrt(2);
                %   apparent resistivities
                rxy = obj.T(:,iSite).*(abs(Zxy).^2)/5.;
                ryx = obj.T(:,iSite).*(abs(Zyx).^2)/5.;
                
                rxy_se = 2*sqrt(obj.T(:,iSite).*rxy/5).*Zxy_se;
                ryx_se = 2*sqrt(obj.T(:,iSite).*ryx/5).*Zyx_se;
                obj.rho(:,:,iSite) = [rxy ryx];
                obj.rho_se(:,:,iSite) = [rxy_se ryx_se];
                %   phases
                pxy = rad_deg*atan(imag(Zxy)./real(Zxy));
                pyx = rad_deg*atan(imag(Zyx)./real(Zyx));
                obj.phi(:,:,iSite) = [pxy pyx];
                pxy_se = rad_deg*Zxy_se./abs(Zxy);
                pyx_se = rad_deg*Zyx_se./abs(Zyx);
                obj.phi_se(:,:,iSite) = [pxy_se pyx_se];
            end
        end
        %******************************************************************
        function objOut = oneSite(obj,iSite)
            %   extracts TF object for a single "site"
            %    THIS LOOKS LIKE GARBAGE
            % objOut = TTrFunZ(obj.Header,iSite);
            
        end
        
    end
end
