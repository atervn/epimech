function videoObject = plot_function(d, time)
% PLOT_FUNCTION Plots the simulation state
%   The function plots the current state of the simulation, or in the case
%   of postsimulation analysis, the imported results.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       videoObject: video object, if video is created
%   by Aapo Tervonen, 2021

% if plotting is enabled
if d.pl.plot
    
    % check if the current time step is one of the plotting time steps
    if mod(time+1e-10,d.pl.plotDt) <= 1e-9
        
        % if this is simulation (plotType == 1), get the time it has taken
        % to simulate after the previous plotting
        if d.pl.plotType == 1
            loopTime = toc;
            
        % otherwise
        else
            loopTime = 0;
        end
        
        % for timing the plotting itself
        tic;
        
        % clear the axis
        d.pl.axesHandle = cla(d.pl.axesHandle);
        
        % hold the axis
        hold(d.pl.axesHandle,'on')
        
        % if frame simulation, reduce the number of cells by one
        if d.simset.simulationType == 4
            nCells = length(d.cells) - 1;
        else
            nCells = length(d.cells);
        end
        
        % set automatic size
        set_automatic_plot_size(d);
        
        % if simulation
        if d.pl.plotType == 1
            
            % use the vertex coordinates from before the next positions
            % were solved (this enables e.g. plotting the forces with
            % the correct positions)
            for k = 1:nCells
                d.cells(k).verticesX = d.cells(k).previousVerticesX;
                d.cells(k).verticesY = d.cells(k).previousVerticesY;
            end
            
            % get the substrate point coordinates from before the next
            % positions were solved
            if d.simset.substrateIncluded
                d.sub.pointsX = d.sub.previousPointsX;
                d.sub.pointsY = d.sub.previousPointsY;
            end
        end
        
        %% SUBSTRATE
        
        % plot substrate
        plot_substrate(d);
        
        % plot substrate forces
        plot_substrate_forces(d);
        
        %% CELLS
        
        % check that the cells data structure is available and that the
        % cells have vertex coordinates
        if numel(d.cells) > 0 && ~isempty(d.cells(1).verticesX)
            
            % plot junctions
            plot_junctions(d);
            
            % initalize structure for force data
            forcePlot = plot_initilize_force_matrices(d);
           
            % go through the cells
            for k = 1:nCells
                
                % plot cell bodies
                plot_cells(d,k);
                
                % highlight cell if needed
                highlight_cell(d,k);
                
                % gather forces for plotting
                forcePlot = plot_gather_cell_forces(d,k,forcePlot);
                
                % plot cell numbers
                plot_cell_numbers(d,k);
                
                % plot boundary vertex numbers
                plot_vertex_numbers(d,k);
            end
            
        % otherwise    
        else
            
            % initialize forcePlot
            forcePlot = [];
        end
        
        % plot cell forces
        plot_cell_forces(d,forcePlot)
        
        %% MISC
        
        % plot a shape (used to show substrate size or remove cells)
        plot_shape(d);
        
        % plot the pointlike cross
        plot_pointlike(d);
        
        % plot optogenetic regions
        plot_opto_region(d,time);
        
        % plot frame
        plot_frame(d);
        
        % plot title
        plot_title(d,time,loopTime);
        
        % define scale bar
        plot_scale_bar(d);
        
        % plot color bar
        plot_color_bar(d);
        
        % plot legend        
        plot_legend(d)
        
        % turn off hold
        hold(d.pl.axesHandle,'off')
        
        % draw the plot
        drawnow
        
        % if video is recorded
        if d.pl.video
            
            % try to write a video frame
            try
                writeVideo(d.pl.videoObject, getframe(d.pl.figureHandle))
            
            % if not possible (mostly due to changing the plot size, which
            % can happen even if the size is locked due to Windows snapping
            % feature)
            catch
                
                % so the message in the command window to resize the plot
                % back to the previous size
                set(gcf,'Resize','on')
                disp('Resize the plot window back\nto the original size and press any key');
                pause
                
                % try to write again
                writeVideo(d.pl.videoObject, getframe(d.pl.figureHandle))
            end
        end
        
        % if this is a simulation plotting, start the clock to get the
        % duration until the next plotting
        if d.pl.plotType == 1
            tic
        end
        
    end
    
    % return the video object
    videoObject = d.pl.videoObject;

% no plotting
else
    
    % return zero video object
    videoObject = 0;
end

end
