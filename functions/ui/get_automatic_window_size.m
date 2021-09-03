function windowSize = get_automatic_window_size(cells,spar)

maxPointX = zeros(1,length(cells));
minPointX = maxPointX;
maxPointY = maxPointX;
minPointY = maxPointX;

for k = 1:length(cells)
    maxPointX(k) = max(cells(k).verticesX);
    minPointX(k) = min(cells(k).verticesX);
    maxPointY(k) = max(cells(k).verticesY);
    minPointY(k) = min(cells(k).verticesY);
end

maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY])));

windowSize = maxSize + spar.rCell;