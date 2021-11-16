function cells = change_cell_state(cells)
% CHANGE_CELL_STATE Changes the state of cell between edge and internal
%   The function checks if it is an internal or edge based on its number of
%   continuous nonjunctional vertices.
%   INPUTS:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% check if there are contacts with other cells
if cells.contacts.present
    
    % find the noncontact vertices
    contactsTemp = cells.contacts.atLeastOne == 0;
    
    % copy it end to end
    contactsTemp2 = [contactsTemp;contactsTemp];
    
    % find the longest relative segement of nonjunctional vertices, based on
    % https://se.mathworks.com/matlabcentral/answers/281373-longest-sequence-of-1s#answer_219724
    longest = max(accumarray(nonzeros((cumsum(~contactsTemp2)+1).*contactsTemp2),1))/cells.nVertices;
    
    % if the cell is an edge cell
    if cells.cellState == 0
        
        % if the longest relative section is below 10 % (or if the cell has no
        % junctions, set the cell state to internal
        if (~isempty(longest) && longest < 0.05) || all(~contactsTemp)
            cells.cellState = 1;
        end
        
        % if the cell is an internal cell
    else
        
        % if the longest relative section is above 10 %, set the cell state to
        % edge
        if (~isempty(longest) && longest(1) >= 0.05)
            cells.cellState = 0;
        end
    end
    
end

end