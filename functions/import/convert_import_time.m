function outputTime = convert_import_time(app,timePoint,option)
% CONVERT_IMPORT_TIME Convert imported time point between the index and
% time
%   The function converts the imported time point between the import index
%   and the time in seconds.
%   INPUT:
%       app: main application object
%       timePoint: current time point to convert (either time in seconds or
%           import index)
%       option: variable to indicate the direction of the conversion
%   OUTPUT:
%       outputTime: the converted time or import index
%   by Aapo Tervonen, 2021

% simulation or post plotting
switch app.appTask
    
    case 'simulate'
        
        % get the time scaling factor for the import
        app.import.timeScalingFactor = get_import_time_scaling_constant(app);
        
        switch option
            
            % conversion from time to import index
            case 'timeToNumber'
                
                % get the index (1 added since the indexing starts at 1,
                % time at 0)
                outputTime = timePoint*app.import.timeScalingFactor + 1;
            
            % conversion from import index to time
            case 'numberToTime'
                
                % get the time (1 substracted since the indexing starts at
                % 1, time at 0)
                outputTime = (timePoint-1)/app.import.timeScalingFactor;    
        end
        
    case 'plotAndAnalyze'
        
        % get the time scaling factor for the import
        app.plotImport(app.selectedFile).timeScalingFactor = get_import_time_scaling_constant(app);
        
        switch option
            
            % conversion from time to import index
            case 'timeToNumber'
                
                % get the index (1 added since the indexing starts at 1,
                % time at 0)
                outputTime = timePoint*app.plotImport(app.selectedFile).timeScalingFactor + 1;
                
            % conversion from import index to time
            case 'numberToTime'
                
                % get the time (1 substracted since the indexing starts at
                % 1, time at 0)
                outputTime = (timePoint-1)/app.plotImport(app.selectedFile).timeScalingFactor;
        end
end