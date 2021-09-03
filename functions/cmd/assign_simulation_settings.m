function data = assign_simulation_settings(data)

%% SYSTEM PARAMETERS
if length(data.systemParameterFiles) ~= data.nSimulations
    if strcmp(data.systemParameterFiles{1},'load')
        [file,path] = uigetfile('.txt','Select a system parameter file for all of the simulations');
        if file == 0
            data = 0;
            return
        else
            data.systemParameterFiles{1} = [path file];
        end
    end
    for i = 2:data.nSimulations
        data.systemParameterFiles{i} = data.systemParameterFiles{1};
    end
else
    for i = 1:data.nSimulations
        if strcmp(data.systemParameterFiles{i},'load')
            [file,path] = uigetfile('.txt',['Select a system parameter file for simulation ' num2str(i)]);
            if file == 0
                data = 0;
                return
            else
                data.systemParameterFiles{i} = [path file];
            end
        end
    end
end

%% CELL PARAMETERS
if length(data.cellParameterFiles) ~= data.nSimulations
    if strcmp(data.cellParameterFiles{1},'load')
        [file,path] = uigetfile('.txt','Select a cell parameter file for all of the simulations');
        if file == 0
            data = 0;
            return
        else
            data.cellParameterFiles{1} = [path file];
        end
    end
    for i = 2:data.nSimulations
        data.cellParameterFiles{i} = data.cellParameterFiles{1};
    end
else
    for i = 1:data.nSimulations
        if strcmp(data.cellParameterFiles{i},'load')
            [file,path] = uigetfile('.txt',['Select a cell parameter file for simulation ' num2str(i)]);
            if file == 0
                data = 0;
                return
            else
                data.cellParameterFiles{i} = [path file];
            end
        end
    end
end

%% SPECIFIC CELL PARAMETERS
if length(data.specificCellParameterFiles) ~= data.nSimulations
    if strcmp(data.specificCellParameterFiles{1},'load')
        [file,path] = uigetfile('.txt','Select a specific cell parameter file for all of the simulations');
        if file == 0
            data = 0;
            return
        else
            data.specificCellParameterFiles{1} = [path file];
        end
    end
    for i = 2:data.nSimulations
        data.specificCellParameterFiles{i} = data.specificCellParameterFiles{1};
    end
else
    for i = 1:data.nSimulations
        if strcmp(data.specificCellParameterFiles{i},'load')
            [file,path] = uigetfile('.txt',['Select a specific cell parameter file for simulation ' num2str(i)]);
            if file == 0
                data = 0;
                return
            else
                data.specificCellParameterFiles{i} = [path file];
            end
        end
    end
end


%% SUBSTRATE PARAMETERS

