function plot_glass_region(d,time)
% PLOT_OPTO_REGION Plot the shape of the optogenetic activation region
%   The function plots the shape(s) of the optogenetic activation regions
%   either in red or in violet if the cells are red.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   by Aapo Tervonen, 2021

% if the regions are plotted
if d.pl.glass
    
    % Get the index of the previous change in activation
    timeIdx = find(d.simset.glass.times <= time, 1, 'last' );
    
    % if the activation level currently is nonzero
    if d.simset.glass.positions(timeIdx+1) > 0
        
        % go through the activation regions
        for i = 1:length(d.simset.glass.shapes)
            
            % if the cell boundaries are red, plot in violet
            if d.pl.cellStyle == 2
                optoHandle = fill(d.simset.glass.shapes{i}(:,1),d.simset.glass.shapes{i}(:,2),[0.47 0.01 0.99], 'EdgeColor',[0.47 0.01 0.99]);
            
            % otherwise, plot in red
            else
                optoHandle = fill(d.simset.glass.shapes{i}(:,1),d.simset.glass.shapes{i}(:,2),[0 0 1], 'EdgeColor',[0 0 1]);
            end
            
            % set the alpha channel to 0.5 to make slightly transparent
            alpha(optoHandle,0.1);
        end
    end
end

end