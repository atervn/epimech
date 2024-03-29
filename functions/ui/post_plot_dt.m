function post_plot_dt(d)
% POST_PLOT_DT Plot the time step after the simulations
%   The function plot the the values of the time step after the simulation
%   if the setting is selected in the GUI.
%   INPUTS:
%       d: main simulation data structure
%       timeStepsCells: cell time step vector
%       timeStepsSub: substrate time step vector
%   by Aapo Tervonen, 2021

% if the plot is to be plotted
if d.simset.dtPlot
    
    % create the figure and plot the cell time steps
    figure(2); semilogy(d.simset.timeStepsCells);
    
    % if substrate is included, plot the substrate time step
    if d.simset.simulationType == 2
        hold on
        plot(d.simset.timeStepsSub);
        hold off
    end
end

end