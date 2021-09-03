function pause_or_stop_simulation(app)

drawnow limitrate

switch app.appTask
    case 'simulate'
        if app.StopButton.Value
            app.simulationStopped = 1;
        elseif app.PauseButton.Value
            userResponse = uiconfirm(app.EpiMechUIFigure,'Simulation is paused', 'Simulation is paused', 'Options', {'Continue','Stop'}, 'DefaultOption', 1);
            switch userResponse
                case 'Continue'
                    app.PauseButton.Value = 0;
                case 'Stop'
                    app.simulationStopped = 1;
            end
        end
    case 'plotAndAnalyze'
        if app.StopButton_2.Value
            app.animationStopped = 1;
        elseif app.PauseButton_2.Value
            userResponse = uiconfirm(app.EpiMechUIFigure,'Animation is paused', 'Animation is paused', 'Options', {'Continue','Stop'}, 'DefaultOption', 1);
            switch userResponse
                case 'Continue'
                    app.PauseButton_2.Value = 0;
                case 'Stop'
                    app.animationStopped = 1;
            end
        end
end