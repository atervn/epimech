function d = setup_optogenetic_settings(app,d)
% SETUP_OPTOGENETIC_SETTINGS Setup settings for the optogenetic activation
%   The function collects the settings for the optogenetic activation
%   during the simulation.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if optogenetic simulation
if d.simset.simulationType == 5
    
    % get the time points where the changes in the activtion levels occur
    % (add large value to the end to make sure there is always next time
    % point available)
    d.simset.opto.times = [app.optoActivation(:,1) ; 1e12]./d.spar.scalingTime;
    
    % get the actiovation levels starting from the time points (duplicate
    % the last activation level and multiply with the full activation
    % constant)
    d.simset.opto.levels = [app.optoActivation(:,2); app.optoActivation(end,2)].*d.spar.fullActivationConstant;
    
    % get the activation region shapes
    d.simset.opto.shapes = app.optoShapes;
    
    % get the initial cells and vertices in those cell that are within the
    % activation regions
    d.simset.opto.cells = app.optoVertices.cells;
    d.simset.opto.vertices = app.optoVertices.vertices;
    
    % initialize a varible to keep track of the current time point and
    % activation level index
    d.simset.opto.currentTime = 1;
end

end