function windingNumbers = check_if_inside(verticesX,verticesY,coordsX,coordsY)
% CHECK_IF_INSIDE Checks if provided coordinates are within a polygon
%   The function used the winding numbers algorithm to calculate if the
%   provided coordinates are within the closed polygon. If the winding
%   number is nonzero, the coordinates are within the polygon, and if zero,
%   they are outside.
%   INPUTS:
%       verticesX: x-coordinates of the closed polygon
%       verticesY: y-coordinates of the closed polygon
%       coordsX: x-coordinates to be checked
%       coordsY: y-coordinates to be checked
%   OUTPUT:
%       windingNumbers: calculate winding numbers
%   by Aapo Tervonen, 2021


% create a vector for the winding numbers
windingNumbers = zeros(length(coordsX),1);

% complete the polygon by assigning the first vertex as the last one
verticesX(end+1) = verticesX(1);
verticesY(end+1) = verticesY(1);

% replicate the vertex vectors with the number of coordinates to check
verticesX = repmat(verticesX',length(coordsX),1);
verticesY = repmat(verticesY',length(coordsX),1);

% replicate the coordinates to check with the number of the polygon
% vertices
coordsX = repmat(coordsX,1,size(verticesX,2)-1);
coordsY = repmat(coordsY,1,size(verticesY,2)-1);

% matrix to store cross products
crossProduct = [];

% first check the winding numbers for the polygon segment vectors going
% upwards. Find the coordinates that have y-coordinates higher than those
% of the polygon vertices (comparing every coordinate against every vertex)
intersectingUpEdge = (verticesY(:,1:end-1) <= coordsY);

% if they exist
if any(intersectingUpEdge(:))
    
    % find if the coordinates also have y-coordinates lower than the
    % next polygon vertex (i.e. are their y-coordinates on the band defined
    % by neighboring polygon vertices
    intersectingUpEdge = intersectingUpEdge.*(verticesY(:,2:end) > coordsY);
    
    % if they exist
    if any(intersectingUpEdge(:))
        
        % calculate cross product between the vectors defined by
        % neighboring polygon vertices and the that between the coordinates
        % and the polygon vertex with smaller index
        crossProduct = (verticesX(:,2:end) - verticesX(:,1:end-1)).*(coordsY-verticesY(:,1:end-1)) - (coordsX - verticesX(:,1:end-1)).*(verticesY(:,2:end)-verticesY(:,1:end-1));
        
        % take sum of all the positive cross products (only including those
        % whose y-coordinates are in the band defined by the neighboring
        % polygon vertices)
        windingNumbers = sum(intersectingUpEdge.*(crossProduct > 0),2);
    end
end

% next check the winding number for the polygon segment vectors going
% downwards. Find the coordinates that have y-coordinates lower than those
% of the polygon vertices (comparing every coordinate against every vertex)
intersectingDownEdge = (verticesY(:,1:end-1) > coordsY);

% if they exist
if any(intersectingDownEdge(:))
    
    % find if the coordinates also have y-coordinates higher than the
    % next polygon vertex (i.e. are their y-coordinates on the band defined
    % by neighboring polygon vertices
    intersectingDownEdge = intersectingDownEdge.*(verticesY(:,2:end) <= coordsY);
    
    % if they exist
    if any(intersectingDownEdge(:))
        
        % check if the cross product has already been calculated
        if isempty(crossProduct)
            
            % if not, calculate it
            crossProduct = (verticesX(:,2:end) - verticesX(:,1:end-1)).*(coordsY-verticesY(:,1:end-1)) - (coordsX - verticesX(:,1:end-1)).*(verticesY(:,2:end)-verticesY(:,1:end-1));
        end
        
        % take sum of all the negative cross products (only including those
        % whose y-coordinates are in the band defined by the neighboring
        % polygon vertices)
        windingNumbers = windingNumbers - sum(intersectingDownEdge.*(crossProduct < 0),2);
    end
end
    
end