function angleCheck = check_junction_angle_add(spar,cells,i,pairVerticesX,pairVerticesY,pairPreviousVectorsX,pairPreviousVectorsY,pairOutsideAngles)
% CHECK_JUNCTION_ANGLE Checks junction angles when adding new junctions
%   The function makes sure that the new junction is within the allowed
%   junction angle limits for both cells.
%   INPUTS:
%       spar: scaled parameter structure
%       cells: cell data structure
%       i: current vertex index
%       pairVerticesX: x-coordinate of the pair vertex
%       pairVerticesY: y-coordinate of the pair vertex
%       pairPreviousVectorsX: x-component of the right side boundary vector
%       pairPreviousVectorsY: y-component of the right side boundary vector
%       pairOutsideAngles: pair's outside angle
%   OUTPUT:
%       angleCheck: logical to indicate if the angles are within the limits
%   by Aapo Tervonen, 2021

% create a vector for the possible link
junctionVectorX = pairVerticesX - cells.verticesX(i);
junctionVectorY = pairVerticesY - cells.verticesY(i);

% find the angle between the right boundary segment and the possible
% junction
junctionAngle = get_angles(cells.rightVectorsX(i), cells.rightVectorsY(i), junctionVectorX, junctionVectorY);

% check that the junction angles is within the allowed limits
if abs(cells.outsideAngles(i)./2 - junctionAngle) > spar.maxJunctionAngleConstant*cells.outsideAngles(i)/2
    
    % if no, return false
    angleCheck = false;

% if the angle is within the allowed limits
else
    
    % find the angle between the right boundary segment of the pair and the
    % possible junction
    pairJunctionAngle = get_angles(pairPreviousVectorsX, pairPreviousVectorsY, -junctionVectorX, -junctionVectorY);    
    
    % check that the junction angles is within the allowed limits
    if abs(pairOutsideAngles/2 - pairJunctionAngle) > spar.maxJunctionAngleConstant*pairOutsideAngles/2
        
        % if no, return false
        angleCheck = false;
    else
        
        % if yes, return true
        angleCheck = true;
    end
end

end