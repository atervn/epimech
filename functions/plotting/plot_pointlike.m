function plot_pointlike(d)
% PLOT_POINTLIKE Plots the pointlike cross
%   The function plots the pointlike cross with either red or violet (if
%   the cells are red)
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if pointlike is plotted
if d.pl.pointlike
    
    % if the cell style is red boundary
    if d.pl.cellStyle == 2
        
        % plot the pointlike cross in violet
        plot(d.pl.axesHandle,d.simset.pointlike.pointX,d.simset.pointlike.pointY,'x','markersize', 20,'LineWidth', 3, 'Color', [0.47 0.01 0.99]);
    
    % otherwise
    else
        
        % plot the pointlike cross in red
        plot(d.pl.axesHandle,d.simset.pointlike.pointX,d.simset.pointlike.pointY,'rx','markersize', 20,'LineWidth', 3);
    end
end

end