function d = setup_division(d,k)
% SETUP_DIVISION Define the division vertices
%   The function finds the division vertices for the cell based on the
%   cells axis and the daughter cell areas. It also removed the junctions
%   from the division vertices.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

%% FIND THE DIVISION AXIS

% meshgrids for x and y coordinates for the distance measurements
[gridX, gridY] = meshgrid(d.cells(k).verticesX,d.cells(k).verticesY);

% creates a matrix with distances between each pair of boundary
% vertices
distances = sqrt((gridX - gridX').^2 + (gridY - gridY').^2);

% finds the maximum values and indices in each column
[maxDistances, idx1] = max(distances);

% finds the maximum index from the column maximum values
[~, idx2] = max(maxDistances);

% indices of the vertices that are at maximum distance from each other
maxInds = [idx2 idx1(idx2)];

% calculates the slope for a line between these vertices
slope = (d.cells(k).verticesY(maxInds(1)) - d.cells(k).verticesY(maxInds(2)))/(d.cells(k).verticesX(maxInds(1)) - d.cells(k).verticesX(maxInds(2)));

% if the slope is horizontal, replace with a small number
if abs(slope) <= eps
    slope = eps;
end

% calculate the orthogonal slope
divisionSlope = -1/slope;

%% FIND DIVISION LINE LOCATION

% Halfway index between the MaxInds as the starting
% position (tempVertex is the index of one end of the division line)
vertexCandidate1 = round((max(maxInds) + min(maxInds))/2);

