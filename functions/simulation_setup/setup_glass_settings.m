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

    times = app.glassActivation(:,1);
    displacements = app.glassActivation(:,2);

    for i = length(displacements):-1:2
        if i == length(displacements)
            times = [times(1:i); times(i)+app.systemParameters.glassMovementTime];
            displacements = [displacements(1:i-1); displacements(i-1); displacements(i)];
        else
            times = [times(1:i); times(i)+app.systemParameters.glassMovementTime; times(i+1:end)];
            displacements = [displacements(1:i-1); displacements(i-1); displacements(i:end)];
        end
    end

    % get the time points where the changes in the positions occur
    % (add large value to the end to make sure there is always next time
    % point available)
    if max(times./d.spar.scalingTime) < d.spar.simulationTime
        d.simset.glass.times = [times./d.spar.scalingTime ; d.spar.simulationTime+10];
    else
        d.simset.glass.times = [times./d.spar.scalingTime ; (times(end) + 1)./d.spar.scalingTime];
    end
    
    % get the glass movements starting from the time points (duplicate
    % the last activation level and multiply with the full movement)
    d.simset.glass.positions = [displacements; displacements(end)].*1e-6./d.spar.scalingLength;

    % get the activation region shapes
    d.simset.glass.shapes = app.glassActivationShapes;
    
    % initialize a varible to keep track of the current time point and
    % activation level index
    d.simset.glass.currentTime = 1;
end

end