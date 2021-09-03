function [d, ok] = form_focal_adhesions(d,app)

% containts information on how many cells vertices are connected to a
% substrate point
d.sub.adhesionNumbers = zeros(d.sub.nPoints,1);

ok = 1;

springScaling = 1/app.substrateParameters.youngsModulusConstant/app.systemParameters.scalingTime*app.systemParameters.eta/(app.substrateParameters.restorativeForceConstant*2*sqrt(3)*(app.substrateParameters.substratePointDistance*1e6/2)^2);

for k = 1:length(d.cells)
    
    focalAdhesionPoints = zeros(d.cells(k).nVertices,3);
    adhesionLinkCols = zeros(d.cells(k).nVertices,3);
    
    for i = 1:d.cells(k).nVertices
        [~, focalAdhesionPoints(i,:)] = mink((d.cells(k).verticesX(i) - d.sub.pointsX).^2 + (d.cells(k).verticesY(i) - d.sub.pointsY).^2,3);
        d.sub.adhesionNumbers(focalAdhesionPoints(i,:)) = d.sub.adhesionNumbers(focalAdhesionPoints(i,:)) + 1;
        adhesionLinkCols(i,:) = d.sub.adhesionNumbers(focalAdhesionPoints(i,:))';
    end
    
    pointXs = d.sub.pointsX(focalAdhesionPoints(:));
    pointYs = d.sub.pointsY(focalAdhesionPoints(:));
    
    pointXs = reshape(pointXs,[],3);
    pointYs = reshape(pointYs,[],3);
    
    W1 = ((pointYs(:,2) - pointYs(:,3)).*(d.cells(k).verticesX - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(d.cells(k).verticesY - pointYs(:,3)))./...
        ((pointYs(:,2) - pointYs(:,3)).*(pointXs(:,1) - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(pointYs(:,1) - pointYs(:,3)));
    W2 = ((pointYs(:,3) - pointYs(:,1)).*(d.cells(k).verticesX - pointXs(:,3)) + (pointXs(:,1) - pointXs(:,3)).*(d.cells(k).verticesY - pointYs(:,3)))./...
        ((pointYs(:,2) - pointYs(:,3)).*(pointXs(:,1) - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(pointYs(:,1) - pointYs(:,3)));
    W3 = 1 - W1 - W2;
    
    d.cells(k).substrate.points = focalAdhesionPoints;
    d.cells(k).substrate.pointsLin = focalAdhesionPoints(:);
    d.cells(k).substrate.weights = [W1 W2 W3];
    d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
    d.cells(k).substrate.linkCols = adhesionLinkCols;
    d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.pointsLin,d.cells(k).substrate.linkCols(:));
    d.cells(k).substrate.connected = true(d.cells(k).nVertices,1);
    
    if any(isnan(d.cells(k).substrate.weightsLin))
        ok = 0;
        return;
    end
    
    if d.simset.simulationType == 3
        d.cells(k).substrate.fFocalAdhesions = get_individual_fFAs(100000,app.fFAInfo,app.systemParameters,app.cellParameters);
    elseif strcmp(app.StiffnessstyleButtonGroup.SelectedObject.Text,'Constant')
        pointYoungs = d.sub.restorativeSpringConstants.*springScaling;
        d.cells(k).substrate.fFocalAdhesions = get_individual_fFAs(pointYoungs(1),app.fFAInfo,app.systemParameters,app.cellParameters);
    else
        
        pointYoungs = d.sub.restorativeSpringConstants.*springScaling;
        
        % get weighted mean young's per vertex
        FAYoungs = sum(pointYoungs(d.cells(k).substrate.points).*d.cells(k).substrate.weights,2);
        
        d.cells(k).substrate.fFocalAdhesions = arrayfun(@(FAYoungs) get_individual_fFAs(FAYoungs,app.fFAInfo,app.systemParameters,app.cellParameters), FAYoungs);
        
    end
end

end

function fFocalAdhesion = get_individual_fFAs(FAYoungs,fFAInfo,systemParameters,cellParameters)

if FAYoungs <= fFAInfo(1,1)
    fFATemp = fFAInfo(1,2);
elseif FAYoungs >= fFAInfo(end,1)
    fFATemp = fFAInfo(end,2);
else
    for i = 1:size(fFAInfo,1)-1
        if (FAYoungs >= fFAInfo(i,1))
            if (FAYoungs <= fFAInfo(i+1,1))
                fFATemp = (fFAInfo(i+1,2) - fFAInfo(i,2))/(fFAInfo(i+1,1) - fFAInfo(i,1)).*(FAYoungs - fFAInfo(i,1)) + fFAInfo(i,2);
                break;
            end
        end
    end
end

% scaling at the end to take into account that this is per um of membrane
% (membraneLength scaled to um instead of m)
fFocalAdhesion = fFATemp*systemParameters.scalingTime/systemParameters.eta*cellParameters.membraneLength/1e-6;

end