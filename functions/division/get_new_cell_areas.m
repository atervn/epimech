function [newAreas, simset] = get_new_cell_areas(spar,area,simset)
% GET_NEW_CELL_AREAS Gives the variable areas of the daughter cells
%   The function produces the areas for the daughter cells based on the
%   MDCK area distribution data. If there are areas left in the initially
%   defined set of areas, the areas are taken from there. If the set is
%   empty, get new areas from the distribution.
%   INPUTS:
%       spar: scaler parameter structure
%       area: area of the mother cell
%       simset: simulation settings structure
%   OUTPUT:
%       newAreas: the areas of the daughter cells
%       simset: simulation settings structure
%   by Aapo Tervonen, 2021

% if there are fewer than 2 areas left in the set
if length(simset.newAreas) < 2
    
    % define the area distrubtion
    f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
    
    % number of areas for the new set
    nAreas = 10000;
    
    % get new areas from the distribtion
    simset.newAreas = slicesample(1,nAreas,'pdf',f)*1e-12/spar.scalingLength^2;
end

% number of times to try to get daughter cell areas
nTries = 500;

% go through the tries
for i = 1:nTries
    
    % get two areas from the area set
    area1 = simset.newAreas(1);
    area2 = simset.newAreas(2);
    
    % check if both the areas are at least double the minimum area for the
    % cells (below the spar.minimumCellSize cells are removed from the
    % simulation), that neither of the areas if more than 1.5 times the
    % other, and that the combined area is between 1.5 and 2.5 times the
    % mother cell area
    if area1 > 2*spar.minimumCellSize && area2 > 2*spar.minimumCellSize && area1/area2 <= 1.5 && area2/area1 <= 1.5 && area1 + area2 > 1.5*area && area1 + area2 < area*2.5
        
        % save the new cell areas (multiply with the constant to take into
        % account the small reduction in size by the cortical tension
        newAreas = spar.newCellAreaConstant.*[area1; area2];
        
        % remove the used areas from the area set
        simset.newAreas(1:2) = [];
        return;
        
    % otherwise
    else
        
        % remove the used areas from the area set
        simset.newAreas(1:2) = [];
        
        % if there are fewer than 2 areas left in the set
        if length(simset.newAreas) < 2
            
            % define the area distrubtion
            f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
            
            % number of areas for the new set
            nTries = 10000;
            
            % get new areas from the distribtion
            simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;
        end
    end
end

% if no suitable areas are found within the nTries, set the areas based on
% the mother cell areas
newAreas = spar.newCellAreaConstant.*ones(2,1).*area;

end
