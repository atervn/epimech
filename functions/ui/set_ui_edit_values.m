function set_ui_edit_values(app)

switch app.appTask
    case 'simulate'
        app.SimulationtimeEditField.Value = scale_time_units(app, 'SimulationtimeDropDown', app.systemParameters.simulationTime, 'field');
        app.TimestepEditField.Value = scale_time_units(app, 'SimulationtimestepDropDown', app.systemParameters.maximumTimeStep, 'field');
        if strcmp(app.simulationType,'growth')
            app.DivideuntilEditField.Value = scale_time_units(app, 'DivideuntilDropDown', app.systemParameters.stopDivisionTime, 'field');
        end
        if app.firstStartup == 1
            sliderValue = log((app.plottingOptions.windowSize/1e-6-30)/10)/log(77);
            if ~isreal(sliderValue)
                app.WindowsizeSlider.Value = 0;
            elseif sliderValue > 1
                app.WindowsizeSlider.Value = 1;
            else
                app.WindowsizeSlider.Value = sliderValue;
            end
            app.WindowsizeEditField.Value = round(app.plottingOptions.windowSize*1e6);
        end
        app.PlottingstepEditField.Value = app.plottingOptions.plotDtMultiplier;
        app.RealplottingstepLabel.Text = set_real_time_steps(app,'plotting');
        app.ExportstepEditField.Value = app.customExportOptions.exportDtMultiplier;
        app.RealexportstepLabel.Text = set_real_time_steps(app,'export');
        set_cell_plotting_style(app,app.plottingOptions.cellStyle);
        set_substrate_plotting_style(app,app.plottingOptions.substrateStyle);
        app.SavevideoCheckBox.Value = 0;
        app.CompressvideoCheckBox.Value = 0;
        app.CompressvideoCheckBox.Enable = 0;
        
        set_object_properties_function(app,{'xdtLabel_2', 'ExportstepEditField', 'ExportstepEditFieldLabel', 'RealexportstepLabel', 'ExporteddataDropDown', 'EditexportoptionsButton', 'SimulationnameEditField','ReloadButton'},'Enable', {'Off'});
        app.ExportdataCheckBox.Value = 0;
        app.ExporteddataDropDown.Value = 'Suitable for import';
        app.SimulationnameEditField.Value = 'Give name';
        app.SimulationnameEditField.FontColor = [0.8 0.8 0.8];
        
        app.ScalebarsettingsMenu.Enable = 'On';
        
        if strcmp(app.modelCase,'loaded')
            app.TimetoloadDropDown.Items = {};
            
            d.spar = app.import.scaledParameters;
            numTemp = num2cell(1:app.import.nTimePoints);
            timeStrings = cellfun(@(i) separate_times(d,convert_import_time(app,i,'numberToTime')),numTemp,'UniformOutput',false);
            app.TimetoloadDropDown.Items = timeStrings;
            app.TimetoloadDropDown.Value = app.TimetoloadDropDown.Items(end);
        end
        
        if strcmp(app.simulationType,'growth')
            app.SolverDropDown.Value = 'RK2';
            app.SimulateButton.Enable = 'On';
        elseif strcmp(app.simulationType,'pointlike')
            app.SolverDropDown.Value = 'RK4';
            if ~isfield(app.pointlikeProperties,'movementTime')
                app.SimulateButton.Enable = 'Off';
            end
        elseif strcmp(app.simulationType,'stretch')
            app.SolverDropDown.Value = 'RK2';
            app.SimulateButton.Enable = 'On';
        elseif strcmp(app.simulationType,'opto')
            app.SolverDropDown.Value = 'RK4';
            app.SimulateButton.Enable = 'On';
        end
        
        
        if strcmp(app.modelCase,'loaded') && strcmp(app.simulationType,'pointlike') && strcmp(app.import.simulationType,'pointlike')
            if exist([app.import.folderName '/pointlike/'],'file') == 7
                app.UseimportedmovementdataCheckBox.Value = 1;
                app.UseimportedmovementdataCheckBox.Enable = 'On';
                app.LoadmovementButton.Enable = 'Off';
                app.SelectcentercellCheckBox.Enable = 'Off';
                app.SelectcellButton.Enable = 'Off';
                app.SelectedcellEditField.Enable = 'Off';
                app.CentercellsCheckBox.Enable = 'Off';
                pointlikeData = import_settings([app.import.folderName '/pointlike/pointlike_data.csv']);
                app.SelectedcellEditField.Value = pointlikeData.cell;
            end
            
        else
            app.UseimportedmovementdataCheckBox.Value = 0;
            app.UseimportedmovementdataCheckBox.Enable = 'Off';
            app.LoadmovementButton.Enable = 'On';
            app.SelectcentercellCheckBox.Enable = 'On';
            app.SelectcellButton.Enable = 'On';
            app.SelectedcellEditField.Enable = 'On';
            app.CentercellsCheckBox.Enable = 'On';
            if isfield(app.pointlikeProperties, 'cell')
                app.SelectedcellEditField.Value = app.pointlikeProperties.cell;
            else
                app.SelectedcellEditField.Value = 1;
            end
        end
        
        if app.firstStartup == 1
            app.firstStartup = 0;
        end
        
    case 'plotAndAnalyze'
        if app.firstStartupPA
            sliderValue = log((app.importPlottingOptions.windowSize/1e-6-30)/10)/log(77);
            if ~isreal(sliderValue)
                app.WindowsizeSlider_2.Value = 0;
            elseif sliderValue > 1
                app.WindowsizeSlider_2.Value = 1;
            else
                app.WindowsizeSlider_2.Value = sliderValue;
            end
            app.WindowsizeEditField_2.Value = round(app.importPlottingOptions.windowSize*1e6);
            app.PlottingtimestepEditField_2.Value = app.importPlottingOptions.plotDtMultiplier;
        end
        
     
        app.TimepointDropDown.Items = {};
        
        d.spar = app.plotImport(app.selectedFile).scaledParameters;
        numTemp = num2cell(1:app.plotImport(app.selectedFile).nTimePoints);
        timeStrings = cellfun(@(i) separate_times(d,convert_import_time(app,i,'numberToTime')),numTemp,'UniformOutput',false);
        app.TimepointDropDown.Items = timeStrings;
        app.TimepointDropDown.Value = app.TimepointDropDown.Items(end);
        
        write_area_perimeter(app);
        
        
        if app.importPlottingOptions.cellStyle == 3
            
            if exist([app.plotImport(app.selectedFile).folderName '/junctions/'],'dir') ~= 7
                app.importPlottingOptions.cellStyle = 1;
            end
        end
        
        app.ScalebarsettingsMenu.Enable = 'On';
        if app.firstStartupPA
            set_cell_plotting_style(app,app.importPlottingOptions.cellStyle);
            set_substrate_plotting_style(app,app.importPlottingOptions.substrateStyle);
        end
        cellNumbers = num2cell(app.plotImport(app.selectedFile).cellNumbers);
        for i = 1:length(cellNumbers)
            cellNumbers{i} = num2str(cellNumbers{i});
        end
        
        app.importPlottingOptions = check_plotting_options(app);
        
        change_import_parameter_panel(app);
        
        if (exist([app.plotImport(app.selectedFile).folderName '/substrate/'],'dir') == 7 && exist([app.plotImport(app.selectedFile).folderName '/substrate_auxiliary/'],'dir') == 7) && (strcmp(app.plotImport(app.selectedFile).simulationType,'pointlike') || strcmp(app.plotImport(app.selectedFile).simulationType,'stretch') || strcmp(app.plotImport(app.selectedFile).simulationType,'opto'))
            set_object_properties_function(app,{'SubstratestyleDropDown_2','SubstratestyleDropDown_2Label'},'Enable', {'On'});
        end
        
        
        app.StartDropDown.Items = {};
        app.EndDropDown.Items = {};
        
        app.ChoosecellstohighlightListBox.Items = cellNumbers;
        app.ShowcelllineageListBox.Items = cellNumbers;
        app.CellsListBox.Items = cellNumbers;
        
        set_import_cells_forces(app);
        
        d.spar = app.plotImport(app.selectedFile).scaledParameters;
        numTemp = num2cell(1:app.plotImport(app.selectedFile).nTimePoints);
        timeStrings = cellfun(@(i) separate_times(d,convert_import_time(app,i,'numberToTime')),numTemp,'UniformOutput',false);
        app.StartDropDown.Items = timeStrings;
        app.EndDropDown.Items = timeStrings;
        app.StartDropDown.Value = app.StartDropDown.Items(1);
        app.EndDropDown.Value = app.EndDropDown.Items(end);
        %         end
        app.firstStartupPA = 0;
        
        app.ClearButton.Enable = 'On';
        
        set_cell_descriptor_limits(app);
               
        
end