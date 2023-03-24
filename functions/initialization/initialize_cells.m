function d = initialize_cells(app,d)

d.cells = initialize_cells_struct;

switch app.modelCase
    case 'new'
        d.cells = initialize_cells_struct;
        switch app.InitialstateButtongroup.SelectedObject.Text
            case 'Single cell'
                d = create_cell(d,[0;0]);
            case 'Place multiple cells'
                for i = 1:size(app.cellCenters,1)
                    d = create_cell(d,app.cellCenters(i,:),'simple_plot');
                end
        end
    case 'import'
        
        d.spar.normArea = app.import.scaledParameters.normArea;
        d.spar.membraneLength = app.import.scaledParameters.membraneLength;
        d.spar.fArea = app.import.scaledParameters.fArea*app.systemParameters.scalingTime/app.systemParameters.eta/app.import.scaledParameters.scalingTime*app.import.systemParameters.eta;
  
        d.cells = import_cells(app,d,'simulation');
        d = remove_cells_gui(app, d,'simulation');
        d = edit_division_properties(d);
end