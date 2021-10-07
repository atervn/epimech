function highlight_cell(d,k,varargin)
% HIGHLIGHT_CELL Highlight the current cell
% The function highlights the current cell with a color depending on the
% plotting situation and if the current cell is to be plotted
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%       varargin: extra option for removing highlighting
%   by Aapo Tervonen, 2021

% normal heighlight (can be used to follow the single cells during
% simulation animation)
if d.pl.highlightType == 1
    
    % if the cell is to be highlight, plot it with the highlight color)
    if any(d.pl.highlightedCells == k)
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.4 0.4 0.8], 'linewidth', 2, 'edgecolor', [0.1 0.1 0.4]);
    end
    
% lineage based highlight
elseif d.pl.highlightType == 2
    
    % define two face and edge colors
    colors = [0.8 0.4 0.4; 0.4 0.4 0.8];
    edgeColors = [0.4 0.1 0.1; 0.1 0.1 0.4];
    
    % if only one cell is selected for the lineage highlight
    if length(d.pl.highlightedCells) == 1
        
        % check if the current cell has the selected cell in its lineage
        if any(d.cells(k).lineage == d.pl.highlightedCells)
            
            % get the highlight color
            colorTemp = colors(1,:);
            edgeColorTemp = edgeColors(1,:);
            
            % highlight the cell
            fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,colorTemp, 'linewidth', 3, 'edgecolor', edgeColorTemp)
        end
        
    % if more than one
    else
        
        % go through the selected cells (inversely, so the newest of the
        % selected lineage cell is used to select to color
        for k2 = length(d.pl.highlightedCells):-1:1
            
            % check if the current cell has the selected cell in its lineage
            if any(d.cells(k).lineage == d.pl.highlightedCells(k2))
                
                % intrapolate the color based on the number of selected
                % cells so that each have their own colors between the two
                % defined colors
                colorTemp = colors(1,:) + (k2-1)/(length(d.pl.highlightedCells)-1).*(colors(2,:)-colors(1,:));
                edgeColorTemp = edgeColors(1,:) + k2/length(d.pl.highlightedCells).*(edgeColors(2,:)-edgeColors(1,:));
                
                % highlight the cell
                fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,colorTemp, 'linewidth', 3, 'edgecolor', edgeColorTemp)
                
                % break to only highlight based on the newest lineage cell
                break;
            end
        end
    end
    
% highlight cells during selection
elseif d.pl.highlightType == 3
    
    % if the current cell is the selected cell
    if any(d.pl.highlightedCells == k)
        
        % highlight the cell
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.4 0.4 0.8], 'linewidth', 2, 'edgecolor', [0.1 0.1 0.4]);
    end
    
    % if there is an optional input of 1, remove the highlight from already
    % highlight cell
    if numel(varargin) > 0 && varargin{1} == 1
        
        % for edge cells, plot will lighter gray
        if d.cells(varargin{1}).cellState == 0
            fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.8 0.8 0.8], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
        
        % for nonedge cells, plot will darker gray
        else
            fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.7 0.7 0.7], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
        end
    end
    
% highlighting for optogenetic region creation
elseif d.pl.highlightType == 4
    
    % if the current cell is within the activated region
    if any(d.pl.highlightedCells.cells == k)
        
        % get the vertices that are activated
        vertices = d.pl.highlightedCells.vertices{d.pl.highlightedCells.cells == k};
        
        % highlight the activated vertices
        plot(d.pl.axesHandle,d.cells(k).verticesX(vertices),d.cells(k).verticesY(vertices),'o','MarkerFaceColor',[0.4 0.4 0.8],'MarkerEdgeColor',[0.4 0.4 0.8]);
    end
    
% highlight when removing cell with shape
elseif d.pl.highlightType == 5
    
    % if the current cell is outside the shape
    if any(d.pl.outsideShape == k)
        
        % highlight the cell
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.5 0.9 0.9], 'linewidth', 2, 'edgecolor', [0.2 0.5 0.5]);
    end
end

end