function d = remove_vertices(d)
% REMOVE_VERTICES Remove vertices from the cell boundaries
%   The function goes through the cells to check if there are vertices with
%   too acute angles or if there is too short section.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% reset the junction modification to false
d.simset.junctionModification = false;

% the lower length limit of the boundary sections
lengthLimit = d.spar.membraneLength*0.5;

% go through the cells
for k = length(d.cells):-1:1
    
    % variable to indicate if the cell is to be removed do to having too
    % few vertices left
    cellRemoved = 0;
    
    %% Removal by angle
    
    % find the vertices with too large or small angles
    vertices2Remove = find(d.cells(k).outsideAngles < d.spar.maxMembraneAngle + d.cells(k).outsideAngles > 2*pi-d.spar.maxMembraneAngle);
    
    % if cell is in cytokinesis, remove the division vertices from the
    % vertices to be removed if they are included
    if d.cells(k).division.state == 2
        for i = 1:2
            vertices2Remove(vertices2Remove == d.cells(k).division.vertices(i)) = [];
        end
    end
    
    % if there still are vertices to remove
    if numel(vertices2Remove) ~= 0
        
        % go through the vertices to remove
        for i = length(vertices2Remove):-1:1
            
            % remove the vertices and edit junction and focal adhesion
            % information
            d = vertex_removal(d,k,vertices2Remove(i));
            
            % get the new cell vertex number
            d.cells(k).nVertices = size(d.cells(k).verticesX,1);
            
            % if there are fewer than 5 vertices in the cell,
            if d.cells(k).nVertices < 5
                cellRemoved = 1;
                break
            end
        end      
    end
    
    %% Remove by length
    
    % if the cell is not to be removed
    if ~cellRemoved
        
        % calculate vectors and lengths
        d.cells(k) = get_boundary_vectors(d.cells(k));
        d.cells(k) = get_boundary_lengths(d.cells(k));
        
        % find boundary sections that are too short
        vertices2Remove = find(d.cells(k).leftLengths < lengthLimit);
        
        % if the cell is in cytokinesis, remove the division vertices from
        % vertices to be removed
        if d.cells(k).division.state == 2
            for i = 1:2
                vertices2Remove(vertices2Remove == d.cells(k).division.vertices(i)) = [];
            end
        end
        
        % if there still are vertices to remove
        if numel(vertices2Remove) ~= 0
            
            % variable to save if the first vertex of the cell has been
            % removed
            firstHasBeenRemoved = false;
            
            % go through the vertices to remove in reverse order
            for i = length(vertices2Remove):-1:1
                
                
                if vertices2Remove(i) == 0 && firstHasBeenRemoved
                    break;
                end
                
                % if the short boundary is the one following the last
                % vertex
                if vertices2Remove(i) == length(d.cells(k).verticesX)
                    
                    % to decide which of the vertices defining the short
                    % boundary, find the which has the shorted boundary
                    % section on the other side and select that for removal
                    if d.cells(k).rightLengths(vertices2Remove(i)) < d.cells(k).leftLengths(1)
                        vertex2Remove = vertices2Remove(i);
                    else
                        
                        % make sure this is not a division vertex
                        if any(d.cells(k).division.vertices == 1)
                            
                            % if yes, remove the one with the longer
                            % neighboring boundary section
                            vertex2Remove = vertices2Remove(i);
                        else
                            
                            % if not, remove the first vertex, set the
                            % firstHasBeenRemoved to true, and substrate
                            % the vertice2Remove indices by one
                            vertex2Remove = 1;
                            firstHasBeenRemoved = true;
                            vertices2Remove = vertices2Remove - 1;
                        end
                    end
                
                % not the last boundary section
                else
                    
                    % find the shorter neighboring boundary section
                    if d.cells(k).rightLengths(vertices2Remove(i)) < d.cells(k).leftLengths(vertices2Remove(i)+1)
                        vertex2Remove = vertices2Remove(i);
                    else
                        
                        % make sure it is not a division vertex
                        if any(vertices2Remove(i)+1 == d.cells(k).division.vertices)
                            vertex2Remove = vertices2Remove(i);
                        else
                            vertex2Remove = vertices2Remove(i)+1;
                        end
                    end
                end
                
                % remove the selected vertex
                d = vertex_removal(d,k,vertex2Remove);
                
                % if there are fewer than 5 vertices in the cell,
                if d.cells(k).nVertices < 5
                    break
                end
                
                % calculate vectors and lengths
                d.cells(k) = get_boundary_vectors(d.cells(k));
                d.cells(k) = get_boundary_lengths(d.cells(k));
            end
                       
            % calculate lengths, vectors, areas and update the number of
            % vertices
            d.cells(k) = get_boundary_vectors(d.cells(k));
            d.cells(k) = get_boundary_lengths(d.cells(k));
            d.cells(k) = get_vertex_angles(d.cells(k));
            d.cells(k).nVertices = size(d.cells(k).verticesX,1);
        end
    end
    
    % get the linear indeces of the substrate stuff
    if any(d.simset.simulationType == [2,3,5])
        d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
        d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
    end
end

end