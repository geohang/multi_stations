classdef TTransferFunction < handle
%  base class for transfer function objects
%  can store multiple sites
properties
% - must exist properties-------------------------------------------------
  TF          %   array of transfer functions: TF(Nout,Nin,Nperiods, NSites)
              %  Example  Zxx = Z(1,1,Period,Site) Zxy = Z(1,2,Period,Site)
              %           Zyx = Z(2,1,Period,Site) Zyy = Z(2,2,Period,Site)
  T           %   list of periods
  StdErr      %   standard errors of TF components, same size and order as TF
  Header      %   TDataHeader object, contains sites location, channel
              %    azimuths, etc.   This header supports multiple sites,
              %    so info on remote sites for RR and/or reference sites for
              %    inter-site TFs can also be included here
  TFType      %    defines the transfer functions type
              % The folloowing types are allowed:  Z (impedance), W (tipper), 
              %                                    M (hor TF)   ,........
              % default Z  
% -------------------------------------------------------------------------

  NPeriods    %   number of periods
  NSites      %   number of sites
  RefSite = 0; %   is needed for intersation TFs (default 0) not an interstation TF 

  Cov_SS      %   inverse signal power matrix 
  Cov_NN      %   noise covariance
              
end
% methods(Abstract)        
% %   rotate coordinate system theta degrees counterclockwise
%   Rotate(obj,theta);
%   Estimate(obj);
%   SaveToFile(obj, FileName);
%   LoadFromFile(obj, FileName);
% end
end %class