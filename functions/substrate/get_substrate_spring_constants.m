function d = get_substrate_spring_constants(d,app)

d.sub.restorativeSpringConstants = zeros(d.sub.nPoints,1);
d.sub.centralInteractionSpringConstants = zeros(length(d.sub.interactionSelvesIdx),1);
d.sub.repulsionSpringConstants = zeros(length(d.sub.repulsionVectorsIdx),1);

scaledRestorativeMultiplier = app.substrateParameters.restorativeForceConstant*2*sqrt(3)*(app.substrateParameters.substratePointDistance*1e6/2)^2;

switch app.StiffnessstyleButtonGroup.SelectedObject.Text
    case 'Constant'
        
        d.spar.fSubstrate = app.substrateParameters.youngsModulusConstant*app.substrateParameters.youngsModulus*app.systemParameters.scalingTime/app.systemParameters.eta;
        
        d.sub.restorativeSpringConstants(:) = d.spar.fSubstrate*scaledRestorativeMultiplier;
        d.sub.centralInteractionSpringConstants(:) = d.spar.fSubstrate.*d.sub.springMultipliers;
        d.sub.repulsionSpringConstants(:) = d.spar.fSubstrate;
    case 'Heterogeneous'
        
        substrateRadius = ceil(1.05*sqrt(max(d.sub.pointsX.^2 + d.sub.pointsY.^2))*app.systemParameters.scalingLength*1e6);
        
        [fData,substrateGridX,substrateGridY] = rsgeng2D(2*substrateRadius,2*substrateRadius,app.heterogenousStiffness(3),app.heterogenousStiffness(1),app.heterogenousStiffness(2));
        
        substrateGridX = substrateGridX.*1e-6/app.systemParameters.scalingLength;
        substrateGridY = substrateGridY.*1e-6/app.systemParameters.scalingLength;
        
        [substrateGridX, substrateGridY] = meshgrid(substrateGridX,substrateGridY);
        
        if app.heterogenousStiffness(4) ~= 0
            
            rotatedCoordinates = [cosd(-app.heterogenousStiffness(4)) -sind(-app.heterogenousStiffness(4)) ; sind(-app.heterogenousStiffness(4)) cosd(-app.heterogenousStiffness(4))]*[substrateGridX(:)' ; substrateGridY(:)'];
            substrateGridX = rotatedCoordinates(1,:)';
            substrateGridY = rotatedCoordinates(2,:)';
    
        end

        stiffnesses = app.substrateParameters.youngsModulus + fData.*1000;
        
        stiffnesses(stiffnesses < 500) = 500;
        
        fData = app.substrateParameters.youngsModulusConstant*stiffnesses*app.systemParameters.scalingTime/app.systemParameters.eta;
        

        pointSpringConstants = griddata(substrateGridX(:),substrateGridY(:),fData(:),d.sub.pointsX, d.sub.pointsY);
        
        d.sub.restorativeSpringConstants = pointSpringConstants.*scaledRestorativeMultiplier;
        
        selfConstants = pointSpringConstants(d.sub.interactionSelvesIdx);
        pairConstants = pointSpringConstants(d.sub.interactionPairsIdx);
        d.sub.centralInteractionSpringConstants = (1./(2.*selfConstants) + 1./(2.*pairConstants)).^-1;
        
        d.sub.repulsionSpringConstants = pointSpringConstants(d.sub.interactionSelvesIdx(d.sub.repulsionVectorsIdx));
        
    case 'Gradient'
        
        fSubstrateGradientValues = app.substrateParameters.youngsModulusConstant.*app.stiffnessGradientInformation(:,2).*1000.*app.systemParameters.scalingTime./app.systemParameters.eta;
        
        baseStiffness = min(fSubstrateGradientValues);
        baseMultipliers = fSubstrateGradientValues./baseStiffness;

        substrateRadius = 1.05*sqrt(max(d.sub.pointsX.^2 + d.sub.pointsY.^2));
        
        [substrateGridX, substrateGridY] = meshgrid(-substrateRadius:d.spar.substratePointDistance/2:substrateRadius+d.spar.substratePointDistance/2,-substrateRadius:d.spar.substratePointDistance/2:substrateRadius+d.spar.substratePointDistance/2);

        gradientPositions = app.stiffnessGradientInformation(:,1).*1e-6/app.systemParameters.scalingLength;
        
        multipliers = arrayfun(@(position) get_gradient_multiplier(position,baseMultipliers,gradientPositions), substrateGridY);
        
        if app.stiffnessGradientInformation(1,3) ~= 0
            rotatedCoordinates = [cosd(-app.stiffnessGradientInformation(3,1)) -sind(-app.stiffnessGradientInformation(3,1)) ; sind(-app.stiffnessGradientInformation(3,1)) cosd(-app.stiffnessGradientInformation(3,1))]*[substrateGridX(:)' ; substrateGridY(:)'];
            substrateGridX = rotatedCoordinates(1,:)';
            substrateGridY = rotatedCoordinates(2,:)';
        end
        
        multipliers = griddata(substrateGridX(:),substrateGridY(:),multipliers(:),d.sub.pointsX, d.sub.pointsY);
        
        pointSpringConstants = multipliers.*baseStiffness;
        
        d.sub.restorativeSpringConstants = pointSpringConstants.*scaledRestorativeMultiplier;
        
        selfConstants = pointSpringConstants(d.sub.interactionSelvesIdx);
        pairConstants = pointSpringConstants(d.sub.interactionPairsIdx);
        d.sub.centralInteractionSpringConstants = (1./(2.*selfConstants) + 1./(2.*pairConstants)).^-1;
        
        d.sub.repulsionSpringConstants = pointSpringConstants(d.sub.interactionSelvesIdx(d.sub.repulsionVectorsIdx));

end

end

function multiplier = get_gradient_multiplier(position,baseMultipliers,gradientPositions)



if length(gradientPositions) == 1
    multiplier = baseMultipliers(1);
else
    if position <= gradientPositions(1)
        multiplier = baseMultipliers(1);
    elseif position >= gradientPositions(end)
        multiplier = baseMultipliers(end);
    else
        for i = 1:length(gradientPositions)-1
            if  position > gradientPositions(i) && position <= gradientPositions(i+1)
                multiplier = (baseMultipliers(i+1) - baseMultipliers(i))/(gradientPositions(i+1) - gradientPositions(i)).*(position - gradientPositions(i)) + baseMultipliers(i);
                return
            end
        end
    end
end


end