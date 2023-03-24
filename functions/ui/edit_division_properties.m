function d = edit_division_properties(d)
% EDIT_DIVISION_PROPERTIES Edit division properties prior simulation
%   The function edits the cells' division properties if needed before a
%   simulation.
%   INPUT:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(d.cells)
    
    % growth simulation
    if d.simset.simulationType == 1
        
        % if division until end or dividion until a time that is nonzero
        if d.simset.division.type == 1 || (simset.division.type == 2 && d.spar.stopDivisionTime > 0)
            
            % if division state is 0
            if d.cells(k).division.state == 0
                
                % calculate new cell division times
                d.cells(k).division.time = d.spar.divisionTimeMean + randn*d.spar.divisionTimeSD;
            end
        else
            
            % set the division time to zero and division state to 0
            d.cells(k).division.time = 0;
            d.cells(k).division.state = -1;
        end
       
    % if division is not included
    elseif d.simset.substrateIncluded
        
        % if division state from the imported simulation is nonzero (e.g.
        % if a cell at the end of the previous simulation was dividing at
        % the end)
        if d.cells(k).division.state > 0
            
            % set the division state to -1 and the normal area based on the
            % the current cell area times a multiplier to account for the
            % cortical contractility
            d.cells(k).division.state = -1;
            d.cells(k).normArea = d.cells(k).area*1.1;
        end
    end
end

end