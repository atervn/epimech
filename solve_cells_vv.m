function [d, dt, maxmaxMovement] = solve_cells_vv(d, dt)


cells = d.cells;

m = 200;

tempVelocitiesX = cell(length(cells),1);
tempVelocitiesY = cell(length(cells),1);
tempForcesX = cell(length(cells),1);
tempForcesY = cell(length(cells),1);

for k = 1:length(cells)
    
%     if d.simset.calculateForces.all(k)
    if d.simset.calculateForces.membrane(k)
        cells(k) = get_cell_membrane_forces(cells(k),d.spar);
    end
    if d.simset.calculateForces.cortical(k)
        cells(k) = get_cell_cortical_forces(cells(k));
    end
    if d.simset.calculateForces.area(k)
        cells(k) = get_cell_area_forces(cells(k),d.spar);
    end
    if d.simset.calculateForces.junction(k)
        cells = get_cell_junction_forces(cells,d.spar,k);
    end
    
    cells = get_cell_contact_forces(cells,d.spar,k,1);
    
    if d.simset.simulationType == 1
        if d.simset.calculateForces.division(k)
            cells(k) = get_cell_division_forces(cells(k),d.spar);
        end
    elseif d.simset.simulationType == 2
        cells(k) = get_cell_pointlike_forces(cells(k),d.simset,d.spar,k);
    end
    
    cells(k).forces.dampingX = -cells(k).velocitiesX;
    cells(k).forces.dampingY = -cells(k).velocitiesY;
    
    [tempForcesX{k}, tempForcesY{k}] = get_cell_total_forces_2(cells(k),d.simset.simulationType);
end

allNotGood = 1;

while allNotGood

    tempCells = cells;
    maxmaxMovement = 0;
    
    for k = 1:length(cells)
        movementX = dt.*cells(k).velocitiesX + 0.5.*tempForcesX{k}/m.*dt^2;
        movementY = dt.*cells(k).velocitiesY + 0.5.*tempForcesY{k}/m.*dt^2;
        
        maxMovement = sqrt(max(movementX.^2 + movementY.^2));
        
        if maxMovement > 0.2
            allNotGood = 1;
            dt = dt/2;
            break
        else
            allNotGood = 0;
            
            if maxMovement > maxmaxMovement
                maxmaxMovement = maxMovement;
            end
            
            tempCells(k).verticesX = tempCells(k).verticesX + movementX;
            tempCells(k).verticesY = tempCells(k).verticesY + movementY;
            
            tempCells(k).normPerimeter = tempCells(k).normPerimeter + dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);
            
            tempVelocitiesX{k} = tempCells(k).velocitiesX + 0.5.*tempForcesX{k}/m.*dt;
            tempVelocitiesY{k} = tempCells(k).velocitiesY + 0.5.*tempForcesY{k}/m.*dt;
            
        end
    end
end
    
    cells = tempCells;
    cells = get_boundary_vectors(cells);
    cells = get_boundary_lengths(cells);
    
for k = 1:length(cells)    
    
    cells(k) = get_cell_membrane_forces(cells(k),d.spar);
    cells(k) = get_cell_cortical_forces(cells(k));
    cells(k) = get_cell_area_forces(cells(k),d.spar);
    cells = get_cell_junction_forces(cells,d.spar,k);
    cells = get_cell_contact_forces(cells,d.spar,k,2);
    if d.simset.simulationType == 1
        cells(k) = get_cell_division_forces(cells(k),d.spar);
    elseif d.simset.simulationType == 2
        cells(k) = get_cell_pointlike_forces(cells(k),d.simset,d.spar,k);
    end
    
    cells(k).forces.dampingX = -tempVelocitiesX{k};
    cells(k).forces.dampingY = -tempVelocitiesY{k};
    
    [cells(k).forces.totalX, cells(k).forces.totalY] = get_cell_total_forces_2(cells(k),d.simset.simulationType);

    cells(k).velocitiesX = cells(k).velocitiesX + 0.5.*(tempForcesX{k} + cells(k).forces.totalX)/m*dt;
    cells(k).velocitiesY = cells(k).velocitiesY + 0.5.*(tempForcesY{k} + cells(k).forces.totalY)/m*dt;
    
    d.simset.calculateForces.all(k) = false;
    d.simset.calculateForces.junction(k) = false;
    d.simset.calculateForces.area(k) = false;
    d.simset.calculateForces.membrane(k) = false;
    d.simset.calculateForces.cortical(k) = false;
    d.simset.calculateForces.division(k) = false;
    
end

d.cells = cells;

end