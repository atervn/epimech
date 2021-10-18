function importedData = read_cell_data(app, d, importTemp, folderName, timePoint, option)
% READ_CELL_DATA Reads the cell data from the files
%   The function reads the required cell data from the files.
%   INPUT:
%       app: main application data structure
%       d: main simulation data structure
%       importTemp: temporary structure to indicate which components are
%           imported
%       folderName: name of the imported folder
%       timePoint: current time point
%       option: option to indicate the type of the import
%   OUTPUT:
%       importedData: structure of the imported data
%   by Aapo Tervonen, 2021

% import vertex coordinates, cell states, vertex states and normal area and
% perimeter values
importedData.vertices = csvread([folderName '/vertices/vertices_' num2str(timePoint), '.csv']);
importedData.cellStates = csvread([folderName '/cell_states/cell_states_' num2str(timePoint), '.csv']);
importedData.vertexStates = csvread([folderName '/vertex_states/vertex_states_' num2str(timePoint), '.csv']);
importedData.normProperties = csvread([folderName '/norm_properties/norm_properties_' num2str(timePoint), '.csv']);

% if simulation
if strcmp(option, 'simulation')
    
    % import junction data
    importedData.junctions = csvread([folderName '/junctions/junctions_' num2str(timePoint), '.csv']);
    
    % import division states
    importedData.divisionStates = csvread([folderName '/division/states_' num2str(timePoint), '.csv']);
    
    % if both the importedData. simulation and the current simulation are type growth
    if strcmp(app.import.simulationType,'growth') && d.simset.simulationType == 1
        
        % import the division vertex, distance, new area and target area
        % data
        importedData.divisionVertices = csvread([folderName '/division/vertices_' num2str(timePoint), '.csv']);
        importedData.divisionDistances = csvread([folderName '/division/distances_' num2str(timePoint), '.csv']);
        importedData.targetAreas = csvread([folderName '/division/target_areas_' num2str(timePoint), '.csv']);
        importedData.newAreas = csvread([folderName '/division/new_areas_' num2str(timePoint), '.csv']);
    end
    
    % if cortical data is available in the import
    % LEGACY
    if exist([app.import.folderName '/cortex/'],'file') == 7
        
        % import the cortical and cell tensions
        importedData.vertexMultipliers = csvread([folderName '/cortex/vertex_cortical_multipliers_' num2str(timePoint), '.csv']);
        importedData.corticalStrengths = csvread([folderName '/cortex/cortical_strengths_' num2str(timePoint), '.csv']);
        importedData.perimeterConstants = csvread([folderName '/cortex/perimeter_constants_' num2str(timePoint), '.csv']);

    % old naming
    elseif exist([app.import.folderName '/cortical_tension/'],'file') == 7
        
        % import the cortical and cell tensions
        importedData.vertexMultipliers = csvread([folderName '/cortical_tension/vertex_cortical_tensions_' num2str(timePoint), '.csv']);
        importedData.corticalStrengths = csvread([folderName '/cortical_tension/cortical_tensions_' num2str(timePoint), '.csv']);
        
        % import the perimeter constant (naming has changed)
        % LEGACY
        if exist([folderName '/cortical_tension/perimeter_constants_' num2str(timePoint), '.csv'],'file') == 2
            importedData.perimeterConstants = csvread([folderName '/cortical_tension/perimeter_constants_' num2str(timePoint), '.csv']);
        else
            importedData.perimeterConstants = csvread([folderName '/cortical_tension/cortical_constants_' num2str(timePoint), '.csv']);
        end
    end
end

% if junction are needed
if importTemp.junctions
    
    % import junction data
    importedData.junctions = csvread([folderName '/junctions/junctions_' num2str(timePoint), '.csv']);
end

% if focal adhesions are needed(either simulation with substrate or
% plotting them)
if importTemp.focalAdhesions
    
    % import the focal adhesion data
    importedData.FAPoints = csvread([folderName '/focal_adhesions/focal_adhesion_points_' num2str(timePoint), '.csv']);
    importedData.FAConnected = csvread([folderName '/focal_adhesions/focal_adhesion_connected_' num2str(timePoint), '.csv']);
    importedData.FAWeights = csvread([folderName '/focal_adhesions/focal_adhesion_weights_' num2str(timePoint), '.csv']);
    importedData.FALinkCols = csvread([folderName '/focal_adhesions/focal_adhesion_link_cols_' num2str(timePoint), '.csv']);
    importedData.FAMatrixIdx = csvread([folderName '/focal_adhesions/focal_adhesion_matrix_idx_' num2str(timePoint), '.csv']);
    importedData.FAStrengths = csvread([folderName '/focal_adhesions/focal_adhesion_strengths_' num2str(timePoint), '.csv']);
end

% if a cell forces are plotted, make sure the folder exists and load (if
% does not exist, set the plotting option to false
if strcmp (option, 'post_plotting')
    if app.importPlottingOptions.cellForcesTotal && exist([folderName '/cell_forces'],'dir') == 7
        importedData.totalForces = csvread([folderName '/cell_forces/total/total_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesTotal = false;
    end
    if app.importPlottingOptions.cellForcesCortical && exist([folderName '/cell_forces'],'dir') == 7
        importedData.corticalForces = csvread([folderName '/cell_forces/cortical/cortical_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesCortical = false;
    end
    if app.importPlottingOptions.cellForcesJunctions && exist([folderName '/cell_forces'],'dir') == 7
        importedData.junctionForces = csvread([folderName '/cell_forces/junction/junction_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesJunctions = false;
    end
    if app.importPlottingOptions.cellForcesDivision && exist([folderName '/cell_forces'],'dir') == 7
        importedData.divisionForces = csvread([folderName '/cell_forces/division/division_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesDivision = false;
    end
    if app.importPlottingOptions.cellForcesMembrane && exist([folderName '/cell_forces'],'dir') == 7
        importedData.membraneForces = csvread([folderName '/cell_forces/membrane/membrane_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesMembrane = false;
    end
    if app.importPlottingOptions.cellForcesContact && exist([folderName '/cell_forces'],'dir') == 7
        importedData.contactForces = csvread([folderName '/cell_forces/contact/contact_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesContact = false;
    end
    if app.importPlottingOptions.cellForcesArea && exist([folderName '/cell_forces'],'dir') == 7
        importedData.areaForces = csvread([folderName '/cell_forces/area/area_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesArea = false;
    end
    if app.importPlottingOptions.cellForcesPointlike && exist([folderName '/cell_forces'],'dir') == 7
        importedData.pointlikeForces = csvread([folderName '/cell_forces/pointlike/pointlike_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesPointlike = false;
    end
    if app.importPlottingOptions.cellForcesFocalAdhesions && exist([folderName '/cell_forces'],'dir') == 7
        importedData.substrateForces = csvread([folderName '/cell_forces/focal_adhesion/focal_adhesion_' num2str(timePoint), '.csv']);
    else
        app.importPlottingOptions.cellForcesFocalAdhesions = false;
    end
end

% if simulation or lineage plot
if importTemp.lineage
    
    % import the lineage data
    importedData.lineages = csvread([folderName '/lineage/lineage_' num2str(timePoint), '.csv']);
end

end