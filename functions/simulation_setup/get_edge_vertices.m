function d = get_edge_vertices(d)

for k = 1:length(d.cells)
    if d.cells(k).cellState == 0
        
        d.cells(k).edgeVertices = [];
        
        vertexStates = [d.cells(k).vertexStates ; d.cells(k).vertexStates];
        
        idx = [1:d.cells(k).nVertices 1:d.cells(k).nVertices]';
        
        transitions = diff([0 ; vertexStates == 0 ; 0]);
        
        runstarts = find(transitions == 1);
        runends = find(transitions == -1);
        runlengths = runends - runstarts;
        
        strIdx = idx(runstarts);
        endIdx = idx(runends-1);
        
        longRuns = find(runlengths >= 4);
        
        for i = longRuns'
            if strIdx(i) == 1
                sti = 1;
            else
                sti = strIdx(i) - 1;
            end
            if endIdx(i) == d.cells(k).nVertices
                eni = endIdx(i);
            else
                eni = endIdx(i) + 1;
            end

            if sti > eni
                d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; (sti:d.cells(k).nVertices)' ; (1:eni)'];
            else
                d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; (sti:eni)'];
            end
        end
        
        d.cells(k).edgeVertices = unique(d.cells(k).edgeVertices);
        
        d.cells(k).edgeInitialX = d.cells(k).verticesX(d.cells(k).edgeVertices);
        d.cells(k).edgeInitialY = d.cells(k).verticesY(d.cells(k).edgeVertices);
        
    end
end

end