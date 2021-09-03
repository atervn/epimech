function data = read_simulation_names(fID,data)

if strcmp(fgetl(fID),'% simulation names')
    while 1
        line = fgetl(fID);
        if strcmp(line,'')
            if numel(data.simulationNames) > 0
                break
            else
                data.simulationNames{1} = 'simulation';
            end
        else
            data.simulationNames{end+1} = line;
        end
    end
else
    disp('Error. Wrong file format, the third line should be ''% simulation names''.')
    data = 0;
    return
end

if length(data.simulationNames) == 1
    hashtagIdx = find(data.simulationNames{1} == '#');
    if numel(hashtagIdx) > 0
        tempName = data.simulationNames{1};
        data.simulationNames = {};
        for i = 1:data.nSimulations
            tempName(hashtagIdx) = num2str(i);
            data.simulationNames{end+1} = tempName;
        end
    end
end

if ~any(length(data.simulationNames) == [1 data.nSimulations])
    disp(['Error. The number of given simulation names should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end