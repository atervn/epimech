function d = setup_exporting(app,d,varargin)
% SETUP_EXPORTING Setup exporting for simulation
%   The function setups the settings for simulation exporting, creates the
%   folders, exports all parameter data, and static data related to
%   substrate, pointlike, and opto.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%       varargin: can be used to give startingTime that was defined before
%           calling the function
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% get the simulation starting time, the starting time is given either by
% the varargin or taken as a new value
if numel(varargin) > 0
    startingTime = varargin{1};
else
    startingTime = clock;
end

% if the exporting is selected
if app.ExportdataCheckBox.Value
    
    % read export settings
    d.ex = read_export_settings(app);
    
    % set exporting to 1 and calculate the export time step
    d.ex.export = 1;
    d.ex.exportDt = app.customExportOptions.exportDtMultiplier*d.spar.maximumTimeStep;
      
    % get the default path
    d.ex.defaultPath = app.defaultPath;
    
    % get the export date and time
    exportDate = datestr(startingTime, 'yyyymmdd');
    exportTime = datestr(startingTime, 'HHMMSS');
    
    % if the name in the simulation/video field is the default "Give name",
    % give the video the name of "simulation"
    if strcmp(app.SimulationnameEditField.Value,'Give name')
        d.ex.exportName = [exportDate '_' exportTime '_simulation'];
    else
        d.ex.exportName = [exportDate '_' exportTime '_' app.SimulationnameEditField.Value];
    end
    
    % if the results folder in the epimech root does not exist, create it
    if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
        mkdir(app.defaultPath, 'results');
    end
    
    % create the folder for the simulation export and get its path
    mkdir([app.defaultPath 'results/'], d.ex.exportName);
    folderPath = [app.defaultPath 'results/' d.ex.exportName];
    
    % create folders for exported data
    create_export_folders(d, folderPath);

    % export cell parameters
    export_cell_parameters(app,folderPath);
    
    % export specific cell parameters
    export_specific_cell_parameters(app,folderPath);
    
    % export system parameters
    export_system_parameters(app,folderPath);

    % export substrate parameters
    export_substrate_parameters(app,d,folderPath);
    
    % export scaled parameters
    export_scaled_parameters(d,folderPath);
    
    % export export settings
    export_export_setting(d,folderPath);

    % export auxiliary substrate data
    export_auxiliary_substrate_data(app,d, folderPath)
    
    % export simulation type
    export_simulation_type(d, folderPath);
    
    % export the cell size type
    csvwrite([app.defaultPath 'Results/' d.ex.exportName '/size_type.csv'],d.simset.division.sizeType);
    
    % export pointlike data
    export_pointlike_data(d,folderPath);

    % export opto settings
    export_opto_settings(d,folderPath);
    
    % export glass settings
    export_glass_settings(d,folderPath);

    % export stretch settings
    export_stretch_settings(app,d,folderPath);
else
    d.ex.export = 0;
end

end

function ex = read_export_settings(app)
% READ_EXPORT_SETTINGS Read export settings from file
%   The function reads the export settings from file based on the user
%   preference.
%   INPUT:
%       d: main simulation data structure
%   OUTPUT:
%       ex: export settings
%   by Aapo Tervonen, 2021

