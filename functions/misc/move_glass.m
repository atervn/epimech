function d = move_glass(d,time)

previousTime = max(d.simset.glass.times(d.simset.glass.times <= time));
nextTime = min(d.simset.glass.times(d.simset.glass.times > time));

% get the indices of the these changes in the movement change vectors
previousIdx = find(d.simset.glass.times == previousTime);
nextIdx = find(d.simset.glass.times == nextTime);

% if the time is exactly at a time point where the pipette location is
% defined
if previousTime == time
    
    % get the displacement from the initial position
    d.simset.glass.glassOffset = d.simset.glass.positions(previousIdx);
    
% otherwise
else
    
    % interpolate the displacement from the initial position
    d.simset.glass.glassOffset = d.simset.glass.positions(previousIdx) + (d.simset.glass.positions(nextIdx) - d.simset.glass.positions(previousIdx))*(time - d.simset.glass.times(previousIdx))/(d.simset.glass.times(nextIdx) - d.simset.glass.times(previousIdx));
end
end