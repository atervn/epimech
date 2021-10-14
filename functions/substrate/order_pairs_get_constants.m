function [suitablePairs, constantsTemp] = order_pairs_get_constants(suitablePairs, idx, iRow, iCol, specialCase, constants, rowIdx, nY)
% ORDER_PAIRS_GET_CONSTANTS Order substrate interaction pairs and get
% honeycomb constants
%   The function orders the substrate interactions pairs for each point in
% counterclockwise order starting from the most clockwise or the one on
% most right and gets the corresponding honeycomb constants. The order is
% based on the fact that the suitable pairs are ordered by default based on
% increasing index and therefore they can be ordered based on they 
% knowledge of the position of the current point in the substrate. The
% honeycomb constants are defined based on their position in relation to
% bottom left corner, which always has the same value. Therefore, their
% constants can be defined by knowing the row and position in the row that
% the current point is.
%   INPUT:
%       suitablePairs: vector of suitaple pairs
%       idx: current point index
%       iRow: current row
%       iCol: current point in the row
%       specialCase: structure with the indices of all the special cases
%           (corners and edges)
%       constants: structure with the honeycomb constant values
%       rowIdx: structure with indices of every third point in a row
%           starting from the first, second, or third point on the row
%       nY: number of rows
%   OUTPUT:
%       suitablePairs: ordered suitable pairs
%       constantsTemp: ordered honeycomb constants for the pair
%           interactions
%   by Aapo Tervonen, 2021

% if bottom row
if any(idx == specialCase.bottomRow)
    
    % order the pairs
    suitablePairs = suitablePairs([2 4 3 1]);
    
    % if every third starting from first
    if any(iCol == rowIdx.first)
        constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma];
        
        % if every third starting from second
    elseif any(iCol == rowIdx.second)
        constantsTemp =  [constants.gamma constants.alpha constants.gamma constants.alpha];
        
        % if every third starting from third
    elseif any(iCol == rowIdx.third)
        constantsTemp = [constants.gamma constants.gamma constants.gamma constants.gamma];
    end
    
    % if top row
elseif any(idx == specialCase.topRow)
    
    % order the pairs
    suitablePairs = suitablePairs([3 1 2 4]);
    
    % if there are even number of rows
    if mod(iRow,2) == 0
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp = [constants.gamma constants.alpha constants.gamma constants.alpha];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp =  [constants.gamma constants.gamma constants.gamma constants.gamma];
        end
        
        % if there are odd number of rows
    else
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp = [constants.gamma constants.alpha constants.gamma constants.alpha];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp =  [constants.gamma constants.gamma constants.gamma constants.gamma];
        end
    end
    
    % if even left end of a row
elseif any(idx == specialCase.leftEven)
    
    % order the pairs
    suitablePairs = suitablePairs([1 2 3 5 4]);
    
    % get the constants (always the same)
    constantsTemp = [constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma];
    
    % if odd left end of a row
elseif any(idx == specialCase.leftOdd)
    
    % order the pairs
    suitablePairs = suitablePairs([1 2 3]);
    
    % get the constants (always the same)
    constantsTemp = [constants.gamma constants.alpha constants.gamma];
    
    % if even right end of a row
elseif any(idx == specialCase.rightEven)
    
    % order the pairs
    suitablePairs = suitablePairs([3 2 1]);
    
    % if every third starting from first
    if any(iCol == rowIdx.first)
        constantsTemp = [constants.gamma constants.gamma constants.gamma];
        
        % if every third starting from second
    elseif any(iCol == rowIdx.second)
        constantsTemp = [constants.alpha constants.gamma constants.alpha];
        
        % if every third starting from third
    elseif any(iCol == rowIdx.third)
        constantsTemp =  [constants.gamma constants.alpha constants.gamma];
    end
    
    % if odee right end of a row
elseif any(idx == specialCase.rightOdd)
    
    % order the pairs
    suitablePairs = suitablePairs([5 4 3 1 2]);
    
    % if every third starting from first
    if any(iCol == rowIdx.first)
        constantsTemp = [constants.gamma constants.alpha constants.gamma constants.alpha constants.gamma];
        
        % if every third starting from second
    elseif any(iCol == rowIdx.second)
        constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma constants.alpha];
        
        % if every third starting from third
    elseif any(iCol == rowIdx.third)
        constantsTemp =  [constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma];
    end
    
    % if bottom left corner
elseif idx == specialCase.bottomLeftCorner
    
    % order the pairs
    suitablePairs = suitablePairs([1 2]);
    
    % get the constants (always the same)
    constantsTemp = [constants.alpha constants.gamma];
    
    % if bottom right corner
elseif idx == specialCase.bottomRightCorner
    
    % order the pairs
    suitablePairs = suitablePairs([3 2 1]);
    
    % if every third starting from first
    if any(iCol == rowIdx.first)
        constantsTemp = [constants.gamma constants.alpha constants.gamma];
        
        % if every third starting from second
    elseif any(iCol == rowIdx.second)
        constantsTemp = [constants.alpha constants.gamma constants.alpha];
        
        % if every third starting from third
    elseif any(iCol == rowIdx.third)
        constantsTemp =  [constants.gamma constants.gamma constants.gamma];
    end
    
    % if top left corner
elseif idx == specialCase.topLeftCorner
    
    % if there are odd number of rows
    if mod(nY,2) == 1
        
        % order the pairs
        suitablePairs = suitablePairs([1 2]);
        
        % get the constants (always the same)
        constantsTemp = [constants.gamma constants.alpha];
        
        % if there are even number of rows
    else
        
        % order the pairs
        suitablePairs = suitablePairs([1 2 3]);
        
        % get the constants (always the same)
        constantsTemp = [constants.gamma constants.gamma constants.gamma];
    end
    
    % if top right corner
elseif idx == specialCase.topRightCorner
    
    % if there are odd number of rows
    if mod(nY,2) == 1
        
        % order the pairs
        suitablePairs = suitablePairs([3 1 2]);
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp = [constants.gamma constants.alpha constants.gamma];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp = [constants.alpha constants.gamma constants.alpha];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp =  [constants.gamma constants.gamma constants.gamma];
        end
        
        % if there are even number of rows
    else
        
        % order the pairs
        suitablePairs = suitablePairs([2 1]);
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp =  [constants.gamma constants.gamma];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp = [constants.gamma constants.alpha];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp = [constants.alpha constants.gamma];
        end
    end
    
    % if middle point
else
    
    % order the pairs
    suitablePairs = suitablePairs([4 6 5 3 1 2]);
    
    % if the current row is an even row
    if mod(iRow,2) == 0
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp = [constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma constants.alpha constants.gamma];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp =  [constants.gamma constants.alpha constants.gamma constants.alpha constants.gamma constants.alpha];
        end
        
        % if the current row is an odd row
    else
        
        % if every third starting from first
        if any(iCol == rowIdx.first)
            constantsTemp = [constants.alpha constants.gamma constants.alpha constants.gamma constants.alpha constants.gamma];
            
            % if every third starting from second
        elseif any(iCol == rowIdx.second)
            constantsTemp =  [constants.gamma constants.alpha constants.gamma constants.alpha constants.gamma constants.alpha];
            
            % if every third starting from third
        elseif any(iCol == rowIdx.third)
            constantsTemp = [constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma constants.gamma];
        end
    end
end

end