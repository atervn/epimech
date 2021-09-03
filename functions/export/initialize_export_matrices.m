function exMat = initialize_export_matrices(d, exTemp)

if d.ex.vertices
    exMat.vertices = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.vertexStates
    exMat.vertexStates = zeros([exTemp.nVerticesMax exTemp.nCells]);
end

if d.ex.division
    exMat.divisionStates = zeros([1 exTemp.nCells]);
    exMat.divisionVertices = zeros([2 exTemp.nCells]);
    exMat.divisionDistances = zeros([1 exTemp.nCells]);
    exMat.newNormAreas = zeros([2 exTemp.nCells]);
    exMat.targetAreas = zeros([1 exTemp.nCells]);
end

if d.ex.cellStates
    exMat.cellStates = zeros([1 exTemp.nCells]);
end

if d.ex.junctions
    exMat.junctions = zeros([exTemp.nVerticesMax exTemp.nCells*4]);
end

if d.ex.boundaryLengths
    exMat.boundaryLengths = zeros([exTemp.nVerticesMax exTemp.nCells]);
end

if d.ex.areas
    exMat.areas = zeros([1 exTemp.nCells]);
end

if d.ex.perimeters
    exMat.perimeters = zeros([1 exTemp.nCells]);
end

if d.ex.normProperties
    exMat.normProperties = zeros([2 exTemp.nCells]);
end

if d.ex.corticalTensions
    exMat.vertexCorticalTensions = zeros([exTemp.nVerticesMax exTemp.nCells]);
    exMat.corticalTensions = zeros([1 exTemp.nCells]);
    exMat.perimeterConstants = zeros([1 exTemp.nCells]);
end

if d.ex.lineage
    exMat.lineage = zeros([exTemp.nLineageMax exTemp.nCells]);
end

if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
    exMat.focalAdhesionPoints = zeros([exTemp.nVerticesMax exTemp.nCells*3]);
    exMat.focalAdhesionConnected = zeros([exTemp.nVerticesMax exTemp.nCells]);
    exMat.focalAdhesionWeights = zeros([exTemp.nVerticesMax exTemp.nCells*3]);
    if d.ex.substrateFull && any(d.simset.simulationType == [2,3])
        exMat.focalAdhesionMatrixIdx = zeros([exTemp.nVerticesMax*3 exTemp.nCells]);
        exMat.focalAdhesionLinkCols = zeros([exTemp.nVerticesMax exTemp.nCells*3]);
        exMat.focalAdhesionStrengths = zeros([exTemp.nVerticesMax exTemp.nCells]);
    end
end

if d.ex.cellForcesArea
    exMat.cellForcesArea = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.cellForcesCortical
    exMat.cellForcesCortical = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.cellForcesJunctions
    exMat.cellForcesJunctions = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
    exMat.cellForcesDivision = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.cellForcesMembrane
    exMat.cellForcesMembrane = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if and(d.ex.cellForcesFocalAdhesions,any(d.simset.simulationType == [2,3,5]))
    exMat.cellForcesFocalAdhesions = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
    exMat.cellForcesPointlike = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.cellForcesContact
    exMat.cellForcesContact = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

if d.ex.cellForcesTotal
    exMat.cellForcesTotal = zeros([exTemp.nVerticesMax exTemp.nCells*2]);
end

end