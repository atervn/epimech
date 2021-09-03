function data = check_output_names(data)

for i = 1:length(data.simulationNames)-1
    for ii = i+1:length(data.simulationNames)
        if strcmp(data.simulationNames{i},data.simulationNames{ii})
            disp(['Duplicate simulation names: ' data.simulationNames{i} ' (simulation numbers ' num2str(i) ' and ' num2str(ii) ').']);
            data = 0;
            return
        end
    end
end