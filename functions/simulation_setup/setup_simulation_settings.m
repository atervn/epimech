function d = setup_simulation_settings(app,d)
% SETUP_SIMULATION_SETTINGS Set the the simulation related settings
%   The function sets the simulation type, the solver and various
%   miscellanious variables.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% define the simulation type as number for the simset structure
switch app.simulationType
    case 'growth'
        d.simset.simulationType = 1;
        d.simset.substrateIncluded = 0;
        d.simset.substrateSolved = 0;
    case 'pointlike'
        d.simset.simulationType = 2;
        d.simset.substrateIncluded = 1;
        d.simset.substrateSolved = 1;
    case 'stretch'
        d.simset.simulationType = 3;
        d.simset.substrateIncluded = 1;
        d.simset.substrateSolved = 0;
    case 'edge'
        d.simset.simulationType = 4;
        d.simset.substrateIncluded = 0;
        d.simset.substrateSolved = 0;
    case 'opto'
        d.simset.simulationType = 5;
        d.simset.substrateIncluded = 1;
        d.simset.substrateSolved = 1;
end

% set the cell solver
switch app.SolverDropDown.Value
    case 'RK2'
        d.simset.solver = 1;
    case 'RK4'
        d.simset.solver = 2;
end

% setup progress bar
d = setup_progress_bar(app,d);

% set the simulation timing, pausing/stopping, and time step plotting
% variables
d.simset.timeSimulation = app.TimesimulationCheckBox.Value;
d.simset.stopOrPause = app.StopandpauseCheckBox.Value;
d.simset.dtPlot = app.TimestepplotCheckBox.Value;

% setup division settings
d = setup_division_settings(app,d);

% set the junction modification to false
d.simset.junctionModification = false;

end