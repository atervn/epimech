function export_data(d,time)

if d.ex.export && mod(time+1e-10,d.ex.exportDt) <= 1e-9
    
    exTemp.nCells = length(d.cells);
    
    exTemp.nVertices = arrayfun(@(x) x.nVertices,d.cells);
    exTemp.nLineage = arrayfun(@(x) length(x.lineage),d.cells);
    
    exTemp.nVerticesMax = max(exTemp.nVertices);
    exTemp.nLineageMax = max(exTemp.nLineage);
    
    exMat = initialize_export_matrices(d, exTemp);
    exMat = get_export_data(d,exMat,exTemp);
    write_export_data(d, exMat, time);
    
end

