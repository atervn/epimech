function data = get_simulation_settings(fileName)

fID = fopen(fileName);

%% comments
while 1
    if strcmp(fgetl(fID),'')
        break
    end
end


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
data.exportDt = 0;
data.simulationNames = {};
data.simulationTime = 0;
data.maximumTimeStep = 0;
data.stopDivisionTime = 0;
data.fFAInfo = {};
data.removeCells.type = {};
data.removeCells.size = {};

%% simulation type
data = read_simulation_types(fID,data);
if ~isstruct(data)
   return 
end

%% number of cores
data = read_number_of_cores(fID,data);
if ~isstruct(data)
   return 
end

%% number of simulations
data = read_number_of_simulations(fID,data);
if ~isstruct(data)
   return 
end

%% system parameters
data = read_system_parameter_paths(fID, data);
if ~isstruct(data)
   return 
end

%% cell parameters
data = read_cell_parameter_paths(fID, data);
if ~isstruct(data)
   return 
end

%% substrate parameter files
data = read_substrate_parameter_paths(fID, data);
if ~isstruct(data)
   return 
end

%% initial state
data = read_initial_state_paths(fID,data);
if ~isstruct(data)
   return 
end

%% simulation time
data = read_simulation_times(fID,data);
if ~isstruct(data)
   return 
end

%% simulation specific input
data = read_simulation_specific_input(fID,data);
if ~isstruct(data)
   return 
end

%% parameter study
data = read_parameter_study(fID,data);
if ~isstruct(data)
   return 
end

%% export settings
data = read_export_settings(fID,data);
if ~isstruct(data)
   return 
end

%% simulation name
data = read_simulation_names(fID,data);
if ~isstruct(data)
   return 
end