function d = get_edge_vertices(d)
% GET_EDGE_VERTICES Defines the edge vertices for the cells
%   The functions finds the edge vertices for the cells for the simulations
%   that include the substrate so that an additional force can be added to
%   these vertices. The edge vertices also include the last vertices with
%   junctions. The function also saves the initial vertex positions  for
%   the them.
%   INPUT:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the simulation requires edge vertices
if any(d.simset.simulationType == [2,3,5])
    
    % go through the cells
    for k = 1:length(d.cells)
        
        % if the cell is an edge cell
        if d.cells(k).cellState == 0
            
            % initialize the edge vertices
            d.cells(k).edgeVertices = [];

            % create a vertex index vector
            idx = [1:d.cells(k).nVertices]';
            
            % find the indices where there are changed between the
            % vertexStates ( add zeros to each end to separate the sections
            % that go over the vertex index 1 into to separate sections)
            transitions = diff([0 ; d.cells(k).vertexStates == 0 ; 0]);
            
            % find the indices where a section of nonjunction vertices
            % begins and ends and the distance between the consequtive
            % start and end indices in the duplicated vector
            runStarts = find(transitions == 1);
            runEnds = find(transitions == -1);
            runlengths = runEnds - runStarts;
            
            % find the indices
            startIdx = idx(runStarts);
            endIdx = idx(runEnds-1);
            
            % find the sections of nonjunction vertices with more than 3
            % consequtive vertices
            longRuns = find(runlengths >= 4);
            
            % go through the long sections
            for i = longRuns'
                
                % if the section begins at index 1 (indicating that the
                % section goes over the index 1)
                if startIdx(i) == 1
                    
                    % get the section start
                    startTemp = 1;
                    
                % otherwise
                else
                    
                    % get the section start - 1 (to get the index of the
                    % last vertex with a junction)
                    startTemp = startIdx(i) - 1;
                end
                
                % if the end vertex is the last vertex (indicating that the
                % section goes over the index 1)
                if endIdx(i) == d.cells(k).nVertices
                    
                    % get the section start
                    endTemp = endIdx(i);
                    
                % otherwise
                else
                    
                    % get the section start + 1 (to get the index of the
                    % next vertex with a junction)
                    endTemp = endIdx(i) + 1;
                end
                
                % add the indices of the vertices between the start and the
                % end
                d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; (startTemp:endTemp)'];

            end
            
            % save the initial coordinates for the edge vertices
            d.cells(k).edgeInitialX = d.cells(k).verticesX(d.cells(k).edgeVertices);
            d.cells(k).edgeInitialY = d.cells(k).verticesY(d.cells(k).edgeVertices); 
        end
    end
end

end