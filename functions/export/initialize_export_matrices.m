function exportMatrices = initialize_export_matrices(d, export)
% INITIALIZE_EXPORT_MATRICES Initializes the matrices for the export
%   The function creates the matrices to which the exported data is
%   collected
%   INPUTS:
%       d: main simulation data structure
%       export: temporary export data structure
%   OUTPUT:
%       exportMatrices: structure of export matrices
%   by Aapo Tervonen, 2021

% if the cell vertex coordinates are exported
if d.ex.vertices
    exportMatrices.vertices = zeros([export.nVerticesMax export.nCells*2]);
end

% if the cell vertex states are exported
if d.ex.vertexStates
    exportMatrices.vertexStates = zeros([export.nVerticesMax export.nCells]);
end

% if the cell division related data is exported
if d.ex.division
    exportMatrices.divisionStates = zeros([1 export.nCells]);
    exportMatrices.divisionVertices = zeros([2 export.nCells]);
    exportMatrices.divisionDistances = zeros([1 export.nCells]);
    exportMatrices.newNormAreas = zeros([2 export.nCells]);
    exportMatrices.targetAreas = zeros([1 export.nCells]);
end

% if the cell states are exported
if d.ex.cellStates
    exportMatrices.cellStates = zeros([1 export.nCells]);
end

% if the cell junction data is exported
if d.ex.junctions
    exportMatrices.junctions = zeros([export.nVerticesMax export.nCells*4]);
end

% if the cell boundary lengths are exported
if d.ex.boundaryLengths
    exportMatrices.boundaryLengths = zeros([export.nVerticesMax export.nCells]);
end

% if the cell areas are exported
if d.ex.areas
    exportMatrices.areas = zeros([1 export.nCells]);
end

% if the cell perimeters are exported
if d.ex.perimeters
    exportMatrices.perimeters = zeros([1 export.nCells]);
end

% if the cell normal area and perimeter are exported
if d.ex.normProperties
    exportMatrices.normProperties = zeros([2 export.nCells]);
end

% if the cortical data is exported
if d.ex.corticalStrengths
    exportMatrices.vertexCorticalMultipliers = zeros([export.nVerticesMax export.nCells]);
    exportMatrices.corticalStrengths = zeros([1 export.nCells]);
    exportMatrices.perimeterConstants = zeros([1 export.nCells]);
end

% if the cell lineage data is exported
if d.ex.lineage
    exportMatrices.lineage = zeros([export.nLineageMax export.nCells]);
end

% if focal adhesion data is exported (and if substrate is included in the
% simulation)
if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
    
    % this data is required for plotting the focal adhesions
    exportMatrices.focalAdhesionPoints = zeros([export.nVerticesMax export.nCells*3]);
    exportMatrices.focalAdhesionConnected = zeros([export.nVerticesMax export.nCells]);
    exportMatrices.focalAdhesionWeights = zeros([export.nVerticesMax export.nCells*3]);
    
    % this data is required to use this export as a starting point for new
    % simulation
    if d.ex.substrateFull && any(d.simset.simulationType == [2,3,5])
        exportMatrices.focalAdhesionMatrixIdx = zeros([export.nVerticesMax*3 export.nCells]);
        exportMatrices.focalAdhesionLinkCols = zeros([export.nVerticesMax export.nCells*3]);
        exportMatrices.focalAdhesionStrengths = zeros([export.nVerticesMax export.nCells]);
    end
end

% if cell area forces are exported
if d.ex.cellForcesArea
    exportMatrices.cellForcesArea = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell cortical forces are exported
if d.ex.cellForcesCortical
    exportMatrices.cellForcesCortical = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell junction forces are exported
if d.ex.cellForcesJunctions
    exportMatrices.cellForcesJunctions = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell division forces are exported
if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
    exportMatrices.cellForcesDivision = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell membrane forces are exported
if d.ex.cellForcesMembrane
    exportMatrices.cellForcesMembrane = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell focal adhesion forces are exported
if and(d.ex.cellForcesFocalAdhesions,any(d.simset.simulationType == [2,3,5]))
    exportMatrices.cellForcesFocalAdhesions = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell pointlike forces are exported
if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
    exportMatrices.cellForcesPointlike = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell contact forces are exported
if d.ex.cellForcesContact
    exportMatrices.cellForcesContact = zeros([export.nVerticesMax export.nCells*2]);
end

% if cell total forces are exported
if d.ex.cellForcesTotal
    exportMatrices.cellForcesTotal = zeros([export.nVerticesMax export.nCells*2]);
end

end