function data = assign_simulation_settings(data)
% ASSIGN_SIMULATION_SETTINGS Assign settings for simulations
%   The function assigns the settings for all simulations for the collected
%   data. If settings or parameters were defined only once, they are set
%   for all simulations. Also, if the file names were replaced by "load"
%   the function opens a dialog to select the files.
%   INPUT:
%       fileName: name of the config file
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

%% system parameters

% check if the number of system parameter files does not equal the number
% of simulation
if length(data.systemParameterFiles) ~= data.nSimulations
    
    % if the file name is "load"
    if strcmp(data.systemParameterFiles{1},'load')
        
        % open a dialog to choose a system parameters file
        [file,path] = uigetfile('.txt','Select a system parameter file for all of the simulations');
        
        % if no file is chosen, return
        if file == 0
            data = 0; return
            
        % otherwise, get the file path and name
        else
            data.systemParameterFiles{1} = [path file];
        end
    end
    
    % go through the rest of the simulations and assign the same system
    % parameters for them
    for i = 2:data.nSimulations
        data.systemParameterFiles{i} = data.systemParameterFiles{1};
    end
    
% if the number of simulations equals the number of system parameters
else
    
    % go through the simulations
    for i = 1:data.nSimulations
        
        % if the file name is "load"
        if strcmp(data.systemParameterFiles{i},'load')
        
            % open a dialog to choose a system parameters file
            [file,path] = uigetfile('.txt',['Select a system parameter file for simulation ' num2str(i)]);
            
            % open a dialog to choose a system parameters file
            if file == 0
                data = 0; return
                
            % otherwise, get the file path and name
            else
                data.systemParameterFiles{i} = [path file];
            end
        end
    end
end


%% cell parameters

% check if the number of cell parameter files does not equal the number
% of simulation
if length(data.cellParameterFiles) ~= data.nSimulations
    
    % if the file name is "load"
    if strcmp(data.cellParameterFiles{1},'load')
        
        % open a dialog to choose a cell parameters file
        [file,path] = uigetfile('.txt','Select a cell parameter file for all of the simulations');
        
        % if no file is chosen, return
        if file == 0
            data = 0; return
            
        % otherwise, get the file path and name
        else
            data.cellParameterFiles{1} = [path file];
        end
    end
    
    % go through the rest of the simulations and assign the same cell
    % parameters for them
    for i = 2:data.nSimulations
        data.cellParameterFiles{i} = data.cellParameterFiles{1};
    end
    
% if the number of simulations equals the number of cell parameters
else
    
    % go through the simulations
    for i = 1:data.nSimulations
        
        % if the file name is "load"
        if strcmp(data.cellParameterFiles{i},'load')
        
            % open a dialog to choose a cell parameters file
            [file,path] = uigetfile('.txt',['Select a cell parameter file for simulation ' num2str(i)]);
            
            % open a dialog to choose a cell parameters file
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.cellParameterFiles{i} = [path file];
            end
        end
    end
end

%% specific cell parameters

% check if the number of specific cell parameter files does not equal the number
% of simulation
if length(data.specificCellParameterFiles) ~= data.nSimulations
    
    % if the file name is "load"
    if strcmp(data.specificCellParameterFiles{1},'load')
        
        % open a dialog to choose a specific cell parameters file
        [file,path] = uigetfile('.txt','Select a specific cell parameter file for all of the simulations');
        
        % if no file is chosen, return
        if file == 0
            data = 0; return
            
        % otherwise, get the file path and name
        else
            data.specificCellParameterFiles{1} = [path file];
        end
    end
    
    % go through the rest of the simulations and assign the same specific
    % cell parameters for them
    for i = 2:data.nSimulations
        data.specificCellParameterFiles{i} = data.specificCellParameterFiles{1};
    end
    
% if the number of simulations equals the number of specific cell
% parameters
else
    
    % go through the simulations
    for i = 1:data.nSimulations
        
        % if the file name is "load"
        if strcmp(data.specificCellParameterFiles{i},'load')
        
            % open a dialog to choose a specific cell parameters file
            [file,path] = uigetfile('.txt',['Select a specific cell parameter file for simulation ' num2str(i)]);
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.specificCellParameterFiles{i} = [path file];
            end
        end
    end
