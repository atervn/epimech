function forcePlot = plot_gather_cell_forces(d,k,forcePlot)


if d.pl.cellForcesCortical
    forcePlot.cellForcesCortical = [forcePlot.cellForcesCortical; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.corticalX d.cells(k).forces.corticalY]];
end
if d.pl.cellForcesJunctions
    forcePlot.cellForcesJunctions = [forcePlot.cellForcesJunctions; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.junctionX d.cells(k).forces.junctionY]];
end
if d.pl.cellForcesDivision
    forcePlot.cellForcesDivision = [forcePlot.cellForcesDivision; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.divisionX d.cells(k).forces.divisionY]];
    
end
if d.pl.cellForcesMembrane
    forcePlot.cellForcesMembrane = [forcePlot.cellForcesMembrane; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.membraneX d.cells(k).forces.membraneY]];
    
end
if d.pl.cellForcesContact
    forcePlot.cellForcesContact = [forcePlot.cellForcesContact; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.contactX d.cells(k).forces.contactY]];
    
end
if d.pl.cellForcesArea
    forcePlot.cellForcesArea = [forcePlot.cellForcesArea; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.areaX d.cells(k).forces.areaY]];
    
end
if d.pl.cellForcesPointlike && d.simset.simulationType == 2
    forcePlot.cellForcesPointlike = [forcePlot.cellForcesPointlike; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.pointlikeX d.cells(k).forces.pointlikeY]];
end
if d.pl.cellForcesFocalAdhesions && any(d.simset.simulationType == [2,3,5])
    forcePlot.cellForcesFocalAdhesions = [forcePlot.cellForcesFocalAdhesions; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.substrateX d.cells(k).forces.substrateY]];
end
if d.pl.cellForcesTotal
    forcePlot.cellForcesTotal = [forcePlot.cellForcesTotal; [d.cells(k).verticesX d.cells(k).verticesY d.cells(k).forces.totalX d.cells(k).forces.totalY]];
end
