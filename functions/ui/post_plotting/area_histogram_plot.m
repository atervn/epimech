function area_histogram_plot(app)

figure(2);
clf;
ax = axes;

folderExists = exist([app.plotImport(app.selectedFile).folderName '/areas'],'dir') == 7;

if ~folderExists
    
    d = [];
    
    cells = import_cells(app,d,'post_plotting');
    
    tempAreas = zeros(1,length(cells));
    for k = 1:length(cells)
        tempAreas(k) = calculate_area(cells(k).verticesX,cells(k).verticesY);
    end
else
    tempAreas = csvread([app.plotImport(app.selectedFile).folderName '/areas/areas_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
end

tempAreas = tempAreas.*app.plotImport(app.selectedFile).scaledParameters.scalingLength^2*1e12;
maxBin = 20*ceil((max(tempAreas)+20)/20);
xlim([0, maxBin]);

histogram(ax,tempAreas,[0:20:maxBin],'FaceColor',[1 0.6 0.4],'EdgeColor',[1 0.6 0.4])

ylabel('number')
xlabel('Cell areas (\mum^2)')
ax.FontSize=10;