classdef TRMEBB < TRegression
    % 2009 Gary Egbert , Maxim Smirnov
    % Oregon State University
    
    %
    %  (Complex) regression-M estimate for the model  Y = X*b
    %
    %  Allows multiple columns of Y, but estimates b for each column separately
    %
    %   S and N are estimated signal and noise covariance
    %    matrices, which together can be used to compute
    %    error covariance for the matrix of regression coefficients b
    %  R2 is squared coherence (top row is using raw data, bottom
    %    cleaned, with crude correction for amount of downweighted data)
    
    %  Parameters that control regression M-estimates are defined in ITER
    
    methods
        
        function obj = TRMEBB(X,Xr,Y,iter)
            %   class constructor for RME object
            %
            %   Usage: obj = RME(X,Y,iter);
            
            if nargin >= 3
                obj.X = X;
                obj.Y = Y;
                obj.Xr = Xr;
                if nargin ==4
                    if class(iter == 'IterControl')
                        obj.ITER  = iter;
                    else
                        obj.ITER = IterControl;
                    end
                else
                    obj.ITER = IterControl;
                end
            end
        end
        
        function result = Estimate(obj)
            %   function that does the actual regression-M estimate
            %
            %   Usage:  [b]  = Estimate(obj);
            %    (Object has all outputs; estimate of coefficients is also returned
            %              as function output)
            
            
            %   note that ITER is a handle object, so mods to ITER properties are
            %   already made also to obj.ITER!
            ITER = obj.ITER;
            %   Q-R decomposition of design matix
            [nData,K] = size(obj.Y);
            [nX,nParam] = size(obj.X);
            if nX ~= nData
                error('data (Y) and design matrix (X) do not have same number of rows')
            end
            if nParam > nData
                % overdetermined problem ... use svd to invert, return
                %   NOTE: the solution IS non-unique ... and by itself RME
                %    is not set up to do anything sensible to resolve the
                %    non-uniqueness (no prior info is passed!)
                %  This is stop-gap, to prevent errors when using RME as part of
                %   some other estimation scheme!
                [u,s,v] = svd(obj.X,'econ');
                sInv = 1./diag(s);
                obj.b = v*diag(sInv)*u'*obj.Y;
                if ITER.returnCovariance
                    obj.Cov_NN = zeros(K,K);
                    obj.Cov_SS = zeros(nParam,nParam);
                end
                result = obj.b;
                return
            end
            
            b0 =inv(obj.Xr'*obj.X)*obj.Xr'*obj.Y;
            
            [Q,R] = qr(obj.X,0);
            [Qr,Rr] = qr(obj.Xr,0);
            
            %  initial LS estimate b0, error variances sigma
            
            data_residual=obj.Y-obj.X*b0 ;
            % data standard deviation calculation
            sigma=sqrt(sum(abs(data_residual).^2,2)/(nData-2));
            
            
            if ITER.iterMax > 0
                notConverged = 1;
                cfac = 1./(2*(1.-(1.+ITER.r0)*exp(-ITER.r0) ));
            else
                notConverged = 0;
                E_psiPrime = 1;
                YP = b0*obj.X;
                obj.b = b0;
                obj.Yc = obj.Y;
            end
            
            ITER.niter = 0;
            
            while notConverged
                ITER.niter= obj.ITER.niter+1;
                %  predicted data
                YP = obj.X*b0;
                %  cleaned data
                [obj.Yc,E_psiPrime,W] = HuberWt(obj.Y,YP,sigma,ITER.r0);
                %  updated error variance estimates, computed using cleaned data
                %        QTY = (Qr.*W)'*obj.Yc;
                
                obj.b =inv((obj.Xr.*W)'*obj.X)*(obj.Xr.*W)'*obj.Y;
                
                data_residual=obj.Y-obj.X*b0 ;
                
                sigma=sqrt(sum(abs(data_residual).^2,2)/(nData-2));
                notConverged = cvgcTest(ITER,obj.b,b0);
                b0 = obj.b;
            end
            
            if ITER.rdscnd
                ITER.niterR = 0;
                while ITER.niterR <= ITER.iterRmax
                    ITER.niterR = ITER.niterR+1;
                    %  one obj with redescending influence curve
                    YP = obj.X*obj.b;
                    %  cleaned data
                    [obj.Yc,E_psiPrime,W] = RedescendWt(obj.Y,YP,sigma,ITER.u0);
                    %  updated error variance estimates, computed using cleaned data
                    %              QTY = (Qr.*W)'*obj.Yc;
                    
                    obj.b =inv((obj.Xr.*W)'*obj.X)*(obj.Xr.*W)'*obj.Y;
                    
                    data_residual=obj.Y-obj.X*b0 ;
                    
                    sigma=sqrt(sum(abs(data_residual).^2,2)/(nData-2));
                end
                %   crude estimate of expectation of psi' ... accounting for
                %    redescending influence curve
                E_psiPrime = 2*E_psiPrime-1;
            end
            result = obj.b;
            if ITER.returnCovariance
                %   compute error covariance matrices
                obj.Cov_SS = inv(R'*Rr*inv(Rr*Rr')*Rr'*R);
                res = obj.Yc-YP;
                
                %   need to look at how we should compute adjusted residual cov
                %   to make consistent with tranmt
                SSRC = conj(res'*res);
                res = obj.Y-YP;
                SSR = conj(res'*res);
                %SSY = real(sum(obj.Y.*conj(obj.Y),1));
                SSYC = real(sum(obj.Yc.*conj(obj.Yc),1));
                obj.Cov_NN = diag(1./(E_psiPrime.^2))*SSRC/(nData-nParam);
                
                obj.R2 = 1-diag(real(SSR))'./SSYC;
                obj.R2(obj.R2<0) = 0;
            end
        end  % RM_Est
        
    end %methods
    
end %class
