function maxSize = get_maximum_epithelium_size(d)
% GET_MAXIMUM_EPITHELIUM_SIZE Find the maximum size of the epithelium
%   The function find the half side length of the square that fits the
%   whole epithelium (with the middle of the square in at 0,0)
%   INPUT:
%       app: main application object
%   OUTPUT:
%       maxSize: maximum size
%   by Aapo Tervonen, 2021

% initialize the maximum and minimum coordinate vectors
maxPointX = zeros(1,length(d.cells));
minPointX = maxPointX;
maxPointY = maxPointX;
minPointY = maxPointX;

% go through the cells
for k = 1:length(d.cells)
    
    % get the maximun and minimum vertex coordinates in each directions
    maxPointX(k) = max(d.cells(k).verticesX);
    minPointX(k) = min(d.cells(k).verticesX);
    maxPointY(k) = max(d.cells(k).verticesY);
    minPointY(k) = min(d.cells(k).verticesY);
end

% find the maximum coordinates value in any cell
maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY])));

end