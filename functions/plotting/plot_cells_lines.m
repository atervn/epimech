function plot_cells_lines(d,k)

neighbors = unique(d.cells(k).junctions.cells(:));
neighbors(neighbors == 0) = [];
centerX = mean(d.cells(k).verticesX);
centerY = mean(d.cells(k).verticesY);
plot(d.pl.axesHandle,centerX,centerY,'-ok','MarkerSize',7,'MarkerFaceColor','k')

if numel(neighbors) > 0
    for k2 = neighbors'
        nCenterX = mean(d.cells(k2).verticesX);
        nCenterY = mean(d.cells(k2).verticesY);
        
        plot(d.pl.axesHandle,[centerX nCenterX],[centerY nCenterY],'-ok','MarkerSize',7,'MarkerFaceColor','k')
    end
end