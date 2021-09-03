function d = update_close_vertices_and_junctions(d,time)



if any(d.simset.simulationType == [1 5])
    
    if ~d.simset.junctionModification
        d.simset.junctionModification = mod(time,d.spar.junctionModificationTimeStep) == 0;
    end
    if d.simset.junctionModification
        d.cells = remove_junctions(d.cells, d.spar);
    end
end

% d.cells = find_closest_vertices(d.cells, d.spar, d.simset);
d.cells = find_closest_vertices(d.cells, d.spar, d.simset);

if d.simset.junctionModification
    d = form_junctions(d);
end

d.simset.junctionModification = false;