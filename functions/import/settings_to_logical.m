function settings = settings_to_logical(settings,settingsType)

switch settingsType
    case 'plot'
        settings.junctions = logical(settings.junctions);
        settings.cellForcesTotal = logical(settings.cellForcesTotal);
        settings.cellForcesCortical = logical(settings.cellForcesCortical);
        settings.cellForcesJunctions = logical(settings.cellForcesJunctions);
        settings.cellForcesDivision = logical(settings.cellForcesDivision);
        settings.cellForcesMembrane = logical(settings.cellForcesMembrane);
        settings.cellForcesContact = logical(settings.cellForcesContact);
        settings.cellForcesArea = logical(settings.cellForcesArea);
        settings.cellForcesPointlike = logical(settings.cellForcesPointlike);
        settings.cellForcesFocalAdhesions = logical(settings.cellForcesFocalAdhesions); 
        settings.cellNumbers = logical(settings.cellNumbers);
        settings.vertexNumbers = logical(settings.vertexNumbers);
        settings.focalAdhesions = logical(settings.focalAdhesions);
        settings.pointlike = logical(settings.pointlike);
        settings.opto = logical(settings.opto);
        settings.substrateForcesCentral = logical(settings.substrateForcesCentral);
        settings.substrateForcesRepulsion = logical(settings.substrateForcesRepulsion);
        settings.substrateForcesRestoration = logical(settings.substrateForcesRestoration);
        settings.substrateForcesFocalAdhesions = logical(settings.substrateForcesFocalAdhesions);
        settings.substrateForcesTotal = logical(settings.substrateForcesTotal);
    case 'export'
        settings.parameters = logical(settings.parameters);
        settings.vertices = logical(settings.vertices);
        settings.vertexStates = logical(settings.vertexStates);
        settings.division = logical(settings.division);
        settings.cellStates = logical(settings.cellStates);
        settings.junctions = logical(settings.junctions);
        settings.cellForcesTotal = logical(settings.cellForcesTotal);
        settings.cellForcesArea = logical(settings.cellForcesArea);
        settings.cellForcesCortical = logical(settings.cellForcesCortical);
        settings.cellForcesJunctions = logical(settings.cellForcesJunctions);
        settings.cellForcesDivision = logical(settings.cellForcesDivision);
        settings.cellForcesMembrane = logical(settings.cellForcesMembrane);
        settings.cellForcesFocalAdhesions = logical(settings.cellForcesFocalAdhesions);
        settings.cellForcesPointlike = logical(settings.cellForcesPointlike);
        settings.cellForcesContact = logical(settings.cellForcesContact);
        settings.boundaryLengths = logical(settings.boundaryLengths);
        settings.areas = logical(settings.areas);
        settings.perimeters = logical(settings.perimeters);
        settings.normProperties = logical(settings.normProperties);
        settings.substratePlot = logical(settings.substratePlot);
        settings.substrateFull = logical(settings.substrateFull);
        settings.substrateForcesCentral = logical(settings.substrateForcesCentral);
        settings.substrateForcesRepulsion = logical(settings.substrateForcesRepulsion);
        settings.substrateForcesRestoration = logical(settings.substrateForcesRestoration);
        settings.substrateForcesFocalAdhesions = logical(settings.substrateForcesFocalAdhesions);
        settings.substrateForcesTotal = logical(settings.substrateForcesTotal);
        settings.pointlike = logical(settings.pointlike);
        settings.opto = logical(settings.opto);
        settings.stretch = logical(settings.stretch);
        settings.lineage = logical(settings.lineage);
        settings.corticalStrengths = logical(settings.corticalStrengths);
end