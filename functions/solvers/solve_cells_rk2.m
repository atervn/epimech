function [d, dt, maxmaxMovement] = solve_cells_rk2(d, dt, time)

tooLargeMovement = 1;

maxmaxMovement = 0;

while tooLargeMovement
    
    while 1
        while 1
            [d, repeat] = get_cell_increment_rk2(d, 1, dt);
            if repeat; dt = dt/2; else; break; end
        end
        
        [d, repeat] = get_cell_increment_rk2(d, 2, dt);
        if repeat; dt = dt/2; else; break; end
    end
    
    if d.simset.simulationType == 4
        nCells = length(d.cells) - 1;
    else
        nCells = length(d.cells);
    end
    
    for k = 1:nCells
        
        d.cells(k).movementX = d.cells(k).increments.k1X./2 + d.cells(k).increments.k2X./2;
        d.cells(k).movementY = d.cells(k).increments.k1Y./2 + d.cells(k).increments.k2Y./2;
        
        maxMovement = max(d.cells(k).movementX.^2 + d.cells(k).movementY.^2);
        
        if maxmaxMovement < maxMovement
            maxmaxMovement = maxMovement;
        end
        if maxMovement >= d.spar.cellMaximumMovementSq
            dt = dt/2;
            tooLargeMovement = 1;
            break;
        else
            tooLargeMovement = 0;
        end
    end
end

if maxmaxMovement <= d.spar.cellMinimumMovementSq
    multiplier = 2;
else
    multiplier = 1;
end
while 1
    if round( ((floor(time/d.spar.maximumTimeStep+1e-10)*d.spar.maximumTimeStep + d.spar.maximumTimeStep) - (multiplier*dt+time)),10) >= 0
        dt = dt*multiplier;
        break;
    else
        multiplier = multiplier/2;
    end
end

if d.simset.simulationType == 4
    nCells = length(d.cells) - 1;
else
    nCells = length(d.cells);
end

for k  = 1:nCells
    d.cells(k).verticesX = d.cells(k).verticesX + d.cells(k).movementX;
    d.cells(k).verticesY = d.cells(k).verticesY + d.cells(k).movementY;
    d.cells(k).normPerimeter = d.cells(k).normPerimeter + d.cells(k).corticalData.perimeter.k1/2 + d.cells(k).corticalData.perimeter.k2/2;
end