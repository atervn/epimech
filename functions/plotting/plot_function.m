function videoObject = plot_function(d, time)

if d.pl.plot
    if mod(time+1e-10,d.pl.plotDt) <= 1e-9
        if d.pl.plotType == 1
            loopTime = toc;
        else
            loopTime = 0;
        end
        
        tic;
        
        d.pl.axesHandle = cla(d.pl.axesHandle);
        hold(d.pl.axesHandle,'on')
        
        if d.simset.simulationType == 4
            nCells = length(d.cells) - 1;
        else
            nCells = length(d.cells);
        end
        
        if d.pl.plotType == 1
            for k = 1:nCells
                d.cells(k).verticesX = d.cells(k).previousVerticesX;
                d.cells(k).verticesY = d.cells(k).previousVerticesY;
            end
            if any(d.simset.simulationType == [2 3 5])
                d.sub.pointsX = d.sub.previousPointsX;
                d.sub.pointsY = d.sub.previousPointsY;
            end
        end
        
        %% SUBSTRATE
        
        plot_substrate(d);
        
        plot_substrate_forces(d);
        %% CELLS
        if any(d.pl.cellStyle == 7:13)

            colormap(d.pl.colormap)
            
            colorbar('southoutside','FontSize',12)
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        end
        plot_junctions(d);
        % initialization for junction plotting
        if isfield(d.cells, 'verticesX') && d.pl.junctions
            plottedJunctions = cell(1,length(d.cells));
            for k = 1:length(d.cells)
                plottedJunctions{k} = zeros(d.cells(k).nVertices,1);
            end
        end
        
        % plot cell specific stuff
        if numel(d.cells) > 0 && ~isempty(d.cells(1).verticesX)
            
            forcePlot = struct();
            if d.pl.cellForcesCortical
                forcePlot.cellForcesCortical = [];
            end
            if d.pl.cellForcesJunctions
                forcePlot.cellForcesJunctions = [];
                
            end
            if d.pl.cellForcesDivision
                forcePlot.cellForcesDivision = [];
                
            end
            if d.pl.cellForcesMembrane
                forcePlot.cellForcesMembrane = [];
                
            end
            if d.pl.cellForcesContact
                forcePlot.cellForcesContact = [];
                
            end
            if d.pl.cellForcesArea
                forcePlot.cellForcesArea = [];
                
            end
            if d.pl.cellForcesPointlike && d.simset.simulationType == 2
                forcePlot.cellForcesPointlike = [];
            end
            if d.pl.cellForcesFocalAdhesions && any(d.simset.simulationType == [2,3,5])
                forcePlot.cellForcesFocalAdhesions = [];
            end
            if d.pl.cellForcesTotal
                forcePlot.cellForcesTotal = [];   
            end
           
            for k = 1:nCells
            
%                
                % plot the cells in style 1 (filled with grey)
                if d.pl.cellStyle == 1
                    if d.cells(k).cellState == 0
                        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.8 0.8 0.8], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
                    else
                        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.7 0.7 0.7], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
                    end
                    % plot the cells in style 2 (red boundaries)
                elseif d.pl.cellStyle == 2
                    plot(d.pl.axesHandle,[d.cells(k).verticesX ; d.cells(k).verticesX(1)],[d.cells(k).verticesY ; d.cells(k).verticesY(1)] ,'-r', 'linewidth', 2)
                    % plot the cells in style 3 (colors showing number of neighbors)
                elseif d.pl.cellStyle == 3
                    plot_cells_neighbor_numbers(d,k)
                elseif d.pl.cellStyle == 4
                    fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0 0 0], 'linewidth', 0.5, 'edgecolor', [0 0 0])
                elseif d.pl.cellStyle == 5
                    plot_cells_lines(d,k)
                elseif any(d.pl.cellStyle == 7:13)
                    plot_cell_descriptors(d,k)
                end
                
                % highlight cell if needed
                highlight_cell(d,k);
                
                % plot forces
                forcePlot = plot_gather_cell_forces(d,k,forcePlot);
                
                % plot cell numbers
                plot_cell_numbers(d,k);
                
                % plot boundary vertex numbers
                plot_vertex_numbers(d,k);
                