if ~strcmp(data.simulationType,'growth')
    if length(data.substrateParameterFiles) ~= data.nSimulations
        if strcmp(data.stiffnessType{1},'gradient') || strcmp(data.stiffnessType{1},'heterogenous')
            if strcmp(data.stiffnessInfo{1},'load')
                if strcmp(data.stiffnessType,'gradient')
                    [file,path] = uigetfile('.txt','Select a stiffness gradient');
                elseif strcmp(data.stiffnessType,'heterogenous')
                    [file,path] = uigetfile('.txt','Select a stiffness heterogeneity');
                end
                if file == 0
                    data = 0;
                    return
                else
                    data.stiffnessInfo{1} = [path file];
                end
            end
        end
        
        
        
        if strcmp(data.substrateParameterFiles{1},'load')
            [file,path] = uigetfile('.txt','Select a substrate parameter file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.substrateParameterFiles{1} = [path file];
            end
        end
        if strcmp(data.fFAInfo{1},'load')
            [file,path] = uigetfile('.csv','Select a fFAInfo file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.fFAInfo{1} = [path file];
            end
        end
        for i = 2:data.nSimulations
            data.stiffnessType{i} = data.stiffnessType{1};
            data.stiffness{i} = data.stiffness{1};
            data.stiffnessInfo{i} = data.stiffnessInfo{1};
            data.substrateParameterFiles{i} = data.substrateParameterFiles{1};
            data.fFAInfo{i} = data.fFAInfo{1};
        end
    else
        for i = 1:data.nSimulations
            if strcmp(data.stiffnessType{i},'gradient') || strcmp(data.stiffnessType{i},'heterogenous')
                if strcmp(data.stiffnessInfo{i},'load')
                    if strcmp(data.stiffnessType{i},'gradient')
                        [file,path] = uigetfile('.txt','Select a stiffness gradient');
                    elseif strcmp(data.stiffnessType{i},'heterogenous')
                        [file,path] = uigetfile('.txt','Select a stiffness heterogeneity');
                    end
                    if file == 0
                        data = 0;
                        return
                    else
                        data.stiffnessInfo{i} = [path file];
                    end
                end
            end
            
            if strcmp(data.substrateParameterFiles{i},'load')
                [file,path] = uigetfile('.txt',['Select a substrate parameter file for simulation ' num2str(i)]);
                if file == 0
                    data = 0;
                    return
                else
                    data.substrateParameterFiles{i} = [path file];
                end
            end
            if strcmp(data.fFAInfo{i},'load')
                [file,path] = uigetfile('.csv','Select a fFAInfo file for all of the simulations');
                if file == 0
                    data = 0;
                    return
                else
                    data.fFAInfo{i} = [path file];
                end
            end
        end
    end
end

%% INITIAL STATES
if ~isempty(data.initialStateFiles)
    if length(data.initialStateFiles) ~= data.nSimulations
        if strcmp(data.initialStateFiles{1},'load')
            [file,path] = uigetfile('.zip','Select a initial state file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.initialStateFiles{1} = [path file];
            end
        end
        for i = 2:data.nSimulations
            data.initialStateFiles{i} = data.initialStateFiles{1};
            data.loadedParameters(i) = data.loadedParameters(1);
            if ~isempty(data.removeCells.type)
                data.removeCells.type{i} = data.removeCells.type{1};
                data.removeCells.size{i} = data.removeCells.size{1};
            end
        end
    else
        for i = 1:data.nSimulations
            if strcmp(data.initialStateFiles{i},'load')
                [file,path] = uigetfile('.zip',['Select a initial state file for simulation ' num2str(i)]);
                if file == 0
                    data = 0;
                    return
                else
                    data.initialStateFiles{i} = [path file];
                end
            end
        end
    end
end

%% SIMULATION SPECIFIC INPUT

if strcmp(data.simulationType,'growth') % GROWTH
    if length(data.sizeType) ~= data.nSimulations
        data.sizeType = ones(1,data.nSimulations).*data.sizeType;
    end
elseif strcmp(data.simulationType,'pointlike') % POINTLIKE
    if length(data.pointlike.cell) ~= data.nSimulations
        if strcmp(data.pointlike.pointlikeMovement{1},'load')
            [file,path] = uigetfile('.txt','Select a pointlike movement file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.pointlike.pointlikeMovement{1} = [path file];
            end
        end
        for i = 2:data.nSimulations
            data.pointlike.cell{i} = data.pointlike.cell{1};
            data.pointlike.pointlikeMovement{i} = data.pointlike.pointlikeMovement{1};
        end
    else
        for i = 1:data.nSimulations
            if strcmp(data.pointlike.pointlikeMovement{1},'load')
                [file,path] = uigetfile('.txt',['Select a pointlike movement file for simulation ' num2str(i)]);
                if file == 0
                    data = 0;
                    return
                else
                    data.pointlike.pointlikeMovement{i} = [path file];
                end
            end
        end
    end
elseif strcmp(data.simulationType,'opto') % OPTO
    if length(data.opto.activation) ~= data.nSimulations
        if strcmp(data.opto.activation{1},'load')
            [file,path] = uigetfile('.csv','Select a activation file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.opto.activation{1} = [path file];
            end
        end
        if strcmp(data.opto.shapes{1},'load')
            [file,path] = uigetfile('.csv','Select a shapes file for all of the simulations');
            if file == 0
                data = 0;
                return
            else
                data.opto.shapes{1} = [path file];
            end
        end
        for i = 2:data.nSimulations
            data.opto.activation{i} = data.opto.activation{1};
            data.opto.shapes{i} = data.opto.shapes{1};
        end
    else
        for i = 1:data.nSimulations
            if strcmp(data.opto.activation{i},'load')
                [file,path] = uigetfile('.csv',['Select a activation file for simulation ' num2str(i)]);
                if file == 0
                    data = 0;
                    return
                else
                    data.opto.activation{i} = [path file];
                end
            end
            if strcmp(data.opto.shapes{1},'load')
                [file,path] = uigetfile('.csv',['Select a shapes file for simulation ' num2str(i)]);
                if file == 0
                    data = 0;
                    return
                else
                    data.opto.shapes{i} = [path file];
                end
            end
        end
    end
elseif strcmp(data.simulationType,'stretch') % STRETCHING
    if length(data.stretching.directions) ~= data.nSimulations
        for i = 2:data.nSimulations
            data.stretching.directions{i} = data.stretching.directions{1};
            data.stretching.type{i} = data.stretching.type{1};
            data.stretching.info{i} = data.stretching.info{1};
        end
    end
end

%% EXPORT SETTINGS

if length(data.exportSettings) ~= data.nSimulations
    if strcmp(data.exportSettings{1},'load')
        [file,path] = uigetfile('.txt','Select a export settings file for all of the simulations');
        if file == 0
            data = 0;
            return
        else
            data.exportSettings{1} = [path file];
        end
    end
    for i = 2:data.nSimulations
        data.exportSettings{i} = data.exportSettings{1};
    end
else
    for i = 1:data.nSimulations
        if strcmp(data.exportSettings{i},'load')
            [file,path] = uigetfile('.txt',['Select a export settings file for simulation ' num2str(i)]);
            if file == 0
                data = 0;
                return
            else
                data.exportSettings{i} = [path file];
            end
        end
    end
end

%% SIMULATION NAMES

if length(data.simulationNames) == 1 && data.nSimulations > 1
    simName = data.simulationNames{1};
    for i = 1:data.nSimulations
        data.simulationNames{i} = [simName '_' num2str(i)];
    end
end