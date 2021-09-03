function plot_title(d,time,plottingTime,loopTime)

switch d.pl.titleType
    case 1 % normal
        if d.simset.simulationType == 1
            timeString = separate_times(d,time*d.spar.scalingTime);
%             title(d.pl.axesHandle,['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '; tLoop: ' num2str(loopTime,'%05.3f') ' s; tPlot: ' num2str(plottingTime,'%05.3f') ' s; tCell:' num2str(loopTime/length(d.cells)*(3600/d.spar.scalingTime/d.pl.plotDt),'%05.3f')]);
            title(d.pl.axesHandle,['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(3600/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
        elseif d.simset.simulationType == 2
            timeString = separate_times(d,time*d.spar.scalingTime);
%             title(d.pl.axesHandle,['Time: ' timeString '; tLoop: ' num2str(loopTime,'%05.3f') ' s; tPlot: ' num2str(plottingTime,'%05.3f') ' s; tCell:' num2str(loopTime/length(d.cells)*(0.001/d.spar.scalingTime/d.pl.plotDt),'%05.3f')]);
            title(d.pl.axesHandle,['Time: ' timeString '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(0.001/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
        elseif d.simset.simulationType == 3
            timeString = separate_times(d,time*d.spar.scalingTime);
            title(d.pl.axesHandle,['Time: ' timeString '; extension: ' num2str(d.simset.stretching.current*100,'%04.1f')  '; tLoop: ' num2str(loopTime,'%05.3f') ' s; tPlot: ' num2str(plottingTime,'%05.3f') ' s; tCell:' num2str(loopTime/length(d.cells)*(1/d.spar.scalingTime/d.pl.plotDt),'%05.3f')]);
        elseif d.simset.simulationType == 5
            timeString = separate_times(d,time*d.spar.scalingTime);
            title(d.pl.axesHandle,['Time: ' timeString '; (' num2str(loopTime,'%05.3f') '/' num2str(plottingTime,'%05.3f') '/' num2str(loopTime/length(d.cells)*(1/d.spar.scalingTime/d.pl.plotDt),'%05.3f') ')']);
        end
    case 3 % place_cells
        title(d.pl.axesHandle,'Place cells by clicking and press enter when done');
        
    case 5 % select_cell
        title(d.pl.axesHandle,'Select a cell and press enter when done');
        
    case 2 % plot_imported
        timeString = separate_times(d,time*d.spar.scalingTime);
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
        title(d.pl.axesHandle,titleText);
        
    case 4 % remove_cells
        timeString = separate_times(d,time*d.spar.scalingTime);
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Select the cells to remove and press enter when done.']);
        title(d.pl.axesHandle,titleText);
        
    case 6 % substrate_visualization
        title(d.pl.axesHandle,'The substrate of given size is presented in red');
        
    case 8 % post_browse_normal
        timeString = separate_times(d,time*d.spar.scalingTime);
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
        title(d.pl.axesHandle,titleText);

    case 7 % post_normal
        timeString = separate_times(d,time*d.spar.scalingTime);
        titleText = sprintf(['Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
        title(d.pl.axesHandle,titleText);
        
    case 9
        title(d.pl.axesHandle,'Select cells to choose them for activation and press enter when finished.');
        
    case 10
        titleText = sprintf([ 'Draw an area for activation (an area is completed when clicking' '\n' 'close to the first point). Press enter when finished.']);
        title(d.pl.axesHandle,titleText);
        
    case 11
        title(d.pl.axesHandle,'Select cells to remove them from activation and press enter when finished.');
    case 20
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Total cell forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Total cell forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 21
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cortical forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cortical forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 22
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Junction forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Junction forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 23
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Division forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Division forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 24
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Membrane forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Membrane forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 25
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Contact forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Contact forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 26
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Area forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Area forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 27
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Pointlike forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Pointlike forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 28
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 29
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Total substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Total substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 30
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Direct substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Direct substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 31
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Restorative substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Restorative substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 32
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Repulsion substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Repulsion substrate forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 33
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Substrate focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Substrate focal adhesion forces; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 34
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell areas; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell areas; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 35
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell area strains; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell area strains; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 36
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell perimeters; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell perimeters; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 37
        title(d.pl.axesHandle,'Cell perimeter strains');
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell perimeter strains; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell perimeter strains; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 38
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell circularities; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell circularities; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 39
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell aspect ratios; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell aspect ratios; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
    case 40
        title(d.pl.axesHandle,'Cell long axis angles');
        timeString = separate_times(d,time*d.spar.scalingTime);
        switch d.pl.extraTitleType
            case 1
                titleText = sprintf(['Cell long axis angles; Time: ' timeString '; nCells: ' num2str(length(d.cells))]);
                title(d.pl.axesHandle,titleText);
            case 2
                titleText = sprintf(['Cell long axis angles; Time: ' timeString '; nCells: ' num2str(length(d.cells)) '\n' 'Use the arrow keys to browse the time points, press enter when done.']);
                title(d.pl.axesHandle,titleText);
        end
        
end