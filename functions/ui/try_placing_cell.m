function [d, endLoop] = try_placing_cell(app,d)

endLoop = 0;

try
    coordsTemp = ginput(1);
    app.cellCenters(end+1,:) = coordsTemp.*d.spar.scalingLength;
catch
    try
        if ~isempty(app.cellCenters)
            app.SelectcellButton.Enable = 'On';
            app.SimulateButton.Enable = 'On';
        end
    catch
    end
    endLoop = 1;
    return
end

if check_placement(app,d)
    d = create_cell(d,app.cellCenters(end,:),'simple_plot');
else
    app.cellCenters(end,:) = [];
end

end