function write_export_data(d, exportMatrices, time)
% WRITE_EXPORT_DATA Write the data to export to files
%   The function write the exported data to files.
%   INPUTS:
%       d: main simulation data structure
%       exportMatrices: structure of export matrices
%       time: current simulation time
%   by Aapo Tervonen, 2021

% get the number of this export
exportNumber = num2str(time/d.ex.exportDt+1);

% write the cell vertex coordinate data to file
if d.ex.vertices
    write_file(d.ex, exportMatrices.vertices, 'vertices', exportNumber);
end

% write the cell vertex state data to file
if d.ex.vertexStates
    write_file(d.ex, exportMatrices.vertexStates, 'vertex_states', exportNumber);
end

% write the cell division to file
if d.ex.division
    write_file(d.ex, exportMatrices.divisionStates, 'states', exportNumber, 'division');
    write_file(d.ex, exportMatrices.divisionVertices, 'vertices', exportNumber, 'division');
    write_file(d.ex, exportMatrices.divisionDistances, 'distances', exportNumber, 'division');
    write_file(d.ex, exportMatrices.newNormAreas, 'new_areas', exportNumber, 'division');
    write_file(d.ex, exportMatrices.targetAreas, 'target_areas', exportNumber, 'division');
end

% write the cell state data to file
if d.ex.cellStates
    write_file(d.ex, exportMatrices.cellStates, 'cell_states', exportNumber);
end

% write the cell junction data to file
if d.ex.junctions
    write_file(d.ex, exportMatrices.junctions, 'junctions', exportNumber);
end

% write the cell boundary length data to file
if d.ex.boundaryLengths
    write_file(d.ex, exportMatrices.boundaryLengths, 'boundary_lengths', exportNumber);
end

% write the cell area data to file
if d.ex.areas
    write_file(d.ex, exportMatrices.areas, 'areas', exportNumber);
end

% write the cell perimeter data to file
if d.ex.perimeters
    write_file(d.ex, exportMatrices.perimeters, 'perimeters', exportNumber);
end

% write the cell normal properties data to file
if d.ex.normProperties
    write_file(d.ex, exportMatrices.normProperties, 'norm_properties', exportNumber);
end

% write the cell cortical data to files
if d.ex.corticalStrengths
    write_file(d.ex,exportMatrices.vertexCorticalMultipliers, 'vertex_cortical_multipliers', exportNumber, 'cortex');
    write_file(d.ex,exportMatrices.corticalStrengths, 'cortical_strengths', exportNumber, 'cortex');
    write_file(d.ex,exportMatrices.perimeterConstants, 'perimeter_constants', exportNumber, 'cortex');
end

% write the cell vertex lineage to file
if d.ex.lineage
    write_file(d.ex,exportMatrices.lineage, 'lineage', exportNumber);
end

% write the cell pointlike data to file
if d.ex.pointlike && d.simset.simulationType == 2
    write_file(d.ex, exportMatrices.pointlike ,'pointlike_locations', exportNumber, 'pointlike');
end

% write the focal adhesion data to file (for plotting)
if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
    write_file(d.ex,exportMatrices.substratePoints, 'substrate_points', exportNumber, 'substrate');
    write_file(d.ex,exportMatrices.focalAdhesionPoints, 'focal_adhesion_points', exportNumber, 'focal_adhesions');
    write_file(d.ex,exportMatrices.focalAdhesionConnected, 'focal_adhesion_connected', exportNumber, 'focal_adhesions');
    write_file(d.ex,exportMatrices.focalAdhesionWeights, 'focal_adhesion_weights', exportNumber, 'focal_adhesions');
end

% write the focal adhesion data to file (for import)
if d.ex.substrateFull && any(d.simset.simulationType == [2,3,5])
    write_file(d.ex,exportMatrices.substrateAdhesionNumbers, 'substrate_adhesion_numbers', exportNumber, 'substrate');
    write_file(d.ex,exportMatrices.focalAdhesionMatrixIdx, 'focal_adhesion_matrix_idx', exportNumber, 'focal_adhesions');
    write_file(d.ex,exportMatrices.focalAdhesionLinkCols, 'focal_adhesion_link_cols', exportNumber, 'focal_adhesions');
    write_file(d.ex,exportMatrices.focalAdhesionStrengths, 'focal_adhesion_strengths', exportNumber, 'focal_adhesions');
end

% write cell area forces to file
if d.ex.cellForcesArea
    write_file(d.ex, exportMatrices.cellForcesArea, 'area', exportNumber, 'cell_forces/area');
end

% write cell cortical forces to file
if d.ex.cellForcesCortical
    write_file(d.ex, exportMatrices.cellForcesCortical, 'cortical', exportNumber, 'cell_forces/cortical');
end

% write cell junction forces to file
if d.ex.cellForcesJunctions
    write_file(d.ex, exportMatrices.cellForcesJunctions, 'junction', exportNumber, 'cell_forces/junction');
end

% write cell division forces to file
if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
    write_file(d.ex, exportMatrices.cellForcesDivision, 'division', exportNumber, 'cell_forces/division');
end

% write cell membrane forces to file
if d.ex.cellForcesMembrane
    write_file(d.ex, exportMatrices.cellForcesMembrane, 'membrane', exportNumber, 'cell_forces/membrane');
end

% write cell focal adhesion forces to file
if and(d.ex.cellForcesFocalAdhesions,any(d.simset.simulationType == [2,3,5]))
    write_file(d.ex, exportMatrices.cellForcesFocalAdhesions, 'focal_adhesion', exportNumber, 'cell_forces/focal_adhesion');
end

% write cell pointlike forces to file
if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
    write_file(d.ex, exportMatrices.cellForcesPointlike, 'pointlike', exportNumber, 'cell_forces/pointlike');
end

% write cell contact forces to file
if d.ex.cellForcesContact
    write_file(d.ex, exportMatrices.cellForcesContact, 'contact', exportNumber, 'cell_forces/contact');
end

% write cell total forces to file
if d.ex.cellForcesTotal
    write_file(d.ex, exportMatrices.cellForcesTotal, 'total', exportNumber, 'cell_forces/total');
end

% write substrate central forces to file
if d.ex.substrateForcesCentral && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exportMatrices.substrateForcesCentral, 'central', exportNumber, 'substrate_forces/central');
end

% write substrate repulsion forces to file
if d.ex.substrateForcesRepulsion && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exportMatrices.substrateForcesRepulsion, 'repulsion', exportNumber, 'substrate_forces/repulsion');
end

% write substrate restoration forces to file
if d.ex.substrateForcesRestoration && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exportMatrices.substrateForcesRestoration, 'restoration', exportNumber, 'substrate_forces/restoration');
end

% write substrate focal adhesion forces to file
if d.ex.substrateForcesFocalAdhesions && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exportMatrices.substrateForcesFocalAdhesions, 'focal_adhesion', exportNumber, 'substrate_forces/focal_adhesion');
end

% write substrate total forces to file
if d.ex.substrateForcesTotal && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exportMatrices.substrateForcesTotal, 'total', exportNumber, 'substrate_forces/total');
end
    
end