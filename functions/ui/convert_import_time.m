function outputTime = convert_import_time(app,timePoint,option)

switch app.appTask
    case 'simulate'
        app.import.timeScalingFactor = get_import_time_scaling_constant(app);
        
        switch option
            case 'timeToNumber'
                outputTime = timePoint*app.import.timeScalingFactor + 1;
            case 'numberToTime'
                outputTime = (timePoint-1)/app.import.timeScalingFactor;
                
        end
    case 'plotAndAnalyze'
        app.plotImport(app.selectedFile).timeScalingFactor = get_import_time_scaling_constant(app);
        
        switch option
            case 'timeToNumber'
                outputTime = timePoint*app.plotImport(app.selectedFile).timeScalingFactor + 1;
            case 'numberToTime'
                outputTime = (timePoint-1)/app.plotImport(app.selectedFile).timeScalingFactor;
                
        end
        
end