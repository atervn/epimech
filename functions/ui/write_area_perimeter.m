function write_area_perimeter(app)

folderExists = exist([app.plotImport(app.selectedFile).folderName '/areas'],'dir') == 7;

if ~folderExists
    
    cells = import_cells(app,'post_plotting');
    
    tempAreas = zeros(1,length(cells));
    for k = 1:length(cells)
        tempAreas(k) = calculate_area(cells(k).verticesX,cells(k).verticesY);
    end
else
    tempAreas = csvread([app.plotImport(app.selectedFile).folderName '/areas/areas_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
end

folderExists2 = exist([app.plotImport(app.selectedFile).folderName '/perimeters'],'dir') == 7;

if ~folderExists2
    
    if ~folderExists
        cells = import_cells(app,'post_plotting');
    end
    tempPerimeters = zeros(1,length(cells));
    cells = get_boundary_vectors(cells);
    cells = get_boundary_lengths(cells);
    for k = 1:length(cells)
        tempPerimeters(k) = sum(cells(k).leftLengths);
    end
else
    tempPerimeters = csvread([app.plotImport(app.selectedFile).folderName '/perimeters/perimeters_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
end

tempAreas = tempAreas.*app.plotImport(app.selectedFile).scaledParameters.scalingLength^2*1e12;
tempPerimeters = tempPerimeters.*app.plotImport(app.selectedFile).scaledParameters.scalingLength*1e6;

app.AreaValueLabel.Text = [num2str(round(mean(tempAreas),2),'%6.2f') ' ' char(177) ' ' num2str(round(std(tempAreas),2),'%6.2f') ' ' char(956) 'm' char(178)];
app.PerimeterValueLabel.Text = [num2str(round(mean(tempPerimeters),2),'%6.2f') ' ' char(177) ' ' num2str(round(std(tempPerimeters),2),'%6.2f') ' ' char(956) 'm'];


folderExists3 = exist([app.plotImport(app.selectedFile).folderName '/junctions'],'dir') == 7;
if folderExists3
    
    cells = import_cells(app,'get_neighbors');
    nNeighbors = zeros(length(cells),1);
    for k = 1:length(cells)
        % only take the internal cells with max 20 % non junction points
        if sum(cells(k).junctions.cells(:,1) == 0)/length(cells(k).junctions.cells(:,1)) < 0.2
            neighbors = unique(cells(k).junctions.cells(:));
            neighbors(neighbors == 0) = [];
            nNeighbors(k) = length(neighbors);
        end
    end
    % remove the external cells
    nNeighbors = nonzeros(nNeighbors);
    app.NeighborsValueLabel.Text = [num2str(round(mean(nNeighbors),2),'%6.2f') ' ' char(177) ' ' num2str(round(std(nNeighbors),2),'%6.2f')];
    
else
    app.NeighborsValueLabel.Text = 'No junction data';
end

end
