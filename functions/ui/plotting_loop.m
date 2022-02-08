function plotting_loop(app,d,option)


if strcmp(option,'add_cells')
    
    plot_function(d,0);
    hold on
    while 1
        
        [d, endLoop] = try_placing_cell(app,d);
        if endLoop
            break
        else
            fill(d.pl.axesHandle,d.cells(end).verticesX,d.cells(end).verticesY,[0.8 0.8 0.8], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
            plot_cell_numbers(d,size(app.cellCenters,1));
        end
    end
elseif strcmp(option,'browse_pre_simulation')
    plotAgain = 1;
    while 1
        
        if plotAgain
            d.cells = initialize_cells_struct;
            
            d = import_cells(app,d,'basic_plotting');
            d = remove_cells_gui(app, d,'basic_plotting');
            
            if app.CentercellsCheckBox.Value
                d.cells = center_cells(d.cells);
            end
            
            plot_function(d, (app.import.currentTimePoint-1)*app.import.exportOptions.exportDt);
        end
        try
            w = waitforbuttonpress;
        catch
            break
        end
        if w == 1
            [plotAgain, stop] = get_key_presses(app,d.pl);
            if stop
                break
            end
        else
            plotAgain = 0;
        end
        
    end
end

