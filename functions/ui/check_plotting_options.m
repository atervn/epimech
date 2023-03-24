function plottingOptions = check_plotting_options(app)

plottingOptions = app.importPlottingOptions;

folderName = app.plotImport(app.selectedFile).folderName;


if plottingOptions.junctions 
    if exist([folderName '/junctions/'],'dir') ~= 7
        plottingOptions.junctions = false;
    end
end
if plottingOptions.cellForcesTotal
    if exist([folderName '/cell_forces/total/'],'dir') ~= 7
         plottingOptions.cellForcesTotal = false;
    end
end
if plottingOptions.cellForcesCortical
    if exist([folderName '/cell_forces/cortical/'],'dir') ~= 7
        plottingOptions.cellForcesCortical = false;
    end
end
if plottingOptions.cellForcesJunctions
    if exist([folderName '/cell_forces/junction/'],'dir') ~= 7
        plottingOptions.cellForcesJunctions = false;
    end
end
if plottingOptions.cellForcesDivision
    if exist([folderName '/cell_forces/division/'],'dir') ~= 7
        plottingOptions.cellForcesDivision = false;
    end
end
if plottingOptions.cellForcesMembrane
    if exist([folderName '/cell_forces/membrane/'],'dir') ~= 7
        plottingOptions.cellForcesMembrane = false;
    end
end
if plottingOptions.cellForcesContact
    if exist([folderName '/cell_forces/contact/'],'dir') ~= 7
        plottingOptions.cellForcesContact = false;
    end
end
if plottingOptions.cellForcesArea
    if exist([folderName '/cell_forces/area/'],'dir') ~= 7
        plottingOptions.cellForcesArea = false;
    end
end
if plottingOptions.cellForcesPointlike
    if exist([folderName '/cell_forces/pointlike/'],'dir') ~= 7
        plottingOptions.cellForcesPointlike = false;
    end
end
if plottingOptions.cellForcesFocalAdhesions
    if exist([folderName '/cell_forces/focal_adhesion/'],'dir') ~= 7
        plottingOptions.cellForcesFocalAdhesions = false;
    end
end
if plottingOptions.focalAdhesions
    if exist([folderName '/focal_adhesion_points/'],'dir') ~= 7
        plottingOptions.focalAdhesions = false;
    end
end
if plottingOptions.pointlike
   if ~(exist([folderName '/pointlike'],'dir') == 7 && exist([folderName '/pointlike_properties.csv'],'file') == 2)
       plottingOptions.pointlike = false;
   end
end
if plottingOptions.opto
   if ~(exist([folderName '/opto'],'dir') == 7)
       plottingOptions.opto = false;
   end
end

% LEGACY
if plottingOptions.substrateForcesCentral
    if exist([folderName '/substrate_forces/central/'],'dir') ~= 7
        if exist([folderName '/substrate_forces/direct/'],'dir') ~= 7
            plottingOptions.substrateForcesCentral = false;
        end
    end
end
if plottingOptions.substrateForcesRepulsion
    if exist([folderName '/substrate_forces/repulsion/'],'dir') ~= 7
        plottingOptions.substrateForcesRepulsion = false;
    end
end
if plottingOptions.substrateForcesRestoration
    if exist([folderName '/substrate_forces/restoration/'],'dir') ~= 7
        plottingOptions.substrateForcesRestoration = false;
    end
end
if plottingOptions.substrateForcesFocalAdhesions
    if exist([folderName '/substrate_forces/focal_adhesion/'],'dir') ~= 7
        plottingOptions.substrateForcesFocalAdhesions = false;
    end
end
if plottingOptions.substrateForcesTotal
    if exist([folderName '/substrate_forces/total/'],'dir') ~= 7
        plottingOptions.substrateForcesTotal = false;
    end
end