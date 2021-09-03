function d = get_substrate_edge_points(d)

if any(d.simset.simulationType == [2,5])
    
    tempMat = d.sub.emptyMatrix;
    
    tempMat(d.sub.interactionLinIdx) = 1;
    tempMat(d.sub.counterInteractionLinIdx) = 1;
    
    d.sub.edgePoints = sum(tempMat,1) < 6;
end

end