function d = move_pointlike(d, time, dt)
% MOVE_POINTLIKE Move the micromanipulated cell
%   The functions moves the micromanipulated cell according to the
%   predefined movement.
%   INPUTS:
%       time: current simulation time
%       dt: current simulation time step
%       pointlike: pointlike data structure
%   OUTPUT:
%       pointlike: pointlike data structure
%   by Aapo Tervonen, 2021

% if pointlike simulation
if d.simset.simulationType == 2
    
    % calculate the next time
    time = time + dt;
    
    % get the previous and nex time points where there are changes in the
    % movement
    previousTime = max(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime <= time));
    nextTime = min(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime > time));
    
    % get the indices of the these changes in the movement change vectors
    previousIdx = find(d.simset.pointlike.movementTime == previousTime);
    nextIdx = find(d.simset.pointlike.movementTime == nextTime);
    
    % if the time is exactly at a time point where the pipette location is
    % defined
    if previousTime == time
        
        % get the displacement from the initial position
        displacementY = d.simset.pointlike.movementY(previousIdx);
        
    % otherwise
    else
        
        % interpolate the displacement from the initial position
        displacementY = d.simset.pointlike.movementY(previousIdx) + (d.simset.pointlike.movementY(nextIdx) - d.simset.pointlike.movementY(previousIdx))*(time - d.simset.pointlike.movementTime(previousIdx))/(d.simset.pointlike.movementTime(nextIdx) - d.simset.pointlike.movementTime(previousIdx));
    end
    
    % calculate a multiplier that assumes that the final position of the
    % pipette is at the boundary of the manipulated cell (the cell is only
    % moved by (maximum pipette movement - (distance between cell center
    % and the boundary at the direction of the movement))/ maximum pipette
    % movement 
    multiplier = (max(d.simset.pointlike.movementY) - abs(max(d.simset.pointlike.vertexOriginalY) - d.simset.pointlike.originalY))/max(d.simset.pointlike.movementY);
    
    % move the pipette (used for visualization purposes mostly
    d.simset.pointlike.pointY = d.simset.pointlike.originalY + displacementY;
    
    % move the virtual image of the manipulated cell
    d.simset.pointlike.vertexY = d.simset.pointlike.vertexOriginalY + displacementY.*multiplier;
end

end