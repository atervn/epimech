function d = move_glass(d,time,subDt)

previousTime = max(d.simset.glass.times(d.simset.glass.times <= time));
nextTime = min(d.simset.glass.times(d.simset.glass.times > time));

% get the indices of the these changes in the movement change vectors
previousIdx = find(d.simset.glass.times == previousTime);
nextIdx = find(d.simset.glass.times == nextTime);

% if the time is exactly at a time point where the pipette location is
% defined
if previousTime == time
    
    % get the displacement from the initial position
    positionBefore = d.simset.glass.positions(previousIdx);
    
% otherwise
else
    
    % interpolate the displacement from the initial position
    positionBefore = d.simset.glass.positions(previousIdx) + (d.simset.glass.positions(nextIdx) - d.simset.glass.positions(previousIdx))*(time - d.simset.glass.times(previousIdx))/(d.simset.glass.times(nextIdx) - d.simset.glass.times(previousIdx));
end

previousTime = max(d.simset.glass.times(d.simset.glass.times <= time+subDt));
nextTime = min(d.simset.glass.times(d.simset.glass.times > time+subDt));

% get the indices of the these changes in the movement change vectors
previousIdx = find(d.simset.glass.times == previousTime);
nextIdx = find(d.simset.glass.times == nextTime);

% if the time is exactly at a time point where the pipette location is
% defined
if previousTime == time+subDt
    
    % get the displacement from the initial position
    positionAfter = d.simset.glass.positions(previousIdx);
    
% otherwise
else
    
    % interpolate the displacement from the initial position
    positionAfter = d.simset.glass.positions(previousIdx) + (d.simset.glass.positions(nextIdx) - d.simset.glass.positions(previousIdx))*(time+subDt - d.simset.glass.times(previousIdx))/(d.simset.glass.times(nextIdx) - d.simset.glass.times(previousIdx));
end

movement = positionAfter-positionBefore;

substrateIdx = [];
for i = 1:length(d.simset.glass.shapes)
    substrateIdx = [substrateIdx; find(check_if_inside(d.simset.glass.shapes{i}(:,1),d.simset.glass.shapes{i}(:,2),d.sub.pointsOriginalX,d.sub.pointsOriginalY))];
end
 
substrateIdx = unique(substrateIdx);

d.sub.pointsOriginalY(substrateIdx) = d.sub.pointsOriginalY(substrateIdx) + movement;

end