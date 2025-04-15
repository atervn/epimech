function d = setup_glass_settings(app,d)
% SETUP_GLASS_SETTINGS Setup settings for the glass movement
%   The function collects the settings for the glass movement
%   during the simulation.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if optogenetic simulation
if d.simset.simulationType == 6
    
    d.simset.glass.glassOffset = 0;

    % get the time points where the changes in the positions occur
    % (add large value to the end to make sure there is always next time
    % point available)
    d.simset.glass.times = [app.glassActivation(:,1) ; 1e12]./d.spar.scalingTime;
    
    % get the glass movements starting from the time points (duplicate
    % the last activation level and multiply with the full movement)
    if app.glassActivation(1,2) == 0
        d.simset.glass.times = [app.glassActivation(:,1) ; 1e12]./d.spar.scalingTime;
        d.simset.glass.positions = [app.glassActivation(:,2); app.glassActivation(end,2)].*1e-6./d.spar.scalingLength;
    else
        d.simset.glass.times = [app.glassActivation(1,1); app.glassActivation(:,1) ; 1e12]./d.spar.scalingTime;
        d.simset.glass.positions = [app.glassActivation(1,2); app.glassActivation(:,2); app.glassActivation(end,2)].*1e-6./d.spar.scalingLength;
    end
    % get the activation region shapes
    d.simset.glass.shapes = app.glassActivationShapes;
    
    d.simset.glass.substrateIdx = [];
    for i = 1:length(d.simset.glass.shapes)
        d.simset.glass.substrateIdx = [d.simset.glass.substrateIdx; find(check_if_inside(d.simset.glass.shapes{i}(:,1),d.simset.glass.shapes{i}(:,2),d.sub.pointsX,d.sub.pointsY))];
    end
    
    d.simset.glass.substrateIdx = unique(d.simset.glass.substrateIdx);

    % initialize a varible to keep track of the current time point and
    % activation level index
    d.simset.glass.currentTime = 1;
end

end