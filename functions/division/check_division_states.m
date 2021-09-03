function d = check_division_states(d, time, dt)

% goes through the cells
for k = 1:length(d.cells)
    
    vertexStatesTemp = d.cells(k).vertexStates == 0;
    
    vertexStatesTemp2 = [vertexStatesTemp;vertexStatesTemp];
    % based on https://se.mathworks.com/matlabcentral/answers/281373-longest-sequence-of-1s#answer_219724
    longest = max(accumarray(nonzeros((cumsum(~vertexStatesTemp2)+1).*vertexStatesTemp2),1))/d.cells(k).nVertices;
    
    if d.cells(k).cellState == 0
        if (~isempty(longest) && longest < 0.1) || all(~vertexStatesTemp)
            d.cells(k).cellState = 1;
        end
    else
        if (~isempty(longest) && longest(1) >= 0.1)
            d.cells(k).cellState = 0;
        end
    end
     
    % check if the division state is 0 (not growing/dividing)
    if d.cells(k).cellState == 0 && d.cells(k).division.state == 0
        
        if ~(d.simset.divisionType == 2 && time >= d.spar.stopDivisionTime)
            

            % checks if the division time for the cell has been passed
            if d.cells(k).division.time < time

                % sets the division state to 1 (growing)
                d.cells(k).division.state = 1;
                
                if d.simset.sizeType == 1
                    newAreas = ones(2,1).*d.spar.normArea;
                elseif d.simset.sizeType == 2
                    [newAreas, d.simset] = get_new_cell_areas(d.spar,d.cells(k).normArea,d.simset); 
                end
                
                sumAreas = sum(newAreas);
                d.cells(k).division.targetArea = sumAreas;
                d.cells(k).division.newAreas = newAreas;
                d.cells(k).normArea = d.spar.cellGrowthConstant*d.cells(k).division.targetArea;
                d.cells(k).division.time = time + d.spar.maximumGrowthTime;

            end
        end
        
    elseif d.cells(k).cellState == 1 && d.cells(k).division.state == 0 && ~(d.simset.divisionType == 2 && time >= d.spar.stopDivisionTime)
        
        areaFactor = d.spar.baseDivisionRate*d.cells(k).area^d.spar.divisionRateExponents;
        
        if d.cells(k).division.time < time && rand < dt*areaFactor
            d.cells(k).division.state = 1;
            
            if d.simset.sizeType == 1
                newAreas = ones(2,1).*d.spar.normArea;
            elseif d.simset.sizeType == 2
                newAreas = get_new_cell_areas(d.spar,d.cells(k).normArea,d.simset);
            end
            
            sumAreas = sum(newAreas);
            d.cells(k).division.targetArea = sumAreas;
            d.cells(k).division.newAreas = newAreas;
            d.cells(k).normArea = d.spar.cellGrowthConstant*d.cells(k).division.targetArea;
            d.cells(k).division.time = time + d.spar.maximumGrowthTime;
            
        end
        
        % checks if the division state is 1 (growing)
    elseif d.cells(k).division.state == 1
        
        % checks if the area of the cells increased to the required area
        if d.cells(k).division.time < time || d.cells(k).area >= d.cells(k).division.targetArea

            % sets the division state to 2 (ready to divide)
            d = setup_division(d,k);
            d.cells(k).normArea = d.cells(k).division.targetArea;
            d.cells(k).division.state = 2;
            d.cells(k).corticalTension = d.spar.fCortex;
            d.cells(k).division.time = time + d.spar.maximumDivisionTime;
        end 
    end
end

end