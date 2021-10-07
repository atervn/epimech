function plot_title(d,time,loopTime)
% PLOT_TITLE Plot the title for the simulation visualization
%   The function plots the title for the visualization depending on the
%   plotting case.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%       loopTime: time since last plotting
%   by Aapo Tervonen, 2021

% get the time string
timeString = separate_times(d,time*d.spar.scalingTime);

% which title type
switch d.pl.titleType
    
    % plotting during simulation
    case 1
        
        % get the time used in the plotting in this time step
        plottingTime = toc;
        
        % growth simulation
        if d.simset.simulationType == 1

            % plot the figure title (format: "Current time ; number of
            % cells; (plot time step simulation duration/duration for the
            % plotting/time it takes to simulate one cell for one hour)"
            title(d.pl.axesHandle,['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str((loopTime - plottingTime)/length(d.cells)*(3600/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
            
        % pointlike simulation
        elseif d.simset.simulationType == 2
            
            % plot the figure title (format: "Current time ; (plot time
            % step simulation duration/duration for the plotting/time it
            % takes to simulate one cell for one millisecond)"
            title(d.pl.axesHandle,['Time: ' timeString '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(0.001/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
            
        % lateral compression or stretching simulation
        elseif d.simset.simulationType == 3
            
            % get the current stretch multiplier
            multiplier = get_current_stretch(d,time);
            
            % plot the figure title (format: "Current time ; current
            % substrate stretch ; (plot time step simulation duration/
            % duration for the plotting/time it takes to simulate one cell
            % for one minute)"
            title(d.pl.axesHandle,['Time: ' timeString '; stretch: ' num2str(multiplier,'%.2f')  '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(60/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
            
        % if optogenetic simulation
        elseif d.simset.simulationType == 5
            
            % plot the figure title (format: "Current time ; (plot time
            % step simulation duration/duration for the plotting/time it
            % takes to simulate one cell for one minute)"
            title(d.pl.axesHandle,['Time: ' timeString '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(60/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
        end
        
    % browsing (when selecting the time point to start simulation or
    % post simulation)
    case 2
        
        % plot the title
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
        title(d.pl.axesHandle,titleText);        
        
    % place cells for the initial state
    case 3
        
        % plot the title
        title(d.pl.axesHandle,'Place cells by clicking and press enter when done');

    % remove_cells
    case 4 

        % plot the title
        title(d.pl.axesHandle,'Select the cells to remove and press enter when done.');
        
    % remove_with_shape
    case 5
        
        % plot the title
        title(d.pl.axesHandle,'The cells outside the shape are shown in cyan');
    
    % show_substrate_sizen  
    case 6
        
        % plot the title
        title(d.pl.axesHandle,'The substrate of given size is presented in red');  
        
    % select pointlike cell
    case 7
        
        % plot the title
        title(d.pl.axesHandle,'Select a cell and press enter when done');  
    
    % post_normal
    case 8

        % plot the title
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
        title(d.pl.axesHandle,titleText);
             
    % opto_area
    case 9
        
        % plot the title
        titleText = sprintf([ 'Draw an area for activation (an area is completed when clicking' '\n' 'close to the first point). Press enter when finished.']);
        title(d.pl.axesHandle,titleText);
   
    % opto_post_cell
    case 10
        
        % plot the title
        titleText = sprintf([ 'Select two neighboring cells to visualize the length of the' '\n' 'boundary between them. Press enter when finished.']);
        title(d.pl.axesHandle,titleText);  
    
    % force_magnitude, Total forces
    case 20

        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Total cell forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Total cell forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % force_magnitude, Cortical forces
    case 21

        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cortical forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cortical forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
         
    % force_magnitude, Junction forces
    case 22

        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Junction forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Junction forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Division forces
    case 23

        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Division forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Division forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Membrane forces
    case 24

        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Membrane forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Membrane forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Contact forces
    case 25
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Contact forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Contact forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Area forces
    case 26
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Area forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Area forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Pointlike forces
    case 27
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Pointlike forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Pointlike forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
           
    % force_magnitude, Cell focal adhesion forces
    case 28
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % force_magnitude, Total substrate forces
    case 29
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Total substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Total substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
        
        
    % force_magnitude, Central substrate forces
    case 30
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Central substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Central substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % force_magnitude, Restorative substrate forces
    case 31
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Restorative substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Restorative substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % force_magnitude, Repulsion substrate forces
    case 32
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Repulsion substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Repulsion substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % force_magnitude, Substrate focal adhesion forces
    case 33
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Substrate focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Substrate focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell areas   
    case 40
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell areas; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell areas; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell area strains   
    case 41
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell area strains; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell area strains; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell arperimeterseas   
    case 42
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell perimeters; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell perimeters; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell perimeter strains   
    case 43
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell perimeter strains; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell perimeter strains; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell circularities   
    case 44
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell circularities; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell circularities; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell aspect ratios   
    case 45
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell aspect ratios; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell aspect ratios; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
    % cell_descriptors, Cell long axis angles   
    case 46
        
        % check if simple plot or browse and plot the corresponding title
        switch d.pl.nTitleLines
            case 1
                title(d.pl.axesHandle,['Cell long axis angles; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
            case 2
                titleText = sprintf(['Cell long axis angles; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
end

end

function multiplier = get_current_stretch(d,time)
% GET_CURRENT_STRETCH Calculate the current substrate stretch
%   The function calculates the current stretch multiplier of the substrate
%   in the lateral compression or stretching simulation.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   by Aapo Tervonen, 2021

% get the previous and next time points where there are changes
% in the substrate stretch
previousTime = max(d.simset.stretch.times(d.simset.stretch.times <= time));
nextTime = min(d.simset.stretch.times(d.simset.stretch.times > time));

% get the indices of the these changes in the movement change
% vectors
previousIdx = find(d.simset.stretch.times == previousTime);
nextIdx = find(d.simset.stretch.times == nextTime);

% if the time is exactly at a time point where the change in substrate
% movement is defined
if previousTime == time
    
    % get multiplier for previous movement
    multiplier = d.simset.stretch.values(previousIdx);
    
    % otherwise
else
    
    % interpolate multiplier for previous movenent
    multiplier = d.simset.stretch.values(previousIdx) + (d.simset.stretch.values(nextIdx) - d.simset.stretch.values(previousIdx))*(time - d.simset.stretch.times(previousIdx))/(d.simset.stretch.times(nextIdx) - d.simset.stretch.times(previousIdx));
end

end