function area_plot(app)

p75 = [];
med = [];
p25 = [];
maxs = [];
mins = [];
folderExists = exist([app.plotImport(app.selectedFile).folderName '/areas'],'dir') == 7;


for i = 1:app.plotImport(app.selectedFile).nTimePoints
    if ~folderExists
        app.plotImport(app.selectedFile).currentTimePoint = i;
        
        d = [];
        
        cells = import_cells(app,d,'post_plotting');
        
        tempAreas = zeros(1,length(cells));
        for k = 1:length(cells)
            tempAreas(k) = calculate_area(cells(k).verticesX,cells(k).verticesY);
        end
    else
        tempAreas = csvread([app.plotImport(app.selectedFile).folderName '/areas/areas_' num2str(i), '.csv']);
    end
    
    tempAreas = tempAreas.*app.plotImport(app.selectedFile).scaledParameters.scalingLength^2*1e12;
    
    p75 = [p75 prctile(tempAreas,75)]; %#ok<AGROW>
    med = [med median(tempAreas)]; %#ok<AGROW>
    p25 = [p25 prctile(tempAreas,25)]; %#ok<AGROW>
    maxs = [maxs max(tempAreas)]; %#ok<AGROW>
    mins = [mins min(tempAreas)]; %#ok<AGROW>
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

figure(2);
cla;
hold on
area(times,maxs,'FaceColor',[1 0.95 0.8],'LineStyle','none');

area(times,p75,'FaceColor',[1 0.9 0.7],'LineStyle','none');
area(times,p25,'FaceColor',[1 0.95 0.8],'LineStyle','none');
area(times,mins,'FaceColor',[1 1 1],'LineStyle','none');
plot(times,med,'Color',[1 0.6 0.4],'LineWidth',3);
hold off
ylabel('Cell areas (\mum^2)')
xlabel(['Time (' timeUnit ')'])
xlim([times(1) times(end)])