function plot_frame(d)
% PLOT_FRAME Plot the frame for the frame simulation
%   The function plots the frame used in the frame simulation. Currently
%   note activated in the platform.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if frame simulation
if d.simset.simulationType == 4
    
    % get the corner coordinate for the frame
    corner = d.cells(end).verticesX(1);
    
    % create the frame coordinates (the frame is given thickess by going
    % around twice (hence the corner+-0.5)
    xVector = [corner -corner -corner corner corner corner-0.5 corner-0.5 -corner+0.5 -corner+0.5 corner-0.5 corner-0.5];
    yVector = [corner corner -corner -corner corner corner -corner+0.5 -corner+0.5 corner-0.5 corner-0.5 corner];
    
    %  plot the frame
    fill(d.pl.axesHandle,xVector,yVector,[0 0 0], 'linewidth', 0.5, 'edgecolor', [0 0 0])
end

end