function d = setup_pointlike_settings(d,app)

if d.simset.simulationType == 2
    if app.UseimportedmovementdataCheckBox.Value
        
        pointlikeData = import_settings([app.import.folderName '/pointlike/pointlike_data.csv']);
        
        d.simset.pointlike.cell = pointlikeData.cell;
        d.simset.pointlike.originalX = pointlikeData.originalX;
        d.simset.pointlike.originalY = pointlikeData.originalY;
        
        originalVertices = csvread([app.import.folderName '/pointlike/original_vertex_locations.csv']);
        d.simset.pointlike.vertexOriginalX = originalVertices(:,1);
        d.simset.pointlike.vertexOriginalY = originalVertices(:,2);

        time = convert_import_time(app,app.import.currentTimePoint,'numberToTime');
        
        previousTime = max(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime <= time));
        nextTime = min(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime > time));
        
        previousIdx = find(d.simset.pointlike.movementTime == previousTime);
        nextIdx = find(d.simset.pointlike.movementTime == nextTime);
        
        if previousTime == time
            displacementY = d.simset.pointlike.movementY(previousIdx);
        else
            displacementY = d.simset.pointlike.movementY(previousIdx) + (d.simset.pointlike.movementY(nextIdx) - d.simset.pointlike.movementY(previousIdx))*(time - d.simset.pointlike.movementY(previousIdx))/(d.simset.pointlike.movementTime(nextIdx) - d.simset.pointlike.movementTime(previousIdx));
        end

        
        d.simset.pointlike.movementTime = d.simset.pointlike.movementTime - time;
        tempIdx = find(d.simset.pointlike.movementTime <= 0);
        d.simset.pointlike.movementTime(tempIdx) = [];
        d.simset.pointlike.movementTime = [0 ; 2*d.simset.pointlike.movementTime];
        
        if max(tempIdx) > 1
            d.simset.pointlike.movementY(1:max(tempIdx)-1) = [];
            d.simset.pointlike.movementY = [displacementY ; d.simset.pointlike.movementY];
        else
            d.simset.pointlike.movementY(1) = displacementY;
        end
        
        multiplier = (2 - abs(max(d.simset.pointlike.vertexOriginalY) - d.simset.pointlike.originalY))/2;
        
        d.simset.pointlike.pointY = d.simset.pointlike.originalY + displacementY;
        
        d.simset.pointlike.vertexY = d.simset.pointlike.vertexOriginalY + displacementY.*multiplier;
        d.simset.pointlike.vertexX = d.simset.pointlike.vertexOriginalX;
        
    else
        if app.SelectcentercellCheckBox.Value
            app.pointlikeProperties.cell = get_center_cell(d.cells);
        end

        d.simset.pointlike.cell = app.pointlikeProperties.cell;
        d.simset.pointlike.pointX = mean(d.cells(d.simset.pointlike.cell).verticesX);
        d.simset.pointlike.pointY = mean(d.cells(d.simset.pointlike.cell).verticesY);
        d.simset.pointlike.originalX = d.simset.pointlike.pointX;
        d.simset.pointlike.originalY = d.simset.pointlike.pointY;
        d.simset.pointlike.vertexX = d.cells(d.simset.pointlike.cell).verticesX;
        d.simset.pointlike.vertexY = d.cells(d.simset.pointlike.cell).verticesY;
        d.simset.pointlike.vertexOriginalX = d.cells(d.simset.pointlike.cell).verticesX;
        d.simset.pointlike.vertexOriginalY = d.cells(d.simset.pointlike.cell).verticesY;
        
    end
end

end