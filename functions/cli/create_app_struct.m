function app = create_app_struct(data,iLoop,defaultPath)
% CREATE_APP_STRUCT Create an app structure for the CMD simulation
%   The function defines the necessary fields for the app structure
%   required by the simulation setup functions based on the inputted config
%   file.
%   INPUT:
%       data: structure to collect config file data
%       iLoop: simulation loop index
%       defaultPath: path to the epimech root
%   OUTPUT:
%       app: temporary application structure
%   by Aapo Tervonen, 2021

% create the app struct
app = struct();

% set the default path
app.defaultPath = defaultPath;

% set the app task
app.appTask = 'simulate';

% set the simulation type
app.simulationType = data.simulationType;

% set various GUI variables
app.UniformdivisiontimesCheckBox.Value = 0;
app.ShowanimationCheckBox.Value = 0;
app.simulationClosed = 0;
app.simulationStopped = 0;
app.ExportdataCheckBox.Value = 1;
app.ExporteddataDropDown.Value = 'Custom export';
app.CentercellsCheckBox.Value = 0;
app.ProgressbarCheckBox.Value = 0;
app.TimesimulationCheckBox.Value = 0;
app.StopandpauseCheckBox.Value = 0;
app.TimestepplotCheckBox.Value = 0;
app.SpecialplotDropDown.Value = 0;
app.UniformdivisiontimesCheckBox.Value = 0;
app.InitialstateButtongroup.SelectedObject.Text = 'Single cell';
app.UseimportedsubstratedataCheckBox.Value = 0;
app.UseimportedmovementdataCheckBox.Value = 0;
app.SubstrateTypeButtonGroup.SelectedObject.Text = 'Fitted';


% set the appropriate solver
switch data.simulationType
    case 'growth'
        app.SolverDropDown.Value = 'RK2';
    case 'pointlike'
        app.SolverDropDown.Value = 'RK4';
    case 'opto'
        app.SolverDropDown.Value = 'RK4';
    case 'stretch'
        app.SolverDropDown.Value = 'RK4';
    case 'glass'
        app.SolverDropDown.Value = 'RK2';
end

% set the simulation name
app.SimulationnameEditField.Value = data.simulationNames{iLoop};

% import the system parameters
app.systemParameters = import_settings(data.systemParameterFiles{iLoop});

% assign the simulation time, time step and stop division time
app.systemParameters.simulationTime = data.simulationTime;
app.systemParameters.maximumTimeStep = data.maximumTimeStep;
app.systemParameters.stopDivisionTime = data.stopDivisionTime;

% if no initial state files given
if isempty(data.initialStateFiles)
    
    % set the model case
    app.modelCase = 'new';
    
    % get the cell and specific cell parameters
    app.cellParameters = import_settings(data.cellParameterFiles{iLoop});
    app.specificCellParameters = import_settings(data.specificCellParameterFiles{iLoop});
    
% if initial states given
else
    
    % set the model case
    app.modelCase = 'import';
    
    % initialize the import structure
    app.import = struct();
    
    % get the filename
    [~,fileName,~] = fileparts(data.initialStateFiles{iLoop});
    
    % define string for the imported folder
    app.import.folderName = [app.defaultPath 'Results/' fileName];
    
    % load the number of time points
    app.import.nTimePoints = size(dir([app.import.folderName '/vertices/*.csv']),1);
    
    % get the simulation type
    fID = fopen([app.import.folderName '/simulation_type.csv']);
    app.import.simulationType = fread(fID,'*char')';
    fclose(fID);
    
    % get the size type
    app.import.sizeType = csvread([app.import.folderName '/size_type.csv']);
    
    % get the index of the last time point to be used as the import time
    % point
    app.import.currentTimePoint = app.import.nTimePoints;
    
    % get the system, scaled, cell, and specific cell parameters
    app.import.systemParameters = import_settings([app.import.folderName '/system_parameters.csv']);
    app.import.scaledParameters = import_settings([app.import.folderName '/scaled_parameters.csv']);
    app.import.cellParameters = import_settings([app.import.folderName '/cell_parameters.csv']);
    app.import.specificCellParameters = import_settings([app.import.folderName '/specific_cell_parameters.csv']);
    app.import.exportOptions = import_settings([app.import.folderName '/export_options.csv']);


    % if the user wishes to use the cell parameters from the import
    if data.loadedParameters(iLoop) == 1
        
        % set the parameters
        app.cellParameters = app.import.cellParameters;
        
        % if the simulation type of the import and the new simulation are
        % the same, use the imported specific cell parameters
        if strcmp('app.import.simulationType',app.simulationType)
            app.specificCellParameters = app.import.specificCellParameters;
            
        % otherwise, use the provided specific cell parameters
        else
            app.specificCellParameters = import_settings(data.specificCellParameterFiles{iLoop});
        end
        
    % otherrwise, use the provided cell and specific cell parameters
    else
        app.cellParameters = import_settings(data.cellParameterFiles{iLoop});
        app.specificCellParameters = import_settings(data.specificCellParameterFiles{iLoop});
    end
    
    % if cells are to be removed by shape, get the removal data
    if ~isempty(data.removeCells.type)
        app.cmdRemovedCells.type = data.removeCells.type{iLoop};
        app.cmdRemovedCells.size = data.removeCells.size{iLoop};
        
    % otherwise
    else
        app.cmdRemovedCells.size = -1;
    end
