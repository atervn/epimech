function outputString = set_real_time_steps(app,option)

switch option
    case 'plotting'
        dtTemp = app.systemParameters.maximumTimeStep*app.plottingOptions.plotDtMultiplier;
    case 'export'
        dtTemp = app.systemParameters.maximumTimeStep*app.customExportOptions.exportDtMultiplier;
end

if dtTemp == 0.001
    outputString = ['= ' num2str(dtTemp*1000,3) ' msec'];
elseif dtTemp < 1
    outputString = ['= ' num2str(dtTemp*1000,3) ' msecs'];
elseif dtTemp == 1
    outputString = ['= ' num2str(dtTemp,3) ' sec'];
elseif dtTemp < 60
    outputString = ['= ' num2str(dtTemp,3) ' secs'];
elseif dtTemp == 60
    outputString = ['= ' num2str(dtTemp/60,3) ' min'];
elseif dtTemp < 60*60
    outputString = ['= ' num2str(dtTemp/60,3) ' mins'];
elseif dtTemp == 60*60
    outputString = ['= ' num2str(dtTemp/60/60,3) ' hour'];
elseif dtTemp < 60*60*24
    outputString = ['= ' num2str(dtTemp/60/60,3) ' hours'];
elseif dtTemp == 60*60*24
    outputString = ['= ' num2str(dtTemp/60/60/24,3) ' day'];
else
    outputString = ['= ' num2str(dtTemp/60/60/24,3) ' days'];
end