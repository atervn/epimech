function neighbors_histogram_plot(app)

folderExists = exist([app.plotImport(app.selectedFile).folderName '/junctions'],'dir') == 7;
if folderExists
    
    figure(2);
    clf;
    ax = axes;
    
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
    % remove the external cells
    nNeighbors = nonzeros(nNeighbors);
   
    xlim([0, 9]);
    
    histogram(ax,nNeighbors,[2.5:1:9.5],'FaceColor',[1 0.6 0.4],'EdgeColor',[1 0.6 0.4])
    
    ylabel('number')
    xlabel('Number of neighbors')
    ax.FontSize=10;
       
end