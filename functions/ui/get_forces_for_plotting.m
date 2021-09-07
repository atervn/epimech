function [vertical,horizontal] = get_forces_for_plotting(app,d,vertical,horizontal,fileIdx,iSimulation,xq,yq,middlePoint)

temp = import_settings([app.CallingApp.plotImport(fileIdx).folderName '/pointlike/pointlike_data.csv']);

pointLikeCell = temp.cell;

substrateForces = {'Total substrate forces','Direct substrate forces','Restorative substrate forces','Repulsion substrate forces','Focal adhesion substrate forces'};

if ~any(strcmp(app.ForceDropDown.Value,substrateForces))
    
    cells = import_cells(app.CallingApp,'post_plotting');
    
    initialCells = import_cells(app.CallingApp,'post_plotting','initial');
    
    cellPositionsX = zeros(1,length(cells));
    cellPositionsY = zeros(1,length(cells));
    forces = zeros(1,length(cells));
    
    for k = 1:length(cells)
        
        cellPositionsX(k) = mean(initialCells(k).verticesX).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
        cellPositionsY(k) = mean(initialCells(k).verticesY).*app.CallingApp.plotImport(fileIdx).scaledParameters.scalingLength.*1e6;
        
        switch app.ForceDropDown.Value
            case 'Total forces'
                forcesTemp = sqrt((cells(k).forces.totalX).^2 + (cells(k).forces.totalY).^2);
            case 'Cortical forces'
                forcesTemp = sqrt((cells(k).forces.corticalX).^2 + (cells(k).forces.corticalY).^2);
            case 'Junction forces'
                forcesTemp = sqrt((cells(k).forces.junctionX).^2 + (cells(k).forces.junctionY).^2);
            case 'Division forces'
                forcesTemp = sqrt((cells(k).forces.divisionX).^2 + (cells(k).forces.divisionY).^2);
            case 'Membrane forces'
                forcesTemp = sqrt((cells(k).forces.membraneX).^2 + (cells(k).forces.membraneY).^2);
            case 'Contact forces'
                forcesTemp = sqrt((cells(k).forces.contactX).^2 + (cells(k).forces.contactY).^2);
            case 'Area forces'
                forcesTemp = sqrt((cells(k).forces.areaX).^2 + (cells(k).forces.areaY).^2);
            case 'Pointlike forces'
                forcesTemp = sqrt((cells(k).forces.pointlikeX).^2 + (cells(k).forces.pointlikeY).^2);
            case 'Focal adhesion forces'
                forcesTemp = sqrt((cells(k).forces.substrateX).^2 + (cells(k).forces.substrateY).^2);
        end
        
        switch app.TypeDropDown.Value
            case 'Average'
                forces(k) = mean(forcesTemp);
            case 'Maximum'
                forces(k) = max(forcesTemp);
            case 'Minimum'
                forces(k) = min(forcesTemp);
        end
    end
    
    moveX = -cellPositionsX(pointLikeCell);
    moveY = -cellPositionsY(pointLikeCell);
    
    cellPositionsX = cellPositionsX + moveX;
    cellPositionsY = cellPositionsY + moveY;
    
    dispData = griddata(cellPositionsX,cellPositionsY,forces,xq,yq,'cubic');
    
else
    if exist([app.CallingApp.plotImport(fileIdx).folderName '/substrate'],'dir') == 7
        
        timePoint = app.CallingApp.plotImport(fileIdx).currentTimePoint;
        
        importedPoints = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate/substrate_points_' num2str(timePoint) '.csv']);
        pointsX = importedPoints(:,1);
        pointsY = importedPoints(:,2);
        
        initialCells = import_cells(app.CallingApp,'post_plotting','initial');
        
        moveX = -mean(initialCells(pointLikeCell).verticesX).*d.spar.scalingLength.*1e6;
        moveY = -mean(initialCells(pointLikeCell).verticesY).*d.spar.scalingLength.*1e6;
        
        switch app.ForceDropDown.Value
            case 'Total substrate forces'
                importForces = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate_forces/total/total_' num2str(timePoint) '.csv']);
                forces = sqrt(importForces(:,1).^2 + importForces(:,2).^2);
            case 'Direct substrate forces'
                importForces = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate_forces/direct/direct_' num2str(timePoint) '.csv']);
                forces = sqrt(importForces(:,1).^2 + importForces(:,2).^2);
            case 'Restorative substrate forces'
                importForces = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate_forces/restoration/restoration_' num2str(timePoint) '.csv']);
                forces = sqrt(importForces(:,1).^2 + importForces(:,2).^2);
            case 'Repulsion substrate forces'
                importForces = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate_forces/repulsion/repulsion_' num2str(timePoint) '.csv']);
                forces = sqrt(importForces(:,1).^2 + importForces(:,2).^2);
            case 'Focal adhesion substrate forces'
                importForces = csvread([app.CallingApp.plotImport(fileIdx).folderName '/substrate_forces/focal_adhesion/focal_adhesion_' num2str(timePoint) '.csv']);
                forces = sqrt(importForces(:,1).^2 + importForces(:,2).^2);
                
        end
        
        
        subX = pointsX*d.spar.scalingLength/1e-6 + moveX;
        subY = pointsY*d.spar.scalingLength/1e-6 + moveY;
        
        dispData = griddata(subX,subY,forces,xq,yq,'cubic');
        
    else
        vertical = -1;
        return
    end
end

if horizontal == -1
    vertical(:,:,iSimulation) = dispData;
else
    vertical(:,iSimulation) = dispData(:,end);
    if app.HorizontalCheckBox_2.Value
        horizontal(:,iSimulation) = dispData(middlePoint,1:end);
    end
end