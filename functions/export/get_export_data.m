function exMat = get_export_data(d,exMat,exTemp)

for k = 1:length(d.cells)
    idx2 = 1+(k-1)*2:2+(k-1)*2;
    idx3 = 1+(k-1)*3:3+(k-1)*3;
    idx4 = 1+(k-1)*4:4+(k-1)*4;
    if d.ex.vertices
        exMat.vertices(1:exTemp.nVertices(k),idx2) = [d.cells(k).previousVerticesX d.cells(k).previousVerticesY];
    end
    if d.ex.vertexStates
        exMat.vertexStates(1:exTemp.nVertices(k),k) = d.cells(k).vertexStates;
    end
    if d.ex.division
        exMat.divisionStates(1,k) = d.cells(k).division.state;
        exMat.divisionVertices(:,k) = d.cells(k).division.vertices;
        exMat.divisionDistances(k) = d.cells(k).division.distanceSq;
        exMat.newAreas(1:2,k) = d.cells(k).division.newAreas;
        exMat.targetAreas(k) = d.cells(k).division.targetArea;
    end
    if d.ex.cellStates
        exMat.cellStates(1,k) = d.cells(k).cellState;
    end
    if d.ex.junctions
        exMat.junctions(1:exTemp.nVertices(k),idx4) = [d.cells(k).junctions.cells d.cells(k).junctions.vertices];
    end
    if d.ex.boundaryLengths
        exMat.boundaryLengths(1:exTemp.nVertices(k),k) = d.cells(k).leftLengths;
    end
    if d.ex.areas
        exMat.areas(1,k) = d.cells(k).area;
    end
    if d.ex.perimeters
        exMat.perimeters(1,k) = d.cells(k).perimeter;
    end
    if d.ex.normProperties
        exMat.normProperties(1:2,k) = [d.cells(k).normArea ; d.cells(k).normPerimeter];
    end
    if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
        nConnected = size(d.cells(k).substrate.points,1);
        exMat.focalAdhesionPoints(1:nConnected,idx3) = d.cells(k).substrate.points;
        exMat.focalAdhesionConnected(1:exTemp.nVertices(k),k) = d.cells(k).substrate.connected;
        exMat.focalAdhesionWeights(1:nConnected,idx3)  = d.cells(k).substrate.weights;
        if d.ex.substrateFull && any(d.simset.simulationType == [2,3,5])
            exMat.focalAdhesionMatrixIdx(1:nConnected*3,k) = d.cells(k).substrate.matrixIdx;
            exMat.focalAdhesionLinkCols(1:nConnected,idx3) = d.cells(k).substrate.linkCols;
            exMat.focalAdhesionStrengths(1:nConnected,k) = d.cells(k).substrate.fFocalAdhesions;
        end
    end
    if d.ex.corticalTensions

        exMat.vertexCorticalTensions(1:exTemp.nVertices(k),k) = d.cells(k).vertexCorticalTensions;
        exMat.corticalTensions(1,k) = d.cells(k).corticalTension;
        exMat.perimeterConstants(1,k) = d.cells(k).perimeterConstant; 
    end
    if d.ex.lineage
        exMat.lineage(1:exTemp.nLineage(k),k) = d.cells(k).lineage';
    end
    if d.ex.cellForcesArea
        exMat.cellForcesArea(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.areaX d.cells(k).forces.areaY];
    end
    if d.ex.cellForcesCortical
        exMat.cellForcesCortical(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.corticalX d.cells(k).forces.corticalY];
    end
    if d.ex.cellForcesJunctions
        exMat.cellForcesJunctions(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.junctionX d.cells(k).forces.junctionY];
    end
    if and(d.ex.cellForcesDivision,d.simset.simulationType == 1)
        exMat.cellForcesDivision(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.divisionX d.cells(k).forces.divisionY];
    end
    if d.ex.cellForcesMembrane
        exMat.cellForcesMembrane(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.membraneX d.cells(k).forces.membraneY];
    end
    if and(d.ex.cellForcesFocalAdhesions,any(d.simset.simulationType == [2,3,5]))
        exMat.cellForcesFocalAdhesions(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.substrateX d.cells(k).forces.substrateY];
    end
    if and(d.ex.cellForcesPointlike,d.simset.simulationType == 2)
        exMat.cellForcesPointlike(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.pointlikeX d.cells(k).forces.pointlikeY];
    end
    if d.ex.cellForcesContact
        exMat.cellForcesContact(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.contactX d.cells(k).forces.contactY];
    end
    if d.ex.cellForcesTotal
        exMat.cellForcesTotal(1:exTemp.nVertices(k),idx2) = [d.cells(k).forces.totalX d.cells(k).forces.totalY];
    end
end
if or(d.ex.substratePlot,d.ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
    exMat.substratePoints = [d.sub.pointsX d.sub.pointsY];
end
if d.ex.substrateFull && any(d.simset.simulationType == [2,3,5])
    exMat.substrateAdhesionNumbers = d.sub.adhesionNumbers;
end
if d.ex.substrateForcesDirect && any(d.simset.simulationType == [2 5])
    exMat.substrateForcesDirect = [d.sub.forces.directX d.sub.forces.directY];
end
if d.ex.substrateForcesRepulsion && any(d.simset.simulationType == [2 5])
    exMat.substrateForcesRepulsion = [d.sub.forces.boundaryRepulsionX d.sub.forces.boundaryRepulsionY];
end
if d.ex.substrateForcesRestoration && any(d.simset.simulationType == [2 5])
    exMat.substrateForcesRestoration = [d.sub.forces.restorativeX d.sub.forces.restorativeY];
end
if d.ex.substrateForcesFocalAdhesions && any(d.simset.simulationType == [2 5])
    exMat.substrateForcesFocalAdhesions = [d.sub.forces.focalAdhesionsX d.sub.forces.focalAdhesionsY];
end
if d.ex.substrateForcesTotal && any(d.simset.simulationType == [2 5])
    exMat.substrateForcesTotal = [d.sub.forces.totalX d.sub.forces.totalY];
end

