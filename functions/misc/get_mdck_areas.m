function areas = get_mdck_areas(spar)
% GET_MDCK_AREAS Get MDCK areas from experimental area distribution.
%   The function get cell areas from the distribution that was defined
%   based on the MDCK data in Tervonen et al..
%   INPUTS:
%       spar: scaler parameter structure
%   OUTPUT:
%       areas: obtained areas
%   by Aapo Tervonen, 2021

% define the area distrubtion
f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);

% number of areas for the new set
nTries = 10000;

% get new areas from the distribtion
areas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;

end