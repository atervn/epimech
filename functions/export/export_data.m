function export_data(d,time)
% EXPORT_DATA Export data during the simulation
%   The function writes the requested simulation data to file at predefined
%   time points during the simulation.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   by Aapo Tervonen, 2021

% check if current time step is one of the exporting time steps
if d.ex.export && mod(time+1e-10,d.ex.exportDt) <= 1e-9
    
    % save the number of cells to a temporary export structure
    export.nCells = length(d.cells);
    
    % get the number of vertices and number of cells in the lineage for
    % each cell and save it to the temporary export structure
    export.nVertices = arrayfun(@(x) x.nVertices,d.cells);
    export.nLineage = arrayfun(@(x) length(x.lineage),d.cells);
    
    % get the maximum number of vertices and lineage members
    export.nVerticesMax = max(export.nVertices);
    export.nLineageMax = max(export.nLineage);
    
    % initialize matrices that are used to collect the cell data that is
    % exported
    exportMatrices = initialize_export_matrices(d, export);
    
    % input the data to be exported to the matrices
    exportMatrices = get_export_data(d,exportMatrices,export);
    
    % write the export matrices to files
    write_export_data(d, exportMatrices, time); 
end

end

