function d = remove_cell_and_links(d,cellToRemove,varargin)
% REMOVE_CELL_AND_LINKS Removes a cell and its links with other cells or
% the substrate
%   The function removes the prefedined cell. The function takes in the
%   main simulation data structure d and the index of the cell to be
%   removed. Also, an additional variable is used to indicate when the
%   function is called during simulation. The function removes the focal
%   adhesions if the substrate is included in the simulation, and the cell
%   from the optogenetics data if required. Finally, the function will
%   remove the cell itself from the main data structure and edit the
%   junctions of the neighboring cells. The function outputs the main data
%   structure d.
%   by Aapo Tervonen, 2021

% is the function is called during simulation and that substrate is
% included
if numel(varargin) > 0 && varargin{1} == 1 && d.simset.substrateIncluded
    
    % find the vertices with focal adhesions
    numberOfConnected = nnz(d.cells(cellToRemove).substrate.connected);
    
    % if there are connected vertices
    if numel(numberOfConnected) > 0
        
        % go through the connected vertices
        for i = 1:numberOfConnected
            
            % get substrate points and the column indices in the
            % substrateMatrix
            removedAdhesions = d.cells(cellToRemove).substrate.points(i,:);
            removedLinkCols = d.cells(cellToRemove).substrate.linkCols(i,:);
            
            % for each removed ahdesion
            for i2 = 1:3
                
                % go through the cells
                for k2 = 1:length(d.cells)
                    
                    % find if any of that cells vertices is linked with
                    % the same point
                    sharedPoints = d.cells(k2).substrate.points == removedAdhesions(i2);
                    if any(sharedPoints(:))
                        % checks if the shared points have higher index
                        % in the substrateMatrix than the removed
                        % vertice had
                        sharedAndHigher = and(sharedPoints,d.cells(k2).substrate.linkCols > removedLinkCols(i2));
                        
                        % update he linkCols and substrateMatrix
                        % indices
                        d.cells(k2).substrate.linkCols(sharedAndHigher) = d.cells(k2).substrate.linkCols(sharedAndHigher) - 1;
                        d.cells(k2).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k2).substrate.points(:),d.cells(k2).substrate.linkCols(:));
                    end
                end
            end
            
            % reduce the adhesion number for the associated substrate points by
            % one
            d.sub.adhesionNumbers(d.cells(cellToRemove).substrate.points(i,:)) = d.sub.adhesionNumbers(d.cells(cellToRemove).substrate.points(i,:)) - 1;
        end
    end
end

% remove the cell
d.cells(cellToRemove) = [];

% go through the cells
for k = 1:length(d.cells)
    
    % find indices of the vertices that have junctions with the removed
    % cell
    linksWithCell2Remove = d.cells(k).junctions.cells(:) == cellToRemove;
    
    % sets those junctions to zero
    d.cells(k).junctions.cells(linksWithCell2Remove) = 0;
    d.cells(k).junctions.vertices(linksWithCell2Remove) = 0;
    
    % reduces the junction cell indices for the cells that have higher
    % index than the removed cell
    d.cells(k).junctions.cells(d.cells(k).junctions.cells > cellToRemove) = d.cells(k).junctions.cells(d.cells(k).junctions.cells > cellToRemove) - 1;
    
    % recalculates the vertex states
    d.cells(k).vertexStates = sum(d.cells(k).junctions.cells > 0,2);
    
    % finds vertices whose first junction was removed
    switchJunctions = and((d.cells(k).vertexStates == 1),(d.cells(k).junctions.cells(:,1) == 0));
    
    % for those vertices, moves the junction from the second junction to
    % the first
    d.cells(k).junctions.cells(switchJunctions,1) = d.cells(k).junctions.cells(switchJunctions,2);
    d.cells(k).junctions.vertices(switchJunctions,1) = d.cells(k).junctions.vertices(switchJunctions,2);
    d.cells(k).junctions.cells(switchJunctions,2) = 0;
    d.cells(k).junctions.cells(switchJunctions,2) = 0;
    
    % reset the vertex states of the dividing cell division vertices to -1
    % (might be unnecessary)
    if d.cells(k).division.state == 2
        d.cells(k).vertexStates(d.cells(k).division.vertices(1)) = -1;
        d.cells(k).vertexStates(d.cells(k).division.vertices(2)) = -1;
    end
end

end
