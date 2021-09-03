function write_export_data(d, exMat, time)

exportNumber = num2str(time/d.ex.exportDt+1);

if d.ex.vertices
    write_file(d.ex, exMat.vertices, 'vertices', exportNumber);
end

if d.ex.vertexStates
    write_file(d.ex, exMat.vertexStates, 'vertex_states', exportNumber);
end

if d.ex.division
    write_file(d.ex, exMat.divisionStates, 'states', exportNumber, 'division');
    write_file(d.ex, exMat.divisionVertices, 'vertices', exportNumber, 'division');
    write_file(d.ex, exMat.divisionDistances, 'distances', exportNumber, 'division');
    write_file(d.ex, exMat.newNormAreas, 'new_areas', exportNumber, 'division');
    write_file(d.ex, exMat.targetAreas, 'target_areas', exportNumber, 'division');
end

if d.ex.cellStates
    write_file(d.ex, exMat.cellStates, 'cell_states', exportNumber);
end

if d.ex.junctions
    write_file(d.ex, exMat.junctions, 'junctions', exportNumber);
end

if d.ex.boundaryLengths
    write_file(d.ex, exMat.boundaryLengths, 'boundary_lengths', exportNumber);
end

if d.ex.areas
    write_file(d.ex, exMat.areas, 'areas', exportNumber);
end

if d.ex.perimeters
    write_file(d.ex, exMat.perimeters, 'perimeters', exportNumber);
end

if d.ex.normProperties
    write_file(d.ex, exMat.normProperties, 'norm_properties', exportNumber);
end

if d.ex.corticalTensions
    write_file(d.ex,exMat.vertexCorticalTensions, 'vertex_cortical_tensions', exportNumber, 'cortical_tension');
    write_file(d.ex,exMat.corticalTensions, 'cortical_tensions', exportNumber, 'cortical_tension');
    write_file(d.ex,exMat.perimeterConstants, 'cortical_constants', exportNumber, 'cortical_tension');
end

if d.ex.lineage
    write_file(d.ex,exMat.lineage, 'lineage', exportNumber);
end

if d.ex.pointlike && d.simset.simulationType == 2
    write_file(d.ex,[d.simset.pointlike.pointX d.simset.pointlike.pointY] ,'pointlike_locations',exportNumber, 'pointlike');
end

if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
    write_file(d.ex,exMat.substratePoints, 'substrate_points', exportNumber, 'substrate');
    write_file(d.ex,exMat.focalAdhesionPoints, 'focal_adhesion_points', exportNumber, 'focal_adhesions');
    write_file(d.ex,exMat.focalAdhesionConnected, 'focal_adhesion_connected', exportNumber, 'focal_adhesions');
    write_file(d.ex,exMat.focalAdhesionWeights, 'focal_adhesion_weights', exportNumber, 'focal_adhesions');
end

if d.ex.substrateFull && any(d.simset.simulationType == [2,3,5])
    write_file(d.ex,exMat.substrateAdhesionNumbers, 'substrate_adhesion_numbers', exportNumber, 'substrate');
    write_file(d.ex,exMat.focalAdhesionMatrixIdx, 'focal_adhesion_matrix_idx', exportNumber, 'focal_adhesions');
    write_file(d.ex,exMat.focalAdhesionLinkCols, 'focal_adhesion_link_cols', exportNumber, 'focal_adhesions');
    write_file(d.ex,exMat.focalAdhesionStrengths, 'focal_adhesion_strengths', exportNumber, 'focal_adhesions');
end

if d.ex.cellForcesArea
    write_file(d.ex, exMat.cellForcesArea, 'area', exportNumber, 'cell_forces/area');
end

if d.ex.cellForcesCortical
    write_file(d.ex, exMat.cellForcesCortical, 'cortical', exportNumber, 'cell_forces/cortical');
end

if d.ex.cellForcesJunctions
    write_file(d.ex, exMat.cellForcesJunctions, 'junction', exportNumber, 'cell_forces/junction');
end

if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
    write_file(d.ex, exMat.cellForcesDivision, 'division', exportNumber, 'cell_forces/division');
end

if d.ex.cellForcesMembrane
    write_file(d.ex, exMat.cellForcesMembrane, 'membrane', exportNumber, 'cell_forces/membrane');
end

if and(d.ex.cellForcesFocalAdhesions,any(d.simset.simulationType == [2,3,5]))
    write_file(d.ex, exMat.cellForcesFocalAdhesions, 'focal_adhesion', exportNumber, 'cell_forces/focal_adhesion');
end

if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
    write_file(d.ex, exMat.cellForcesPointlike, 'pointlike', exportNumber, 'cell_forces/pointlike');
end

if d.ex.cellForcesContact
    write_file(d.ex, exMat.cellForcesContact, 'contact', exportNumber, 'cell_forces/contact');
end

if d.ex.cellForcesTotal
    write_file(d.ex, exMat.cellForcesTotal, 'total', exportNumber, 'cell_forces/total');
end

if d.ex.substrateForcesDirect && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exMat.substrateForcesDirect, 'direct', exportNumber, 'substrate_forces/direct');
end

if d.ex.substrateForcesRepulsion && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exMat.substrateForcesRepulsion, 'repulsion', exportNumber, 'substrate_forces/repulsion');
end

if d.ex.substrateForcesRestoration && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exMat.substrateForcesRestoration, 'restoration', exportNumber, 'substrate_forces/restoration');
end

if d.ex.substrateForcesFocalAdhesions && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exMat.substrateForcesFocalAdhesions, 'focal_adhesion', exportNumber, 'substrate_forces/focal_adhesion');
end

if d.ex.substrateForcesTotal && any(d.simset.simulationType == [2 5])
    write_file(d.ex,exMat.substrateForcesTotal, 'total', exportNumber, 'substrate_forces/total');
end
    
end