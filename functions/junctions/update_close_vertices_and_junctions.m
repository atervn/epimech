function d = update_close_vertices_and_junctions(d,time)
% UPDATE_CLOSE_VERTICES_AND_JUNCTIONS Update junction and contact data
%   The function removes and creates junctions as well as finds the closest
%   vertices in other cell for each vertex.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% junction are not edited in pointlike micromanipulation simulations
% (simulation type 2)
if any(d.simset.simulationType == [1 3 5])
    
    % if the junctions are currently not yet to be modified
    if ~d.simset.junctionModification
        
        % check if the current time equals any of the junction modification
        % times (defined by the junction modification time step)
        d.simset.junctionModification = mod(time,d.spar.junctionModificationTimeStep) == 0;
    end
    
    % if junctions are to be modified, remove junctions if required
    if d.simset.junctionModification
        d = remove_junctions(d);
    end
end

% find the closest vertices in other cells
d = find_closest_vertices(d);

% if junctions are to be modified, create new junctions
if d.simset.junctionModification
    d = form_junctions(d);
end

% set junction modfication to false
d.simset.junctionModification = false;

end