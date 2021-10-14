function placementOK = check_placement(app,d)

if size(app.cellCenters,2) > 1
    distances = sqrt((app.cellCenters(end,1) - app.cellCenters(1:end-1,1)).^2 + (app.cellCenters(end,2) - app.cellCenters(1:end-1,2)).^2);
    tooClose2Cells = distances < 2*d.spar.rCell*d.spar.scalingLength + d.spar.junctionLength*d.spar.scalingLength;
    if any(tooClose2Cells)
        placementOK = 0;
        return
    end
end

placementOK = 1;

end