function post_plot_forces(app)

folderName = app.plotImport(app.selectedFile).folderName;

switch app.ForceDropDown.Value
    case 'Total forces'
        forceFolder = [folderName '/cell_forces/total/'];
        force = 'total';
    case 'Cortical forces'
        forceFolder = [folderName '/cell_forces/cortical/'];
        force = 'cortical';
    case 'Junction forces'
        forceFolder = [folderName '/cell_forces/junction/'];
        force = 'junction';
    case 'Division forces'
        forceFolder = [folderName '/cell_forces/division/'];
        force = 'division';
    case 'Membrane forces'
        forceFolder = [folderName '/cell_forces/membrane/'];
        force = 'membrane';
    case 'Contact forces'
        forceFolder = [folderName '/cell_forces/contact/'];
        force = 'contact';
    case 'Area forces'
        forceFolder = [folderName '/cell_forces/area/'];
        force = 'area';
    case 'Pointlike forces'
        forceFolder = [folderName '/cell_forces/pointlike/'];
        force = 'pointlike';
    case 'Focal adhesion forces'
        forceFolder = [folderName '/cell_forces/focal_adhesion/'];
        force = 'focal_adhesion';
end

selectedCells = app.CellsListBox.Value;
for i = 1:length(selectedCells)
    selectedCells{i} = str2double(selectedCells{i});
end
selectedCells = sort(cell2mat(selectedCells));

forceData = zeros(app.plotImport(app.selectedFile).nTimePoints,length(selectedCells));

for i = 1:app.plotImport(app.selectedFile).nTimePoints
    
    tempData = csvread([forceFolder force '_' num2str(i), '.csv']);
    
    for k = 1:length(selectedCells)
        
        importedVertices = csvread([folderName '/vertices/vertices_' num2str(i), '.csv']);
        vertices = importedVertices(:,1+2*(selectedCells(k)-1):2+2*(selectedCells(k)-1));
        nVertices = nnz(vertices(:,1));
        
        forceX = tempData(1:nVertices,1+2*(selectedCells(k)-1));
        forceY = tempData(1:nVertices,2+2*(selectedCells(k)-1));
        
        forceM = sqrt(forceX.^2 + forceY.^2);
        
        switch app.TypeDropDown.Value
            case 'Average'
                forceData(i,k) = mean(forceM);
            case 'Maximum'
                forceData(i,k) = max(forceM);
            case 'Minimum'
                forceData(i,k) = min(forceM);
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

figure(2);
hold on

plot(times,forceData,'LineWidth',3);
hold off
ylabel('Cell areas (\mum^2)')
xlabel(['Time (' timeUnit ')'])
xlim([times(1) times(end)])