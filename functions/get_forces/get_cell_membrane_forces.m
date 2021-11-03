function cells = get_cell_membrane_forces(cells,spar)
% GET_CELL_MEMBRANE_FORCES Calculate the membrane forces
%   The function calculate the mebrane forces for the cells. The membrane
%   force springs are nonlinear to prevent large changes in their length.
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameters data structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% get the coordinates of the left side neighbor
leftVerticesX = circshift(cells.verticesX,-1,1);
leftVerticesY = circshift(cells.verticesY,-1,1);

% calculate the reciprocal lengths for the left side vectors
reciprocalTempLengths = 1./cells.leftLengths;

% get the vertices with short or long lengths
displacements = cells.leftLengths - spar.membraneLength;
shorts = displacements <= 0;
longs = displacements > 0;

% initialize force magnitude vector
% forceMagnitudes = zeros(cells.nVertices,1);

% get the short magnitudes (basically only the displacement for the
% nonlinear spring)
forceMagnitudes = cells.leftLengths - spar.membraneLength.^2.*reciprocalTempLengths;

% get the long magnitudes
% forceMagnitudes(longs) = cells.leftLengths(longs) - spar.membraneLength.^2./(cells.leftLengths(longs) - 2*spar.membraneLength) - 2*spar.membraneLength;

% multiply the magnitude with the spring constant and by the reciprocal
% lengths (needed for calculating the unit vectors in the next step)
forceMagnitudes = spar.fMembrane.*forceMagnitudes.*reciprocalTempLengths;

% calculate the membrane forces for the left side
cells.forces.membraneX = forceMagnitudes.*(leftVerticesX - cells.verticesX);
cells.forces.membraneY = forceMagnitudes.*(leftVerticesY - cells.verticesY);

% using circshift, get the forces forces for the right side (since these
% are antiparallel to the right side neighbors left side force)
cells.forces.membraneX = cells.forces.membraneX - circshift(cells.forces.membraneX,1,1);
cells.forces.membraneY = cells.forces.membraneY - circshift(cells.forces.membraneY,1,1);

end