function cells = get_boundary_lengths(cells,varargin)

    if numel(varargin) > 0
        nCells = varargin{1};
    else
        nCells = length(cells);
    end

    for k = 1:nCells
        cells(k).leftLengths = sqrt(cells(k).leftVectorsX.^2 + cells(k).leftVectorsY.^2);
        cells(k).rightLengths = circshift(cells(k).leftLengths,1,1);
    end        
end