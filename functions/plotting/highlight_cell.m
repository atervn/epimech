function highlight_cell(d,k,varargin)

if d.pl.highlightType == 1
    if any(d.pl.highlightedCells == k)
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.4 0.4 0.8], 'linewidth', 2, 'edgecolor', [0.1 0.1 0.4]);
    end
elseif d.pl.highlightType == 2
    colors = [0.8 0.4 0.4; 0.4 0.4 0.8];
    edgeColors = [0.4 0.1 0.1; 0.1 0.1 0.4];
    if length(d.pl.highlightedCells) == 1
        if any(d.cells(k).lineage == d.pl.highlightedCells)
            colorTemp = colors(1,:);
            edgeColorTemp = edgeColors(1,:);
            fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,colorTemp, 'linewidth', 3, 'edgecolor', edgeColorTemp)
        end
    else
        for k2 = length(d.pl.highlightedCells):-1:1
            if any(d.cells(k).lineage == d.pl.highlightedCells(k2))
                colorTemp = colors(1,:) + (k2-1)/(length(d.pl.highlightedCells)-1).*(colors(2,:)-colors(1,:));
                edgeColorTemp = edgeColors(1,:) + k2/length(d.pl.highlightedCells).*(edgeColors(2,:)-edgeColors(1,:));
                fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,colorTemp, 'linewidth', 3, 'edgecolor', edgeColorTemp)
                break;
            end
        end
    end
elseif d.pl.highlightType == 3
    if any(d.pl.highlightedCells == k)
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.4 0.4 0.8], 'linewidth', 2, 'edgecolor', [0.1 0.1 0.4]);
    elseif d.pl.plotType == 3 && any(d.pl.outsideShape == k)
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.5 0.9 0.9], 'linewidth', 2, 'edgecolor', [0.2 0.5 0.5]);
    end
    
    if numel(varargin) > 0 && numel(varargin{1}) == 1
        if k ~= varargin{1}
            if d.cells(varargin{1}).cellState == 0
                fill(d.pl.axesHandle,d.cells(varargin{1}).verticesX,d.cells(varargin{1}).verticesY,[0.8 0.8 0.8], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
            else
                fill(d.pl.axesHandle,d.cells(varargin{1}).verticesX,d.cells(varargin{1}).verticesY,[0.7 0.7 0.7], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
            end
        end
    end
elseif d.pl.highlightType == 4
    if any(d.pl.highlightedCells.cells == k)
        vertices = d.pl.highlightedCells.vertices{d.pl.highlightedCells.cells == k};
        
        plot(d.pl.axesHandle,d.cells(k).verticesX(vertices),d.cells(k).verticesY(vertices),'o','MarkerFaceColor',[0.4 0.4 0.8],'MarkerEdgeColor',[0.4 0.4 0.8]);
    end
    if numel(varargin) > 0 && numel(varargin{1}) == 1
        vertices = d.pl.highlightedCells.vertices{d.pl.highlightedCells.cells == varargin{1}};
        plot(d.pl.axesHandle,d.cells(varargin{1}).verticesX(vertices),d.cells(varargin{1}).verticesY(vertices),'o','MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.4 0.4 0.4]);
        
        idx = find(d.pl.highlightedCells.cells == varargin{1});
        d.pl.highlightedCells.cells(idx) = [];
        d.pl.highlightedCells.vertices(idx) = [];
    end
end

end