% get the choice for the extension of the export
switch app.ExporteddataDropDown.Value

    % export suitable for import
    case 'Suitable for import'
        
        % depending on the simulation type, read to corresponding
        % export settings
        switch app.simulationType
            case 'growth'
                ex = import_settings([app.defaultPath 'settings/export/export_options_import_growth.txt']);
            case 'pointlike'
                ex = import_settings([app.defaultPath 'settings/export/export_options_import_pointlike.txt']);
            case 'stretch'
                ex = import_settings([app.defaultPath 'settings/export/export_options_import_stretch.txt']);
            case 'opto'
                ex = import_settings([app.defaultPath 'settings/export/export_options_import_opto.txt']);
            case 'glass'
                ex = import_settings([app.defaultPath 'settings/export/export_options_import_glass.txt']);
        end
        
        % export suitable for basic plotting
    case 'Suitable for basic plotting'
        
        % depending on the simulation type, read to corresponding
        % export settings
        switch app.simulationType
            case 'growth'
                ex = import_settings([app.defaultPath 'settings/export/export_options_plotting_growth.txt']);
            case 'pointlike'
                ex = import_settings([app.defaultPath 'settings/export/export_options_plotting_pointlike.txt']);
            case 'stretch'
                ex = import_settings([app.defaultPath 'settings/export/export_options_plotting_stretch.txt']);
            case 'opto'
                ex = import_settings([app.defaultPath 'settings/export/export_options_plotting_opto.txt']);
            case 'glass'
                ex = import_settings([app.defaultPath 'settings/export/export_options_plotting_glass.txt']);
                
        end
        
        % full export
    case 'Full export'
        
        % read the full export settings
        ex = import_settings([app.defaultPath 'settings/export/export_options_full.txt']);
        
        % custom export
    case 'Custom export'
        
        % assign the custom export settings
        ex = app.customExportOptions;
end

end

function create_export_folders(d, folderPath)
% CREATE_EXPORT_FOLDER Create folders for exported data
%   The function creates the folders for the chosen exported features
%   INPUT:
%       d: main simulation data structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if vertex coordinates are exported, create the folder for them
if d.ex.vertices
    mkdir(folderPath, 'vertices');
end

% if vertex states are exported, create the folder for them
if d.ex.vertexStates
    mkdir(folderPath, 'vertex_states');
end

% if division data is exported, create the folder for them
if d.ex.division
    mkdir(folderPath, 'division');
end

% if cell states are exported, create the folder for them
if d.ex.cellStates
    mkdir(folderPath, 'cell_states');
end

% if junction data is exported, create the folder for them
if d.ex.junctions
    mkdir(folderPath, 'junctions');
end

% if boundary lengths are exported, create the folder for them
if d.ex.boundaryLengths
    mkdir(folderPath, 'boundary_lengths');
end

% if cell areas are exported, create the folder for them
if d.ex.areas
    mkdir(folderPath, 'areas');
end

% if cell perimeters are exported, create the folder for them
if d.ex.perimeters
    mkdir(folderPath, 'perimeters');
end

% if normal area and perimeters are exported, create the folder for
% them
if d.ex.normProperties
    mkdir(folderPath, 'norm_properties');
end

% if cortical strength data is exported, create the folder for them
if d.ex.corticalStrengths
    mkdir(folderPath, 'cortex');
end

% if lineage data is exported, create the folder for them
if d.ex.lineage
    mkdir(folderPath, 'lineage');
end

% if pointlike data is exported and pointlike simulation, create the
% folder
if d.ex.pointlike && d.simset.simulationType == 2
    mkdir(folderPath, 'pointlike');
end

% if opto data is exported and opto simulation, create the folder
if d.ex.opto && d.simset.simulationType == 5
    mkdir(folderPath, 'opto');
end

% if opto data is exported and opto simulation, create the folder
if d.ex.glass && d.simset.simulationType == 6
    mkdir(folderPath, 'glass');
end

% if stretch data is exported and stretch simulation, create the folder
if d.ex.stretch && d.simset.simulationType == 3
    mkdir(folderPath, 'stretch');
end

% if substrate is exported and substrate is included in the simulation,
% create folders for substrate data, auxiliary data, and focal
% adhesions
if or(d.ex.substratePlot,d.ex.substrateFull) && d.simset.substrateIncluded
    mkdir(folderPath, 'substrate');
    mkdir(folderPath, 'substrate_auxiliary');
    mkdir(folderPath, 'focal_adhesions');
end

% if cell area forces are exported, create a folder for them under cell
% forces folder (also, if the cell forces does not exist, create it
% also)
if d.ex.cellForcesArea
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'area');
end

