function linesCross = check_line_intersection(vertexX,vertexY,neighborVertexX,neighborVertexY,pairX,pairY,neighborPairX,neighborPairY)
% CHECK_LINE_INTERSECTION Checks if two junctions intersect each other
%   The function checks if two junctions intersect each other by defining
%   a linear problem to find the intersection between two lines going
%   through the two pairs of vertices and if the point of intersection is
%   within the section of junctions.
%   INPUTS:
%       vertexX: x-coordinate of the current vertex
%       vertexY: y-coordinate of the current vertex
%       neighborVertexX: x-coordinate of the neighboring vertex
%       neighborVertexY: y-coordinate of the neighboring vertex
%       pairX: x-coordinate of the possible pair
%       pairY: y-coordinate of the possible pair
%       neighborPairX: x-coordinate of the neighboring vertexes pair
%       neighborPairY: y-coordinate of the neighboring vertexes pair
%   OUTPUT:
%       linesCross: logical to indicate if the junctions intersect
%   by Aapo Tervonen, 2021

% define matrix A for the linear system
A = [pairY-vertexY vertexX-pairX  ; neighborPairY-neighborVertexY neighborVertexX-neighborPairX];

% if the determinate is nonsingular
if abs(det(A)) >= 1e-10
    
    % define  vector b for the linear system
    b = [(pairY-vertexY)*vertexX - (pairX-vertexX)*vertexY ; (neighborPairY-neighborVertexY)*neighborVertexX - (neighborPairX-neighborVertexX)*neighborVertexY];
    
    % solve the linear system
    Pint = A\b;
    
    % if the line segments intersect, one of the following statements
    % is true
    
    % if the neighboring junction is fully horizonatl
    if neighborVertexX == neighborPairX
        
        % if the intersection point is above the minimum of
        % y-coordinates of the two junctions below the maximum
        % y-coordiantes
        if Pint(2) > min(pairY,vertexY) && Pint(2) > min(neighborPairY,neighborVertexY) && Pint(2) < max(pairY,vertexY) && Pint(2) < max(neighborPairY,neighborVertexY)
            
            % junctions cross
            linesCross = false;
        else
            
            % junctions don't cross
            linesCross = true;
        end
        
    % if the intersection point is above the minimum of
    % x-coordinates of the two junctions below the maximum
    % x-coordiantes
    elseif Pint(1) > min(pairX,vertexX) && Pint(1) > min(neighborPairX,neighborVertexX) && Pint(1) < max(pairX,vertexX) && Pint(1) < max(neighborPairX,neighborVertexX)
        
        % junctions cross
        linesCross = false;
    else
        
        % junctions don't cross
        linesCross = true;
    end
else
    
    % junctions don't cross
    linesCross = true;
end

end
