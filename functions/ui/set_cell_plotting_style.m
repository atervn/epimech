function set_cell_plotting_style(app,styleNumber)

switch app.appTask
    case 'simulate'
        switch styleNumber
            case 1
                app.CellstyleDropDown.Value = 'Grey filled';
            case 2
                app.CellstyleDropDown.Value = 'Red outline';
            case 3
                app.CellstyleDropDown.Value = 'Number of neighbors';
            case 4
                app.CellstyleDropDown.Value = 'Black';
            case 5
                app.CellstyleDropDown.Value = 'Lines';
            case 6
                app.CellstyleDropDown.Value = 'No cells';
        end
    case 'plotAndAnalyze'
        switch styleNumber
            case 1
                app.CellstyleDropDown_2.Value = 'Grey filled';
            case 2
                app.CellstyleDropDown_2.Value = 'Red outline';
            case 3
                app.CellstyleDropDown_2.Value = 'Number of neighbors';
            case 4
                app.CellstyleDropDown_2.Value = 'Black';
            case 5
                app.CellstyleDropDown_2.Value = 'Lines';
            case 6
                app.CellstyleDropDown_2.Value = 'No cells';
        end
end