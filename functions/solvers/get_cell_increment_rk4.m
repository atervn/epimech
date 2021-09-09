function [d, repeat] = get_cell_increment_rk4(d,kIteration,dt)

repeat = false;
tempCells = d.cells;

if d.simset.simulationType == 4
    nCells = length(tempCells) - 1;
else
    nCells = length(tempCells);
end

if kIteration == 2
    for k = 1:length(tempCells)
        tempCells(k).verticesX = tempCells(k).verticesX + tempCells(k).increments.k1X./2;
        tempCells(k).verticesY = tempCells(k).verticesY + tempCells(k).increments.k1Y./2;
        tempCells(k).normPerimeter = tempCells(k).normPerimeter + d.cells(k).corticalData.perimeter.k1/2;
        tempCells(k).corticalTension = tempCells(k).corticalTension + d.cells(k).corticalData.tension.k1/2;
    end
elseif kIteration == 3
    for k = 1:length(tempCells)
        tempCells(k).verticesX = tempCells(k).verticesX + tempCells(k).increments.k2X./2;
        tempCells(k).verticesY = tempCells(k).verticesY + tempCells(k).increments.k2Y./2;
        tempCells(k).normPerimeter = tempCells(k).normPerimeter + d.cells(k).corticalData.perimeter.k2/2;
        tempCells(k).corticalTension = tempCells(k).corticalTension + d.cells(k).corticalData.tension.k2/2;
    end
elseif kIteration == 4
    for k = 1:length(tempCells)
        tempCells(k).verticesX = tempCells(k).verticesX + tempCells(k).increments.k3X;
        tempCells(k).verticesY = tempCells(k).verticesY + tempCells(k).increments.k3Y;
        tempCells(k).normPerimeter = tempCells(k).normPerimeter + d.cells(k).corticalData.perimeter.k3;
        tempCells(k).corticalTension = tempCells(k).corticalTension + d.cells(k).corticalData.tension.k3;
    end
end

if kIteration > 1
    tempCells = get_boundary_lengths(tempCells);
    tempCells = get_boundary_vectors(tempCells);
    tempCells = get_cell_areas(tempCells);
    tempCells = get_cell_perimeters(tempCells);
end

for k = 1:nCells
    
        tempCells(k) = get_cell_membrane_forces(tempCells(k),d.spar);
        tempCells(k) = get_cell_cortical_forces(tempCells(k),d.spar);
        tempCells(k) = get_cell_area_forces(tempCells(k),d.spar);
        tempCells = get_cell_junction_forces(tempCells,d.spar,k);
        tempCells = get_cell_contact_forces(tempCells,d.spar,k);
        
        if d.simset.simulationType == 1
            tempCells(k) = get_cell_division_forces(tempCells(k),d.spar);
        elseif d.simset.simulationType == 2
            tempCells(k) = get_cell_focal_adhesion_forces(tempCells(k),d.sub);
            tempCells(k) = get_cell_pointlike_forces(tempCells(k),d.simset,d.spar,k);
            tempCells(k) = get_edge_forces(tempCells(k),d.spar);
        elseif d.simset.simulationType == 3
            tempCells(k) = get_cell_focal_adhesion_forces(tempCells(k),d.sub);
            tempCells(k) = get_edge_forces(tempCells(k),d.spar);
        elseif d.simset.simulationType == 5
            tempCells(k) = get_cell_focal_adhesion_forces(tempCells(k),d.sub);
            tempCells(k) = get_edge_forces(tempCells(k),d.spar);
        end
        
        tempCells(k) = get_cell_total_forces(tempCells(k),d.simset.simulationType);
        if kIteration == 1
            d.cells(k) = save_forces(d.cells(k), tempCells(k), d.simset.simulationType);
        end

    if kIteration == 1
        
        d.cells(k).increments.k1X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k1Y = dt*tempCells(k).forces.totalY;
        
        if max(d.cells(k).increments.k1X.^2 + d.cells(k).increments.k1Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end
        
        d.cells(k).corticalData.perimeter.k1 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);
        strain = (tempCells(k).perimeter - tempCells(k).normPerimeter)/tempCells(k).normPerimeter;
        
    elseif kIteration == 2
        
        d.cells(k).increments.k2X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k2Y = dt*tempCells(k).forces.totalY;
        if max(d.cells(k).increments.k2X.^2 + d.cells(k).increments.k2Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end
        
        d.cells(k).corticalData.perimeter.k2 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);

    elseif kIteration == 3
        
        d.cells(k).increments.k3X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k3Y = dt*tempCells(k).forces.totalY;
        if max(d.cells(k).increments.k3X.^2 + d.cells(k).increments.k3Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end
        
        d.cells(k).corticalData.perimeter.k3 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);

    elseif kIteration == 4
        
        d.cells(k).increments.k4X = dt*tempCells(k).forces.totalX;
        d.cells(k).increments.k4Y = dt*tempCells(k).forces.totalY;
        if max(d.cells(k).increments.k4X.^2 + d.cells(k).increments.k4Y.^2) >= 2*d.spar.cellMaximumMovementSq
            repeat = true;
            return
        end
        
        d.cells(k).corticalData.perimeter.k4 = dt*d.spar.perimeterModelingRate*(tempCells(k).perimeter - tempCells(k).normPerimeter);
    end
end
end