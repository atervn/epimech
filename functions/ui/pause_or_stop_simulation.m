function pause_or_stop_simulation(app)
% STOP_OR_PAUSE_SIMULATION Checks the stop or pause button states
%   The function checks if either the stop or pause buttons have been
%   clicked during the last iteration. Depending on the case, it either
%   checks the simulation buttons or the post plotting buttons. If the
%   pause has been clicked, the UI asks the user whether they want to
%   continue the simulation or stop it.
%   INPUTS:
%       app: main app handle
%   by Aapo Tervonen, 2021

% update the UI so the changes in the button states can be seen
drawnow limitrate

% which type of loop is running
switch app.appTask
    case 'simulate'
        
        % check the stop button
        if app.StopButton.Value
            app.simulationStopped = 1;
        
        % check the pause button
        elseif app.PauseButton.Value
            
            % ask the user what to do
            userResponse = uiconfirm(app.EpiMechUIFigure,'Simulation is paused', 'Simulation is paused', 'Options', {'Continue','Stop'}, 'DefaultOption', 1);
            
            % either continue or stop the simulation
            switch userResponse
                case 'Continue'
                    app.PauseButton.Value = 0;
                case 'Stop'
                    app.simulationStopped = 1;
            end
        end
        
    case 'plotAndAnalyze'
        
        % check the stop button
        if app.StopButton_2.Value
            app.animationStopped = 1;
            
        % check the pause button
        elseif app.PauseButton_2.Value
            
            % ask the user what to do
            userResponse = uiconfirm(app.EpiMechUIFigure,'Animation is paused', 'Animation is paused', 'Options', {'Continue','Stop'}, 'DefaultOption', 1);
            
            % either continue or stop the animation
            switch userResponse
                case 'Continue'
                    app.PauseButton_2.Value = 0;
                case 'Stop'
                    app.animationStopped = 1;
            end
        end
end