function d = main_simulation(d,app)
% MAIN_SIMULATION The main simulation loop in the model.
%   INPUTS:
%       d: main simulation data structure that include the cell data,
%           substrate data (if included), simulation settings, plotting
%           settings, and export settings
%       app: main app handle is needed to enable simulating stopping as
%           well as the progress bar
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% set time to zero
time = 0;

% set the initial simulation time step
dt = d.spar.maximumTimeStep;

% if substrate is solved, set the initial substrate time step
if any(d.simset.simulationType == [2 5]) 
    subDt = d.spar.maximumTimeStep;
end

% if using matlab profiler
if d.simset.timeSimulation
    profile on
end

% if showing progress bar
if d.simset.progressBar
    d.simset = progress_bar(app,time,d.spar,d.simset);
end

% if the time steps are plotted following the simulation
if d.simset.dtPlot
    timeStepsCells = [];
    timeStepsSub = [];
end

tic

%% main simulation loop
while time - d.spar.simulationTime <= 1e-8

    %% stop or pause
    if ~d.pl.plot && d.simset.stopOrPause
        drawnow limitrate
    end
    if or(d.simset.stopOrPause, app.simulationClosed)
        pause_or_stop_simulation(app)
        if app.simulationStopped
            break
        end
    end
    
    
    %% cell properties and component removal
    
    % get cell properties
    d.cells = get_boundary_vectors(d.cells);
    d.cells = get_boundary_lengths(d.cells);
    d.cells = get_vertex_angles(d.cells);
    
    % check if focal adhesions are to be removed
    if any(d.simset.simulationType == [2 3 5])
        d = remove_focal_adhesions(d);
    % define a frame around the cells (simulation type currently disabled)
    elseif d.simset.simulationType == 4
        d.cells(end) = create_frame_cell(d);
    end
    
    % remove vertices if needed
    if d.simset.simulationType ~= 2
        d = remove_vertices(d);
    end
    
    % remove cells if needed
    d = remove_cells(d);
    if isempty(d.cells)
        break
    end
    
    %% division
    
    % get cell areas and perimeters
    d.cells = get_cell_areas(d.cells);
    d.cells = get_cell_perimeters(d.cells);
    
    % if simulationType is growth (1)
    if d.simset.simulationType == 1
        
        % check and change cell division states
        d = check_division_states(d, time, dt);
        
        % divide cells
        d = divide_cell(d, time);
    end

    %% add vertices
    d.cells = get_boundary_vectors(d.cells);
    d.cells = get_boundary_lengths(d.cells);
    if d.simset.simulationType ~= 2
        d = add_vertices(d);
    end

    %% misc
    
    % update closest vertices for contact forces and junctions
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

    % change vertex activation states in optogenetic simulation
    if d.simset.simulationType == 5
        d = change_activation(d,time);    
    end
    
    %% solve cells
    switch d.simset.solver
        case 1
            % 2nd order Runge Kutta solver
            [d, dt, maxmaxMovement] = solve_cells_rk2(d, dt);
        case 2
            % 4th order Runge Kutta solver
            [d, dt, maxmaxMovement] = solve_cells_rk4(d, dt);
    end
    
    % save time step for post plotting
    if d.simset.dtPlot
        timeStepsCells(end+1) = dt; %#ok<AGROW>
    end
    
    %% solve substrate
    if any(d.simset.simulationType == [2 5])
        % solve using 4th order Runge Kutta solver
        [d,subDt] = solve_substrate(d,dt,subDt);
        
        % save time step for post plotting
        if d.simset.dtPlot
            timeStepsSub(end+1) = subDt; %#ok<AGROW>
        end
    end
    
    %% misc
    
    if d.simset.simulationType == 2
        % move pointlike micromanipulator
        d.simset.pointlike = move_pointlike(time,d.simset.pointlike);
    elseif d.simset.simulationType == 3
        % move substrate points in lateral compression or stretching
        % simulations (not solved)
        d = move_substrate_points(d,time,dt);
    end
    
    % plot data
    d.pl.videoObject = plot_function(d, time);
    
    % export data
    export_data(d, time)
    
    % move a frame around the cells (simulation type currently disabled)
    if d.simset.simulationType == 4
         d = move_frame(d,dt);
    end

    % update time
    time = time + dt;
    
    % update time step (depending on the maximum cell movement)
    dt = update_dt(d,dt,time,maxmaxMovement);

    % update progress bar if shown
    if d.simset.progressBar
        d.simset = progress_bar(app,time,d.spar,d.simset);
    end
end

% plot the simulation time steps if selected
if d.simset.dtPlot
    figure(2); semilogy(timeStepsCells);
    if d.simset.simulationType == 2
        hold on
        plot(timeStepsSub);
        hold off
    end
end

% enable closing of the simulation plot
if d.pl.plot
    set(d.pl.figureHandle,'CloseRequestFcn','closereq');
end

% open profiler results if selected
if d.simset.timeSimulation
    profile viewer
end

end
