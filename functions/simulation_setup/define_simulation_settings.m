function simset = define_simulation_settings(app,spar)

simset = define_simset_structure;

simset.simulating = 1;
simset.stopped = 0;

simset.progressBar = app.ProgressbarCheckBox.Value;
simset.timeSimulation = app.TimesimulationCheckBox.Value;
simset.stopOrPause = app.StopandpauseCheckBox.Value;
simset.dtPlot = app.TimestepplotCheckBox.Value;
simset.junctionModification = false;
simset.uniformDivision = 0;
if app.UniformdivisiontimesCheckBox.Value
    try
        simset.divisionRandomNumbers = csvread([app.defaultPath 'settings/Misc/random_division_numbers.txt']);
        simset.uniformDivision = 1;
    catch
        errordlg(['No \"random_division_numbers.txt\" file found in ' app.defaultPath 'settings/Misc/ folder.'],'Error','modal')
        simset.divisionRandomNumbers = 0;
    end
else
    simset.divisionRandomNumbers = 0;
end



simset.divisionNumberCounter = 1;

switch app.SolverDropDown.Value
    case 'RK2'
        simset.solver = 1;
    case 'RK4'
        simset.solver = 2;
end

switch app.simulationType
    case 'growth'
        simset.simulationType = 1;
    case 'pointlike'
        simset.simulationType = 2;
    case 'stretch'
        simset.simulationType = 3;
    case 'edge'
        simset.simulationType = 4;
    case 'opto'
        simset.simulationType = 5;
end

switch app.DivisiontypeButtongroup.SelectedObject.Text
    case 'Normal division'
        simset.divisionType = 1;
    case 'Division until'
        simset.divisionType = 2;
end

if simset.simulationType == 2
    if app.UseimportedmovementdataCheckBox.Value
        movementData = csvread([app.import.folderName '/pointlike/movement_data.csv']);
        simset.pointlike.movementTime = [movementData(:,1); movementData(end,1)];
        simset.pointlike.movementY = [movementData(:,2); 1e20];
    else
        simset.pointlike.movementTime = app.pointlikeProperties.movementTime./app.systemParameters.scalingTime;
        simset.pointlike.movementY = app.pointlikeProperties.movementY./app.systemParameters.scalingLength;
    end
elseif simset.simulationType == 3
    if app.stretch.type == 1
        simset.stretch.times = [app.stretch.piecewise(:,1); 2*spar.simulationTime]./spar.scalingTime;
        simset.stretch.values = [app.stretch.piecewise(:,2); app.stretch.piecewise(end,2)];
    else
        dt = min(0.001,1./(app.stretch.sine(2).*spar.scalingTime)./60);
        simset.stretch.times = 0:dt:(spar.simulationTime*1.1);
        simset.stretch.values = 1 + app.stretch.sine(1).*sin(2.*pi.*app.stretch.sine(2).*spar.scalingTime.*simset.stretch.times + app.stretch.sine(3));
    end
    switch app.CompressionAxisButtonGroup.SelectedObject.Text
        case 'Uniaxial'
            simset.stretch.axis = 1;
        case 'Biaxial'
            simset.stretch.axis = 2;
    end
end




if app.ProgressbarCheckBox.Value
    simset.progressBar = true;
    simset.percentVariable = 0.1;
    simset.progressVariable = 1;
    
    totalTime = round(spar.simulationTime*spar.scalingTime);
    
    if totalTime < 60
        simset.simulationTime.seconds = spar.simulationTime*spar.scalingTime;
        simset.simulationTime.minutes = 0;
        simset.simulationTime.hours = 0;
        simset.simulationTime.days = 0;
    elseif totalTime < 60*60
        simset.simulationTime.minutes = floor(round(totalTime,1)/60);
        simset.simulationTime.seconds = totalTime - simset.simulationTime.minutes*60;
        simset.simulationTime.hours = 0;
        simset.simulationTime.days = 0;
    elseif totalTime < 60*60*24
        simset.simulationTime.hours = floor(totalTime/(60*60));
        simset.simulationTime.minutes = floor(totalTime/60 - simset.simulationTime.hours*60);
        simset.simulationTime.seconds = totalTime - simset.simulationTime.minutes*60 - simset.simulationTime.hours*60*60;
        simset.simulationTime.days = 0;
    else
        simset.simulationTime.days = floor(totalTime/(60*60*24));
        simset.simulationTime.hours = floor(totalTime/(60*60) - simset.simulationTime.days*24);
        simset.simulationTime.minutes = floor(totalTime/60 - simset.simulationTime.hours*60 - simset.simulationTime.days*24*60);
        simset.simulationTime.seconds = totalTime - simset.simulationTime.minutes*60 - simset.simulationTime.hours*60*60 - simset.simulationTime.days*24*60*60;
    end

end

if strcmp(app.modelCase,'new')
    if simset.simulationType == 1
        switch app.CellsizeButtonGroup.SelectedObject.Text
            case 'Uniform sizing'
                simset.sizeType = 1;
            case 'MDCK sizing'
                simset.sizeType = 2;
                
                f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
                nTries = 10000;

                simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;
                
        end
        
    else
        simset.sizeType = 1;
    end
else
    simset.sizeType = app.import.sizeType;
    if simset.simulationType == 1
        if simset.sizeType == 2
            
            f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
            nTries = 10000;
            
            simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/spar.scalingLength^2;
            
        end
    end
end