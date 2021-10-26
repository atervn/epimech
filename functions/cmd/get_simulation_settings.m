function data = get_simulation_settings(fileName)
% READ_SIMULATION_SETTINGS Read simulation settings from the config file
%   The function reads the model definitions from the config file and saves
%   them into a structure.
%   INPUT:
%       fileName: name of the config file
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% open the file
fID = fopen(fileName);

% go through the lines in the file until there is an empty line. This will
% go past the possible comment lines in the beginning of the file, after
% which there has to be and empty line before the simulation definitions
% themselves
while 1
    if strcmp(fgetl(fID),'')
        break
    end
end

% form a data structure to collect the simulation definitions
data = create_simulation_data_structure;

%% read the simulation type settings
data = read_simulation_type(fID,data);
if ~isstruct(data); return; end

%% read the number of simulation cores
data = read_number_of_cores(fID,data);
if ~isstruct(data); return; end

%% number of simulations
data = read_number_of_simulations(fID,data);
if ~isstruct(data); return; end

%% system parameters
data = read_system_parameters(fID, data);
if ~isstruct(data); return; end

%% cell parameters
data = read_cell_parameters(fID, data);
if ~isstruct(data); return; end

%% substrate parameters
data = read_substrate_parameters(fID, data);
if ~isstruct(data); return; end

%% initial state
data = read_initial_states(fID,data);
if ~isstruct(data); return; end

%% simulation time
data = read_simulation_times(fID,data);
if ~isstruct(data); return; end

%% simulation specific input
data = read_simulation_specific_input(fID,data);
if ~isstruct(data); return; end

%% parameter study
data = read_parameter_study(fID,data);
if ~isstruct(data); return; end

%% export settings
data = read_export_settings(fID,data);
if ~isstruct(data); return; end

%% simulation names
data = read_simulation_names(fID,data);
if ~isstruct(data); return; end

end

function data = create_simulation_data_structure
% CREATE_SIMULATION_DATA_STRUCTURE Create data structure for simulation
% data
%   The function defines the data structure that is used to collect the
%   simulation data from the config file
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% define the data structure field
data.nCores = 0;
data.nSimulations = 0;
data.systemParameterFiles = {};
data.cellParameterFiles = {};
data.substrateParameterFiles = {};
data.specificCellParameterFiles = {};
data.initialStateFiles = {};
data.loadedParameters = [];
data.simulationType = '';
data.parameterStudy.type = '';
data.exportSettings = {};
data.exportDt = {};
data.simulationNames = {};
data.simulationTime = 0;
data.maximumTimeStep = 0;
data.stopDivisionTime = -1;
data.fFAInfo = {};
data.removeCells.type = {};
data.removeCells.size = {};

end