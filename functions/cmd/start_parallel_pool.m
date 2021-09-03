function parforArg = start_parallel_pool(data)

if data.nCores > 1
    % Create a pool object
    poolObject = gcp('nocreate');
    
    maxCores = feature('numcores');
    
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
    % Set the pargor argument to normal parfor mode
    parforArg = Inf;
else
    parforArg = 0;
end