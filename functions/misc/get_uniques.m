function uniques = get_uniques(vector,cellNumbers,zeroVec)
% GET_UNIQUES Find the unique pair cell indices
%   INPUT:
%       vector: vector of pair cell indices
%       cellNumbers: vector with each cell number in the model
%       zeroVec: vector of zeros with the same length as cellNumbers
%   OUTPUT:
%       uniques: unique pair cell indices

% if there are pair cells
if numel(vector)
    
    % set the pair cells to 1 in the zero vector
    zeroVec(vector) = 1;
    
    % get the uniques
    uniques = cellNumbers(logical(zeroVec));

% othewise, no uniques
else
    uniques = [];
end

end