function forcePlot = plot_gather_cell_forces(d,k,forcePlot)
% PLOT_GATHER_CELL_FORCES Get the forces for the current cell
%   The function saves the coordinates of the cell vertices and the force
%   components for the forces to be plotted.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%       forcePlot: structure with initialized matrices for the force
%       components and vertex coordinates
%   OUTPUT:
%       forcePlot: structure with matrices for the force components and
%       vertex coordinates
%   by Aapo Tervonen, 2021

% if cortical forces are plotted
if d.pl.cellForcesCortical
    forcePlot.cellForcesCortical = [forcePlot.cellForcesCortical; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.corticalX d.cells(k).forces.corticalY]];
end

% if junction forces are plotted
if d.pl.cellForcesJunctions
    forcePlot.cellForcesJunctions = [forcePlot.cellForcesJunctions; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.junctionX d.cells(k).forces.junctionY]];
end

% if division forces are plotted
if d.pl.cellForcesDivision
    forcePlot.cellForcesDivision = [forcePlot.cellForcesDivision; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.divisionX d.cells(k).forces.divisionY]];
end

% if membrane forces are plotted
if d.pl.cellForcesMembrane
    forcePlot.cellForcesMembrane = [forcePlot.cellForcesMembrane; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.membraneX d.cells(k).forces.membraneY]];
end

% if the contact forces are plotted
if d.pl.cellForcesContact
    forcePlot.cellForcesContact = [forcePlot.cellForcesContact; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.contactX d.cells(k).forces.contactY]];
end

% if the area forces are plotted
if d.pl.cellForcesArea
    forcePlot.cellForcesArea = [forcePlot.cellForcesArea; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.areaX d.cells(k).forces.areaY]];
end

% if the pointlike forces are plotted (if pointlike simulation)
if d.pl.cellForcesPointlike && d.simset.simulationType == 2
    forcePlot.cellForcesPointlike = [forcePlot.cellForcesPointlike; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.pointlikeX d.cells(k).forces.pointlikeY]];
end

% if focal adhesion forces are plotted (if substrate is included in the
% simulation)
if d.pl.cellForcesFocalAdhesions && d.simset.substrateIncluded
    forcePlot.cellForcesFocalAdhesions = [forcePlot.cellForcesFocalAdhesions; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.substrateX d.cells(k).forces.substrateY]];
end

% if total forces are plotted
if d.pl.cellForcesTotal
    forcePlot.cellForcesTotal = [forcePlot.cellForcesTotal; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.totalX d.cells(k).forces.totalY]];
end

end
