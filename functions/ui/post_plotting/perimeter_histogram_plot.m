function perimeter_histogram_plot(app)

figure(3);
clf;
ax = axes;

folderExists2 = exist([app.plotImport(app.selectedFile).folderName '/perimeters'],'dir') == 7;

if ~folderExists2
    d = [];
    cells = import_cells(app,d,'post_plotting');
    tempPerimeters = zeros(1,length(cells));
    cells = get_boundary_vectors(cells);
    cells = get_boundary_lengths(cells);
    for k = 1:length(cells)
        tempPerimeters(k) = sum(cells(k).leftLengths);
    end
else
    tempPerimeters = csvread([app.plotImport(app.selectedFile).folderName '/perimeters/perimeters_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
end

tempPerimeters = tempPerimeters.*app.plotImport(app.selectedFile).scaledParameters.scalingLength*1e6;
maxBin = 10*ceil((max(tempPerimeters)+10)/10);
xlim([0, maxBin]);
histogram(ax,tempPerimeters,[0:5:maxBin],'FaceColor',[0.4 0.6 1],'EdgeColor',[0.4 0.6 1])

ylabel('number')
xlabel('Cell perimeters (\mum)')
ax.FontSize=10;