end


%% substrate parameters

% if other than growth simulation
if ~strcmp(data.simulationType,'growth')
    
    % check if the number of substraet parameter files does not equal the
    % number of simulations
    if length(data.substrateParameterFiles) ~= data.nSimulations
        
        % if gradient or heterogeneous stiffness
        if strcmp(data.stiffnessType{1},'gradient') || strcmp(data.stiffnessType{1},'heterogeneous')
            
            % check if the gradient or heterogeneous file is load
            if strcmp(data.stiffnessInfo{1},'load')
                if strcmp(data.stiffnessType,'gradient')
                    
                    % open a dialog to choose a stiffnee gradient file
                    [file,path] = uigetfile('.txt','Select a stiffness gradient');
                elseif strcmp(data.stiffnessType,'heterogeneous')
                    
                    % open a dialog to choose a heterogeneous stiffness
                    % file
                    [file,path] = uigetfile('.txt','Select a stiffness heterogeneity');
                end
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name
                else
                    data.stiffnessInfo{1} = [path file];
                end
            end
        end
                
        % if the substrate parameters is "load"
        if strcmp(data.substrateParameterFiles{1},'load')
            
            % open a dialog to choose a substrate parameters file
            [file,path] = uigetfile('.txt','Select a substrate parameter file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.substrateParameterFiles{1} = [path file];
            end
        end
        
        % if the focal adhesion info is "load"
        if strcmp(data.fFAInfo{1},'load')
            
            % open a dialog to choose a focal adhesion info file
            [file,path] = uigetfile('.csv','Select a fFAInfo file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
            
            % otherwise, get the file path and name
            else
                data.fFAInfo{1} = [path file];
            end
        end
        
        % go through the simulations and copy the stiffness data to other
        % simulations
        for i = 2:data.nSimulations
            data.stiffnessType{i} = data.stiffnessType{1};
            data.stiffness{i} = data.stiffness{1};
            data.stiffnessInfo{i} = data.stiffnessInfo{1};
            data.substrateParameterFiles{i} = data.substrateParameterFiles{1};
            data.fFAInfo{i} = data.fFAInfo{1};
        end
        
    % if the number of substraet parameter files equals the number of
    % simulations
    else
        
        % go through the simulations
        for i = 1:data.nSimulations
            
            % if gradient or heterogeneous stiffness
            if strcmp(data.stiffnessType{i},'gradient') || strcmp(data.stiffnessType{i},'heterogeneous')
                
                % check if the gradient or heterogeneous file is load
                if strcmp(data.stiffnessInfo{i},'load')
                    if strcmp(data.stiffnessType{i},'gradient')
                        
                        % open a dialog to choose a stiffnee gradient file
                        [file,path] = uigetfile('.txt','Select a stiffness gradient');
                    elseif strcmp(data.stiffnessType{i},'heterogeneous')
                        
                        % open a dialog to choose a heterogeneous stiffness
                        % file
                        [file,path] = uigetfile('.txt','Select a stiffness heterogeneity');
                    end
                    
                    % if no file is chosen, return
                    if file == 0
                        data = 0;
                        return
                        
                    % otherwise, get the file path and name
                    else
                        data.stiffnessInfo{i} = [path file];
                    end
                end
            end
            
            % if the substrate parameters is "load"
            if strcmp(data.substrateParameterFiles{i},'load')
                
                % open a dialog to choose a substrate parameters file
                [file,path] = uigetfile('.txt',['Select a substrate parameter file for simulation ' num2str(i)]);
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name    
                else
                    data.substrateParameterFiles{i} = [path file];
                end
            end
            
            % if the focal adhesion info is "load"
            if strcmp(data.fFAInfo{i},'load')
                
                % open a dialog to choose a focal adhesion info file
                [file,path] = uigetfile('.csv','Select a fFAInfo file for all of the simulations');
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name
                else
                    data.fFAInfo{i} = [path file];
                end
            end
        end
    end
end

%% initial states

% check if there are initial states defined
if ~isempty(data.initialStateFiles)
    
    % check if the number of initials states does not equal the number of
    % simulation 
    if length(data.initialStateFiles) ~= data.nSimulations
        
        % if the file name is "load"
        if strcmp(data.initialStateFiles{1},'load')
            
            % open a dialog to choose a initial state simulation file
            [file,path] = uigetfile('.zip','Select a initial state file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.initialStateFiles{1} = [path file];
            end
        end
        
        % go through the rest of the simulations and assign the same
        % initial state settings
        for i = 2:data.nSimulations
            data.initialStateFiles{i} = data.initialStateFiles{1};
            data.loadedParameters(i) = data.loadedParameters(1);
            if ~isempty(data.removeCells.type)
                data.removeCells.type{i} = data.removeCells.type{1};
                data.removeCells.size{i} = data.removeCells.size{1};
            end
        end
        
    % if the number of simulations equals the number of initial state
    % settings
    else
        
        % go through the simulations
        for i = 1:data.nSimulations
            
            % if the file name is "load"
            if strcmp(data.initialStateFiles{i},'load')
                
                % open a dialog to choose a specific cell parameters file
                [file,path] = uigetfile('.zip',['Select a initial state file for simulation ' num2str(i)]);
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name
                else
                    data.initialStateFiles{i} = [path file];
                end
            end
        end
    end
end

%% simulation specific input

% if growth simulation
if strcmp(data.simulationType,'growth')
    
    % if the number of sizeTypes does not equal the number of simulations
    if length(data.sizeType) ~= data.nSimulations
        
        % copy the sizetype to other simulations
        data.sizeType = ones(1,data.nSimulations).*data.sizeType;
    end
    
% if pointlike simulation    
elseif strcmp(data.simulationType,'pointlike')
    
    % if the number of pointlike settings does not equal the number of
    % simulations
    if length(data.pointlike.cell) ~= data.nSimulations
        
        % if the movement file is "load"
        if strcmp(data.pointlike.pointlikeMovement{1},'load')
            
            % open a dialog to choose a pointlike movement file
            [file,path] = uigetfile('.txt','Select a pointlike movement file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.pointlike.pointlikeMovement{1} = [path file];
            end
        end
        
        % copy the settings from the first simulation to the rest
        for i = 2:data.nSimulations
            data.pointlike.cell{i} = data.pointlike.cell{1};
            data.pointlike.pointlikeMovement{i} = data.pointlike.pointlikeMovement{1};
        end
        
    % if the number of pointlike settings equals the number of simulations
    else
        
        % go through the simulations
        for i = 1:data.nSimulations
            
            % if the movement file is "load"
            if strcmp(data.pointlike.pointlikeMovement{1},'load')
                
                % open a dialog to choose a pointlike movement file
                [file,path] = uigetfile('.txt',['Select a pointlike movement file for simulation ' num2str(i)]);
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name
                else
                    data.pointlike.pointlikeMovement{i} = [path file];
                end
            end
        end
    end
    
% if opto simulation
elseif strcmp(data.simulationType,'opto')
    
    % if the number of opto settings does not equal the number of
    % simulations
    if length(data.opto.activation) ~= data.nSimulations
        
        % if the activation file name is "load"
        if strcmp(data.opto.activation{1},'load')
            
            % open a dialog to choose a opto activation file
            [file,path] = uigetfile('.csv','Select an activation file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.opto.activation{1} = [path file];
            end
        end
        
        % if the activation shapes file name is "load"
        if strcmp(data.opto.shapes{1},'load')
            
            % open a dialog to choose a opto activation shapes file
            [file,path] = uigetfile('.csv','Select a shapes file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.opto.shapes{1} = [path file];
            end
        end
        
        % copy the settings from the first simulation to the rest
        for i = 2:data.nSimulations
            data.opto.activation{i} = data.opto.activation{1};
            data.opto.shapes{i} = data.opto.shapes{1};
        end
        
    % if the number of opto settings equals the number of simulations    
    else
        
        % go through the simulations
        for i = 1:data.nSimulations
            
            % if the activation file name is "load"
            if strcmp(data.opto.activation{i},'load')
                
                % open a dialog to choose an opto activation file
                [file,path] = uigetfile('.csv',['Select an activation file for simulation ' num2str(i)]);
                
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                    
                % otherwise, get the file path and name
                else
                    data.opto.activation{i} = [path file];
                end
            end
            
            % if the activation shapes file name is "load"
            if strcmp(data.opto.shapes{1},'load')
                
                % open a dialog to choose an opto activation shapes file
                [file,path] = uigetfile('.csv',['Select a shapes file for simulation ' num2str(i)]);
            
                % if no file is chosen, return
                if file == 0
                    data = 0;
                    return
                
                % otherwise, get the file path and name
                else
                    data.opto.shapes{i} = [path file];
                end
            end
        end
    end
    
% if stretch simulation
elseif strcmp(data.simulationType,'stretch') % STRETCHING
    
    % if the number of stretch settings does not equal the number of
    % simulations
    if length(data.stretching.directions) ~= data.nSimulations
        
        % if the stretch file is "load"
        if strcmp(data.stretching.info{1},'load')
            
            % open a dialog to choose a stretch file
            [file,path] = uigetfile('.txt','Select a stretch info file for all of the simulations');
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.stretching.info{1} = [path file];
            end
        end
        
        % copy the settings from the first simulation to the rest
        for i = 2:data.nSimulations
            data.stretching.directions{i} = data.stretching.directions{1};
            data.stretching.type{i} = data.stretching.type{1};
            data.stretching.info{i} = data.stretching.info{1};
        end
        
    % if the number of stretch settings equals the number of simulations
    else
        
        % go through the simulations
        for i = 1:data.nSimulations
            
            % if the stretch file name is "load"
            if strcmp(data.stretching.info{i},'load')
                
                % open a dialog to choose a stretch file
                [file,path] = uigetfile('.csv',['Select a stretch info file for simulation ' num2str(i)]);
                
                % if no file is chosen, return
                if file == 0
                    data = 0; return
                    
                % otherwise, get the file path and name
                else
                    data.stretching.info{i} = [path file];
                end
            end
        end
    end
end

%% export settings

% if the number of export settings does not equal the number of simulations
if length(data.exportSettings) ~= data.nSimulations
    
    % if the export settings file name is "load"
    if strcmp(data.exportSettings{1},'load')
        
        % open a dialog to choose an export settings file
        [file,path] = uigetfile('.txt','Select an export settings file for all of the simulations');
        
        % if no file is chosen, return
        if file == 0
            data = 0; return
            
        % otherwise, get the file path and name
        else
            data.exportSettings{1} = [path file];
        end
    end
    
    % copy the export settings from the first simulation to the rest
    for i = 2:data.nSimulations
        data.exportSettings{i} = data.exportSettings{1};
        data.exportDt{i} = data.exportDt{1};
    end
    
% if the number of export settings equals the number of simulations    
else
    
    % go through the simulations
    for i = 1:data.nSimulations
        
        % if the export settings file name is "load"
        if strcmp(data.exportSettings{i},'load')
            
            % open a dialog to choose an export settings file
            [file,path] = uigetfile('.txt',['Select an export settings file for simulation ' num2str(i)]);
            
            % if no file is chosen, return
            if file == 0
                data = 0;
                return
                
            % otherwise, get the file path and name
            else
                data.exportSettings{i} = [path file];
            end
        end
    end
end

%% simulation names

% if the number of simulation names does not equal that of the simulations
if length(data.simulationNames) == 1 && data.nSimulations > 1
    
    % get the base name
    simName = data.simulationNames{1};
    
    % go through the simulations and postfix underscore and simulation
    % number
    for i = 1:data.nSimulations
        data.simulationNames{i} = [simName '_' num2str(i)];
    end
end

end