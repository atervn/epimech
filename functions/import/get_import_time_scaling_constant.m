function timeScalingFactor = get_import_time_scaling_constant(app)
% GET_IMPORT_TIME_SCALING_CONSTANT Calculate time scaling constant for
% import
%   The function calculate the time scaling constant for conversion between
%   import index and time
%   INPUT:
%       app: main application structure
%   OUTPUT:
%       timeScalingFactor: calculated time scaling factor
%   by Aapo Tervonen, 2021

% simulation or post plotting
switch app.appTask
    
    case 'simulate'
        
        % find the time step between exports in the imported data
        timeStep = (app.import.systemParameters.scalingTime*app.import.exportOptions.exportDt);

    case 'plotAndAnalyze'
        
        % find the time step between exports in the current imported data
        timeStep = (app.plotImport(app.selectedFile).systemParameters.scalingTime*app.plotImport(app.selectedFile).exportOptions.exportDt);
end

% get the time scaling factor
timeScalingFactor = 1/timeStep;

end