% if cell cortical forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesCortical
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'cortical');
end

% if cell junction forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesJunctions
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'junction');
end

% if cell division forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesDivision && d.simset.simulationType == 1
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'division');
end

% if cell membrane forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesMembrane
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'membrane');
end

% if cell focal adhesion forces are exported and substrate is include
% in the simulation, create a folder for them under cell forces folder
% (also, if the cell forces does not exist, create it also)
if d.ex.cellForcesFocalAdhesions && d.simset.substrateIncluded
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'focal_adhesion');
end

% if cell pointlike forces are exported and simulation is a pointlike
% simulation, create a folder for them under cell forces folder (also,
% if the cell forces does not exist, create it also)
if d.ex.cellForcesPointlike && d.simset.simulationType == 2
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'pointlike');
end
% if cell contact forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesContact
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'contact');
end

% if cell total forces are exported, create a folder for them under
% cell forces folder (also, if the cell forces does not exist, create
% it also)
if d.ex.cellForcesTotal
    if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'cell_forces');
    end
    mkdir([folderPath '/cell_forces'], 'total');
end

% if substrate central forces are exported and the substrate is solved,
% create a folder for them under substrate forces folder (also, if the
% substrate forces does not exist, create it also)
if d.ex.substrateForcesCentral && d.simset.substrateSolved
    if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'substrate_forces');
    end
    mkdir([folderPath '/substrate_forces'], 'central');
end

% if substrate repulsion forces are exported and the substrate is
% solved, create a folder for them under substrate forces folder (also,
% if the substrate forces does not exist, create it also)
if d.ex.substrateForcesRepulsion && d.simset.substrateSolved
    if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'substrate_forces');
    end
    mkdir([folderPath '/substrate_forces'], 'repulsion');
end

% if substrate restoration forces are exported and the substrate is
% solved, create a folder for them under substrate forces folder (also,
% if the substrate forces does not exist, create it also)
if d.ex.substrateForcesRestoration && d.simset.substrateSolved
    if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'substrate_forces');
    end
    mkdir([folderPath '/substrate_forces'], 'restoration');
end

% if substrate focal adhesion forces are exported and the substrate is
% solved, create a folder for them under substrate forces folder (also,
% if the substrate forces does not exist, create it also)
if d.ex.substrateForcesFocalAdhesions && d.simset.substrateSolved
    if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'substrate_forces');
    end
    mkdir([folderPath '/substrate_forces'], 'focal_adhesion');
end

% if substrate total forces are exported and the substrate is solved,
% create a folder for them under substrate forces folder (also, if the
% substrate forces does not exist, create it also)
if d.ex.substrateForcesTotal && d.simset.substrateSolved
    if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
        mkdir(folderPath, 'substrate_forces');
    end
    mkdir([folderPath '/substrate_forces'], 'total');
end

end

function export_cell_parameters(app,folderPath)
% EXPORT_CELL_PARAMETERS Export cell parameters
%   The function exports the cell parameters into a file with field names
%   and values
%   INPUT:
%       app: main application structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% get the parameter field names
fieldNames = fieldnames(app.cellParameters);

% get the parameter values
cellParameterMatrix = cell2mat(struct2cell(app.cellParameters));

% create the export file
fileID = fopen([folderPath '/cell_parameters.csv'], 'w');

% go through the parameters
for i = 1:length(cellParameterMatrix)
    
    % write the parameter name and value
    fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(cellParameterMatrix(i)));
end

% close the file
fclose(fileID);

end

function export_specific_cell_parameters(app,folderPath)
% EXPORT_SPECIFIC_CELL_PARAMETERS Export specific cell parameters
%   The function exports the specific cell parameters into a file with
%   field names and values
%   INPUT:
%       app: main application structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% get the parameter field names
fieldNames = fieldnames(app.specificCellParameters);

% get the parameter values
specificCellParameterMatrix = cell2mat(struct2cell(app.specificCellParameters));

