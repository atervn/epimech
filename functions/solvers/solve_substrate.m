function [d,subDt] = solve_substrate(d,gTime,cellDt,subDt)
% SOLVE_SUBSTRATE Solves substrate movement using 4th order Runge-Kutta
% method
%   The function solves the substrate point movements using 4th order
%   Runge-Kutta method. The substrate movement is solved with a time step
%   that is smaller or equal to the cell time step. If smaller time step is
%   used, the substrate movement is solved until the time equal to
%   time+cellDt is reached while the cells are kept stationary. While
%   solving, the function checks if either the increments or the movement
%   itself are too large, and halves the time step in these cases. It will
%   solve the movement until all movements are below the predefined limit.
%   The increments were checked in addition to the movements themselves as
%   this allowed the simulation try to stop faster to begin the simulation
%   with the halved time step.
%   INPUTS:
%       d: main simulation data structure
%       cellDt: current simulation time step
%       subDt: current substrate solution time step
%   OUTPUT:
%       d: main simulation data structure
%       subDt: current, possibly modified substrate solution time step
%   by Aapo Tervonen, 2021

% temporary time to check if the same time point as the cell has been
% reached
time = 0;

% if the substrate time step is larger than the cell time step, make them
% equal
if subDt > cellDt
    subDt = cellDt;
end


% variable to indicate that this is the first substrate iteration
firstTime = 1;


% initialize cells to temporarily save data on the cell vertex
% coordiantes, their focal adhesion connetions and weights, focal
% adhesion strengths, and their indices in the substrateMatrix
subTemp.verticesX = cell(1,length(d.cells));
subTemp.verticesY = cell(1,length(d.cells));
subTemp.weightsLin = cell(1,length(d.cells));
subTemp.pointsLin = cell(1,length(d.cells));
subTemp.fFocalAdhesions = cell(1,length(d.cells));
subTemp.matrixIdx = cell(1,length(d.cells));

% go through the cells
for k = 1:length(d.cells)
    
    % get the data for cell k
    subTemp.verticesX{k} = d.cells(k).verticesX(d.cells(k).substrate.connected);
    subTemp.verticesY{k} = d.cells(k).verticesY(d.cells(k).substrate.connected);
    subTemp.weightsLin{k} = d.cells(k).substrate.weightsLin;
    subTemp.pointsLin{k} = d.cells(k).substrate.pointsLin;
    subTemp.fFocalAdhesions{k} = d.cells(k).substrate.fFocalAdhesions;
    subTemp.matrixIdx{k} = d.cells(k).substrate.matrixIdx;
end

if d.simset.simulationType == 6
    pointsOriginalX = d.sub.pointsOriginalX;
    pointsOriginalY = d.sub.pointsOriginalY;
end

% loop until the cell time step has been reached
while 1
    
    % get the coordinates of the point that the central force is calculated
    % for (called selves here)
    subTemp.selvesX = d.sub.pointsX(d.sub.interactionSelvesIdx);
    subTemp.selvesY = d.sub.pointsY(d.sub.interactionSelvesIdx);
    
    % get the coordinates of the pair for the selves in the central forces
    subTemp.pairsX = d.sub.pointsX(d.sub.interactionPairsIdx);
    subTemp.pairsY = d.sub.pointsY(d.sub.interactionPairsIdx);
    
    % initialize vectors to store the data for calculating each increment
    subTemp.pointsX = zeros(d.sub.nPoints,1);
    subTemp.pointsY = subTemp.pointsX;
    subTemp.vectorsX = zeros(size(subTemp.selvesX));
    subTemp.vectorsY = subTemp.vectorsX;
    subTemp.vectorLengths = subTemp.vectorsX;
    subTemp.reciprocalVectorLengths = subTemp.vectorsX;
    subTemp.unitVectorsX = subTemp.vectorsX;
    subTemp.unitVectorsY = subTemp.vectorsX;
    
    % variable to check if there are too large vertex movements in the time
    % step
    tooLargeMovement = 1;
    
    % keeping looping until there are no too large movements
    while tooLargeMovement
        
        % keep looping until there are no too large increments k3
        while 1
            
            % keep looping until there are no too large increments k2
            while 1
                
                % keep looping until there are no too large increments k1
                while 1
                    
                    if d.simset.simulationType == 6
                        d.sub.pointsOriginalX = pointsOriginalX;
                        d.sub.pointsOriginalY = pointsOriginalY;
                        d = move_glass(d,gTime+time,subDt);
                    end

                    % calculate the increments k1
                    [d, repeat] = get_substrate_increments(d, subTemp, 1, subDt, firstTime);
                    
                    firstTime = 0;
                    
                    % if there are too large increments, half the time
                    % step, if not, break the k1 loop
                    if repeat; subDt = subDt/2; else; break; end
                end
                
                % calculate the increments k2
                [d, repeat] = get_substrate_increments(d, subTemp, 2, subDt);
                
                % if there are too large increments, half the time step, if
                % not, break the k2 loop
                if repeat; subDt = subDt/2; else; break; end
            end
            
            % calculate the increments k3
            [d, repeat] = get_substrate_increments(d, subTemp, 3, subDt);
            
            % if there are too large increments, half the time step, if
            % not, break the k3 loop
            if repeat; subDt = subDt/2; else; break; end
        end
        
        % calculate the increments k4
        [d, ~] = get_substrate_increments(d, subTemp, 4, subDt);
        
        % calculate the movement of the substrate points
        movementX = 1/6.*(d.sub.increments.k1X + 2.*d.sub.increments.k2X + 2.*d.sub.increments.k3X + d.sub.increments.k4X);
        movementY = 1/6.*(d.sub.increments.k1Y + 2.*d.sub.increments.k2Y + 2.*d.sub.increments.k3Y + d.sub.increments.k4Y);
        
        % calculate the maximum squared movement for the cell
        maxMovement = max(movementX.^2 + movementY.^2);
        
        % if the maximum squared movement is larger than the largers
        % allowed movement, half time step and start again
        if maxMovement >= d.spar.substrateMaximumMovementSq
            subDt = subDt/2;
            
            % if the maximum squares movement is within the limits, move
            % forwards in time
        else
            
            % if there are no too large movements, calculate the new
            % substrate point positions
            d.sub.pointsX = d.sub.pointsX + movementX;
            d.sub.pointsY = d.sub.pointsY + movementY;
            
            % update the time
            time = time + subDt;
            
            break;
        end
    end

    if d.simset.simulationType == 6
        pointsOriginalX = d.sub.pointsOriginalX;
        pointsOriginalY = d.sub.pointsOriginalY;
    end
    
    % if the substrate time step is smaller than the cell time step and
    % ther maximum substrate movement is below the defined limit,
    % possibly increase the
    if subDt < cellDt && maxMovement <= d.spar.substrateMinimumMovementSq
        multiplier = 2;
    else
        multiplier = 1;
    end
    
    % if the cellDt has been reached, end break out of the loop
    if abs(cellDt - time) < 1e-8
        
        % if the movement limit was passed, the time step can be doubled
        % for the next simulation time step
        subDt = subDt*multiplier;
        break
        
    % otherwise
    else
        
        % loop until a good time step is found
        while 1
            
            % if the current substrate time plus the time step times the
            % multiplier is smaller or equal to the cellDt
            if  multiplier*subDt + time <= cellDt
                
                % get the new time step
                subDt = subDt*multiplier;
                break
                
            % if the current substrate time plus the time step times the
            % multiplier is larger than the cellDt, halve the time step
            else
                multiplier = multiplier/2;
            end
        end



        
    end
end

end


