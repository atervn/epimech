function linesCross = check_line_intersection(vertexX,vertexY,neighborVertexX,neighborVertexY,pairX,pairY,neighborPairX,neighborPairY)
% vertex11,vertex12,vertex21,vertex22)
% vertex pair prevvertex prevpair


    % define a linear problem to find the intersection vertex between two
    % lines going through the two pairs of vertices
    
    A = [pairY-vertexY vertexX-pairX  ; neighborPairY-neighborVertexY neighborVertexX-neighborPairX];
    
    if abs(det(A)) >= 1e-10
        b = [(pairY-vertexY)*vertexX - (pairX-vertexX)*vertexY ; (neighborPairY-neighborVertexY)*neighborVertexX - (neighborPairX-neighborVertexX)*neighborVertexY];
        
        % solve the linear system
        Pint = A\b;
        
        % if the lines segments intersect, all of the following statements are
        % true
        
        
%         T?h?n j?i!!!
        
        if neighborVertexX == neighborPairX
            if Pint(2) > min(pairY,vertexY) && Pint(2) > min(neighborPairY,neighborVertexY) && Pint(2) < max(pairY,vertexY) && Pint(2) < max(neighborPairY,neighborVertexY)
                linesCross = 0;
            else
                linesCross = 1;
            end
        elseif Pint(1) > min(pairX,vertexX) && Pint(1) > min(neighborPairX,neighborVertexX) && Pint(1) < max(pairX,vertexX) && Pint(1) < max(neighborPairX,neighborVertexX)
            
            % if the line segments intersect, the link is not allowed
            linesCross = 0;
        else
            
            % no intersection with the previous link
            linesCross = 1;
        end
    else
        linesCross = 1;
    end

end