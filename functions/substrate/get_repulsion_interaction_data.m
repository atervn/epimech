function [repulsionPairsIdx, repulsionInteractions1Idx, repulsionChangeSigns, repulsionInteractions2Idx] = get_repulsion_interaction_data(i, interactionPairs, repulsionPairsIdx, repulsionInteractions1Idx, repulsionChangeSigns, repulsionInteractions2Idx)
% GET_REPULSION_INTERACTION_DATA Define the repulsion interaction data
%   The function defines the data required for the substrate repulsion
%   interactions. This is done by finding the indices from the unique
%   interaction pair matrix (interactionPairs) that correspond to the two
%   vectors needed to calculate the repulsive forces between a point and
%   the link between two of its pairs:
%       1: an interaction between pair 1 and point i (the direction of this
%           interactions has to be from pair 1 to point i, so the unique
%           interactions in the other directions are noted for later sign 
%           change)
%       2: an interaction between pair 1 and pair 2 (the direction does not
%           matter)
%   INPUT:
%       i: current point index
%       interactionPairs: unique interaction pair matrix
%       repulsionPairsIdx: indices of the repulsion pairs for point idx
%       repulsionInteractions1Idx: matrix to save the interaction of type 1
%       repulsionChangeSigns: matrix indicating the interactions whose sign
%           has to be changed
%       repulsionInteractions1Idx: matrix to save the interaction of type 2
%   OUTPUT:
%       repulsionPairsIdx: indices of the repulsion pairs for point idx
%       repulsionInteractions1Idx: matrix to save the interaction of type 1
%       repulsionChangeSigns: matrix indicating the interactions whose sign
%           has to be changed
%       repulsionInteractions1Idx: matrix to save the interaction of type 2
%   by Aapo Tervonen, 2021

% get the boundary repulsion pairs for point i and their number
repulsionPairsIdxTemp = nonzeros(repulsionPairsIdx(:,i))';
nPairs = length(repulsionPairsIdxTemp);

% substrate boundaries or corners
if nPairs < 6
    
    % go through the pairs counter clockwise (excluding the last one)
    for j = 1:nPairs-1
        
        % find the interactions that the point i is the
        % "self"
        match = interactionPairs(:,1) == i;
        
        % find the interaction where the point is the "self" and the
        % repulsion pair is the pair
        match(match) = interactionPairs(match,2) == repulsionPairsIdxTemp(j);
        
        % get the interaction index
        idx = find(match);
        
        % if the interaction direction is unique
        if ~isempty(idx)
            
            % save the interaction index and set the change sign value
            % for this pair to true (since the interaction from the
            % pair to the point i is needed, we need to know this to
            % flip the direction)
            repulsionInteractions1Idx(j,i) = idx;
            repulsionChangeSigns(j,i) = 1;
            
        % if the interaction direction is counter
        else
            
            % find the interactions that the point i is the
            % pair
            match = interactionPairs(:,2) == i;
            
            % find the interaction where the point is the pair and the
            % repulsion pair is the "self"
            match(match) = interactionPairs(match,1) == repulsionPairsIdxTemp(j);
            
            % save the interaction index (there is no need to change
            % the sign for this, since it is already in the correct
            % direction)
            repulsionInteractions1Idx(j,i) = find(match);
        end
        
        % get the indices of the interaction between pair and the next
        % pair counterclockwise
        intPair = j:j+1;
        
        % find the interaction where the current pair is the "self"
        match = interactionPairs(:,1) == repulsionPairsIdxTemp(intPair(1));
        
        % find the interactions where the current pair is the "self"
        % and the next pair counterclockwise is the pair
        match(match) = interactionPairs(match,2) == repulsionPairsIdxTemp(intPair(2));
        
        % get the interaction index
        idx = find(match);
        
        % if the interaction direction is unique
        if ~isempty(idx)
            
            % get the interaction index
            repulsionInteractions2Idx(j,i) = idx;
            
        % if the interaction direction is counter
        else
            
            % find the interactions where the next pair clockwise is
            % the "self"
            match = interactionPairs(:,2) == repulsionPairsIdxTemp(intPair(1));
            
            % find the interaction where the next pair counterclockwise
            % is the "self" and the current pair is the pair
            match(match) = interactionPairs(match,1) == repulsionPairsIdxTemp(intPair(2));
            
            % get the interaction index
            repulsionInteractions2Idx(j,i) = find(match);
        end
    end
    
    % remove the last pair, since there are no next counterclockwise
    % pair for this and thus not needed)
    repulsionPairsIdx(nPairs,i) = 0;
    
% if the point is in the middle (full 6 neighbors)
else
    
    % go through the pairs counter clockwise
    for j = 1:nPairs
        
        % find the interactions that the point i is the
        % "self"
        match = interactionPairs(:,1) == i;
        
        % find the interaction where the point is the "self" and the
        % repulsion pair is the pair
        match(match) = interactionPairs(match,2) == repulsionPairsIdxTemp(j);
        
        % get the interaction index
        idx = find(match);
        
        % if the interaction direction is unique
        if ~isempty(idx)
            
            % save the interaction index and set the change sign value
            % for this pair to true (since the interaction from the
            % pair to the point i is needed, we need to know this to
            % flip the direction)
            repulsionInteractions1Idx(j,i) = idx;
            repulsionChangeSigns(j,i) = 1;
            
        % if the interaction direction is counter
        else
            
            % find the interactions that the point i is the
            % pair
            match = interactionPairs(:,2) == i;
            
            % find the interaction where the point is the pair and the
            % repulsion pair is the "self"
            match(match) = interactionPairs(match,1) == repulsionPairsIdxTemp(j);
            
            % save the interaction index (there is no need to change
            % the sign for this, since it is already in the correct
            % direction)
            repulsionInteractions1Idx(j,i) = find(match);
        end
        
        % get the indices of the interaction between pair and the next
        % pair counterclockwise
        if j == nPairs
            intPair = [nPairs 1];
        else
            intPair = j:j+1;
        end
        
        % find the interaction where the current pair is the "self"
        match = interactionPairs(:,1) == repulsionPairsIdxTemp(intPair(1));
        
        % find the interactions where the current pair is the "self"
        % and the next pair counterclockwise is the pair
        match(match) = interactionPairs(match,2) == repulsionPairsIdxTemp(intPair(2));
        
        % get the interaction index
        idx = find(match);
        
        % if the interaction direction is unique
        if ~isempty(idx)
            
            % get the interaction index
            repulsionInteractions2Idx(j,i) = idx;
            
        % if the interaction direction is counter
        else
            
            % find the interactions where the next pair clockwise is
            % the "self"
            match = interactionPairs(:,2) == repulsionPairsIdxTemp(intPair(1));
            
            % find the interaction where the next pair counterclockwise
            % is the "self" and the current pair is the pair
            match(match) = interactionPairs(match,1) == repulsionPairsIdxTemp(intPair(2));
            
            % get the interaction index
            repulsionInteractions2Idx(j,i) = find(match);
        end
    end
end