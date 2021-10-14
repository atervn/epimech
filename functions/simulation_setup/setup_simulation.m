function d = setup_simulation(app)
% SETUP_SIMULATION Setup the data related to the simulation
%   The function setups to the simulation by scaling parameters, setting up
%   the simulation settings, creating or importing the cells, creating or
%   importing the substrate, setting up the pointlike, stretching,
%   optogenetic, or frame simulations, as well as the plotting and
%   exporting options.
%   INPUT:
%       app: main application structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% start the rng
set_rng(app);

% create main simulation data structure
d = [];

% scale model parameters
d = scale_parameters(app,d);

% setup the simulation settings
d = setup_simulation_settings(app,d);

% setup cells
d = setup_cells(app,d);

% stretching settings
d = setup_stretching_settings(app,d);

% setup substrate (if there were problems or the substrate creation was
% canceled, indicated by nonstructure d, return)
d = setup_substrate(app,d);
if ~isstruct(d); return; end

% pointlike settings
d = setup_pointlike_settings(d,app);

% setup optogenetics
d = setup_optogenetics(app,d);

% frame settings
d = setup_frame(d);

% plotting settings
d = setup_plotting_options(app,'simulate',d);

% export settings
d.ex = setup_exporting(app,d);

end
