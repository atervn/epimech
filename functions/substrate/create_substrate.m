function d = create_substrate(app, d, substrateSize)
% CREATE_SUBSTRATE Create the substrate for the simulation
%   The function creates the substrate and defines the substrate
%   interactions for the simulation. The substrate and its interactions are
%   defined with following information
%       pointsX: substrate point x-coordinates
%       pointsY: substrate point y-coordinates
%       nPoints: number of substrate points
%       interactionSelvesIdx: the first point of each interaction between
%           two points
%       interactionPairsIdx: the second point of each interaction between
%           two points
%       springMultipliers: honeycomb multiplier values for the interactions
%           between points defined by interactionSelvesIdx and
%           interactionPairsIdx (multiplier at index i correspond to the
%           points at the same indices)
%       interactionLinIdx: when solving the substrate central forces, a 
%           6-by-nPoints matrix (one column for each point with maximum 6
%           direct interactions) is used. This linear index defines the
%           index of the interaction in that matrix. (e.g. the linear index
%           of the central interaction with the first point at index i in
%           interactionSelvesIdx and second point at index i in
%           interactionPairsIdx is at index i in interactionLinIdx)
%       counterInteractionLinIdx: linear indices in the central interaction
%           matrix that are the counter interactions to each unique
%           interactions defined by interactionSelvesIdx and
%           interactionPairsIdx. (e.g linear index at index i corresponds
%           to the interaction with the first point at index i in
%           interactionPairsIdx and the second point at index i in
%           interactionSelvesIdx, which is just the same interaction as
%           defined by interactionLinIdx at index i, but in the reverse
%           direction)
%       repulsionLinIdx: when solving the substrate repulsion forces, a 
%           6-by-nPoints matrix (one column for each point with maximum 6
%           direct interactions) is used. This linear index defines the
%           index of the repulsivion interaction in that matrix.
%       repulsionVectors1Idx: each repulsion interaction requires two
%           vectors: (1) vector from one of the end points of the line that
%           is repulsing to the point that is repulsed, and (2) the vector
%           between the points that define the repulsing line. This vector
%           is the index of the interaction defined by interactionSelvesIdx
%           and interactionPairsIdx (or the other direction) that form the
%           required vector. Therefore, the index i in this vector gives
%           the interaction index that corresponds to the first vector and
%           whose location in the repulsion interaction matrix is given at
%           index i in repulsionLinIdx.
%       repulsionVectors2Idx: defines the interaction indices of the second
%           vectors in similar way as repulsionVectors1Idx
%       repulsionChangeSigns: for cases where repulsionVectors1Idx points
%           to interaction that is in the wrong direction (vector is from the
%           repulsed point to one of the end points), there is true in this
%           vector to indicate to flip the vector direction
%       emptyMatrix: emptry matrix of zeroes for the central and repulsion
%           forces to be added in, so there is no need to create it during
%           simulation
%       adhesionNumbers: number of focal adhesions that are interacting
%           with each point, defined when creating focal adhesions
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       substrateSize: size of the substrate square
%       progressdlg: progress dialog handle used with the GUI
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% get the number of substrate points in both directions based on their
% distance
nX = round(substrateSize/d.spar.substratePointDistance);
nY = round(substrateSize/(d.spar.substratePointDistance*sqrt(3)/2));

% if there are even number of point rows
if mod(nY,2) == 0
    
    % find the coordinates of the first two rows (even rows are shifted by
    % half point distance due to the triangular grid) and replicate them
    % for the all the rows
    pointsX = repmat([(0:nX-1).*d.spar.substratePointDistance (0:nX-1).*d.spar.substratePointDistance + d.spar.substratePointDistance/2]',nY/2,1);

% otherwise
else
    
    % find the coordinates of the first two rows (even rows are shifted by
    % half point distance due to the triangular grid) and replicate them
    % for the all the rows
    pointsX = repmat([(0:nX-1).*d.spar.substratePointDistance d.spar.substratePointDistance/2 + (0:nX-1).*d.spar.substratePointDistance]',(nY-1)/2,1);
    
    % add the coordinates of the final odd row
    pointsX = [pointsX; (0:nX-1)'.*d.spar.substratePointDistance];
end

% find the y coordinates for each point (scaled point distance from the
% triangular nature of the grid)
pointsY = repmat(((0:nY-1).*d.spar.substratePointDistance*sqrt(3)/2),nX,1);
pointsY = pointsY(:);

% center to get the final coordinates
d.sub.pointsX = pointsX - substrateSize/2;
d.sub.pointsY = pointsY - substrateSize/2;

% number of the substrate points
d.sub.nPoints = length(d.sub.pointsX);

% save the initial coordinates
d.sub.pointsOriginalX = d.sub.pointsX;
d.sub.pointsOriginalY = d.sub.pointsY;

% define the substrate point interactions for pointlike and optogenetic
% simulations
if any(d.simset.simulationType == [2,5])
    d = get_substrate_interactions(app,d,nX,nY);
    if ~isstruct(d); return; end
end

end