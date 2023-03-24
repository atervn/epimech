function plot_substrate(d)
% PLOT_SUBSTRATE Plot the substrate points and focal adhesions
%   The function plots the substrate based on the chosen style and the
%   focal adhesions if required.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% substrate style
switch d.pl.substrateStyle
    
    % with only circles at the substrate point positions
    case 1
        plot(d.pl.axesHandle,d.sub.pointsX,d.sub.pointsY,'o','color',[0.8 0.8 0.8]);
        
        % with lines showing the triangular grid (this takes a long time to
        % plot)
    case 2
        
        % get coordinates for the interactions
        pointsX = d.sub.pointsX(d.sub.interactionSelvesIdx)';
        pointsY = d.sub.pointsY(d.sub.interactionSelvesIdx)';
        pairsX = d.sub.pointsX(d.sub.interactionPairsIdx)';
        pairsY = d.sub.pointsY(d.sub.interactionPairsIdx)';
        
        % plot all on one go
        plot(d.pl.axesHandle,[pointsX ; pairsX],[pointsY ; pairsY],'-','color',[0.8 0.8 0.8])
end

% if focal adhesions are plotted
if d.pl.focalAdhesions
    
    % initialize matrices
    plotXs = [];
    plotYs = [];
    
    % go through the cells
    for k = 1:length(d.cells)
        
        % get cell center coordinates
        centerX = mean(d.cells(k).verticesX);
        centerY = mean(d.cells(k).verticesY);
        
        % checks if the cell is within the shown section of the epithelium
        % (the focal adhesions of the cells outside are not plotted, since
        % this takes unnecessary time), currently the limit is that the
        % cell center is more than one scaling length (by default 20 nm)
        % outsidde the plot area, IMPROVE
        if centerX > d.pl.axisLimits(1)-1 && centerX < d.pl.axisLimits(2)+1 && centerY > d.pl.axisLimits(3)-1 && centerY < d.pl.axisLimits(4)+1
            
            % find the connected vertices
            connected = find(d.cells(k).substrate.connected);
            
            % get the coordinates of the relevant substrate points
            substrateX = d.sub.pointsX(d.cells(k).substrate.pointsLin);
            substrateY = d.sub.pointsY(d.cells(k).substrate.pointsLin);
            
            % calcaulte the adhesion points
            adhesionPointsX = sum(reshape(substrateX.*d.cells(k).substrate.weightsLin,[],3),2);
            adhesionPointsY = sum(reshape(substrateY.*d.cells(k).substrate.weightsLin,[],3),2);
            
            % add the focal adhesions links to the coordinates matrices
            plotXs = [plotXs [d.cells(k).verticesX(connected)' ; adhesionPointsX']]; %#ok<AGROW>
            plotYs = [plotYs [d.cells(k).verticesY(connected)' ; adhesionPointsY']]; %#ok<AGROW>
        end
    end
    
    % plot the focal adhesions
    plot(d.pl.axesHandle,plotXs,plotYs,'-k')
end

end