% create the export file
fileID = fopen([folderPath '/specific_cell_parameters.csv'], 'w');

% go through the parameters
for i = 1:length(specificCellParameterMatrix)
    
    % write the parameter name and value
    fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(specificCellParameterMatrix(i)));
end

% close the file
fclose(fileID);

end

function export_system_parameters(app,folderPath)
% EXPORT_SYSTEM_PARAMETERS Export system parameters
%   The function exports the system parameters into a file with field names
%   and values
%   INPUT:
%       app: main application structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% get the parameter field names
fieldNames = fieldnames(app.systemParameters);

% get the parameter values
systemParameterMatrix = cell2mat(struct2cell(app.systemParameters));

% create the export file
fileID = fopen([folderPath '/system_parameters.csv'], 'w');

% go through the parameters
for i = 1:length(systemParameterMatrix)
    
    % write the parameter name and value
    fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(systemParameterMatrix(i)));
end

% close the file
fclose(fileID);
 
end

function export_substrate_parameters(app,d,folderPath)
% EXPORT_SUBSTRATE_PARAMETERS Export substrate parameters
%   The function exports the substrate parameters into a file with field
%   names and values
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if simulation includes substrate
if d.simset.substrateIncluded
    
    % if gradient simulation
    if strcmp(app.StiffnessstyleButtonGroup.SelectedObject.Text,'Gradient')
        
        % remove the Young modulus from the parameters
        substrateParameters = rmfield(app.substrateParameters,'youngsModulus');
        
    % otherwise
    else
        substrateParameters = app.substrateParameters;
    end
    
    % get the parameter field names
    fieldNames = fieldnames(substrateParameters);
    
    % get the parameter values
    substrateParameterMatrix = cell2mat(struct2cell(substrateParameters));
    
    % create the export file
    fileID = fopen([folderPath '/substrate_parameters.csv'], 'w');
    
    % go through the parameters
    for i = 1:length(substrateParameterMatrix)
        
        % write the parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(substrateParameterMatrix(i)));
    end
    
    % close the file
    fclose(fileID);
    
end

end

function  export_scaled_parameters(d,folderPath)
% EXPORT_SCALED_PARAMETERS Export scaled parameters
%   The function exports the scaled parameters into a file with field
%   names and values
%   INPUT:
%       d: main simulation data structure
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% get the field names
fieldNames = fieldnames(d.spar);

% get the scaled parameter values
scaledParameterMatrix = cell2mat(struct2cell(d.spar));

% create the export file
fileID = fopen([folderPath '/scaled_parameters.csv'], 'w');

% go through the scaled parameters
for i = 1:length(scaledParameterMatrix)
    
    % write the scaled parameter name and value
    fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(scaledParameterMatrix(i)));
end

% clsoe the file
fclose(fileID);

end

function export_export_setting(d,folderPath)
% EXPORT_SCALED_PARAMETERS Export export settings
%   The function exports the export settings into a file with field
%   names and values
%   INPUT:
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% remove the export name field from the export options
exportOptions = rmfield(d.ex,{'exportName','defaultPath'});

% get the field names
fieldNames = fieldnames(exportOptions);

% get the export values
exportMatrix = structfun(@(a) double(a), exportOptions);

% create the file
fileID = fopen([folderPath '/export_options.csv'], 'w');

% go through the export options
for i = 1:length(exportMatrix)
    
    %if the fieldname is exportoptions
    if strcmp(fieldNames{i},'exportDt')
        
        % write the with higher accuracy
        fprintf(fileID,'%s,%.8f\r\n', fieldNames{i}, exportMatrix(i));
        
        % if not
    else
        
        % write the fieldname and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(exportMatrix(i)));
    end
end

% close the file
fclose(fileID);

end

