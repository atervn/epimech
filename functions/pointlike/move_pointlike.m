function pointlike = move_pointlike(time,pointlike)

previousTime = max(pointlike.movementTime(pointlike.movementTime <= time));
nextTime = min(pointlike.movementTime(pointlike.movementTime > time));

previousIdx = find(pointlike.movementTime == previousTime);
nextIdx = find(pointlike.movementTime == nextTime);

if previousTime == time
    displacementY = pointlike.movementY(previousIdx);
else
    displacementY = pointlike.movementY(previousIdx) + (pointlike.movementY(nextIdx) - pointlike.movementY(previousIdx))*(time - pointlike.movementTime(previousIdx))/(pointlike.movementTime(nextIdx) - pointlike.movementTime(previousIdx));
end

multiplier = (1.5 - abs(max(pointlike.vertexOriginalY) - pointlike.originalY))/1.5;

pointlike.pointY = pointlike.originalY + displacementY;

pointlike.vertexY = pointlike.vertexOriginalY + displacementY.*multiplier;