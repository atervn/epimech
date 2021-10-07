function plot_cell_descriptors(d,k)
% PLOT_CELL_DESCRIPTORS Plot the cells with the face color based on a
% descriptor
%   The function plots the cell bodies with their face coloring their value
%   for the chosen shape descriptor, including absolute area, area strain,
%   perimeter, perimeter strain, circularity, aspect ratio, and long axis
%   angle.

%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% which descriptor
switch d.pl.cellStyle
    
    % area
    case 7
        
        % get the area and scale it to cubic micrometers
        d.cells(k) =  get_cell_areas(d.cells(k));
        descriptorValue = d.cells(k).area*d.spar.scalingLength^2*1e12;

    % area strain
    case 8
        
        % get the area and calculate the strain
        d.cells(k) =  get_cell_areas(d.cells(k));
        descriptorValue = (d.cells(k).area - d.cells(k).normArea)/d.cells(k).normArea;

    % perimeter 
    case 9
        
        % get the perimeter and scale it to micrometers
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        descriptorValue = d.cells(k).perimeter*d.spar.scalingLength*1e6;

    % perimeter strain
    case 10
        
        % get the perimeter and calculate the perimeter strain
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        descriptorValue = (d.cells(k).perimeter - d.cells(k).normPerimeter)/d.cells(k).normPerimeter;

    % circularity
    case 11
        
        % get the area and perimeter and calculate the circulatiry
        % according to the formula 4*pi*A/P^2
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        d.cells(k) =  get_cell_areas(d.cells(k));
        descriptorValue = 4*pi*d.cells(k).area/d.cells(k).perimeter^2;

    % aspect ratio
    case 12
        
        % fit an ellipse to the cell and calculate the aspect ratio from
        % the long and short axes
        ellipseData = fit_ellipse(d.cells(k).verticesX,d.cells(k).verticesY);
        descriptorValue = ellipseData.long_axis/ellipseData.short_axis;

    % angle
    case 13
        
        % fit an ellipse to the cell and calculate the angle of the long
        % axis
        ellipseData = fit_ellipse(d.cells(k).verticesX,d.cells(k).verticesY);
        descriptorValue = ellipseData.phi*180/pi;
end

% if the descriptor value is below the preset range minimum limit, set its
% color to the range minimum
if descriptorValue < min(d.pl.colorLocations)
    color = d.pl.colormap(1,:);
    
% if the descriptor value is above the preset range maximum limit, set its
% color to the range maximum
elseif descriptorValue > max(d.pl.colorLocations)
    color = d.pl.colormap(end,:);
    
%otherwise interpolate the color from the range
else
    color = interp1(d.pl.colorLocations,d.pl.colormap,descriptorValue);
end

% plot the cell body with the obtained color
fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,color, 'linewidth', 0.5, 'edgecolor', [0 0 0])

end