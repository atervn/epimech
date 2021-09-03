function timeScalingFactor = get_import_time_scaling_constant(app)

switch app.appTask
    case 'simulate'
        timeStep = (app.import.systemParameters.scalingTime*app.import.exportOptions.exportDt);
        timeScalingFactor = 1/timeStep;

    case 'plotAndAnalyze'
        timeStep = (app.plotImport(app.selectedFile).systemParameters.scalingTime*app.plotImport(app.selectedFile).exportOptions.exportDt);
        timeScalingFactor = 1/timeStep;
end
end