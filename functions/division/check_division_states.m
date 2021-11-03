function d = check_division_states(d, time, dt)
% CHECK_DIVISION_STATES Check and change the cell division states
%   The function goes through each cell to check if there needs to be
%   changes in its division state and changes it is required.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%       dt: current time step
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% goes through the cells
for k = 1:length(d.cells)
    
    % change cell state (between edge and internal)
    d.cells(k) = change_cell_state(d.cells(k));
    
    % if the cell is an edge cell and it is not growing or dividing (and if
    % division time has not been passed it the division type is 2)
    if d.cells(k).cellState == 0 && d.cells(k).division.state == 0 && ~(d.simset.division.type == 2 && time >= d.spar.stopDivisionTime)
        
        % checks if the division time for the cell has been passed
        if d.cells(k).division.time < time
            
            % sets the division state to 1 (growing)
            d.cells(k).division.state = 1;
            
            % get the areas of the daughter cells
            if d.simset.division.sizeType == 1
                
                % with uniform cell size
                newAreas = ones(2,1).*d.spar.normArea;
                
            elseif d.simset.division.sizeType == 2
                
                % with cell sizes based on the MDCK data
                [newAreas, d.simset] = get_new_cell_areas(d.spar,d.cells(k).normArea,d.simset);
            end

            % set the new target areas, save the new areas, set the normal
            % area (multiplied by the growth constant), and calculate the
            % time after which cytokinesis will begin independent of the
            % cell growth
            d.cells(k).division.targetArea = sum(newAreas);
            d.cells(k).division.newAreas = newAreas;
            d.cells(k).normArea = d.spar.cellGrowthConstant*d.cells(k).division.targetArea;
            d.cells(k).division.time = time + d.spar.maximumGrowthTime;
            d.simset.calculateForces.area(k) = true;
        end
    
    % if the cell is an internal cell, not growing or dividing, and that
    % the cell's division time has been passed (and if division time has
    % not been passed it the division type is 2)
    elseif d.cells(k).cellState == 1 && d.cells(k).division.state == 0 && d.cells(k).division.time < time && ~(d.simset.division.type == 2 && time >= d.spar.stopDivisionTime)
        
        % calculate the factor describing the effect or area on the
        % division probability
        areaFactor = d.spar.baseDivisionRate*d.cells(k).area^d.spar.divisionRateExponents;
        
        % Depending on the time step, check if cell is to divide
        if rand < dt*areaFactor
            
            % sets the division state to 1 (growing)
            d.cells(k).division.state = 1;
            
            % get the areas of the daughter cells
            if d.simset.division.sizeType == 1
                
                % with uniform cell size
                newAreas = ones(2,1).*d.spar.normArea;
                
            elseif d.simset.division.sizeType == 2
                
                % with cell sizes based on the MDCK data
                newAreas = get_new_cell_areas(d.spar,d.cells(k).normArea,d.simset);
            end
            
            % set the new target areas, save the new areas, set the normal
            % area (multiplied by the growth constant), and calculate the
            % time after which cytokinesis will begin independent of the
            % cell growth
            sumAreas = sum(newAreas);
            d.cells(k).division.targetArea = sumAreas;
            d.cells(k).division.newAreas = newAreas;
            d.cells(k).normArea = d.spar.cellGrowthConstant*d.cells(k).division.targetArea;
            d.cells(k).division.time = time + d.spar.maximumGrowthTime;
            d.simset.calculateForces.area(k) = true;
            
        end
        
    % if the cell is growting
    elseif d.cells(k).division.state == 1
        
        % checks if growting time has been passed or if the area of the 
        % cells increased to the required area
        if d.cells(k).division.time < time || d.cells(k).area >= d.cells(k).division.targetArea
            
            % setup the division
            d = setup_division(d,k);
            
            % set the normal areas, division state, and the maximum
            % cytokinesis time
            d.cells(k).normArea = d.cells(k).division.targetArea;
            d.cells(k).division.state = 2;
            d.cells(k).division.time = time + d.spar.maximumDivisionTime;
            d.simset.calculateForces.area(k) = true;
        end
    end
end

end