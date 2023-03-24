function plot_legend(d)
% PLOT_LEGEND Create a legend for the number of neighbors cell style
%   The function creates a legend indicating the colors for the number of
%   neighbors for the corresponding cell plot style.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if the cell style is the number of neighbors
if d.pl.cellStyle == 3

    % set marker size
    markerSize = 20;
    
    % initialize a vector for the colors
    legendColors = zeros(8, 1);
    
    % plot nonexisting square markers with the correct colors
    legendColors(1) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.6 0.73 0.62],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(2) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.69 0.55],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(3) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.59 0.55],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(4) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.55 0.59],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(5) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.5 0.59 0.71],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(6) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.59 0.63 0.71],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(7) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.55 0.69 0.70],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    legendColors(8) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.40 0.45 0.41],'MarkerEdgeColor', 'k', 'MarkerSize', markerSize);
    
    % create the legend
    legend(d.pl.axesHandle,legendColors, '1','2','3','4','5','6','7','7+','FontSize',14);
end

end