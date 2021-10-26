function d = change_activation(d, time)
% CHANGE_ACTIVATION Modify the state of the optogenetic activation
%   The function finds the vertices that are within the optogenetic
%   activation regions and assigns the appropriate increases in the
%   cortical multipliers for the cortical links associated with these
%   vertices.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% variable to indicate the activation has been switched off
switchOff = 0;

% check if time has passed the next time point where activation state is 
% changed
if d.simset.opto.times(d.simset.opto.currentTime+1) <= time
    
    % if it has passed the time point, update the current time point data
    d.simset.opto.currentTime = d.simset.opto.currentTime + 1;
    
    % check if the optogenetic activation has shut off (there is no
    % activation at current time, but there was one earlier.
    if d.simset.opto.currentTime > 1 && d.simset.opto.levels(d.simset.opto.currentTime) == 0 && d.simset.opto.levels(d.simset.opto.currentTime-1) > 0
        
        % activation has been shifted off
        switchOff = 1;
    end
end

% if the activation level following the latest change in the activation is
% nonzero
if d.simset.opto.levels(d.simset.opto.currentTime) > 0
    
    % save the activated cells and vertices in the last time step
    oldOpto = d.simset.opto;
    
    % find the activated vertice
    d = find_activated_vertices(d);
    
    % find cells that preivously were in the activation region but not
    % anymore
    notActivatedCells = setdiff(oldOpto.cells,d.simset.opto.cells);
    
    % if they exist
    if ~isempty(notActivatedCells)
        
        % go through these cells
        for k = notActivatedCells
            
            % set the vertex cortical multipliers to one (default)
            d.cells(k).cortex.vertexMultipliers = ones(d.cells(k).nVertices,1);
        end
    end
    
    % assign activation for the vertices
    d = assign_activations(d);

% if the activation has switched off
elseif switchOff
    
    % go through the activated cells and remove their activations
    for k = d.simset.opto.cells
        d.cells(k).cortex.vertexMultipliers = ones(d.cells(k).nVertices,1);
        d.simset.opto.cells = [];
        d.simset.opto.vertices = {};
    end
end

end

function d = find_activated_vertices(d)
% FIND_ACTIVATED_VERTICES Find the vertices that are within the activation
% regions
%   The function finds the vertices that are within the defined
%   optogenetic activation regions when the activation is active.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% number of cells
nCells = length(d.cells);

% if there are no cells activated currently
if isempty(d.simset.opto.cells)
    
    % go throught the activatino regions
    for i = 1:length(d.simset.opto.shapes)
        
        % go through the cells
        for k = 1:nCells
            
            % check if the cell vertices are within the activation
            % region using winding number algorithm
            isInside = check_if_inside(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),d.cells(k).verticesX,d.cells(k).verticesY);
            
            % if there are any nonzero winding numbers (cell vertices
            % that are inside the region)
            if any(isInside ~= 0)
                
                % find the indices of the vertices inside
                isInside = find(isInside ~= 0);
                
                % input the cell and the vertices into the opto
                % activation data
                d.simset.opto.cells(end+1) = k;
                d.simset.opto.vertices{end+1} = isInside;
            end
        end
    end
    
    % if there are cells activated currently
else
    
    % vectors needed to find unique cells
    cellNumbers = 1:nCells;
    zeroVec = zeros(nCells,1);
    
    % get the cells being currently activated
    cell2Check = d.simset.opto.cells;
    
    % get cells that these cells have junctions with
    for k = cell2Check
        cell2Check = get_uniques([cell2Check d.cells(k).junctions.linked2CellNumbers1 d.cells(k).junctions.linked2CellNumbers2],cellNumbers,zeroVec);
    end
    
    % reset the activated cells and vertices
    d.simset.opto.cells = [];
    d.simset.opto.vertices = {};
    
    % go through the activation regions
    for i = 1:length(d.simset.opto.shapes)
        
        % go through the cells to check
        for k = cell2Check
            
            % check if the cell vertices are within the activation
            % region using winding number algorithm
            isInside = check_if_inside(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),d.cells(k).verticesX,d.cells(k).verticesY);
            
            % if there are any nonzero winding numbers (cell vertices
            % that are inside the region)
            if any(isInside ~= 0)
                
                % find the indices of the vertices inside
                isInside = find(isInside ~= 0);
                
                % input the cell and the vertices into the opto
                % activation data
                d.simset.opto.cells(end+1) = k;
                d.simset.opto.vertices{end+1} = isInside;
            end
        end
    end
end

end

