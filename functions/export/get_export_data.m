function exportMatrices = get_export_data(d,exportMatrices,export)
% GET_EXPORT_DATA Inputs the data to export to the matrices
%   The function inputs the data that will be exported to the export
%   matrices
%   INPUTS:
%       d: main simulation data structure
%       export: temporary export data structure
%       exportMatrices: structure of export matrices
%   OUTPUT:
%       exportMatrices: structure of export matrices
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(d.cells)
    
    % define indices for the cell based on how many columns of data will be
    % inputed to the matrix
    idx2 = 1+(k-1)*2:2+(k-1)*2;
    idx3 = 1+(k-1)*3:3+(k-1)*3;
    idx4 = 1+(k-1)*4:4+(k-1)*4;
    
    % input the vertex coordinate data
    if d.ex.vertices
        exportMatrices.vertices(1:export.nVertices(k),idx2) = [d.cells(k).previousVerticesX d.cells(k).previousVerticesY];
    end
    
    % input the vertex states data
    if d.ex.vertexStates
        exportMatrices.vertexStates(1:export.nVertices(k),k) = d.cells(k).vertexStates;
    end
    
    % input the division data
    if d.ex.division
        exportMatrices.divisionStates(1,k) = d.cells(k).division.state;
        exportMatrices.divisionVertices(:,k) = d.cells(k).division.vertices;
        exportMatrices.divisionDistances(k) = d.cells(k).division.distanceSq;
        exportMatrices.newNormAreas(1:2,k) = d.cells(k).division.newAreas;
        exportMatrices.targetAreas(k) = d.cells(k).division.targetArea;
        exportMatrices.divisionTimes(k) = d.cells(k).division.time;    
    end
    
    % input the cell state data
    if d.ex.cellStates
        exportMatrices.cellStates(1,k) = d.cells(k).cellState;
    end
    
    % input the junction pair data
    if d.ex.junctions
        exportMatrices.junctions(1:export.nVertices(k),idx4) = [d.cells(k).junctions.cells d.cells(k).junctions.vertices];
    end
    
    % input the boundary length data
    if d.ex.boundaryLengths
        exportMatrices.boundaryLengths(1:export.nVertices(k),k) = d.cells(k).leftLengths;
    end
    
    % input the cell area data
    if d.ex.areas
        exportMatrices.areas(1,k) = d.cells(k).area;
    end
    
    % input the perimeter data
    if d.ex.perimeters
        exportMatrices.perimeters(1,k) = d.cells(k).perimeter;
    end
    
    % input the normal area and perimeter data
    if d.ex.normProperties
        exportMatrices.normProperties(1:2,k) = [d.cells(k).normArea ; d.cells(k).normPerimeter];
    end
    
    % input the focal adhesion data
    if or(d.ex.substratePlot,d.ex.substrateFull) && d.simset.substrateIncluded
        
        % for plotting
        nConnected = size(d.cells(k).substrate.points,1);
        exportMatrices.focalAdhesionPoints(1:nConnected,idx3) = d.cells(k).substrate.points;
        exportMatrices.focalAdhesionConnected(1:export.nVertices(k),k) = d.cells(k).substrate.connected;
        exportMatrices.focalAdhesionWeights(1:nConnected,idx3)  = d.cells(k).substrate.weights;
        
        % for import
        if d.ex.substrateFull && d.simset.substrateIncluded
            exportMatrices.focalAdhesionMatrixIdx(1:nConnected*3,k) = d.cells(k).substrate.matrixIdx;
            exportMatrices.focalAdhesionLinkCols(1:nConnected,idx3) = d.cells(k).substrate.linkCols;
            exportMatrices.focalAdhesionStrengths(1:nConnected,k) = d.cells(k).substrate.fFocalAdhesions;
        end
    end
    
    % input the cortical data
    if d.ex.corticalStrengths
        exportMatrices.vertexCorticalMultipliers(1:export.nVertices(k),k) = d.cells(k).cortex.vertexMultipliers;
        exportMatrices.corticalStrengths(1,k) = d.cells(k).cortex.fCortex;
        exportMatrices.perimeterConstants(1,k) = d.cells(k).cortex.perimeterConstant; 
    end
    
    % input lineage data
    if d.ex.lineage
        exportMatrices.lineage(1:export.nLineage(k),k) = d.cells(k).lineage';
    end
    
    % input cell area force data
    if d.ex.cellForcesArea
        exportMatrices.cellForcesArea(1:export.nVertices(k),idx2) = [d.cells(k).forces.areaX d.cells(k).forces.areaY];
    end
    
    % input cell cortical force data
    if d.ex.cellForcesCortical
        exportMatrices.cellForcesCortical(1:export.nVertices(k),idx2) = [d.cells(k).forces.corticalX d.cells(k).forces.corticalY];
    end
    
    % input cell junction force data
    if d.ex.cellForcesJunctions
        exportMatrices.cellForcesJunctions(1:export.nVertices(k),idx2) = [d.cells(k).forces.junctionX d.cells(k).forces.junctionY];
    end
    
    % input cell division force data
    if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
        exportMatrices.cellForcesDivision(1:export.nVertices(k),idx2) = [d.cells(k).forces.divisionX d.cells(k).forces.divisionY];
    end
    
    % input cell membrane force data
    if d.ex.cellForcesMembrane
        exportMatrices.cellForcesMembrane(1:export.nVertices(k),idx2) = [d.cells(k).forces.membraneX d.cells(k).forces.membraneY];
    end
    
    % input cell focal adhesion force data
    if and(d.ex.cellForcesFocalAdhesions,d.simset.substrateIncluded)
        exportMatrices.cellForcesFocalAdhesions(1:export.nVertices(k),idx2) = [d.cells(k).forces.substrateX d.cells(k).forces.substrateY];
    end
    
    % input cell pointlike force data
    if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
        exportMatrices.cellForcesPointlike(1:export.nVertices(k),idx2) = [d.cells(k).forces.pointlikeX d.cells(k).forces.pointlikeY];
    end
    
    % input cell contact force data
    if d.ex.cellForcesContact
        exportMatrices.cellForcesContact(1:export.nVertices(k),idx2) = [d.cells(k).forces.contactX d.cells(k).forces.contactY];
    end
    
    % input cell total force data
    if d.ex.cellForcesTotal
        exportMatrices.cellForcesTotal(1:export.nVertices(k),idx2) = [d.cells(k).forces.totalX d.cells(k).forces.totalY];
    end
