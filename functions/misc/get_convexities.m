function cells = get_convexities(cells)

for k = 1:length(cells)
    cells(k).convexity = cells(k).rightVectorsX.*cells(k).leftVectorsY - cells(k).leftVectorsX.*cells(k).rightVectorsY > 0;
end

end