function perimeter_plot(app)

p75 = [];
med = [];
p25 = [];
maxs = [];
mins = [];
folderExists = exist([app.plotImport(app.selectedFile).folderName '/perimeters'],'dir') == 7;

currentTimePoint = app.plotImport(app.selectedFile).currentTimePoint;

if isempty(app.selectedCells)

for i = 1:app.plotImport(app.selectedFile).nTimePoints
    if ~folderExists
        app.plotImport(app.selectedFile).currentTimePoint = i;
        d = [];
        [~,cells] = import_cells(app,d,'post_plotting');
        
        tempPerimeters = zeros(1,length(cells));
        cells = get_boundary_vectors(cells);
        cells = get_boundary_lengths(cells);
        for k = 1:length(cells)
            tempPerimeters(k) = sum(cells(k).leftLengths);
        end
    else
        tempPerimeters = csvread([app.plotImport(app.selectedFile).folderName '/perimeters/perimeters_' num2str(i), '.csv']);
    end
    
    tempPerimeters = tempPerimeters.*app.plotImport(app.selectedFile).scaledParameters.scalingLength*1e6;
    
    p75 = [p75 prctile(tempPerimeters,75)]; %#ok<AGROW>
    med = [med median(tempPerimeters)]; %#ok<AGROW>
    p25 = [p25 prctile(tempPerimeters,25)]; %#ok<AGROW>
    maxs = [maxs max(tempPerimeters)]; %#ok<AGROW>
    mins = [mins min(tempPerimeters)]; %#ok<AGROW>
    
end
times = (0:app.plotImport(app.selectedFile).nTimePoints-1)*app.plotImport(app.selectedFile).exportOptions.exportDt*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
if times(end) <= 60
    timeUnit =  's';
elseif times(end) <= 2*60*60
    times = times/60;
    timeUnit =  'min';
elseif times(end) <= 2*24*60*60
    times = times/60/60;
    timeUnit =  'h';
else
    times = times/60/60/24;
    timeUnit =  'd';
end

figure(3);

area(times,maxs,'FaceColor',[0.8 0.95 1],'LineStyle','none');
hold on
area(times,p75,'FaceColor',[0.7 0.9 1],'LineStyle','none');
area(times,p25,'FaceColor',[0.8 0.95 1],'LineStyle','none');
area(times,mins,'FaceColor',[1 1 1],'LineStyle','none');
plot(times,med,'Color',[0.4 0.6 1],'LineWidth',3);
hold off
ylabel('Cell perimeters (\mum)')
xlabel(['Time (' timeUnit ')'])
xlim([times(1) times(end)])

else
    
    perimeterData = nan(app.plotImport(app.selectedFile).nTimePoints,length(app.selectedCells));
    
    for i = 1:app.plotImport(app.selectedFile).nTimePoints
        
        app.plotImport(app.selectedFile).currentTimePoint = i;
        d = [];
        [~,cells] = import_cells(app,d,'post_plotting');
        cells = get_boundary_vectors(cells);
        cells = get_boundary_lengths(cells);
        
        tempCellN = 1;
        
        for k = 1:length(cells)
            if any(k == app.selectedCells)
                perimeterData(i,tempCellN) = sum(cells(k).leftLengths);
                tempCellN = tempCellN + 1;
            end
        end
        
        
    end
    
    times = (0:app.plotImport(app.selectedFile).nTimePoints-1)*app.plotImport(app.selectedFile).exportOptions.exportDt*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    if times(end) <= 60
        timeUnit =  's';
    elseif times(end) <= 2*60*60
        times = times/60;
        timeUnit =  'min';
    elseif times(end) <= 2*24*60*60
        times = times/60/60;
        timeUnit =  'h';
    else
        times = times/60/60/24;
        timeUnit =  'd';
    end
    
    figure(3);
    
    plot(times,perimeterData);
    ylabel('Cell perimeters (\mum)')
    xlabel(['Time (' timeUnit ')'])
    xlim([times(1) times(end)])
    l = legend;
    for k = 1:length(l.String)
       l.String{k} = ['cell ' num2str(app.selectedCells(k))]; 
    end
end

app.plotImport(app.selectedFile).currentTimePoint = currentTimePoint;