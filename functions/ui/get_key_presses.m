function [plotAgain,varargout] = get_key_presses(app,pl)

plotAgain = 0;

varargout = {0};

hManager = uigetmodemanager(pl.figureHandle);
if isempty(hManager.CurrentMode)
    
    try
        if double(get(gcf,'CurrentCharacter')) == 13
            varargout = {1};
            return
        elseif double(get(gcf,'CurrentCharacter')) == 29
            switch app.appTask
                case 'simulate'
                    if app.import.currentTimePoint < app.import.nTimePoints
                        app.import.currentTimePoint = app.import.currentTimePoint + 1;
%                         app.TimetoloadEditField.Value = convert_import_time(app,app.import.currentTimePoint,'numberToTime');
                        app.TimetoloadDropDown.Value = app.TimetoloadDropDown.Items(app.import.currentTimePoint);
                        app.import.originalCellNumbers = get_original_cell_numbers_function(app);
                        app.import.nCells = length(app.import.originalCellNumbers);
                        plotAgain = 1;
                    end
                case 'plotAndAnalyze'
                    if app.plotImport(app.selectedFile).currentTimePoint + app.importPlottingOptions.plotDtMultiplier <= app.plotImport(app.selectedFile).nTimePoints
                        app.plotImport(app.selectedFile).currentTimePoint = app.plotImport(app.selectedFile).currentTimePoint + app.importPlottingOptions.plotDtMultiplier;
                        app.TimepointDropDown.Value = app.TimepointDropDown.Items(app.plotImport(app.selectedFile).currentTimePoint);
                        write_area_perimeter(app);
                        plotAgain = 1;
                    end
            end
        elseif double(get(gcf,'CurrentCharacter')) == 28
            
            switch app.appTask
                case 'simulate'
                    if app.import.currentTimePoint > 1
                        app.import.currentTimePoint = app.import.currentTimePoint - 1;
%                         app.TimetoloadEditField.Value = convert_import_time(app,app.import.currentTimePoint,'numberToTime');
                        app.TimetoloadDropDown.Value = app.TimetoloadDropDown.Items(app.import.currentTimePoint);
                        app.import.originalCellNumbers = get_original_cell_numbers_function(app);
                        app.import.nCells = length(app.import.originalCellNumbers);
                        plotAgain = 1;
                    end
                case 'plotAndAnalyze'
                    if app.plotImport(app.selectedFile).currentTimePoint - app.importPlottingOptions.plotDtMultiplier >= 1
                        app.plotImport(app.selectedFile).currentTimePoint = app.plotImport(app.selectedFile).currentTimePoint - app.importPlottingOptions.plotDtMultiplier;
                        app.TimepointDropDown.Value = app.TimepointDropDown.Items(app.plotImport(app.selectedFile).currentTimePoint);
                        write_area_perimeter(app);
                        plotAgain = 1;
                    end
            end
        end
    catch
    end
end

