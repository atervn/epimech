function junctions2Remove = check_junction_angle_remove(spar,cells,linkedIdx,pairVerticesX,pairVerticesY)
% CHECK_JUNCTION_ANGLE Check if the junction angle is too large
%   The function checks if existing junctions have too large acute angle in
%   relation to the cell membrane.
%   INPUTS:
%       spar: scaled parameters data structure
%       cells: current cell data structure
%       linkedIdx: the indices of the linked vertices
%       pairVerticesX: x-coordinates of junction pairs
%       pairVerticesY: y-coordinates of junction pairs
%   OUTPUT:
%       junctions2Remove: junctions to be removed
%   by Aapo Tervonen, 2021

% get the junction vector components
junctionVectorsX = pairVerticesX - cells.verticesX(linkedIdx);
junctionVectorsY = pairVerticesY - cells.verticesY(linkedIdx);

% get the junction angles
junctionAngles = get_angles(cells.rightVectorsX(linkedIdx), cells.rightVectorsY(linkedIdx), junctionVectorsX, junctionVectorsY);

% get half of the membrane outside angles
halfAngles = cells.outsideAngles(linkedIdx)./2;

% find the junctions that differ too much from the membrane normal
badJunctions = abs(halfAngles - junctionAngles) > spar.maxJunctionAngleConstant*halfAngles;

% get the indices of the bad junctions
junctions2Remove = linkedIdx(badJunctions);

end