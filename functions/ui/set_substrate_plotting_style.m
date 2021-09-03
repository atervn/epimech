function set_substrate_plotting_style(app,styleNumber)

switch app.appTask
    case 'simulate'
        switch styleNumber
            case 1
                app.SubstratestyleDropDown.Value = 'Simple';
            case 2
                app.SubstratestyleDropDown.Value = 'With lines';
            case 0
                app.SubstratestyleDropDown.Value = 'No substrate';
        end
    case 'plotAndAnalyze'
        switch styleNumber
            case 1
                app.SubstratestyleDropDown_2.Value = 'Simple';
            case 2
                app.SubstratestyleDropDown_2.Value = 'With lines';
            case 0
                app.SubstratestyleDropDown_2.Value = 'No substrate';
        end
end