end

% if growth simulation
if strcmp(data.simulationType,'growth')
    
    % if no stop division time given
    if app.systemParameters.stopDivisionTime == -1
        app.DivisiontypeButtongroup.SelectedObject.Text = 'Normal division';
        
    % otherwise
    else
        app.DivisiontypeButtongroup.SelectedObject.Text = 'Division until';
    end
    
    % if uniform cell sizing
    if data.sizeType(iLoop) == 1
        app.CellsizeButtonGroup.SelectedObject.Text = 'Uniform sizing';
        
    % if MDCK sizing
    elseif data.sizeType(iLoop) == 2
        app.CellsizeButtonGroup.SelectedObject.Text = 'MDCK sizing';
    end
end

% if stretch simulation
if strcmp(app.simulationType,'stretch')
    
    % if piecewise, set the type and get the data
    if data.stretching.type{iLoop} == 1
        app.stretch.type = 1;
        app.stretch.piecewise = csvread(data.stretching.info{iLoop});
        
    % if sine, set the type and get the data
    else
        app.stretch.type = 2;
        app.stretch.sine = csvread(data.stretching.info{iLoop});
    end
    
    % set the direction of the stretch to the appropriate setting
    if data.stretching.directions{iLoop} == 1
        app.CompressionAxisButtonGroup.SelectedObject.Text = 'Uniaxial';
    else
        app.CompressionAxisButtonGroup.SelectedObject.Text = 'Biaxial';
    end
    
end

% if pointlike simulation
if strcmp(app.simulationType,'pointlike')
    
    % if the center cell is to be selected
    if data.pointlike.cell{iLoop} == 0
        app.SelectcentercellCheckBox.Value = 1;
        
    % otherwise, take the inputted cell
    else
        app.SelectcentercellCheckBox.Value = 0;
        app.pointlikeProperties.cell = data.pointlike.cell{iLoop};
    end
    
    % get the pointlike data and assign the times and movements
    importedData = csvread(data.pointlike.pointlikeMovement{iLoop});
    app.pointlikeProperties.movementTime = importedData(:,1);
    app.pointlikeProperties.movementY = importedData(:,2);
end

% if opto simulation
if strcmp(app.simulationType,'opto')
    
    % get the optogenetic activationd ata
    app.optoActivation = csvread(data.opto.activation{iLoop});
    
    % get the shape data
    optoShapesTemp = csvread(data.opto.shapes{iLoop});
    
    % go through the shape data and save the different shapes into the
    % optoShapes cell (the shape coordinates are separated by a row of
    % zeros)
    app.optoShapes = {};
    nShapes = sum(optoShapesTemp(:,1) == 0)+1;
    for i = 1:nShapes
        [~,idx] = find(optoShapesTemp(:,1) == 0);
        if isempty(idx)
            app.optoShapes{i} = optoShapesTemp;
            nextZero = 2;
        else
            nextZero = min(idx);
            app.optoShapes{i} = optoShapesTemp(1:nextZero-1,:);
        end
        optoShapesTemp(1:nextZero,:) = [];
        app.optoVertices.vertices = {};
    end
    
    % initialize the activated cells
    app.optoVertices.cells = [];
end

% if opto simulation
if strcmp(app.simulationType,'glass')
    
    % get the optogenetic activationd ata
    app.glassActivation = csvread(data.glass.movement{iLoop});
    
    % get the shape data
    glassShapesTemp = csvread(data.glass.shapes{iLoop});
    
    % go through the shape data and save the different shapes into the
    % optoShapes cell (the shape coordinates are separated by a row of
    % zeros)
    app.glassActivationShapes = {};
    nShapes = sum(glassShapesTemp(:,1) == 0)+1;
    for i = 1:nShapes
        [~,idx] = find(glassShapesTemp(:,1) == 0);
        if isempty(idx)
            app.glassActivationShapes{i} = glassShapesTemp;
            nextZero = 2;
        else
            nextZero = min(idx);
            app.glassActivationShapes{i} = glassShapesTemp(1:nextZero-1,:);
        end
        glassShapesTemp(1:nextZero,:) = [];

    end
    
end

% if simulation with substrate
if strcmp(app.simulationType,'pointlike') || strcmp(app.simulationType,'stretch') || strcmp(app.simulationType,'opto') || strcmp(app.simulationType,'glass')
    
    % set the substrate, focal adhesion, and youngs modulus parameters
    app.substrateParameters = import_settings(data.substrateParameterFiles{iLoop});
    app.fFAInfo = csvread(data.fFAInfo{iLoop});
    app.substrateParameters.youngsModulus = data.stiffness{iLoop};
    
    % set the stiffess type    
    switch data.stiffnessType{iLoop}
        case 'uniform'
            app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Constant';
        case 'gradient'
            app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Gradient';
            app.stiffnessGradientInformation = csvread(data.stiffnessInfo{iLoop});
        case 'heterogeneous'
            app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Heterogeneous';
            app.heterogeneousStiffness = csvread(data.stiffnessInfo{iLoop});
    end
end

% set up the simulation export options
app.customExportOptions = settings_to_logical(import_settings(data.exportSettings{iLoop}),'export');
app.customExportOptions.exportDtMultiplier = data.exportDt{iLoop};

% setup parameter study
app = setup_parameter_study(data,app,iLoop);

end