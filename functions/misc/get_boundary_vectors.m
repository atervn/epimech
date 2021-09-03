function cells = get_boundary_vectors(cells)

for k = 1:length(cells)
    cells(k).leftVectorsX = circshift(cells(k).verticesX,-1,1) - cells(k).verticesX;
    cells(k).leftVectorsY = circshift(cells(k).verticesY,-1,1) - cells(k).verticesY;
    cells(k).rightVectorsX = circshift(cells(k).leftVectorsX,1,1);
    cells(k).rightVectorsY = circshift(cells(k).leftVectorsY,1,1);
end

end