function export_auxiliary_substrate_data(app,d, folderPath)
% EXPORT_AUXILIARY_SUBSTRATE_DATA Export the auxiliary substrate data
%   The function export the static substrate data.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if simulation included the substrate and if substrate is exported for
% plotting or fully
if d.simset.substrateIncluded && or(d.ex.substratePlot,d.ex.substrateFull)
    
    % export the original point coordinates
    writematrix(d.sub.pointsOriginalX, [folderPath '/substrate_auxiliary/points_original_x.csv']);
    writematrix(d.sub.pointsOriginalY, [folderPath '/substrate_auxiliary/points_original_y.csv']);
    
    if d.simset.simulationType ~= 3
        
        % export the interaction "selves" and pairs
        writematrix(d.sub.interactionSelvesIdx, [folderPath '/substrate_auxiliary/interaction_selves_idx.csv']);
        writematrix(d.sub.interactionPairsIdx, [folderPath '/substrate_auxiliary/interaction_pairs_idx.csv']);
        
        % export the stiffness type
        fileID = fopen([folderPath '/substrate_auxiliary/stiffness_type.csv'], 'w');
        fprintf(fileID,app.StiffnessstyleButtonGroup.SelectedObject.Text);
        fclose(fileID);
        
        % for heterogeneous and gradient stiffness, export the data that
        % describes the stiffness profile
        switch app.StiffnessstyleButtonGroup.SelectedObject.Text
            case 'Heterogeneous'
                writematrix(app.heterogeneousStiffness, [folderPath '/substrate_auxiliary/heterogeneous_information.csv']);
            case 'Gradient'
                writematrix(app.stiffnessGradientInformation, [folderPath '/substrate_auxiliary/gradient_information.csv']);
        end
    end
end

% if simulation included the substrate and if substrate is exported fully
if d.simset.substrateSolved && d.ex.substrateFull
    
    % export unique and counter interaction indices
    writematrix(d.sub.interactionLinIdx, [folderPath '/substrate_auxiliary/interaction_lin_idx.csv']);
    writematrix(d.sub.counterInteractionLinIdx, [folderPath '/substrate_auxiliary/counter_interaction_lin_idx.csv']);
    
    % export repulsion force index data and change signs
    writematrix(d.sub.repulsionLinIdx, [folderPath '/substrate_auxiliary/repulsion_lin_idx.csv']);
    writematrix(d.sub.repulsionVectors1Idx, [folderPath '/substrate_auxiliary/repulsion_vectors1_idx.csv']);
    writematrix(d.sub.repulsionVectors2Idx, [folderPath '/substrate_auxiliary/repulsion_vectors2_idx.csv']);
    writematrix(d.sub.repulsionChangeSigns, [folderPath '/substrate_auxiliary/repulsion_change_signs.csv']);
    
    % export honeycomb spring multipliers
    writematrix(d.sub.springMultipliers, [folderPath '/substrate_auxiliary/spring_multipliers.csv']);
    
    % export edge points
    writematrix(d.sub.edgePoints, [folderPath '/substrate_auxiliary/edge_points.csv']);
    
    % export restorative, central, and repulsion spring constants
    writematrix(d.sub.restorativeSpringConstants, [folderPath '/substrate_auxiliary/restorative_spring_constant.csv']);
    writematrix(d.sub.centralSpringConstants, [folderPath '/substrate_auxiliary/central_spring_constant.csv']);
    writematrix(d.sub.repulsionSpringConstants, [folderPath '/substrate_auxiliary/repulsion_spring_constant.csv']);
    
    % export the focal adhesion data
    writematrix(app.fFAInfo, [folderPath '/substrate_auxiliary/focal_adhesion_strengths.csv']);
end

end

function export_simulation_type(d, folderPath)
% EXPORT_SIMULATION_TYPE Export simulation type
%   The function export the static substrate data.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% create the file
fileID = fopen([folderPath '/simulation_type.csv'], 'w');

