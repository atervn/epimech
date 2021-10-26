function nWorkers = start_parallel_pool(data)
% START_PARALLEL_POOL Start the parallel pool
%   The function starts the parallel pool for the simulation. If there is
%   a pool running already, it first deletes that. Also, it makes sure that
%   the number of cores requested is not more than what is available. If
%   only one core is requested, the function set the number of workers to
%   0.
%   INPUT:
%       nWorkers: number of parallel pool workers
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% if the simulation is run with more than one core
if data.nCores > 1
    
    % get current parallel pool
    poolObject = gcp('nocreate');
    
    % get the maximum number of cores in the system
    maxCores = feature('numcores');
    
    % if the user requested more cores than available, set the number of
    % cores to the maximum
    if data.nCores > maxCores
        data.nCores = maxCores;
    end
    
    % Check that if there is a pool running already
    if isempty(poolObject)
        
        % if no, create a new one
        parpool('local', data.nCores);
    else
        
        % if yes, delete the old one and create a new one
        delete(poolObject);
        parpool('local', data.nCores);
    end
    
    % Set the maximum number of workers to inf
    nWorkers = Inf;
else
    
    % set the maximum number of workers to 0
    nWorkers = 0;
end

end