% Makes a vector of the vertex indices on the other side of the cell
% compared to tempVertex1 (between max(maxInds and min(maxInds)
oppositeSide = 1:d.cells(k).nVertices;
oppositeSide(min(maxInds):max(maxInds)) = [];

% condition when the division line location search should be
% stopped
stopCondition = 0;

% condition to show if one of the vertices has passed from the last
% to first index or other way around
passedFirst = 0;

% find the relative area for one of the new daughter cells
areaMultiplier = d.cells(k).division.newAreas(2)/sum(d.cells(k).division.newAreas);

% Iterative loop that goes through the vertices and finds the one the
% other side vertex closest to the line drawn with the
% dividing_slope. Then, an area calculate based on these two vertices
% being the dividing vertices and compared with the half of the
% original area. Then, the vertices are iteratively changed towards
% the minimization of the difference between the areas. When the
% difference begins to increase, the areas calculated with the
% current vertices and the previous vertices are compared to find the
% minimizing ones.
while 1
    
    % calculates the distance between a line through vertexCandidate1
    % with slope divisionSlope and the vertices in oppositeSide
    % (https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line)
    distances = abs(-divisionSlope.*d.cells(k).verticesX(oppositeSide) + d.cells(k).verticesY(oppositeSide) - d.cells(k).verticesY(vertexCandidate1) + divisionSlope*d.cells(k).verticesX(vertexCandidate1))/sqrt((-divisionSlope)^2 + 1);
    
    % index of the vertex closest to the line in the otherCellSide
    [~,idx] = min(distances);
    
    % index of the vertex closest to the line in the boundaryVertices
    vertexCandidate2 = oppositeSide(idx);
    
    % reorder the vertex candidates
    vertexCandidates = [vertexCandidate1 vertexCandidate2];
    vertexCandidate1 = min(vertexCandidates);
    vertexCandidate2 = max(vertexCandidates);
    
    % switch the other side if the vertex with small index is in
    % the current opposite side
    if any(oppositeSide == vertexCandidate1)
        oppositeSide = (min(maxInds):max(maxInds));
    end
        
    % check if vertexCandidate2 has passed the boundary end
    if stopCondition == 2 && previousCandidate2 < vertexCandidate2
        passedFirst = 1;
    elseif stopCondition == 1 && previousCandidate2 > vertexCandidate2
        passedFirst = 1;
    end
    
    % creates a temporary boundary vertex vector for the possible
    % cell half
    boundaryCandidateX = d.cells(k).verticesX(min([vertexCandidate1 vertexCandidate2]):max([vertexCandidate1 vertexCandidate2]));
    boundaryCandidateY = d.cells(k).verticesY(min([vertexCandidate1 vertexCandidate2]):max([vertexCandidate1 vertexCandidate2]));
    
    % the area of this possible half cell, if one of the tempVertices
    % has passed the boundary end, calculate the area of the other
    % half
    if passedFirst == 0
        area = calculate_area(boundaryCandidateX,boundaryCandidateY);
    else
        area = d.cells(k).area - calculate_area(boundaryCandidateX,boundaryCandidateY);
    end
    
    % the difference between tempArea and the area of half of the
    % original cell
    areaDifference = area - d.cells(k).area*areaMultiplier;
    
    if abs(areaDifference) < 0.0001 % if area already equals to half of the original area
        
        % these vertices are chosen without checking
        d.cells(k).division.vertices = sort([vertexCandidate1; vertexCandidate2]);
        break
        
    elseif areaDifference < 0 % if area is smaller than half of the original cell
        
        % if areaDifference was positive in the beginning, but is
        % now negative, this condition is true
        if stopCondition == 2
            
            % if areaDifference was larger in the previous
            % iteration
            if previousAreaDifference > abs(areaDifference)
                
                % choose the vertex used in this iteration
                d.cells(k).division.vertices = sort([vertexCandidate1; vertexCandidate2]);
                break
                
                % if areaDifference was smaller in the previous
                % iteration
            else
                
                % choose the vertices used in previous iteration
                d.cells(k).division.vertices = sort([previousCandidate1; previousCandidate2]);
                break
            end
            
            % if stopCondition is 1 or 0
        else
            
            % set the stopCondition (1 = area is reduced until
            % the half area of the original cell is passed
            stopCondition = 1;
            
            % saves the areaDifference for future comparison
            previousAreaDifference = abs(areaDifference);
            
            % saves the tempVertices for future use
            previousCandidate1 = vertexCandidate1;
            previousCandidate2 = vertexCandidate2;
            
            % assings new vertexCandidate1 so that the area reduces
            % (first index is dealt differently)
            if vertexCandidate1 ~= 1
                vertexCandidate1 = vertexCandidate1 - 1;
            else
                vertexCandidate1 = d.cells(k).nVertices;
                passedFirst = 1;
            end
        end
        
    else % if area is larger than half of the original cell
        
        % if areaDifference was positive in the beginning, but is
        % now negative, this condition is true
        if stopCondition == 1
            
            % if areaDifference was larger in the previous
            % iteration
            if previousAreaDifference > abs(areaDifference)
                
                % choose the vertex used in this iteration
                d.cells(k).division.vertices = sort([vertexCandidate1; vertexCandidate2]);
                break
                
                % if areaDifference was smaller in the previous
                % iteration
            else
                
                % choose the vertices used in previous iteration
                d.cells(k).division.vertices = sort([previousCandidate1; previousCandidate2]);
                break
            end
            
            % if stopCondition is 2 or 0,
        else
            
            % set the stopCondition (2 = area is reduced until
            % the half area of the original cell is passed
            stopCondition = 2;
            
            % saves the areaDifference for future comparison
            previousAreaDifference = abs(areaDifference);
            
            % saves the tempVertices for future use
            previousCandidate1 = vertexCandidate1;
            previousCandidate2 = vertexCandidate2;
            
            % assings new tempVertex1 so that the area decreases
            % (last vertex is dealt differently)
            if vertexCandidate1 ~= d.cells(k).nVertices
                vertexCandidate1 = vertexCandidate1 + 1;
            else
                vertexCandidate1 = 1;
                passedFirst = 1;
            end
        end
    end
end

% get divisionDistance
d.cells(k).division.distanceSq = d.spar.divisionDistanceConstant*((d.cells(k).verticesX(d.cells(k).division.vertices(1)) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))^2 + (d.cells(k).verticesY(d.cells(k).division.vertices(1)) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))^2);

% go through the division vertices to check if they have junctions
for i = 1:2
    % checks if the division vertex has junctions
    if d.cells(k).vertexStates(d.cells(k).division.vertices(i)) > 0
        
        % go through the junctions
        for i2 = 1:d.cells(k).vertexStates(d.cells(k).division.vertices(i))
            
            % get the pair indices
            cellID = d.cells(k).junctions.cells(d.cells(k).division.vertices(i),i2);
            vertexID = d.cells(k).junctions.vertices(d.cells(k).division.vertices(i),i2);
            
            % find which junction this is for the pair
            whichJunction = find(d.cells(cellID).junctions.cells(vertexID,:) == k);
            
            % remove the junction information of the vertex the
            % division vertex was bound with
            d.cells(cellID).junctions.cells(vertexID,whichJunction) = 0;
            d.cells(cellID).junctions.vertices(vertexID,whichJunction) = 0;
            
            % if this is the first junction for the pair
            if whichJunction == 1
                
                % check if there is a second junction, if yes move the
                % junction data from the second position to the first and
                % remove the junction data related to new division vertex
                if d.cells(cellID).junctions.cells(vertexID,2) ~= 0
                    idx = d.cells(cellID).junctions.linkedIdx1 == vertexID;
                    d.cells(cellID).junctions.pairCells1(idx) = d.cells(cellID).junctions.cells(vertexID,2);
                    d.cells(cellID).junctions.pairVertices1(idx) = d.cells(cellID).junctions.vertices(vertexID,2);
                    d.cells(cellID).junctions.cells(vertexID,1) = d.cells(cellID).junctions.cells(vertexID,2);
                    d.cells(cellID).junctions.vertices(vertexID,1) = d.cells(cellID).junctions.vertices(vertexID,2);
                    d.cells(cellID).junctions.cells(vertexID,2) = 0;
                    d.cells(cellID).junctions.vertices(vertexID,2) = 0;
                    idx = d.cells(cellID).junctions.linkedIdx2 == vertexID;
                    
                    
                    d.cells(cellID).junctions.linkedIdx2(idx) = [];
                    d.cells(cellID).junctions.pairCells2(idx) = [];
                    d.cells(cellID).junctions.pairVertices2(idx) = [];
                    
                % if there is only one junction, just remove the data
                else
                    idx = d.cells(cellID).junctions.linkedIdx1 == vertexID;
                    
                    d.cells(cellID).junctions.linkedIdx1(idx) = [];
                    d.cells(cellID).junctions.pairCells1(idx) = [];
                    d.cells(cellID).junctions.pairVertices1(idx) = [];
                end
            
            % if this is pais second junction, just remove the data
            else
                idx = d.cells(cellID).junctions.linkedIdx2 == vertexID;
                
                d.cells(cellID).junctions.linkedIdx2(idx) = [];
                d.cells(cellID).junctions.pairCells2(idx) = [];
                d.cells(cellID).junctions.pairVertices2(idx) = [];
                
            end
            
            % change the state of the vertex the division vertex was
            % bound with to a nonbound state
            d.cells(cellID).vertexStates(vertexID) = sum(d.cells(cellID).junctions.cells(vertexID,:) > 0);
            
            % remove the junction information of the division vertex
            d.cells(k).junctions.cells(d.cells(k).division.vertices(i),i2) = 0;
            d.cells(k).junctions.vertices(d.cells(k).division.vertices(i),i2) = 0;
            if i2 == 1
                idx = d.cells(k).junctions.linkedIdx1 == d.cells(k).division.vertices(i);
                
                % remove the linkedIdx and links data for the vertex
                d.cells(k).junctions.linkedIdx1(idx) = [];
                d.cells(k).junctions.pairCells1(idx) = [];
                d.cells(k).junctions.pairVertices1(idx) = [];
            else
                idx = d.cells(k).junctions.linkedIdx2 == d.cells(k).division.vertices(i);
                
                % remove the linkedIdx and links data for the vertex
                d.cells(k).junctions.linkedIdx2(idx) = [];
                d.cells(k).junctions.pairCells2(idx) = [];
                d.cells(k).junctions.pairVertices2(idx) = [];
            end
        end

    end
    
    % change the vertex state to division vertex
    d.cells(k).vertexStates(d.cells(k).division.vertices(i)) = -1;
end

end