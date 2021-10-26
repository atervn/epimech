function data = check_output_names(data)
% CHECK_OUTPUT_NAMES Check that all simulation names are unique
%   The function makes sure that all simulation names are unique to prevent
%   files being overwritten during the simulation run.
%   INPUT:
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% go through the simulation names
for i = 1:length(data.simulationNames)-1
    
    % go through all the simulations with higher index
    for ii = i+1:length(data.simulationNames)
        
        % check if the names are the same
        if strcmp(data.simulationNames{i},data.simulationNames{ii})
            
            % if yes, give error and return
            disp(['Duplicate simulation names: ' data.simulationNames{i} ' (simulation numbers ' num2str(i) ' and ' num2str(ii) ').']); data = 0; return
        end
    end
end

end