function apply_setting_changes(app)

switch app.tableData
    case 'cellParameters'
        app.cellParameters = table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:));
        app.specificCellParameters = table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:));
    case 'systemParameters'
        app.systemParameters = table_to_struct(app.UITable.Data);
        app.SimulationtimeEditField.Value = scale_time_units(app, 'SimulationtimeDropDown', app.systemParameters.simulationTime, 'field');
        app.TimestepEditField.Value = scale_time_units(app, 'SimulationtimestepDropDown', app.systemParameters.maximumTimeStep, 'field');
        if strcmp(app.simulationType,'growth')
            app.DivideuntilEditField.Value = scale_time_units(app, 'DivideuntilDropDown', app.systemParameters.stopDivisionTime, 'field');
        end
    case 'plottingOptions'
        switch app.appTask
            case 'simulate'
                app.plottingOptions = table_to_struct(app.UITable.Data);
                app.PlottingstepEditField.Value = app.plottingOptions.plotDtMultiplier;
                sliderValue = log((app.plottingOptions.windowSize/1e-6-30)/10)/log(77);
                if ~isreal(sliderValue) || sliderValue <= 0
                    app.WindowsizeSlider.Value = 0;
                elseif sliderValue > 1
                    app.WindowsizeSlider.Value = 1;
                else
                    app.WindowsizeSlider.Value = sliderValue;
                end
                app.WindowsizeEditField.Value = round(app.plottingOptions.windowSize*1e6);
                set_cell_plotting_style(app,app.plottingOptions.cellStyle);
                set_substrate_plotting_style(app,app.plottingOptions.substrateStyle);
                
            case 'plotAndAnalyze'
                app.importPlottingOptions = table_to_struct(app.UITable.Data);
                app.PlottingstepEditField_2.Value = app.importPlottingOptions.plotDtMultiplier;
                sliderValue = log((app.importPlottingOptions.windowSize/1e-6-30)/10)/log(77);
                if ~isreal(sliderValue) || sliderValue <= 0
                    app.WindowsizeSlider_2.Value = 0;
                elseif sliderValue > 1
                    app.WindowsizeSlider_2.Value = 1;
                else
                    app.WindowsizeSlider.Value = sliderValue;
                end
                app.WindowsizeEditField_2.Value = round(app.importPlottingOptions.windowSize*1e6);
                set_cell_plotting_style(app,app.importPlottingOptions.cellStyle);
                set_substrate_plotting_style(app,app.importPlottingOptions.substrateStyle)
                
        end
    case 'customExportOptions'
        app.customExportOptions = table_to_struct(app.UITable.Data);
        app.ExportstepEditField.Value = app.customExportOptions.exportDtMultiplier;
    case 'substrateParameters'
        app.substrateParameters = table_to_struct(app.UITable.Data);
        app.YoungsmodulusEditField.Value = app.substrateParameters.youngsModulus/1000;
    case 'fFAInfo'
        app.fFAInfo = cell2mat(app.UITable.Data);
end

end