end

% input substrate point coordinates data if substrate is exported (and part
% of the simulation)
if or(d.ex.substratePlot,d.ex.substrateFull) && d.simset.substrateIncluded
    exportMatrices.substratePoints = [d.sub.pointsX d.sub.pointsY];
end

% input the substrate adhesion number data (required for substrate import)
if d.ex.substrateFull && d.simset.substrateIncluded
    exportMatrices.substrateAdhesionNumbers = d.sub.adhesionNumbers;
end

% input the substrate central force data
if d.ex.substrateForcesCentral && d.simset.substrateSolved
    exportMatrices.substrateForcesCentral = [d.sub.forces.centralX d.sub.forces.centralY];
end

% input the substrate repulsion force data
if d.ex.substrateForcesRepulsion && d.simset.substrateSolved
    exportMatrices.substrateForcesRepulsion = [d.sub.forces.repulsionX d.sub.forces.repulsionY];
end

% input the substrate restoration force data
if d.ex.substrateForcesRestoration && d.simset.substrateSolved
    exportMatrices.substrateForcesRestoration = [d.sub.forces.restorativeX d.sub.forces.restorativeY];
end

% input the substrate focal adhesion force data
if d.ex.substrateForcesFocalAdhesions && d.simset.substrateSolved
    exportMatrices.substrateForcesFocalAdhesions = [d.sub.forces.focalAdhesionsX d.sub.forces.focalAdhesionsY];
end

% input the substrate total force data
if d.ex.substrateForcesTotal && d.simset.substrateSolved
    exportMatrices.substrateForcesTotal = [d.sub.forces.totalX d.sub.forces.totalY];
end

% input the pointlike location data to file
if d.ex.pointlike && d.simset.simulationType == 2
    exportMatrices.pointlike = [d.simset.pointlike.pointX d.simset.pointlike.pointY];
end

end