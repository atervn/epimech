function cells = get_vertex_angles(cells)

for k = 1:length(cells)
    cells(k).vectorAngles = get_angles(-cells(k).rightVectorsX, -cells(k).rightVectorsY, cells(k).leftVectorsX, cells(k).leftVectorsY, cells(k).leftLengths, cells(k).rightLengths);
    cells(k).outsideAngles = cells(k).vectorAngles; 
    cells(k).outsideAngles(cells(k).convexity) = 2*pi - cells(k).outsideAngles(cells(k).convexity);
end

end