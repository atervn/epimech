function [focalAdhesionForcesX,focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp)

focalAdhesionForcesX = zeros(d.sub.nPoints,max(d.sub.adhesionNumbers));
focalAdhesionForcesY = focalAdhesionForcesX;

for k = 1:length(subTemp.verticesX)

    substrateX = subTemp.pointsX(subTemp.pointsLin{k});
    substrateY = subTemp.pointsY(subTemp.pointsLin{k});
    
    adhesionPointsX = sum(reshape(substrateX.*subTemp.weightsLin{k},[],3),2);
    adhesionPointsY = sum(reshape(substrateY.*subTemp.weightsLin{k},[],3),2);

    forcesX = -subTemp.fFocalAdhesions{k}.*(adhesionPointsX - subTemp.verticesX{k});
    forcesY = -subTemp.fFocalAdhesions{k}.*(adhesionPointsY - subTemp.verticesY{k});

    focalAdhesionForcesX(subTemp.matrixIdx{k}) = repmat(forcesX,3,1).*subTemp.weightsLin{k};
    focalAdhesionForcesY(subTemp.matrixIdx{k}) = repmat(forcesY,3,1).*subTemp.weightsLin{k};

end

focalAdhesionForcesX = sum(focalAdhesionForcesX,2);
focalAdhesionForcesY = sum(focalAdhesionForcesY,2);