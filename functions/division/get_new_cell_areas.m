function [newAreas, simset] = get_new_cell_areas(spar,area,simset)

if length(simset.newAreas) < 2
    
    f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
    
    nTries = 10000;
    
    simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;
end

nTries = 500;

for i = 1:nTries
    area1 = simset.newAreas(1);
    area2 = simset.newAreas(2);
    if area1 > spar.minimumCellSize && area2 > spar.minimumCellSize && area1/area2 <= 1.5 && area2/area1 <= 1.5 && area1 + area2 > 1.5*area && area1 + area2 < area*2.5
        newAreas = spar.newCellAreaConstant.*[area1; area2];
        simset.newAreas(1:2) = [];
        return;
    else
        simset.newAreas(1:2) = [];
        if length(simset.newAreas) < 2
            
            f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
            
            nTries = 10000;
            
            simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;
        end
    end
end

if area < 2*spar.minimumCellSize
    newAreas = spar.newCellAreaConstant.*ones(2,1).*area;
else
    newAreas = ones(2,1).*area/2;
end

