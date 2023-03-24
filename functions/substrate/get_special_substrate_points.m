function specialCase = get_special_substrate_points(nX,nPoints)
% GET_SPECIAL_SUBSTRATE_POINTS Find the special substrate points
%   The function finds the indices of the points that are on the edges or
%   in the corners of the substrate.
%   INPUT:
%       nX: number of points in each row
%       nPoints: total number of points
%   OUTPUT:
%       specialCase: structure with the special point indices
%   by Aapo Tervonen, 2021

% get the indices of the points in the first row (excluding the ends)
specialCase.bottomRow = 2:nX-1;

% get the indices of the points in the last row (excluding the ends)
specialCase.topRow = nPoints-nX+2:nPoints-1;

% get the indices of the left side ends of the even rows
specialCase.leftEven = nX+1:2*nX:nPoints-nX;

% get the indices of the left side ends of the odd rows
specialCase.leftOdd = 2*nX+1:2*nX:nPoints-nX;

% get the indices of the right side ends of the even rows
specialCase.rightEven = 2*nX:2*nX:nPoints-nX;

% get the indices of the right side ends of the odd rows
specialCase.rightOdd = 3*nX:2*nX:nPoints-nX;

% get the indices of the corners
specialCase.bottomLeftCorner = 1;
specialCase.bottomRightCorner = nX;
specialCase.topLeftCorner = nPoints-nX+1;
specialCase.topRightCorner = nPoints;

end