function d = initialize_cells(d,app)

d.cells = initialize_cells_struct;

switch app.modelCase
    case 'new'
        d.cells = initialize_cells_struct;
        switch app.InitialstateButtongroup.SelectedObject.Text
            case 'Single cell'
                d = single_cell_initialization(d,[0;0]);
            case 'Place multiple cells'
                for i = 1:size(app.cellCenters,1)
                    d = single_cell_initialization(d,app.cellCenters(i,:));
                end
        end
    case 'loaded'
        
        d.spar.normArea = app.import.scaledParameters.normArea;
        d.spar.membraneLength = app.import.scaledParameters.membraneLength;
        d.spar.fArea = app.import.scaledParameters.fArea*app.systemParameters.scalingTime/app.systemParameters.eta/app.import.scaledParameters.scalingTime*app.import.systemParameters.eta;
  
        d.cells = import_cells(app,'simulation');
        d.cells = remove_cells_gui(app, d.cells,'simulation');
        d.cells = set_division_times(d.cells,d.simset,d.spar,length(d.cells));
end