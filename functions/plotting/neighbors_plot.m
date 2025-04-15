function neighbors_plot(app)

folderExists = exist([app.plotImport(app.selectedFile).folderName '/junctions'],'dir') == 7;
if folderExists
    
    currentTimePoint = app.plotImport(app.selectedFile).currentTimePoint;
    
    n1 = [];
    n2 = [];
    n3 = [];
    n4 = [];
    n5 = [];
    n6 = [];
    n7 = [];
    n8 = [];
        
    for i = 1:app.plotImport(app.selectedFile).nTimePoints
        app.plotImport(app.selectedFile).currentTimePoint = i;
        d = [];
        [~,cells] = import_cells(app,d,'get_neighbors');
        nNeighbors = zeros(length(cells),1);
        for k = 1:length(cells)
            % only take the internal cells with max 20 % non junction points
            if sum(cells(k).junctions.cells(:,1) == 0)/length(cells(k).junctions.cells(:,1)) < 0.2
                neighbors = unique(cells(k).junctions.cells(:));
                neighbors(neighbors == 0) = [];
                nNeighbors(k) = length(neighbors);
            end
        end
        
        n1(i) = sum(nNeighbors <= 1);
        n2(i) = sum(nNeighbors == 2);
        n3(i) = sum(nNeighbors == 3);
        n4(i) = sum(nNeighbors == 4);
        n5(i) = sum(nNeighbors == 5);
        n6(i) = sum(nNeighbors == 6);
        n7(i) = sum(nNeighbors == 7);
        n8(i) = sum(nNeighbors >= 8);
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
    
    n2 = n2 + n1;
    n3 = n3 + n2;
    n4 = n4 + n3;
    n5 = n5 + n4;
    n6 = n6 + n5;
    n7 = n7 + n6;
    n8 = n8 + n7;
    
    n1 = n1./n8;
    n2 = n2./n8;
    n3 = n3./n8;
    n4 = n4./n8;
    n5 = n5./n8;
    n6 = n6./n8;
    n7 = n7./n8;
    n8 = n8./n8;
    
    figure(2);
    clf;
    ax = axes;
    hold on
    area(ax,times,n8,'FaceColor',[0.40 0.45 0.41],'LineStyle','none');
    area(ax,times,n7,'FaceColor',[0.55 0.69 0.70],'LineStyle','none');
    area(ax,times,n6,'FaceColor',[0.59 0.63 0.71],'LineStyle','none');
    area(ax,times,n5,'FaceColor',[0.5 0.59 0.71],'LineStyle','none');
    area(ax,times,n4,'FaceColor',[0.71 0.55 0.59],'LineStyle','none');
    area(ax,times,n3,'FaceColor',[0.71 0.59 0.55],'LineStyle','none');
    area(ax,times,n2,'FaceColor',[0.71 0.69 0.55],'LineStyle','none');
    area(ax,times,n1,'FaceColor',[0.6 0.73 0.62],'LineStyle','none');

    hold off
    
    ylabel('Number of neighbors')
    xlabel(['Time (' timeUnit ')'])
    xlim([times(1) times(end)])
   
    app.plotImport(app.selectedFile).currentTimePoint = currentTimePoint;
    
end