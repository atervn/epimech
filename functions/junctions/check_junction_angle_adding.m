function angleCheck = check_junction_angle_adding(spar,cells,i,pairVerticesX,pairVerticesY,pairPreviousVectorsX,pairPreviousVectorsY,pairOutsideAngles,pairPreviousLengths,junctionDistance)

% create a coordinate vector for the possible link
junctionVectorX = pairVerticesX - cells.verticesX(i);
junctionVectorY = pairVerticesY - cells.verticesY(i);
junctionDistance = sqrt(junctionDistance);
junctionAngle = get_angles(cells.rightVectorsX(i),cells.rightVectorsY(i), junctionVectorX, junctionVectorY, cells.rightLengths(i), junctionDistance);
junctionAngle = atan2(junctionVectorY, junctionVectorX) - atan2(-cells.rightVectorsY(i), -cells.rightVectorsX(i));
if junctionAngle < 0
    junctionAngle = junctionAngle + 2*pi;
end

if abs(cells.outsideAngles(i)./2 - junctionAngle) > spar.maxJunctionAngleConstant*cells.outsideAngles(i)/2
    
    angleCheck = 0;
    
else
    
%     pairJunctionAngle = get_angles(pairPreviousVectorsX,pairPreviousVectorsY, -junctionVectorX, -junctionVectorY, pairPreviousLengths, junctionDistance);
    pairJunctionAngle = atan2(-junctionVectorY, -junctionVectorX) - atan2(-pairPreviousVectorsY, -pairPreviousVectorsX);
    if pairJunctionAngle < 0
        pairJunctionAngle = pairJunctionAngle + 2*pi;
    end
    
    
    if abs(pairOutsideAngles/2 - pairJunctionAngle) > spar.maxJunctionAngleConstant*pairOutsideAngles/2
        angleCheck = 0;
    else
        angleCheck = 1;
    end
end


end