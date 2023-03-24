function d = update_progress_bar(app, d, time)
% UPDATE_PROGRESS_BAR Update the progress bar during the simulation
%   The function updates the progress bar in the GUI based on the current
%   simulation time. It updates the bar itself, the percentage as well as
%   the displayed time. To limit the amount of updates, they are only done
%   at certain percentages of progress. The progress bar itself consists of
%   50 l-letters that are printed when a corresponding percentage is
%   reached.
%   INPUTS:
%       app: main application data structure
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the progress bar is active
if d.simset.progressBar.active
    
    % calculate the current progess percentage of the simulation
    percentage = time/d.spar.simulationTime;
    
    % check if the curren progress has passed the next progress bar update
    % percentage
    if percentage*100 >= d.simset.progressBar.percent
        
        % update the percent text in the GUI
        app.SimulationprogressLabel.Text = sprintf('%0.1f %%',percentage*100);
        
        % define the next progress update percentage
        d.simset.progressBar.percent = d.simset.progressBar.percent + 0.1;
        
    % otherwise, do not update the progress bar
    else
        return
    end
    
    % check if the current progress is enough to print the next l-letter in
    % the progress bar
    if floor(percentage*50) >= d.simset.progressBar.progress
        
        % add one l-letter
        app.ProgressLabel.Text = [app.ProgressLabel.Text 'l'];
        
        % define the next progress bar update level
        d.simset.progressBar.progress = d.simset.progressBar.progress + 1;
    end
    
    % get the current simulation time in seconds
    time = time*d.spar.scalingTime;
    
    % based on the simulation type, obtain the appropriate time string
    switch d.simset.simulationType
        case 1
             msg = get_time_string(d, time, 4);
        case 2
            msg = get_time_string(d, time, 1);
        case 3
            msg = get_time_string(d, time, 3);
        case 4
            msg = get_time_string(d, time, 3);
        case 5
            msg = get_time_string(d, time, 2);
    end
    
    % print the update time string 
    app.SimulationprogresstimeLabel.Text = [msg ' / ' d.simset.progressBar.totalTimeString];
end

end