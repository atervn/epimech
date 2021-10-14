function [d, dt, maxmaxMovement] = solve_cells_rk2(d, dt)
% SOLVE_CELLS_RK2 Solves cell movement using 2nd order Runge-Kutta method
%   The function solves the cell vertex movements and the cell normal
%   perimeter using 2nd order Runge-Kutta method. While solving, the
%   function checks if either the increments or the movement itself are too
%   large, and halves the time step in these cases. It will solve the
%   movement until all movements are below the predefined limit. The
%   increments were checked in addition to the movements themselves as this
%   allowed the simulation try to stop faster to begin the simulation with
%   the halved time step.
%   INPUTS:
%       d: main simulation data structure
%       dt: current time step
%   OUTPUT:
%       d: main simulation data structure
%       dt: current, possibly modified time step
%       maxmaxMovement: the largest vertex movement in the time step
%   by Aapo Tervonen, 2021

% variable to check if there are too large vertex movements in the time
% step
tooLargeMovement = 1;

% variable to store the largest vertex movement in the time step
maxmaxMovement = 0;

% if frame simulation, do not solve the last (frame) cell
if d.simset.simulationType == 4
    nCells = length(d.cells) - 1;
else
    nCells = length(d.cells);
end

% keeping looping until there are no too large movements
while tooLargeMovement
    
    % keep looping until there are no too large increments k2
    while 1
        
        
        % keep looping until there are no too large increments k1
        while 1
            
            % calculate the increments k1
            [d, repeat] = get_cell_increment_rk2(d, 1, dt);
            
            % if there are too large increments, half the time step,if not,
            % break the k1 loop
            if repeat; dt = dt/2; else; break; end
        end
        
        % calculate the incretements k2
        [d, repeat] = get_cell_increment_rk2(d, 2, dt);
        
        % if there are too large increments, half the time step,if not,
        % break the k1 loop
        if repeat; dt = dt/2; else; break; end
    end
    
    % go through the cells
    for k = 1:nCells
        
        % calculate the movement of the cell vertices
        d.cells(k).movementX = d.cells(k).increments.k1X./2 + d.cells(k).increments.k2X./2;
        d.cells(k).movementY = d.cells(k).increments.k1Y./2 + d.cells(k).increments.k2Y./2;
        
        % calculate the maximum squared movement for the cell
        maxMovement = max(d.cells(k).movementX.^2 + d.cells(k).movementY.^2);
        
        % if this is larger than the current maximum for the time step,
        % assign it to maxmaxMovement
        if maxmaxMovement < maxMovement
            maxmaxMovement = maxMovement;
        end
        
        % if the maximum squares movement is larger than the largers allowed
        % movement, half time step and start again
        if maxMovement >= d.spar.cellMaximumMovementSq
            tooLargeMovement = 1;
            dt = dt/2;
            break;
         
        % if the maximum squares movement is within the limits, continue
        % with the other cells
        else
            
            % if all cells have no too large movenent, end the loop after
            % going through the cells
            tooLargeMovement = 0;
        end
    end
end

% go through the cells
for k  = 1:nCells
    
    % calculate the new vertex coorindates
    d.cells(k).verticesX = d.cells(k).verticesX + d.cells(k).movementX;
    d.cells(k).verticesY = d.cells(k).verticesY + d.cells(k).movementY;
    
    % calculate the new normal perimeter
    d.cells(k).normPerimeter = d.cells(k).normPerimeter + d.cells(k).perimeterIncrements.k1/2 + d.cells(k).perimeterIncrements.k2/2;
end

end