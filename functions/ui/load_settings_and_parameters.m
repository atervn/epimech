function folderLoaded = load_settings_and_parameters(app,option)

folderLoaded = 1;

if option == 1
    switch app.appTask
        case 'simulate'     
            switch app.modelCase
                case 'new'
                    app.cellParameters = import_settings([app.defaultPath 'parameters/cell_parameters.txt']);
                case 'import'
                    
                    fID = fopen([app.import.folderName '/simulation_type.csv']);
                    app.import.simulationType = fread(fID,'*char')';
                    fclose(fID);
                    
                    if strcmp(app.import.simulationType,'pointlike') && strcmp(app.SimulationtypeDropDown.Value,'Epithelial growth')
                        uialert(app.EpiMechUIFigure,'Pointlike simulation cannot be used as the initial state of a growth simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'opto') && strcmp(app.SimulationtypeDropDown.Value,'Epithelial growth')
                        uialert(app.EpiMechUIFigure,'Optogenetic activation simulation cannot be used as the initial state of a growth simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'stretch') && strcmp(app.SimulationtypeDropDown.Value,'Epithelial growth')
                        uialert(app.EpiMechUIFigure,'Lateral compression or stretching simulation cannot be used as the initial state of a growth simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'opto') && strcmp(app.SimulationtypeDropDown.Value,'Pointlike micromanipulation')
                        uialert(app.EpiMechUIFigure,'Optogenetic activation simulation cannot be used as the initial state of a pointlike micromanipulation simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'stretch') && strcmp(app.SimulationtypeDropDown.Value,'Pointlike micromanipulation')
                        uialert(app.EpiMechUIFigure,'Lateral compression or stretching simulation cannot be used as the initial state of a pointlike micromanipulation simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'pointlike') && strcmp(app.SimulationtypeDropDown.Value,'Optogenetic activation')
                        uialert(app.EpiMechUIFigure,'Pointlike simulation cannot be used as the initial state of an optogenetic activation simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'stretch') && strcmp(app.SimulationtypeDropDown.Value,'Optogenetic activation')
                        uialert(app.EpiMechUIFigure,'Lateral compression or stretching simulation cannot be used as the initial state of an optogenetic activation simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'pointlike') && strcmp(app.SimulationtypeDropDown.Value,'Lateral compression and stretching')
                        uialert(app.EpiMechUIFigure,'Pointlike simulation cannot be used as the initial state of a lateral compression or stretching simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    elseif strcmp(app.import.simulationType,'opto') && strcmp(app.SimulationtypeDropDown.Value,'Lateral compression and stretching')
                        uialert(app.EpiMechUIFigure,'Optogenetic activation simulation cannot be used as the initial state of a lateral compression or stretching simulation.','Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    end
                    
                    incomplete = check_loaded_simulation(app);
                    if incomplete ~= 0
                        uialert(app.EpiMechUIFigure,['Data not loaded, ' incomplete ' is missing.'],'Bad Input');
                        folderLoaded = 0;
                        disable_enable_all_function(app,'On')
                        figure(app.EpiMechUIFigure)
                        return;
                    end
  
                    exportOptions = import_settings([app.import.folderName '/export_options.csv']);
                    app.import.exportOptions = exportOptions;
                    app.cellParameters = import_settings([app.import.folderName '/cell_parameters.csv']);
                    app.import.cellParameters = app.cellParameters;
                    app.defaultCellParameters = import_settings([app.defaultPath 'parameters/cell_parameters.txt']);
                    app.import.specificCellParameters = import_settings([app.import.folderName '/specific_cell_parameters.csv']);
                    app.import.systemParameters = import_settings([app.import.folderName '/system_parameters.csv']);
                    app.import.scaledParameters = import_settings([app.import.folderName '/scaled_parameters.csv']);
                    app.import.nTimePoints = size(dir([app.import.folderName '/vertices/*.csv']),1);
                    app.import.currentTimePoint = app.import.nTimePoints;
                    app.import.originalCellNumbers = get_original_cell_numbers_function(app);
                    app.import.nCells = length(app.import.originalCellNumbers);
                    app.import.removedCells = [];
                    app.import.sizeType = csvread([app.import.folderName '/size_type.csv']);
            end
            
        case 'plotAndAnalyze'
            for i = app.newImports
                incomplete = check_loaded_simulation(app,i);
                if incomplete ~= 0
                    uialert(app.EpiMechUIFigure,['Data not loaded, ' incomplete ' is missing.'],'Bad Input');
                    app.LoadedfilesDropDown.Items(i) = [];
                else
                    app.plotImport(i).exportOptions = import_settings([app.plotImport(i).folderName '/export_options.csv']);
                    app.plotImport(i).systemParameters = import_settings([app.plotImport(i).folderName '/system_parameters.csv']);
                    app.plotImport(i).scaledParameters = import_settings([app.plotImport(i).folderName '/scaled_parameters.csv']);
                    app.plotImport(i).nTimePoints = size(dir([app.plotImport(i).folderName '/vertices/*.csv']),1);
                    app.plotImport(i).currentTimePoint = app.plotImport(i).nTimePoints;
                    app.plotImport(i).cellNumbers = get_original_cell_numbers_function(app,i);
                    app.plotImport(i).cellParameters = import_settings([app.plotImport(i).folderName '/cell_parameters.csv']);
                    app.plotImport(i).specificCellParameters = import_settings([app.plotImport(i).folderName '/specific_cell_parameters.csv']);
                    if exist([app.plotImport(i).folderName '/substrate_parameters.csv'],'file') == 2
                        app.plotImport(i).substrateParameters = import_settings([app.plotImport(i).folderName '/substrate_parameters.csv']);
                    end
                    fID = fopen([app.plotImport(i).folderName '/simulation_type.csv']);
                    app.plotImport(i).simulationType = fscanf(fID,'%s');
                    fclose(fID);
                    if strcmp(app.plotImport(i).simulationType,'opto')
                        app.plotImport(i).optoSelectedCells = [];
                    end
                    if strcmp(app.plotImport(i).simulationType,'glass')
                        app.plotImport(i).glassActivation = readmatrix([app.plotImport(i).folderName '/glass/glass_activation.csv']);
                        app.plotImport(i).glassShapes = readmatrix([app.plotImport(i).folderName '/glass/glass_shapes.csv']);
                    end
                                        
                    if isfield(app.plotImport(i).systemParameters,'SIMULATION_TIME')
                        app.plotImport(i).systemParameters.simulationTime = app.plotImport(i).systemParameters.SIMULATION_TIME;
                        app.plotImport(i).systemParameters.maximumTimeStep = app.plotImport(i).systemParameters.DEFAULT_DT;
                        app.plotImport(i).scaledParameters.simulationTime = app.plotImport(i).scaledParameters.SIMULATION_TIME;
                        app.plotImport(i).scaledParameters.maximumTimeStep = app.plotImport(i).scaledParameters.DEFAULT_DT;
                    end
                    
                    
                end
            end
            if app.firstStartupPA 
                switch app.plotImport(app.selectedFile).simulationType
                    case 'growth'
                        app.importPlottingOptions = import_settings([app.defaultPath 'settings/plotting/post_plotting_options_growth.txt']);
                        app.importPlottingOptions = settings_to_logical(app.importPlottingOptions,'plot');
                    case 'pointlike'
                        app.importPlottingOptions = import_settings([app.defaultPath 'settings/plotting/post_plotting_options_pointlike.txt']);
                        app.importPlottingOptions = settings_to_logical(app.importPlottingOptions,'plot');
                    case 'stretch'
                        app.importPlottingOptions = import_settings([app.defaultPath 'settings/plotting/post_plotting_options_stretch.txt']);
                        app.importPlottingOptions = settings_to_logical(app.importPlottingOptions,'plot');
                        if app.importPlottingOptions.substrateStyle == 2
                            app.importPlottingOptions.substrateStyle = 1;
                        end
                    case 'opto'
                        app.importPlottingOptions = import_settings([app.defaultPath 'settings/plotting/post_plotting_options_opto.txt']);
                        app.importPlottingOptions = settings_to_logical(app.importPlottingOptions,'plot');
                    case 'glass'
                        app.importPlottingOptions = import_settings([app.defaultPath 'settings/plotting/post_plotting_options_glass.txt']);
                        app.importPlottingOptions = settings_to_logical(app.importPlottingOptions,'plot');
                end
            end
    end
end

import_scale_bar_data(app)


if strcmp(app.appTask,'simulate')
    if strcmp(app.modelCase,'import')
        
        if strcmp(app.import.simulationType,'pointlike') && strcmp(app.SimulationtypeDropDown.Value,'Epithelial growth')
            uialert(app.EpiMechUIFigure,'Pointlike simulation cannot be used as the initial state of a growth simulation.','Bad Input');
            folderLoaded = 0;
            disable_enable_all_function(app,'On')
            figure(app.EpiMechUIFigure)
            return;
        end
        
        
        incomplete = check_loaded_simulation(app);
        if incomplete ~= 0
            uialert(app.EpiMechUIFigure,['Cannot change simulation type. ' incomplete ' is missing.'],'Bad Input');
            disable_enable_all_function(app,'On')
            figure(app.EpiMechUIFigure)
            folderLoaded = 0;
            return;
        end
    end
    
    app.stiffnessGradientInformation = csvread([app.defaultPath 'settings/misc/default_stiffness_gradient.csv']);
    app.fFAInfo = csvread([app.defaultPath 'parameters/focal_adhesion_parameters.csv']);
    app.optoActivation = csvread([app.defaultPath 'settings/misc/default_opto_activation.csv']);
    app.glassActivation = csvread([app.defaultPath 'settings/misc/default_glass_movements.csv']);
    app.stretch.piecewise = csvread([app.defaultPath 'settings/misc/default_piecewise_stretch.csv']);
    app.stretch.sine = csvread([app.defaultPath 'settings/misc/default_sine_stretch.csv']);
    app.stretch.type = 1;
    app.optoActivation(app.optoActivation(:,2) > 1,2) = 1;
    app.heterogeneousStiffness = csvread([app.defaultPath 'settings/misc/default_heterogeneous_data.csv']);
    
    switch app.SimulationtypeDropDown.Value
        case 'Epithelial growth'
            
            if app.firstStartup || ~strcmp(app.simulationType,'growth')
                app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_growth.txt']);
                app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
                
                app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_growth.txt']);
                app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
                
                app.simulationType = 'growth';
                
                if strcmp(app.modelCase,'import') && strcmp(app.simulationType,app.import.simulationType)
                    app.specificCellParameters = app.import.specificCellParameters;
                else
                    app.specificCellParameters = import_settings([app.defaultPath 'parameters/specific_parameters_growth.txt']);
                end
                
                app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_growth.txt']);
                
                set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'Off'});
                
                app.SimulationtimeDropDown.Items = {'days','hours','mins','secs'};
                app.SimulationtimeDropDown.Value = 'days';
                app.SimulationtimestepDropDown.Items = {'days','hours','mins','secs'};
                app.SimulationtimestepDropDown.Value = 'mins';
            end
        case 'Pointlike micromanipulation'
            
            if app.firstStartup || ~strcmp(app.simulationType,'pointlike')
                app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_pointlike.txt']);
                app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
                
                app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_pointlike.txt']);
                app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
            end
            app.simulationType = 'pointlike';
            
            if strcmp(app.modelCase,'import') && strcmp(app.simulationType,app.import.simulationType)
                app.specificCellParameters = app.import.specificCellParameters;
            else
                app.specificCellParameters = import_settings([app.defaultPath 'parameters/specific_parameters_pointlike.txt']);
            end

            app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_pointlike.txt']);
            
            if strcmp(app.modelCase,'import')
                switch app.import.simulationType
                    case 'growth'
                        set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                        app.FittedButton.Value = 1;
                        app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                        app.UseimportedsubstratedataCheckBox.Value = 0;
                        app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                        app.UseimportedsubstratedataCheckBox_2.Value = 0;
                        app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                        app.ConstantButton.Value = 1;
                        set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                        set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                    case 'pointlike'
                        if check_substrate_import(app)
                            defaultSubstrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                            app.substrateParameters = import_settings([app.import.folderName '/substrate_parameters.csv']);
                            app.UseimportedsubstratedataCheckBox.Value = 1;
                            app.UseimportedsubstratedataCheckBox.Visible = 'On';
                            set_object_properties_function(app,{'FittedButton','SquareButton', 'ManualsizeCheckBox','SubstratesizeEditField', 'SubstratesizeEditFieldLabel', 'mLabel','ComparesizeButton', 'SubstrateparametersButton'},'Enable',{'Off'});
                            app.UseimportedsubstratedataCheckBox_2.Value = 1;
                            app.UseimportedsubstratedataCheckBox_2.Visible = 'On';
                            app.ConstantButton.Value = 1;
                            set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel', 'EditstiffnessButton'},'Enable',{'Off'});
                            fID = fopen([app.import.folderName '/substrate_auxiliary/stiffness_type.csv']);
                            app.import.stiffnessType = fread(fID,'*char')';
                            fclose(fID);
                        else
                            uialert(app.EpiMechUIFigure, 'Substrate data not available for the loaded simulation. New substrate is created', 'Substrate not found' ,'Icon', 'info');
                            
                            set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                            app.FittedButton.Value = 1;
                            app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                            app.UseimportedsubstratedataCheckBox.Value = 0;
                            app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                            app.UseimportedsubstratedataCheckBox_2.Value = 0;
                            app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                            app.ConstantButton.Value = 1;
                            set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                            set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                            app.import.stiffnessType = '';
                        end
                end
            else
                set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                app.ConstantButton.Value = 1;
                set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});          
                set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                app.UseimportedsubstratedataCheckBox.Value = 0;
                app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                app.UseimportedsubstratedataCheckBox_2.Value = 0;
                app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
            end
            
            app.pointlikeProperties.cell = 1;
            
            if strcmp(app.modelCase,'import') && strcmp(app.import.simulationType,'pointlike') && strcmp(app.import.stiffnessType,'Gradient')
                app.YoungsmodulusEditField.Value = defaultSubstrateParameters.youngsModulus/1000;
            else
                app.YoungsmodulusEditField.Value = app.substrateParameters.youngsModulus/1000;
            end
            
            app.SelectedcellEditField.Value = 1;
            if app.ShowanimationCheckBox.Value
                set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'On'});
            end
            
            if exist('./settings/pointlike_movements/30um_1s.txt','file') == 2
                try
                    importedData = csvread(['./settings/pointlike_movements/30um_1s.txt']);
                    app.pointlikeProperties.movementTime = importedData(:,1);
                    app.pointlikeProperties.movementY = importedData(:,2);
                    app.PointlikeFileNameLabel.Text = '30um_1s';
                catch
                    app.SimulateButton.Enable = 'Off';
                end
                
            end
            
            app.SimulationtimeDropDown.Items = {'secs','msecs'};
            app.SimulationtimeDropDown.Value = 'secs';
            app.SimulationtimestepDropDown.Items = {'secs','msecs'};
            app.SimulationtimestepDropDown.Value = 'msecs';
        case 'Lateral compression and stretching'
            
            if app.firstStartup || ~strcmp(app.simulationType,'stretch')
                app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_stretch.txt']);
                app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
                if app.plottingOptions.substrateStyle == 2
                    app.plottingOptions.substrateStyle = 1;
                end
                app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_stretch.txt']);
                app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
                
                
                app.simulationType = 'stretch';
                
                if strcmp(app.modelCase,'import') && strcmp(app.simulationType,app.import.simulationType)
                    app.specificCellParameters = app.import.specificCellParameters;
                else
                    app.specificCellParameters = import_settings([app.defaultPath 'parameters/specific_parameters_stretch.txt']);
                end
                
                
                
                
                app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_stretch.txt']);
                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                
                
                set_object_properties_function(app,{'YoungsmodulusEditField','YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'Off'});
                
                if app.ShowanimationCheckBox.Value
                    set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'On'});
                end
                
                app.SimulationtimeDropDown.Items = {'mins','secs','msecs'};
                app.SimulationtimeDropDown.Value = 'mins';
                app.SimulationtimestepDropDown.Items = {'mins','secs','msecs'};
                app.SimulationtimestepDropDown.Value = 'secs';
            end
        case 'Edge compression'
 
%             if app.firstStartup || ~strcmp(app.simulationType,'edge')
%                 app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_growth.txt']);
%                 app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
%                 
%                 app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_growth.txt']);
%                 app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
%                 
%                 app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_edge.txt']);
%                 app.simulationType = 'edge';
%                 set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'Off'});
%                 
%                 app.SimulationtimeDropDown.Items = {'days','hours','mins','secs','msecs'};
%                 app.SimulationtimeDropDown.Value = 'secs';
%                 app.SimulationtimestepDropDown.Items = {'secs','msecs'};
%                 app.SimulationtimestepDropDown.Value = 'msecs';
%             end
        case 'Optogenetic activation'
            if app.firstStartup || ~strcmp(app.simulationType,'opto')
                app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_opto.txt']);
                app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
                
                app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_opto.txt']);
                app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
                
                app.simulationType = 'opto';
                
                if strcmp(app.modelCase,'import') && strcmp(app.simulationType,app.import.simulationType)
                    app.specificCellParameters = app.import.specificCellParameters;
                else
                    app.specificCellParameters = import_settings([app.defaultPath 'parameters/specific_parameters_opto.txt']);
                end
                
                app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_opto.txt']);
                
                
                if strcmp(app.modelCase,'import')
                    switch app.import.simulationType
                        case 'growth'
                            set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                            app.FittedButton.Value = 1;
                            app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                            app.UseimportedsubstratedataCheckBox.Value = 0;
                            app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                            app.UseimportedsubstratedataCheckBox_2.Value = 0;
                            app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                            app.ConstantButton.Value = 1;
                            set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                            set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                        case 'opto'
                            if check_substrate_import(app)
                                defaultSubstrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                                app.substrateParameters = import_settings([app.import.folderName '/substrate_parameters.csv']);
                                app.UseimportedsubstratedataCheckBox.Value = 1;
                                app.UseimportedsubstratedataCheckBox.Visible = 'On';
                                set_object_properties_function(app,{'FittedButton','SquareButton', 'ManualsizeCheckBox','SubstratesizeEditField', 'SubstratesizeEditFieldLabel', 'mLabel','ComparesizeButton', 'SubstrateparametersButton'},'Enable',{'Off'});
                                app.UseimportedsubstratedataCheckBox_2.Value = 1;
                                app.UseimportedsubstratedataCheckBox_2.Visible = 'On';
                                app.ConstantButton.Value = 1;
                                set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel', 'EditstiffnessButton'},'Enable',{'Off'});
                                fID = fopen([app.import.folderName '/substrate_auxiliary/stiffness_type.csv']);
                                app.import.stiffnessType = fread(fID,'*char')';
                                fclose(fID);
                            else
                                uialert(app.EpiMechUIFigure, 'Substrate data not available for the loaded simulation. New substrate is created', 'Substrate not found' ,'Icon', 'info');
                                
                                set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                                app.FittedButton.Value = 1;
                                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                                app.UseimportedsubstratedataCheckBox.Value = 0;
                                app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                                app.UseimportedsubstratedataCheckBox_2.Value = 0;
                                app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                                app.ConstantButton.Value = 1;
                                set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                                set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                                app.import.stiffnessType = '';
                            end
                    end
                else
                    set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                    app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                    app.ConstantButton.Value = 1;
                    set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                    set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                    app.UseimportedsubstratedataCheckBox.Value = 0;
                    app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                    app.UseimportedsubstratedataCheckBox_2.Value = 0;
                    app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                end
                
                if strcmp(app.modelCase,'opto') && strcmp(app.import.simulationType,'opto') && strcmp(app.import.stiffnessType,'Gradient')
                    app.YoungsmodulusEditField.Value = defaultSubstrateParameters.youngsModulus/1000;
                else
                    app.YoungsmodulusEditField.Value = app.substrateParameters.youngsModulus/1000;
                end
                
                set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'On'});
                
                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                
                app.YoungsmodulusEditField.Value = app.substrateParameters.youngsModulus/1000;
                
                app.SimulationtimeDropDown.Items = {'mins','secs'};
                app.SimulationtimeDropDown.Value = 'mins';
                app.SimulationtimestepDropDown.Items = {'mins','secs','msecs'};
                app.SimulationtimestepDropDown.Value = 'secs';
                
                app.SaveactivationareaButton.Enable = 'Off';
                app.optoShapes = {};
                
                app.optoVertices.cells = [];
                app.optoVertices.vertices = {};
            end
        case 'Glass activation'
            if app.firstStartup || ~strcmp(app.simulationType,'glass')
                app.plottingOptions = import_settings([app.defaultPath 'settings/plotting/plotting_options_glass.txt']);
                app.plottingOptions = settings_to_logical(app.plottingOptions,'plot');
                
                app.customExportOptions = import_settings([app.defaultPath 'settings/export/export_options_custom_glass.txt']);
                app.customExportOptions = settings_to_logical(app.customExportOptions,'export');
                
                app.simulationType = 'glass';
                
                app.specificCellParameters = import_settings([app.defaultPath 'parameters/specific_parameters_glass.txt']);

                app.systemParameters = import_settings([app.defaultPath 'parameters/system_parameters_glass.txt']);
                
                set_object_properties_function(app,{'FittedButton','SquareButton', 'SubstrateparametersButton'},'Enable',{'On'});
                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters.txt']);
                app.ConstantButton.Value = 1;
                set_object_properties_function(app,{'EditstiffnessButton'},'Enable',{'Off'});
                set_object_properties_function(app,{'ConstantButton','HeterogeneousButton','GradientButton','YoungsmodulusEditField', 'YoungsmodulusEditFieldLabel','kPaLabel'},'Enable',{'On'});
                app.UseimportedsubstratedataCheckBox.Value = 0;
                app.UseimportedsubstratedataCheckBox.Visible = 'Off';
                app.UseimportedsubstratedataCheckBox_2.Value = 0;
                app.UseimportedsubstratedataCheckBox_2.Visible = 'Off';
                                
                set_object_properties_function(app,{'SubstratestyleDropDown','SubstratestyleLabel'},'Enable',{'On'});
                
                app.substrateParameters = import_settings([app.defaultPath 'parameters/substrate_parameters_glass.txt']);
                
                app.YoungsmodulusEditField.Value = app.substrateParameters.youngsModulus/1000;
                
                app.SimulationtimeDropDown.Items = {'mins','secs'};
                app.SimulationtimeDropDown.Value = 'secs';
                app.SimulationtimestepDropDown.Items = {'mins','secs','msecs'};
                app.SimulationtimestepDropDown.Value = 'msecs';
                
                app.SaveactivationareaButton.Enable = 'Off';
                app.glassActivationShapes = {};
            end
    end
end