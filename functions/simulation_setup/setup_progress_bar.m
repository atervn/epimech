function d = setup_progress_bar(app,d)
% SETUP_PROGRESS_BAR Setup the progress bar settings for the GUI
%   The function defines the basic settings for the progress bar to be
%   printed during the simulation.
%   INPUTS:
%       app: main application data structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021  

% set the progress bar state based on the GUI selection
d.simset.progressBar.active = app.ProgressbarCheckBox.Value;

% if the progress bar is active
if d.simset.progressBar.active
    
    % set the first simulation progress percentage where the progress bar
    % will be updated
    d.simset.progressBar.percent = 0;
    
    % set the first simulation process point where l-letters are added to
    % the progress bar itself
    d.simset.progressBar.progress = 0;
    
    % get the total simulation time in seconds
    totalTime = d.spar.simulationTime*d.spar.scalingTime;

    % get the appropriate total simulation time string based on the
    % simulation type
    switch d.simset.simulationType
        case 1
            d.simset.progressBar.totalTimeString = get_time_string(d, totalTime, 4);
        case 2
            d.simset.progressBar.totalTimeString = get_time_string(d, totalTime, 1);
        case 3
            d.simset.progressBar.totalTimeString = get_time_string(d, totalTime, 3);
        case 4
            d.simset.progressBar.totalTimeString = get_time_string(d, totalTime, 3);
        case 5
            d.simset.progressBar.totalTimeString = get_time_string(d, totalTime, 2);
    end
end

end