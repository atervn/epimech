function [d, endLoop] = try_placing_cell(d,app)

endLoop = 0;

try
    coordsTemp = ginput(1);
    app.cellCenters(end+1,:) = coordsTemp;
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
    d = single_cell_initialization(d,app.cellCenters(end,:));
else
    app.cellCenters(end,:) = [];
end

end