% check with type and write it to file
switch d.simset.simulationType
    case 1
        fprintf(fileID,'growth');
    case 2
        fprintf(fileID,'pointlike');
    case 3
        fprintf(fileID,'stretch');
    case 4
        fprintf(fileID,'frame');
    case 5
        fprintf(fileID,'opto');
    case 6
        fprintf(fileID,'glass');
end

% close the file
fclose(fileID);

end

function export_pointlike_data(d,folderPath)
% EXPORT_POINTLIKE_DATA Export pointlike data
%   The function export the static pointlike data
%   INPUT:
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% check if pointlike is exported and if simulation type is pointlike
if d.ex.pointlike && d.simset.simulationType == 2
    
    % get the pointlike data, and remove some fields
    pointlikeTemp = d.simset.pointlike;
    pointlikeTemp = rmfield(pointlikeTemp,{'pointX','pointY','vertexOriginalX','vertexOriginalY','vertexX','vertexY','movementTime','movementY'});
    
    % get the names of the remaining fields
    fieldNames = fieldnames(pointlikeTemp);
    
    % convert the struct to cell
    pointlikeCell = cell2mat(struct2cell(pointlikeTemp));
    
    % create the file, write the properties, and close the file
    fileID = fopen([folderPath '/pointlike/pointlike_data.csv'], 'w');
    % go through the parameters
    for i = 1:length(pointlikeCell)
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(pointlikeCell(i)));
    end
    fclose(fileID);
    
    % write the original vertex coordinates
    csvwrite([folderPath '/pointlike/original_vertex_locations.csv'],[d.simset.pointlike.vertexOriginalX d.simset.pointlike.vertexOriginalY]);

    % write the movement data
    csvwrite([folderPath '/pointlike/movement_data.csv'],[(d.simset.pointlike.movementTime).*d.spar.scalingTime (d.simset.pointlike.movementY).*d.spar.scalingLength]);
end

end

function export_opto_settings(d,folderPath)
% EXPORT_OPTO_DATA Export opto data
%   The function export the opto data, including the activation behavior
%   and the activation region shapes
%   INPUT:
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if opto is exported and simualtion type is opto
if d.ex.opto && d.simset.simulationType == 5
    
    % export activation data and activation regions
    csvwrite([folderPath '/opto/opto_activation.csv'],[d.simset.opto.times d.simset.opto.levels]);
    csvwrite([folderPath '/opto/opto_shapes.csv'],d.simset.opto.shapes);
end

end

function export_glass_settings(d,folderPath)
% EXPORT_OPTO_DATA Export opto data
%   The function export the opto data, including the activation behavior
%   and the activation region shapes
%   INPUT:
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if opto is exported and simualtion type is opto
if d.ex.glass && d.simset.simulationType == 6
    
    % export activation data and activation regions
    csvwrite([folderPath '/glass/glass_activation.csv'],[d.simset.glass.times d.simset.glass.positions]);
    csvwrite([folderPath '/glass/glass_shapes.csv'],d.simset.glass.shapes);
end

end

function export_stretch_settings(app,d,folderPath)
% EXPORT_STRETCH_DATA Export stretch data
%   The function export the stretch data
%   INPUT:
%       d: main simulation data structure
%       ex: export settings
%       folderPath: simulation export root folder path
%   by Aapo Tervonen, 2021

% if opto is exported and simualtion type is opto
if d.ex.stretch && d.simset.simulationType == 3
    
    % open a file to write the stretch type
    fileID = fopen([folderPath '/stretch/stretch_type.csv'], 'w');
    
    % check with type and write it to file
    switch app.stretch.type
        case 1
            fprintf(fileID,'piecewise');
        case 2
            fprintf(fileID,'sine');
    end
    % close the file
    fclose(fileID);
    
    % write the stretch axis
    csvwrite([folderPath '/stretch/stretch_axis.csv'],d.simset.stretch.axis);
    
    csvwrite([folderPath '/stretch/stretch_values.csv'],[d.simset.stretch.times.*d.spar.scalingTime d.simset.stretch.values])

end

end