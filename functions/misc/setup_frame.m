function d = setup_frame(d)

if d.simset.simulationType == 4
    maxPointX = zeros(1,length(d.cells));
    minPointX = maxPointX;
    maxPointY = maxPointX;
    minPointY = maxPointX;
    for k = 1:length(d.cells)
        maxPointX(k) = max(d.cells(k).verticesX);
        minPointX(k) = min(d.cells(k).verticesX);
        maxPointY(k) = max(d.cells(k).verticesY);
        minPointY(k) = min(d.cells(k).verticesY);
    end
    
    maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY]))) + d.spar.rCell;
    
    d.simset.frame.cornersX = [-maxSize maxSize maxSize -maxSize]';
    d.simset.frame.cornersY = [-maxSize -maxSize maxSize maxSize]';
    d.cells(end+1) = create_edge_cell(d);
    
end

end