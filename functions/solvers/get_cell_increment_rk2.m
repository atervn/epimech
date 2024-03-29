function [d, repeat] = get_cell_increment_rk2(d, kIncrement, dt)
% GET_CELL_INCREMENT_RK2 Calculate the 2nd order Runge-Kutta increments
%   The function calculate the increment for the 2nd order Runge-Kutta
%   method by calculating the total force at each increment and multiplying
%   it by the time step. If the movement increment are too large, the
%   function will return so that the time step can be halved.
%   INPUTS:
%       d: main simulation data structure
%       kIncrement: the number of the increment (1 or 2)
%       dt: current time step
%   OUTPUT:
%       d: main simulation data structure
%       repeat: variable to indicate if the time step is to be repeated
%   by Aapo Tervonen, 2021

% variable to indicate that there are too large increments
repeat = false;

% get the cell data to a temporary structure
tempCells = d.cells;

% if frame simulation, do not solve the last (frame) cell
if d.simset.simulationType == 4
    nCells = length(tempCells) - 1;
else
    nCells = length(tempCells);
end

% if this is the second increment
if kIncrement == 2
    
    % go through the cells
    for k = 1:nCells
        
        % calculate the vertex coordinates and normal perimeter at time+k1
        tempCells(k).verticesX = tempCells(k).verticesX + tempCells(k).increments.k1X;
        tempCells(k).verticesY = tempCells(k).verticesY + tempCells(k).increments.k1Y;
        tempCells(k).normPerimeter = tempCells(k).normPerimeter + d.cells(k).perimeterIncrements.k1;
    end
    
    % calculate the boundary segment lengths, angles, cell areas and
    % perimeters
    tempCells = get_boundary_vectors(tempCells);
    tempCells = get_boundary_lengths(tempCells);
    tempCells = get_vertex_angles(tempCells);
    tempCells = get_cell_areas(tempCells);
    tempCells = get_cell_perimeters(tempCells);
end

% go through the cells
for k = 1:nCells

    % calculate the membrane forces
    tempCells(k) = get_cell_membrane_forces(tempCells(k),d.spar);
        
    % calculate the cortical forces
    tempCells(k) = get_cell_cortical_forces(tempCells(k));
    
    % calculate the area forces
    tempCells(k) = get_cell_area_forces(tempCells(k),d.spar);
    
    % calculate the junction forces
    tempCells = get_cell_junction_forces(tempCells,d.spar,k);
    
    % calculate the contact forces
    tempCells = get_cell_contact_forces(tempCells,d.spar,k);
    
    % if growth simulation
    if d.simset.simulationType == 1
        
        % calculate division forces
        tempCells(k) = get_cell_division_forces(tempCells(k),d.spar);
        
    % if pointlike micromanipulation simultion
    elseif d.simset.simulationType == 2
        
        % calculate the pointlike force
        tempCells(k) = get_cell_pointlike_forces(tempCells(k),d.simset,d.spar,k);
    end
    
    % if the simulation includes substrate
    if d.simset.substrateIncluded
        
        % calculate the focal adhesion force for the cells
        tempCells(k) = get_cell_focal_adhesion_forces(tempCells(k),d.sub);
        
        % calcualte the edge force for the cells
        tempCells(k) = get_edge_forces(tempCells(k),d.spar);
    end
    
    % calculate the total forces
    tempCells(k) = get_cell_total_forces(tempCells(k),d.simset.simulationType);
    
    % if this is the first increment, save the forces
    if kIncrement == 1
        d.cells(k) = save_forces(d.cells(k), tempCells(k), d.simset.simulationType);
    end
    
    % first increment
    if kIncrement == 1
        
        % calculate the first vertex movement increment
        d.cells(k).increments.k1X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k1Y = dt*tempCells(k).forces.totalY;
        
        % check if the increment is too large, if yes, stop and return
        if max(d.cells(k).increments.k1X.^2 + d.cells(k).increments.k1Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end
        
        % calculate the first perimeter remodeling increment
        d.cells(k).perimeterIncrements.k1 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);
        
    % second increment
    elseif kIncrement == 2
        
        % calculate the second movement increment
        d.cells(k).increments.k2X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k2Y = dt*tempCells(k).forces.totalY;
        
        % check if the increment is too large, if yes, stop and return
        if max(d.cells(k).increments.k2X.^2 + d.cells(k).increments.k2Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end

        % calculate the second perimeter remodeling increment
        d.cells(k).perimeterIncrements.k2 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);
    end
end

end