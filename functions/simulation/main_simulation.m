function d = main_simulation(d,app)

time = 0;

dt = d.spar.maximumTimeStep;

if any(d.simset.simulationType == [2 5]) 
    subDt = d.spar.maximumTimeStep;
end

if d.simset.timeSimulation
    profile on
end

if d.simset.progressBar
    d.simset = progress_bar(app,time,d.spar,d.simset);
end

if d.simset.dtPlot
    timeStepsCells = [];
    timeStepsSub = [];
end

tic

while time - d.spar.simulationTime <= 1e-8

    % stop or pause
    if ~d.pl.plot && d.simset.stopOrPause
        drawnow limitrate
    end
    if or(d.simset.stopOrPause, app.simulationClosed)
        pause_or_stop_simulation(app)
        if app.simulationStopped
            break
        end
    end
    
    
    % Cell properties
    d.cells = get_boundary_vectors(d.cells);
    d.cells = get_boundary_lengths(d.cells);
    d.cells = get_convexities(d.cells);
    d.cells = get_vertex_angles(d.cells);
    
    if any(d.simset.simulationType == [2 3 5])
        d = remove_focal_adhesions(d);
    elseif d.simset.simulationType == 4
        d.cells(end) = create_edge_cell(d);
    end
    
    % Remove vertices
    if d.simset.simulationType ~= 2
        d = remove_vertices(d);
    end
    
    % Remove cells
    d = remove_cells(d);
    if isempty(d.cells)
        break
    end
    
    % Division
    d.cells = get_cell_areas(d.cells);
    d.cells = get_cell_perimeters(d.cells);
    if d.simset.simulationType == 1
        d = check_division_states(d, time, dt);
        d = divide_cell(d, time);
    end

    % Add vertices
    d.cells = get_boundary_vectors(d.cells);
    d.cells = get_boundary_lengths(d.cells);
    if d.simset.simulationType ~= 2
        d = add_vertices(d);
    end

    % Junctions
    d = update_close_vertices_and_junctions(d,time);
    
    % save for plotting
    for k = 1:length(d.cells)
        d.cells(k).previousVerticesX = d.cells(k).verticesX;
        d.cells(k).previousVerticesY = d.cells(k).verticesY;
    end
    if any(d.simset.simulationType == [2 3 5])
        d.sub.previousPointsX = d.sub.pointsX;
        d.sub.previousPointsY = d.sub.pointsY;
    end

    if d.simset.simulationType == 5
        d = change_activation(d,time);    
    end
    
    % Solve cells
    switch d.simset.solver
        case 1
            [d, dt, maxmaxMovement] = solve_cells_rk2(d, dt, time);
        case 2
            [d, dt, maxmaxMovement] = solve_cells_rk4(d, dt, time);
    end
    if d.simset.dtPlot
        timeStepsCells(end+1) = dt; %#ok<AGROW>
    end
    
    % Solve substrate
    if any(d.simset.simulationType == [2 5])
        [d,subDt] = solve_substrate(d,dt,subDt);
        if d.simset.dtPlot
            timeStepsSub(end+1) = subDt; %#ok<AGROW>
        end
    end
    if d.simset.simulationType == 2
        d.simset.pointlike = move_pointlike(time,d.simset.pointlike);
    elseif d.simset.simulationType == 3
        d = move_substrate_points(d,time,dt);
    end
    
    % Plot
    d.pl.videoObject = plot_function(d, time);
    
    % Export
    export_data(d, time)
    
    if d.simset.simulationType == 4
         d = move_edge_frame(d,dt);
    end

    % Update time
    time = time + dt;
    
    dt = update_dt(d,dt,time,maxmaxMovement);

    % Update progress bar
    if d.simset.progressBar
        d.simset = progress_bar(app,time,d.spar,d.simset);
    end
end

if d.simset.dtPlot
    figure(2); semilogy(timeStepsCells);
    if d.simset.simulationType == 2
        hold on
        plot(timeStepsSub);
        hold off
    end
end

if d.pl.plot
    set(d.pl.figureHandle,'CloseRequestFcn','closereq');
end

if d.simset.timeSimulation
    profile viewer
end
