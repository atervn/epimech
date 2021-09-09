function angleCheck = check_junction_angle_adding(spar,cells,i,pairVerticesX,pairVerticesY,pairPreviousVectorsX,pairPreviousVectorsY,pairOutsideAngles)

% create a coordinate vector for the possible link
junctionVectorX = pairVerticesX - cells.verticesX(i);
junctionVectorY = pairVerticesY - cells.verticesY(i);

junctionAngle = get_angles(cells.rightVectorsX(i), cells.rightVectorsY(i), junctionVectorX, junctionVectorY);


if abs(cells.outsideAngles(i)./2 - junctionAngle) > spar.maxJunctionAngleConstant*cells.outsideAngles(i)/2
    
    angleCheck = 0;
    
else
    
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