%                 if d.simset.simulationType == 5 && any(d.simset.opto.cells == k)
%                     ind = d.simset.opto.cells == k;
%                     if d.cells(k).vertexCorticalTensions(d.simset.opto.vertices{ind}(1)) > 1
%                         idx = d.simset.opto.vertices{ind};
%                         plot(d.cells(k).verticesX(idx),d.cells(k).verticesY(idx),'ob', 'MarkerSize',12,'MarkerFaceColor','b');
%                     end
%                 end
                
            end
            
            if d.simset.simulationType == 4
                base = d.cells(end).verticesX(1);
                xVector = [base -base -base base base base-0.5 base-0.5 -base+0.5 -base+0.5 base-0.5 base-0.5];
                yVector = [base base -base -base base base -base+0.5 -base+0.5 base-0.5 base-0.5 base];
                fill(d.pl.axesHandle,xVector,yVector,[0 0 0], 'linewidth', 0.5, 'edgecolor', [0 0 0])
            end
            
            
            
        end
        
        plot_cell_forces(d,forcePlot)
        
        
        if d.pl.plotType == 4 % 'substrate_visualization'
            halfSize = d.spar.substrateSize/2;
            cornersX = [-halfSize halfSize halfSize -halfSize -halfSize];
            cornersY = [-halfSize -halfSize halfSize halfSize -halfSize];
            plot(d.pl.axesHandle,cornersX,cornersY, '--r', 'LineWidth',2)
        elseif d.pl.plotType == 3
            switch d.pl.shape
                case 1
                    halfSize = d.pl.shapeSize;
                    cornersX = [-halfSize halfSize halfSize -halfSize -halfSize];
                    cornersY = [-halfSize -halfSize halfSize halfSize -halfSize];
                    plot(d.pl.axesHandle,cornersX,cornersY, '-c', 'LineWidth',2)
                case 2
                    viscircles(d.pl.axesHandle,[0 0], d.pl.shapeSize,'Color','c');
            end
        end
        
        if d.pl.pointlike
            if d.pl.cellStyle == 2
                plot(d.pl.axesHandle,d.simset.pointlike.pointX,d.simset.pointlike.pointY,'x','markersize', 20,'LineWidth', 3, 'Color', [0.47 0.01 0.99]);                
            else
                plot(d.pl.axesHandle,d.simset.pointlike.pointX,d.simset.pointlike.pointY,'rx','markersize', 20,'LineWidth', 3);
            end
        end
        if d.pl.opto
            timeIdx = find(d.simset.opto.times <= floor(time), 1, 'last' );
            if d.simset.opto.levels(timeIdx) > 0
                for i = 1:length(d.simset.opto.shapes)
                    if d.pl.cellStyle == 2
                        optoHandle = fill(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),[0.47 0.01 0.99], 'EdgeColor',[0.47 0.01 0.99]);
                    else
                        optoHandle = fill(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),[0 0 1], 'EdgeColor',[0 0 1]);
                    end
                    alpha(optoHandle,0.5);
                end
            end
        end
        
        %% TITLE
        
        plottingTime = toc;
        plot_title(d,time,plottingTime,loopTime);
        
        if d.pl.automaticSize
            maxPointX = zeros(1,length(d.cells));
            minPointX = maxPointX;
            maxPointY = maxPointX;
            minPointY = maxPointX;
            for k = 1:length(d.cells)
                maxPointX(k) = max(d.cells(k).verticesX);
                minPointX(k) = min(d.cells(k).verticesX);
                maxPointY(k) = max(d.cells(k).verticesY);
                minPointY(k) = min(d.cells(k).verticesY);
            end
            
            maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY])));
            
            d.pl.windowSize = maxSize + d.spar.rCell;
            
            d.pl.axesHandle.XLim = [-d.pl.windowSize d.pl.windowSize];
            d.pl.axesHandle.YLim = [-d.pl.windowSize d.pl.windowSize];
        end
        
        %% SCALEBASR
        
        plot_scale_bar(d)
        
        %% LEGEND
        
        plot_legend(d)
        
        
        hold(d.pl.axesHandle,'off')
        
        drawnow
        
        if d.pl.video
            try
                writeVideo(d.pl.videoObject, getframe(d.pl.figureHandle))
            catch
                set(gcf,'Resize','on')
                disp('Resize the plot window back\nto the original size and press any key');
                pause
                writeVideo(d.pl.videoObject, getframe(d.pl.figureHandle))
            end
        end
        
        if d.pl.plotType == 1
            tic
        end
        
    end
    videoObject = d.pl.videoObject;
else
    videoObject = 0;
end
