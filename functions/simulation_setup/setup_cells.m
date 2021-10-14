function d = setup_cells(app,d)
% SETUP_CELLS Create the cells for the simulation
%   The function either creates new cells or imports cells from previous
%   simulation for the simulation. 
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021


switch app.modelCase
    
    % new simulation
    case 'new'
        
        % initialize the cell structure
        d.cells = initialize_cells_struct;
        
        switch app.InitialstateButtongroup.SelectedObject.Text
            
            % initial state is a single cell
            case 'Single cell'
                
                % create the single cell
                d = create_cell(d,[0;0]);
                
            % initial state is multiple cells
            case 'Place multiple cells'
                
                % create the multiple cells
                for i = 1:size(app.cellCenters,1)
                    d = create_cell(d,app.cellCenters(i,:));
                end
        end
        
    % imported simulation
    case 'import'
        
        % import cell data
        d.cells = import_cells(app,d,'simulation');
        
        % remove cells
        d = remove_cells_gui(app, d,'simulation');

        % get additional junction data
        d.cells = get_junction_data(d.cells);
        
        % rescale imported parameters
        d = rescale_imported_parameters(app,d);
        
        % edit division properties
        d = edit_division_properties(d);
end

% get edge vertices for simulations with substrate
d = get_edge_vertices(d);

end
