function dispData = get_area_displacements(app,d,dispData,fileIdx,iSimulation,xq,yq)

initialTime = find(strcmp(app.StartDropDown.Items, app.StartDropDown.Value));
endTime = find(strcmp(app.EndDropDown.Items, app.EndDropDown.Value));

temp = import_settings([app.CallingApp.plotImport(fileIdx).folderName '/pointlike/pointlike_data.csv']);

pointLikeCell = temp.cell;

if app.CellsButton.Value
    app.CallingApp.plotImport(fileIdx).currentTimePoint = initialTime;
    
    initialCells = import_cells(app.CallingApp,d,'post_plotting');
    
    app.CallingApp.plotImport(fileIdx).currentTimePoint = endTime;
    
    endCells = import_cells(app.CallingApp,d,'post_plotting');
    
    initialCellCenterX = zeros(1,length(initialCells));
    initialCellCenterY = zeros(1,length(initialCells));
    finalCellCenterX = zeros(1,length(endCells));
    finalCellCenterY = zeros(1,length(endCells));
    
    
    
    for k = 1:length(endCells)
        initialCellCenterX(k) = mean(initialCells(k).verticesX).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
        initialCellCenterY(k) = mean(initialCells(k).verticesY).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
        finalCellCenterX(k) = mean(endCells(k).verticesX).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
        finalCellCenterY(k) = mean(endCells(k).verticesY).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
    end
    
    displacements = sqrt((initialCellCenterX - finalCellCenterX).^2 + (initialCellCenterY - finalCellCenterY).^2);
    
    moveX = -initialCellCenterX(pointLikeCell);
    moveY = -initialCellCenterY(pointLikeCell);
    
    initialCellCenterX = initialCellCenterX + moveX;
    initialCellCenterY = initialCellCenterY + moveY;
    
    dispData(:,:,iSimulation) = griddata(initialCellCenterX,initialCellCenterY,displacements,xq,yq,'cubic');
    
else
    if exist([app.CallingApp.plotImport(fileIdx).folderName '/substrate'],'dir') == 7
        
        importedPoints = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate/substrate_points_' num2str(initialTime) '.csv']);
        initialPointsX = importedPoints(:,1);
        initialPointsY = importedPoints(:,2);
        
        importedPoints = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate/substrate_points_' num2str(endTime) '.csv']);
        endPointsX = importedPoints(:,1);
        endPointsY = importedPoints(:,2);
        
        initialCells = import_cells(app.CallingApp,d,'post_plotting',1);
        
        moveX = -mean(initialCells(pointLikeCell).verticesX).*d.spar.scalingLength.*1e6;
        moveY = -mean(initialCells(pointLikeCell).verticesY).*d.spar.scalingLength.*1e6;
        
        displacements = sqrt((endPointsX - initialPointsX).^2 + (endPointsY - initialPointsY).^2)*d.spar.scalingLength/1e-6;
        
        subX = initialPointsX*d.spar.scalingLength/1e-6 + moveX;
        subY = initialPointsY*d.spar.scalingLength/1e-6 + moveY;
        
        dispData(:,:,iSimulation) = griddata(subX,subY,displacements,xq,yq,'cubic');
        
    else
        dispData = -1;
        return
    end
    
end