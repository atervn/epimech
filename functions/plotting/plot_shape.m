function plot_shape(d)
% PLOT_SHAPE Plot a shape over the cells
%   The function plots a square or a circle over the cells. Used when
%   visualizing the substrate size or when removing cell with shape.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021
    
% if cell removal with shape
if d.pl.plotType == 2
    
    % which shape
    switch d.pl.shape
        
        % rectangle
        case 1
            
            % get the size
            halfSize = d.pl.shapeSize;
            
            % get the coordinates
            cornersX = [-halfSize halfSize halfSize -halfSize -halfSize];
            cornersY = [-halfSize -halfSize halfSize halfSize -halfSize];
            
            % plot the rectangle
            plot(d.pl.axesHandle,cornersX,cornersY, '-c', 'LineWidth',2)
        
        % circle
        case 2
            
            % get the coordinates
            coordsX = d.pl.shapeSize.*cos(linspace(0, 2*pi, 500));
            coordsY = d.pl.shapeSize.*sin(linspace(0, 2*pi, 500));
            
            % plot the circle
            plot(d.pl.axesHandle,coordsX,coordsY,'-c','LineWidth',5)
    end

% if substrate is visualized
elseif d.pl.plotType == 3
    
    % get the half of the substrate size
    halfSize = d.simset.substrateSize/2;
    
    % create coordinate vectors
    cornersX = [-halfSize halfSize halfSize -halfSize -halfSize];
    cornersY = [-halfSize -halfSize halfSize halfSize -halfSize];
    
    % plot the shape
    plot(d.pl.axesHandle,cornersX,cornersY, '--r', 'LineWidth',2)
end

end