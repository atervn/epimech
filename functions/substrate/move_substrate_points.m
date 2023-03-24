function d = move_substrate_points(d,time,dt)
% MOVE_SUBSTRATE-POINTS Strech or compress the substrate laterally
%   The functions moves the substrate points based on the predefined path
%   during lateral stretching or compression simulations (the substrate
%   movement is not solved). Also the initial positions of the edge
%   vertices for the edge cells are changed, since they are in relation to
%   the changing substrate point positions.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%       dt: current time step
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if stretching simulation
if d.simset.simulationType == 3
    
    % get the previous and next time points where there are changes in the
    % movement compared to (time + dt)
    previousTime = max(d.simset.stretch.times(d.simset.stretch.times <= time+dt));
    nextTime = min(d.simset.stretch.times(d.simset.stretch.times > time+dt));
    
    % get the indices of the these changes in the movement change vectors
    previousIdx = find(d.simset.stretch.times == previousTime);
    nextIdx = find(d.simset.stretch.times == nextTime);
    
    % if the (time + dt) is exactly at a time point where the change in substrate
    % movement is defined
    if previousTime == time+dt
        
        % get multiplier for the next movement
        multiplierNext = d.simset.stretch.values(previousIdx);
        
    % otherwise
    else
        
        % interpolate the multiplier for the next movement
        multiplierNext = d.simset.stretch.values(previousIdx) + (d.simset.stretch.values(nextIdx) - d.simset.stretch.values(previousIdx))*(time+dt - d.simset.stretch.times(previousIdx))/(d.simset.stretch.times(nextIdx) - d.simset.stretch.times(previousIdx));
    end
    
    % get the previous and next time points where there are changes in the
    % movement compared to (time)
    previousTime = max(d.simset.stretch.times(d.simset.stretch.times <= time));
    nextTime = min(d.simset.stretch.times(d.simset.stretch.times > time));
    
    % get the indices of the these changes in the movement change vectors
    previousIdx = find(d.simset.stretch.times == previousTime);
    nextIdx = find(d.simset.stretch.times == nextTime);
    
    % if the (time) is exactly at a time point where the change in substrate
    % movement is defined
    if previousTime == time
        
        % get multiplier for previous movement
        multiplierPrevious = d.simset.stretch.values(previousIdx);
        
    % otherwise
    else
        
        % interpolate multiplier for previous movenent
        multiplierPrevious = d.simset.stretch.values(previousIdx) + (d.simset.stretch.values(nextIdx) - d.simset.stretch.values(previousIdx))*(time - d.simset.stretch.times(previousIdx))/(d.simset.stretch.times(nextIdx) - d.simset.stretch.times(previousIdx));
    end
    
    % uniaxial stretch or compression
    if d.simset.stretch.axis == 1
        
        % move the substrate points
        d.sub.pointsX = multiplierNext.*d.sub.pointsOriginalX;
        
        % calculate a multiplier to use to move the edge vertex inital
        % positions (since the multiplier is defined for the substarte (i.e.
        % how much substrate is moved from the rest positions, the same
        % multiplier cannot be used for the cells directly. Therefore, change
        % between the previous locations (using the previous multiplier) is
        % used to obtain the movement relative to previous positions
        cellMultiplier = multiplierNext/multiplierPrevious;
        
        % go through the cells
        for k = 1:length(d.cells)
            
            % if edge cell
            if d.cells(k).cellState == 0
                
                % calculate the new initial edge positions
                d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
            end
        end
        
    % biaxial stretch of compression
    elseif d.simset.stretch.axis == 2
        
        % move the substrate points
        d.sub.pointsX = multiplierNext.*d.sub.pointsOriginalX;
        d.sub.pointsY = multiplierNext.*d.sub.pointsOriginalY;
        
        % calculate the edge vertex initial position multiplier
        cellMultiplier = multiplierNext./multiplierPrevious;
        
        % go through the cells
        for k = 1:length(d.cells)
            
            % if edge cell
            if d.cells(k).cellState == 0
                
                % calculate the new initial edge positions
                d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
                d.cells(k).edgeInitialY = d.cells(k).edgeInitialY.*cellMultiplier;
            end
        end
    end
    
end

end