function d = assign_activations(d)
% ASSIGN_ACTIVATIONS Assign the appropriate activation for the vertices
%   The function goes through the activated vertices and assigns
%   multipliers accordingly. To smoothen the changes in cortical tensions,
%   3 different levels of activation are used: (1) fully activated for
%   vertices whose cortical link passes between two activated vertices,
%   with also the middle point that is passed over being activated; (2) the
%   half activated is used for cases where only one of the end points of
%   the cortical link is activated, with also the middle vertex being
%   activated, or when only the middle vertex is activated; and (3) the
%   quarter activated is used for cases where only one of the end points is
%   activated, but not the middle vertex.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% go through the cells that are within the activation regions
for k = 1:length(d.simset.opto.cells)
    
    % get the cell ID
    cellID = d.simset.opto.cells(k);
    
    % reset their vertex cortical tensions
    d.cells(cellID).cortex.vertexMultipliers = ones(d.cells(cellID).nVertices,1);
    
    % make a temporary vector and assign 1 to all activated vertices
    verticesTemp = zeros(d.cells(cellID).nVertices,1);
    verticesTemp(d.simset.opto.vertices{k}) = 1;
    
    % find the indices of the vertices where the activation changes
    activationChanges = diff(verticesTemp([1:end 1]));
    
    % find the indices where the changes between activated and not
    % activated vertices occur (note that the "ups" are true at the
    % vertex before the increase)
    downs = find(activationChanges == -1);
    ups  = find(activationChanges == 1);
    
    % if not all vertices are activated
    if ~isempty(downs)
        
        % if the first change in the activation is down (from activated
        % to not activated)
        if downs(1) < ups(1)
            
            % get the pairs where the up and down of the activated
            % section correspond to each other (since the first change
            % is down, the last up corresponds to it).
            pairs = [ups([end 1:end-1]) downs];
            
            % variable to indicate the first change is down
            firstSwapped = 1;
            
        % otherwise
        else
            
            % get the pairs of up and downs corresponding to each other
            pairs = [ups downs];
            
            % variable to indicate the first change is up
            firstSwapped = 0;
        end
        
        % initialize vectors to collect the vertices that are either
        % fully, half, or quarter activated
        fullyActivated = [];
        halfActivated = [];
        quarterActivated = [];
        
        % go through the pairs
        for i = 1:size(pairs,1)
            
            % if the first pair corresonds to the situation with the
            % first vertex being activated, and this is the first pair
            if firstSwapped && i == 1
                
                % calcualted the number of activated vertices (between
                % the two pair points)
                numberActivated = pairs(1,2) + (d.cells(cellID).nVertices - pairs(1,1));
                
            % otherwise
            else
                
                % calcualted the number of activated vertices (between
                % the two pair points)
                numberActivated = pairs(i,2) - pairs(i,1);
            end
            
            % if the number of activated vertices for this pair is 1
            if numberActivated == 1
                
                % if the sole activated vertex is the first one
                if firstSwapped && i == 1
                    halfActivated = [halfActivated d.cells(cellID).nVertices]; %#ok<*AGROW>
                    quarterActivated = [quarterActivated 1 d.cells(cellID).nVertices-1];
                    
                % otherwise
                else
                    
                    % if the sole activated vertex is the second one
                    if pairs(i,1) == 1
                        halfActivated = [halfActivated 1];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices 2];
                        
                    % otherwise a general case
                    else
                        halfActivated = [halfActivated pairs(i,1)];
                        quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,1)+1];
                    end
                end
                
                % if there are two activated vertices
            elseif numberActivated == 2
                
                % if the activation either begins at vertex 1 or spans
                % across from the last to the first
                if firstSwapped && i == 1
                    
                    % if the first and second vertices are activated
                    if pairs(1,1) == d.cells(cellID).nVertices
                        halfActivated = [halfActivated 1 d.cells(cellID).nVertices];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 2];
                        
                    % if the last and the first vertices are activated
                    else
                        halfActivated = [halfActivated d.cells(cellID).nVertices-1 d.cells(cellID).nVertices];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 1];
                    end
                    
                % otherwise
                else
                    
                    % if the activation is the second and third
                    % vertices
                    if pairs(i,1) == 1
                        halfActivated = [halfActivated 1 2];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices 3];
                        
                    % otherwise a general case
                    else
                        halfActivated = [halfActivated pairs(i,1) pairs(i,1)+1];
                        quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,1)+2];
                    end
                end
                
            % if there are three activated vertices
            elseif numberActivated == 3
                
                % if the activation either begins at vertex 1 or spans
                % across from the last to the first
                if firstSwapped && i == 1
                    
                    % if the activated vertices are the first, second,
                    % and third
                    if pairs(1,1) == d.cells(cellID).nVertices
                        fullyActivated = [fullyActivated 1];
                        halfActivated = [halfActivated 2 d.cells(cellID).nVertices];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 3];
                        
                    % if the activated vertices are the second to last,
                    % last, and the first
                    elseif pairs(1,2) == 1
                        fullyActivated = [fullyActivated d.cells(cellID).nVertices-1];
                        halfActivated = [halfActivated d.cells(cellID).nVertices-2 d.cells(cellID).nVertices];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-3 1];
                        
                    % if the activated vertices are the last, first, and
                    % second
                    else
                        fullyActivated = [fullyActivated d.cells(cellID).nVertices];
                        halfActivated = [halfActivated d.cells(cellID).nVertices-1 1];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 2];
                    end
                    
                % otherwise
                else
                    
                    % if the activated vertices are the second, third,
                    % and fourth
                    if pairs(i,1) == 1
                        fullyActivated = [fullyActivated 2];
                        halfActivated = [halfActivated 1 3];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices 4];
                        
                    % otherwise a general case
                    else
                        fullyActivated = [fullyActivated pairs(i,1)+1];
                        halfActivated = [halfActivated pairs(i,1) pairs(i,2)-1];
                        quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,2)];
                    end
                end
                
            % more than 3 activated vertices
            else
                
                % if the activation either begins at vertex 1 or spans
                % across from the last to the first
                if firstSwapped && i == 1
                    
                    % if the activated region begins at vertex 1
                    if pairs(1,1) == d.cells(cellID).nVertices
                        fullyActivated = [fullyActivated 1:(pairs(1,2)-2)];
                        halfActivated = [halfActivated d.cells(cellID).nVertices pairs(1,2)-1];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 pairs(1,2)];
                        
                    % if the activated region begins at last vertex
                    elseif pairs(1,1) == d.cells(cellID).nVertices-1
                        fullyActivated = [fullyActivated d.cells(cellID).nVertices 1:(pairs(1,2)-2)];
                        halfActivated = [halfActivated d.cells(cellID).nVertices-1 pairs(1,2)-1];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 pairs(1,2)];
                        
                    % if the activation region ends at vertex 1
                    elseif pairs(1,2) == 1
                        fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices-1];
                        halfActivated = [halfActivated pairs(1,1) d.cells(cellID).nVertices];
                        quarterActivated = [quarterActivated pairs(1,1)-1 1];
                        
                    % if the activation region ends at vertex 2
                    elseif pairs(1,2) == 2
                        fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices];
                        halfActivated = [halfActivated pairs(1,1) 1];
                        quarterActivated = [quarterActivated pairs(1,1)-1 2];
                        
                    % otherwise
                    else
                        fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices 1:(pairs(1,2)-2)];
                        halfActivated = [halfActivated pairs(1,1) pairs(1,2)-1];
                        quarterActivated = [quarterActivated pairs(1,1)-1 pairs(1,2)];
                    end
                    
                % otherwise
                else
                    
                    % if the activation region begins at vertex 2
                    if pairs(i,1) == 1
                        fullyActivated = [fullyActivated 2:pairs(i,1)-2];
                        halfActivated = [halfActivated 1 pairs(i,2)-1];
                        quarterActivated = [quarterActivated d.cells(cellID).nVertices pairs(i,2)];
                        
                    % otherwise a general case
                    else
                        quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,2)];
                        halfActivated = [halfActivated pairs(i,1) pairs(i,2)-1];
                        fullyActivated = [fullyActivated (pairs(i,1)+1):pairs(i,2)-2];
                    end
                end
            end
        end
        
    % if there are no ups or downs, the whole cell is fully activated
    else
        quarterActivated = [];
        halfActivated = [];
        fullyActivated = 1:d.cells(cellID).nVertices;
    end
    
    % assign the activation values based on the derived multipliers
    d.cells(cellID).cortex.vertexMultipliers(quarterActivated) = 1 + 0.25.*d.simset.opto.levels(d.simset.opto.currentTime);
    d.cells(cellID).cortex.vertexMultipliers(halfActivated) = 1 + 0.5.*d.simset.opto.levels(d.simset.opto.currentTime);
    d.cells(cellID).cortex.vertexMultipliers(fullyActivated) = 1 + d.simset.opto.levels(d.simset.opto.currentTime);
end

end