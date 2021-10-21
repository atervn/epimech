function set_substrate_plotting_style(app,styleNumber)

switch app.appTask
    case 'simulate'
        switch styleNumber
            case 1
                app.SubstratestyleDropDown.Value = 'Simple';
            case 2
                if strcmp(app.simulationType,'stretch')
                    app.SubstratestyleDropDown.Value = 'Simple';
                    app.plottingOptions.substrateStyle = 1;
                else
                    app.SubstratestyleDropDown.Value = 'With lines';
                end
            case 0
                app.SubstratestyleDropDown.Value = 'No substrate';
        end
    case 'plotAndAnalyze'
        switch styleNumber
            case 1
                app.SubstratestyleDropDown_2.Value = 'Simple';
            case 2
                if strcmp(app.plotImport(app.selectedFile).simulationType,'stretch')
                    app.SubstratestyleDropDown_2.Value = 'Simple';
                    app.importPlottingOptions.substrateStyle = 1;
                else
                    app.SubstratestyleDropDown.Value = 'With lines';
                end
            case 0
                app.SubstratestyleDropDown_2.Value = 'No substrate';
        end
end