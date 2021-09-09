function angles = get_angles(vector1X, vector1Y, vector2X, vector2Y)
% GET_ANGLES Calculate the angles between two vectors
%   The function takes in the vector components of two vectors meeting in
%   a vertex and calculates the angle between the vectors. It assumes that
%   the first vector is directed towards the vertex and the second vector
%   is directed away from the vertex
%   by Aapo Tervonen, 2021

% get the outside angles between the two vectors
angles = atan2(-vector2Y, -vector2X) - atan2(vector1Y, vector1X);

% if the angle is clocwise, get the supplementary angle
angles(angles < 0) = angles(angles < 0) + 2*pi;

end