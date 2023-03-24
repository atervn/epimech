function epimech_cmd(varargin)
% EPIMECH_CMD Run the epimech using command line
%   The function defines the simulations to run based on the user input in
%   the config file.
%   INPUT:
%       varargin: used to provide the path to the simulation config file
%       by Aapo Tervonen, 2021

% if no input, start the GUI and return
if numel(varargin) == 0
    epimech_gui;
    return
    
% otherwise
else
    
    % save the input filename
    inputFile = varargin{1};
    
    % check if the config file exists
    if exist(inputFile,'file') ~= 2
        
        % if not found, so error and stop
        disp('Config txt file not found.');
        return;
    end
end

% get the root path for the model
defaultPath = [fileparts(mfilename('fullpath')) '/'];

% add the functions folder to the path
addpath(genpath([defaultPath '/functions']));

% collect the simulation settings data from the input file
data = get_simulation_settings(inputFile);

% if there were errors, return
if ~isstruct(data); return; end

% check that all simulation names are unique
data = check_output_names(data);

% if there were errors, return
if ~isstruct(data); return; end

% assign simulation settings for the simulations
data = assign_simulation_settings(data);

% if there were errors, return
if ~isstruct(data); return; end

% if there are initial state files
if ~isempty(data.initialStateFiles)
    
    % go through the simulations
    for i = 1:data.nSimulations
        
        % get the file names of the initial state file
        [~,fileName,~] = fileparts(data.initialStateFiles{i});
                
        % check if the results folder exists in the epimech root folder, if
        % not, create it
        if exist([defaultPath 'results'],'dir') ~= 7
            mkdir(defaultPath, 'results');
        end
        
        % if the initial state for the current simulation has not been
        % unzipper, unzip it to the results folder
        if exist([defaultPath  'results/' fileName],'dir') ~= 7
            unzip(data.initialStateFiles{i},[defaultPath  'results/'])
        end
    end
end

% get the default path of the epimech root
defaultPath = [fileparts(mfilename('fullpath')) '/'];

% start the overall timing clock
overall = tic;

% get the simulation starting time
startingTime = clock;

% start the parallel pool
nWorkers = start_parallel_pool(data);

% go through the simulations
parfor (iLoop = 1:data.nSimulations, nWorkers)
    
    % try to run the simulation (makes sure that if one simulation breaks
    % down, the rest can run until the end)
    try
        
        % pause the simulation for a time that depends on the simulation
        % iteration (this is to make sure that every simulation have their
        % own rng seeds)
        pause(iLoop)
        
        % start timing for the simulation
        tic;
        
        % creat the app structure and setup the parameter study
        app = create_app_struct(data,iLoop,defaultPath);
        
        % if there were no problems setting up the parameter study
        if isstruct(app)
            
            % setup the simulation
            d = setup_simulation(app,startingTime);
            
            % run the simulation
            d = main_simulation(app,d);
            
            % zip the results
            zip_results(app,d);
        end
        
        % show the finishing message for the simulation
        show_simulation_time(toc,1,iLoop);
        
    % catch errors 
    catch ME
        
        % print that there was an error
        fprintf('Simulation %.0f failed\n', iLoop);
        
        % create an error report file to the root, write the error report
        % and close the file
        fID = fopen(['simulation_' num2str(iLoop) '_error_log.txt'],'w');
        fprintf(fID, '%s\n', getReport(ME, 'extended'));
        fclose(fID);
    end
end

% if there were initial state files
if ~isempty(data.initialStateFiles)
    
    % go through the simulations and remove the unzipped initial state
    % files if they exist
    for i = 1:data.nSimulations
        [~,fileName,~] = fileparts(data.initialStateFiles{i});
        folderName = [defaultPath  'results/' fileName];
        if exist(folderName,'dir') == 7
            remove_folder(folderName);
        end
    end
end

% if there was parallel pool, remove it
if data.nCores > 1
    delete(gcp('nocreate'));
end

% show the finishing message for the all simulations
show_simulation_time(toc(overall),2)

end