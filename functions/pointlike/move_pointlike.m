function pointlike = move_pointlike(time,dt,pointlike)
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
    previousTime = max(pointlike.movementTime(pointlike.movementTime <= time));
    nextTime = min(pointlike.movementTime(pointlike.movementTime > time));
    
    % get the indices of the these changes in the movement change vectors
    previousIdx = find(pointlike.movementTime == previousTime);
    nextIdx = find(pointlike.movementTime == nextTime);
    
    % if the time is exactly at a time point where the pipette location is
    % defined
    if previousTime == time
        
        % get the displacement from the initial position
        displacementY = pointlike.movementY(previousIdx);
        
    % otherwise
    else
        
        % interpolate the displacement from the initial position
        displacementY = pointlike.movementY(previousIdx) + (pointlike.movementY(nextIdx) - pointlike.movementY(previousIdx))*(time - pointlike.movementTime(previousIdx))/(pointlike.movementTime(nextIdx) - pointlike.movementTime(previousIdx));
    end
    
    % calculate a multiplier that assumes that the final position of the
    % pipette is at the boundary of the manipulated cell (this the cell is only
    % moved by (maximum pipette movement - (distance between cell center and
    % the boundary at the direction of the movement))/ maximum pipette movement
    multiplier = (max(pointlike.movementY) - abs(max(pointlike.vertexOriginalY) - pointlike.originalY))/max(pointlike.movementY);
    
    % move the pipette (used for visualization purposes mostly
    pointlike.pointY = pointlike.originalY + displacementY;
    
    % move the virtual image of the manipulated cell
    pointlike.vertexY = pointlike.vertexOriginalY + displacementY.*multiplier;
end

end