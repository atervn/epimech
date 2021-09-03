function plot_junctions(d)

if isfield(d.cells, 'verticesX') && d.pl.junctions
    
    coordX = [];
    coordY = [];
    plottedJunctions = cell(1,length(d.cells));
    for k = 1:length(d.cells)
        plottedJunctions{k} = d.cells(k).junctions.cells > 0;
    end
    
    for k = 1:length(d.cells)
        for j = d.cells(k).junctions.linkedIdx1'
            % only plot junctions that have not been plotted
            if plottedJunctions{k}(j,1)
                cellid = d.cells(k).junctions.cells(j,1);
                vertexid = d.cells(k).junctions.vertices(j,1);
                coordX = [coordX [d.cells(k).verticesX(j) ; d.cells(cellid).verticesX(vertexid)]]; %#ok<AGROW>
                coordY = [coordY [d.cells(k).verticesY(j) ; d.cells(cellid).verticesY(vertexid)]]; %#ok<AGROW>
                plottedJunctions{k}(j,1) = false;
                whichJunction = d.cells(cellid).junctions.cells(vertexid,:) == k;
                plottedJunctions{cellid}(vertexid,whichJunction) = false;
            end
        end
        for j = d.cells(k).junctions.linkedIdx2'
            % only plot junctions that have not been plotted
            if plottedJunctions{k}(j,2)
                cellid = d.cells(k).junctions.cells(j,2);
                vertexid = d.cells(k).junctions.vertices(j,2);
                coordX = [coordX [d.cells(k).verticesX(j) ; d.cells(cellid).verticesX(vertexid)]]; %#ok<AGROW>
                coordY = [coordY [d.cells(k).verticesY(j) ; d.cells(cellid).verticesY(vertexid)]]; %#ok<AGROW>
                plottedJunctions{k}(j,2) = false;
                whichJunction = d.cells(cellid).junctions.cells(vertexid,:) == k;
                plottedJunctions{cellid}(vertexid,whichJunction) = false;
            end
        end
    end
    plot(d.pl.axesHandle,coordX,coordY, '-k', 'linewidth', 1.5);
end



end