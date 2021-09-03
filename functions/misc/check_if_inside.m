function windingNumbers = check_if_inside(verticesX,verticesY,coordsX,coordsY)
    
%method here: http://geomalgorithms.com/a03-_inclusion.html

% create a vector for the winding numbers
windingNumbers = zeros(length(coordsX),1);

% assign the first point of the boundaryPoints matrix as the last point to
% complete the cell polygon
verticesX(end+1) = verticesX(1);
verticesY(end+1) = verticesY(1);

verticesX = repmat(verticesX',length(coordsX),1);
verticesY = repmat(verticesY',length(coordsX),1);

coordsX = repmat(coordsX,1,size(verticesX,2)-1);
coordsY = repmat(coordsY,1,size(verticesY,2)-1);

crossProduct = [];

intersectingUpEdge = (verticesY(:,1:end-1) <= coordsY);
if any(intersectingUpEdge(:))
    intersectingUpEdge = intersectingUpEdge.*(verticesY(:,2:end) > coordsY);
    if any(intersectingUpEdge(:))
        crossProduct = (verticesX(:,2:end) - verticesX(:,1:end-1)).*(coordsY-verticesY(:,1:end-1)) - (coordsX - verticesX(:,1:end-1)).*(verticesY(:,2:end)-verticesY(:,1:end-1));
        windingNumbers = windingNumbers + sum(intersectingUpEdge.*(crossProduct > 0),2);
    end
end
intersectingDownEdge = (verticesY(:,1:end-1) > coordsY);
if any(intersectingDownEdge(:))
    intersectingDownEdge = intersectingDownEdge.*(verticesY(:,2:end) <= coordsY);
    if any(intersectingDownEdge(:))
        if isempty(crossProduct)
            crossProduct = (verticesX(:,2:end) - verticesX(:,1:end-1)).*(coordsY-verticesY(:,1:end-1)) - (coordsX - verticesX(:,1:end-1)).*(verticesY(:,2:end)-verticesY(:,1:end-1));
        end
        windingNumbers = windingNumbers - sum(intersectingDownEdge.*(crossProduct < 0),2);
    end
end

% crossProduct = (verticesX(:,2:end) - verticesX(:,1:end-1)).*(coordsY-verticesY(:,1:end-1)) - (coordsX - verticesX(:,1:end-1)).*(verticesY(:,2:end)-verticesY(:,1:end-1));

% checks that there are upwards edge intersections
%     if any(intersectingUpEdge(:))
        
        % indices of the points whose cross product is above zero (are on
        % the left) and that intersect upwards edge
%         windingNumbers = windingNumbers + sum(intersectingUpEdge.*(crossProduct > 0),2);
        
        % increase the winding number of these points
%         windingNumbers(inds) = windingNumbers(inds) + 1;
%     end
    
%     if any(intersectingDownEdge(:))
        
        % indices of the points whose cross product is below zero (are on
        % the right) and that intersect upwards edge
%         inds = find(intersectingDownEdge.*(crossProduct < 0));
%         windingNumbers = windingNumbers - sum(intersectingDownEdge.*(crossProduct < 0),2);
        % decrease the winding number of these points
%         windingNumbers(inds) = windingNumbers(inds) - 1;
%     end

% go through all the boundary edges (-1 as the size of the matrix was
% increase in the previous line)
% for i = 1:length(verticesX)-1
%     
%     % finds the source points whose y coordinate falls on the edge that is
%     % going up (so that their rays intersect the edge from left)
%     intersectingUpEdge = (verticesY(i) <= coordsY).*(verticesY(i+1) > coordsY);
%     
%     % finds the source points whose y coordinate falls on the edge that is
%     % going down (so that their rays intersect the edge from left)
%     intersectingDownEdge = (verticesY(i) > coordsY).*(verticesY(i+1) <= coordsY);
%     
%     % cross product is calculated and used to check of which side of the
%     % edge the point is (edgepoint1 -> edgepoint2) x (edgepoint1 -> point)
%     crossProduct = (verticesX(i+1) - verticesX(i)).*(coordsY-verticesY(i)) - (coordsX - verticesX(i)).*(verticesY(i+1)-verticesY(i));
%     
%     % checks that there are upwards edge intersections
%     if sum(intersectingUpEdge) ~= 0
%         
%         % indices of the points whose cross product is above zero (are on
%         % the left) and that intersect upwards edge
%         inds = find(intersectingUpEdge.*(crossProduct > 0));
%         
%         % increase the winding number of these points
%         windingNumbers(inds) = windingNumbers(inds) + 1;
%     end
%     
%     % checks that there are downwards edge intersections
%     if sum(intersectingDownEdge) ~= 0
%         
%         % indices of the points whose cross product is below zero (are on
%         % the right) and that intersect upwards edge
%         inds = find(intersectingDownEdge.*(crossProduct < 0));
%         
%         % decrease the winding number of these points
%         windingNumbers(inds) = windingNumbers(inds) - 1;
%     end
% end
    
end