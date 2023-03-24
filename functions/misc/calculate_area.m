function area = calculate_area(verticesX,verticesY)
% CALCULATE_AREA Calculate the area of the provided polygon
%   The function calculates the area based on the provided polygon vertex
%   coordinates.
%   INPUTS:
%       verticesX: x-coordinates of the polygon
%       verticesY: y-coordinates of the polygon
%   OUTPUT:
%       area: polygon area
%   by Aapo Tervonen, 2021

% get the coordinates of the enxt vertices
leftVerticesX = circshift(verticesX,-1,1);
leftVerticesY = circshift(verticesY,-1,1);

% calculate the area of the polygon
area = sum(0.5.*(verticesX.*leftVerticesY - leftVerticesX.*verticesY));

end