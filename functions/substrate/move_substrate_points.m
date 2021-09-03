function d = move_substrate_points(d,time,dt)

previousTime = max(d.simset.stretch.times(d.simset.stretch.times <= time+dt));
nextTime = min(d.simset.stretch.times(d.simset.stretch.times > time+dt));

previousIdx = find(d.simset.stretch.times == previousTime);
nextIdx = find(d.simset.stretch.times == nextTime);

if previousTime == time+dt
    multiplierCurrent = d.simset.stretch.values(previousIdx);
else
    multiplierCurrent = d.simset.stretch.values(previousIdx) + (d.simset.stretch.values(nextIdx) - d.simset.stretch.values(previousIdx))*(time+dt - d.simset.stretch.times(previousIdx))/(d.simset.stretch.times(nextIdx) - d.simset.stretch.times(previousIdx));
end

previousTime = max(d.simset.stretch.times(d.simset.stretch.times <= time));
nextTime = min(d.simset.stretch.times(d.simset.stretch.times > time));

previousIdx = find(d.simset.stretch.times == previousTime);
nextIdx = find(d.simset.stretch.times == nextTime);

if previousTime == time
    multiplierPrevious = d.simset.stretch.values(previousIdx);
else
    multiplierPrevious = d.simset.stretch.values(previousIdx) + (d.simset.stretch.values(nextIdx) - d.simset.stretch.values(previousIdx))*(time - d.simset.stretch.times(previousIdx))/(d.simset.stretch.times(nextIdx) - d.simset.stretch.times(previousIdx));
end

if d.simset.stretch.axis == 1
    d.sub.pointsX = multiplierCurrent.*d.sub.pointsOriginalX;
    cellMultiplier = multiplierCurrent./multiplierPrevious;
    for k = 1:length(d.cells)
        if d.cells(k).cellState == 0
            d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
        end
    end
elseif d.simset.stretch.axis == 2
    d.sub.pointsX = multiplierCurrent.*d.sub.pointsOriginalX;
    d.sub.pointsY = multiplierCurrent.*d.sub.pointsOriginalY;
    cellMultiplier = multiplierCurrent./multiplierPrevious;
    for k = 1:length(d.cells)
        if d.cells(k).cellState == 0
            d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
            d.cells(k).edgeInitialY = d.cells(k).edgeInitialY.*cellMultiplier;
        end
    end
end

% multiplier = d.simset.stretching.current - d.simset.stretching.rate*dt;
% 
% if multiplier >= 1 && multiplier <= d.simset.stretching.maximum
%     if d.simset.stretching.axis == 1
%         d.sub.pointsX = multiplier.*d.sub.pointsOriginalX;
%         cellMultiplier = multiplier./d.simset.stretching.current;
%         d.simset.stretching.current = multiplier;
%         for k = 1:length(d.cells)
%             if d.cells(k).cellState == 0
%                 d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
%             end
%         end
%     elseif d.simset.stretching.axis == 2
%         d.sub.pointsX = multiplier.*d.sub.pointsOriginalX;
%         d.sub.pointsY = multiplier.*d.sub.pointsOriginalY;
%         cellMultiplier = multiplier./d.simset.stretching.current;
%         d.simset.stretching.current = multiplier;
%         for k = 1:length(d.cells)
%             if d.cells(k).cellState == 0
%                 d.cells(k).edgeInitialX = d.cells(k).edgeInitialX.*cellMultiplier;
%                 d.cells(k).edgeInitialY = d.cells(k).edgeInitialY.*cellMultiplier;
%             end
%         end
%     end
end
