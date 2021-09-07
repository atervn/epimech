function [d, dt, maxmaxMovement] = solve_cells_rk4(d, dt)

tooLargeMovement = 1;

limitSq = 20e-4;

maxmaxMovement = 0;

while tooLargeMovement
    while 1
        while 1
            while 1
                while 1
                    [d, repeat] = get_cell_increment_rk4(d, 1, dt);
                    if repeat
                        dt = dt/2;
                    else
                        break
                    end
                end
                
                [d, repeat] = get_cell_increment_rk4(d, 2, dt);
                if repeat
                    dt = dt/2;
                else
                    break
                end
            end
            
            [d, repeat] = get_cell_increment_rk4(d, 3, dt);
            if repeat
                dt = dt/2;
            else
                break
            end
        end
        
        [d, repeat] = get_cell_increment_rk4(d, 4, dt);
        if repeat
            dt = dt/2;
        else
            break
        end
    end

    for k = 1:length(d.cells)
        
        d.cells(k).movementX = 1/6.*(d.cells(k).increments.k1X + 2.*d.cells(k).increments.k2X + 2.*d.cells(k).increments.k3X + d.cells(k).increments.k4X);
        d.cells(k).movementY = 1/6.*(d.cells(k).increments.k1Y + 2.*d.cells(k).increments.k2Y + 2.*d.cells(k).increments.k3Y + d.cells(k).increments.k4Y);
        
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

for k = 1:length(d.cells)
    d.cells(k).verticesX = d.cells(k).verticesX + d.cells(k).movementX;
    d.cells(k).verticesY = d.cells(k).verticesY + d.cells(k).movementY;
    d.cells(k).normPerimeter = d.cells(k).normPerimeter + 1/6*(d.cells(k).corticalData.perimeter.k1 + 2*d.cells(k).corticalData.perimeter.k2 + 2*d.cells(k).corticalData.perimeter.k3 + d.cells(k).corticalData.perimeter.k4);
end