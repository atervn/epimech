function epimech_cmd(varargin)

if numel(varargin) == 0
    epimech_gui;
    return
else
    inputFile = varargin{1};
    if exist(inputFile) ~= 2 %#ok<EXIST>
        disp('Config txt file not found.');
        return;
    end
end

app.defaultPath = [fileparts(mfilename('fullpath')) '/'];

addpath(genpath([app.defaultPath '/functions']));

data = get_simulation_settings(inputFile);

if ~isstruct(data); return; end

data = check_output_names(data);

data = assign_simulation_settings(data);

defaultPath = [fileparts(mfilename('fullpath')) '/'];

if ~isempty(data.initialStateFiles)
    for i = 1:data.nSimulations
        [~,fileName,~] = fileparts(data.initialStateFiles{i});
        
        % define string for the imported folder
        app.import.folderName = [defaultPath 'Results/' fileName];
        
        if exist([defaultPath 'results'],'dir') ~= 7
            mkdir(defaultPath, 'results');
        end
        if exist([defaultPath  'results/' fileName],'dir') ~= 7
            unzip(data.initialStateFiles{i},[app.defaultPath  'results/'])
        end
    end
end

overall = tic;
startingTime = clock;
parforArg = start_parallel_pool(data);

parfor (iLoop = 1:data.nSimulations, parforArg)
    % for iLoop = data.nSimulations:-1:1
    
%     try
        
        pause(iLoop)
        rng shuffle
        
        tic;
        
        d = initialize_d_structure;
        
        d.simset = define_simset_structure;
        
        switch data.simulationType
            case 'growth'
                d.simset.solver = 1;
            case 'pointlike'
                d.simset.solver = 2;
            case 'opto'
                d.simset.solver = 2;
            case 'stretch'
                d.simset.solver = 2;
        end
        
        if strcmp(data.simulationType,'growth')
            d.simset.simulationType = 1;
        elseif strcmp(data.simulationType,'pointlike')
            d.simset.simulationType = 2;
        elseif strcmp(data.simulationType,'opto')
            d.simset.simulationType = 5;
        elseif strcmp(data.simulationType,'stretch')
            d.simset.simulationType = 3;
        end
        
        d.simset.divisionType = 1;
        d.simset.simulating = 1;
        d.simset.progressBar = false;
        d.simset.timeSimulation = false;
        d.simset.simulating = 0;
        d.simset.stopped = 0;
        d.simset.stopOrPause = false;
        d.simset.dtPlot = 0;
        
        
        app = struct();
        app.defaultPath = [fileparts(mfilename('fullpath')) '/'];
        app.systemParameters = import_settings(data.systemParameterFiles{iLoop});
        
        app.cellParameters = import_settings(data.cellParameterFiles{iLoop});
        app.specificCellParameters = import_settings(data.specificCellParameterFiles{iLoop});
        
        if any(d.simset.simulationType == [2 3 5])
            app.substrateParameters = import_settings(data.substrateParameterFiles{iLoop});
            app.fFAInfo = csvread(data.fFAInfo{iLoop});
            app.substrateParameters.youngsModulus = data.stiffness{iLoop};
        end
        
        [app,stop] = setup_parameter_study(data,app,iLoop);
        if ~stop
            
            app.systemParameters.simulationTime = data.simulationTime;
            app.systemParameters.maximumTimeStep = data.maximumTimeStep;
            if data.stopDivisionTime ~= 0
                app.systemParameters.stopDivisionTime = data.stopDivisionTime;
                d.simset.divisionType = 2;
            end
            
            app.customExportOptions = settings_to_logical(import_settings(data.exportSettings{iLoop}),'export');
            
            app.simulationType = data.simulationType;
            
            app.appTask = 'simulate';
            
            app.ExportdataCheckBox.Value = 1;
            app.customExportOptions.exportDtMultiplier = data.exportDt;
            app.ExporteddataDropDown.Value = 'Custom export';
            app.SimulationnameEditField.Value = data.simulationNames{iLoop};
            app.simulationClosed = 0;
            app.simulationStopped = 0;
            app.defaultPath = [fileparts(mfilename('fullpath')) '/'];
            
            d.spar = scale_parameters(app);
            
            if isempty(data.initialStateFiles)
                app.modelCase = 'new';
                d.cells = initialize_cells_struct;
                d = single_cell_initialization(d,[0;0]);
                if strcmp(data.simulationType,'growth')
                    d.simset.sizeType = data.sizeType(iLoop);
                elseif strcmp(data.simulationType,'pointlike')
                    d.simset.sizeType = 0;
                elseif strcmp(data.simulationType,'opto')
                    d.simset.sizeType = 0;
                end
                d.cells = assign_cortical_tensions(app, d.cells, d.spar);
            else
                app.modelCase = 'loaded';
                app.import = struct();
                [~,fileName,~] = fileparts(data.initialStateFiles{iLoop});
                
                % define string for the imported folder
                app.import.folderName = [app.defaultPath 'Results/' fileName];
                
                app.import.nTimePoints = size(dir([app.import.folderName '/vertices/*.csv']),1);
                fID = fopen([app.import.folderName '/simulation_type.csv']);
                app.import.simulationType = fread(fID,'*char')';
                fclose(fID);
                app.import.currentTimePoint = app.import.nTimePoints;
                app.import.systemParameters = import_settings([app.import.folderName '/system_parameters.csv']);
                app.import.scaledParameters = import_settings([app.import.folderName '/scaled_parameters.csv']);
                app.import.cellParameters = import_settings([app.import.folderName '/cell_parameters.csv']);
                
                
                if data.loadedParameters(iLoop) == 1
                    app.cellParameters = app.import.cellParameters;
                    d.spar = scale_parameters(app);
                end
                
                d.spar.normArea = app.import.scaledParameters.normArea;
                d.spar.membraneLength = app.import.scaledParameters.membraneLength;
                
                if data.loadedParameters(iLoop) == 0
                    d.spar.fArea = app.import.scaledParameters.fArea*app.systemParameters.scalingTime/app.systemParameters.eta/app.import.scaledParameters.scalingTime*app.import.systemParameters.eta;
                end
                
                d.cells = import_cells(app,'simulation');
                
                if ~isempty(data.removeCells.type)
                    shapeSize = data.removeCells.size{iLoop}*1e-6/d.spar.scalingLength/2;
                    
                    outsideShape = [];
                    for k = 1:length(d.cells)
                        cellCenterX = mean(d.cells(k).verticesX);
                        cellCenterY = mean(d.cells(k).verticesY);
                        if strcmp(data.removeCells.type{iLoop},'s')
                            if ~(cellCenterX > -shapeSize && cellCenterX < shapeSize && cellCenterY > -shapeSize && cellCenterY < shapeSize)
                                outsideShape(end+1) = k;
                            end
                        elseif strcmp(data.removeCells.type{iLoop},'c')
                            if ~(sqrt(cellCenterX^2 + cellCenterY^2) <= shapeSize)
                                outsideShape(end+1) = k;
                            end
                        end
                    end
                    removedCells = outsideShape;
                    
                    for k = length(removedCells):-1:1
                        d = remove_cell_and_links(d,removedCells(k));
                    end
                end
                
                d.cells = assign_cortical_tensions(app, d.cells, d.spar);
                d.cells = initialize_junction_data(d.cells);
                
                if d.simset.simulationType == 1
                    d.cells = set_division_times(d.cells,d.simset,d.spar,length(d.cells));
                end
                d.simset.sizeType = csvread([app.import.folderName '/size_type.csv']);
                
                if any(d.simset.simulationType == [2 3 5])
                    for k = 1:length(d.cells)
                        if d.cells(k).division.state ~= 0
                            d.cells(k).division.state = 0;
                            d.cells(k).normArea = d.cells(k).area*1.1;
                        end
                    end
                    
                end
                
            end
            
            d = get_edge_vertices(d);
            
            if d.simset.simulationType == 1 && d.simset.sizeType == 2
                
                f = @(x) 0.02902.*exp(-((x-103.3)./12.82).^2) + 0.05107.*exp(-((x-79.61)./19.21).^2) + 0.07028.*exp(-((x-107.9)./45.84).^2) + 0.0126.*exp(-((x-164)./79.22).^2);
                nTries = 10000;
                
                d.simset.newAreas = slicesample(1,nTries,'pdf',f)*1e-12/d.spar.scalingLength^2;
            end
            
            if any(d.simset.simulationType == [2,3,5])
                
                d.sub = initialize_substrate_structure;
                
                maxPointX = zeros(1,length(d.cells));
                minPointX = maxPointX;
                maxPointY = maxPointX;
                minPointY = maxPointX;
                for k = 1:length(d.cells)
                    maxPointX(k) = max(d.cells(k).verticesX);
                    minPointX(k) = min(d.cells(k).verticesX);
                    maxPointY(k) = max(d.cells(k).verticesY);
                    minPointY(k) = min(d.cells(k).verticesY);
                end
                
                maxSize = max(max([abs([maxPointX; minPointX; maxPointY; minPointY])]));
                
                d.spar.substrateSize = maxSize*2 + d.spar.rCell;
                
                if d.simset.simulationType == 3
                    
                    if data.stretching.type{iLoop} == 1
                        
                        piecewiseData = csvread(data.stretching.info{iLoop});
                        
                        d.simset.stretch.times = [piecewiseData(:,1); 2*d.spar.simulationTime]./d.spar.scalingTime;
                        d.simset.stretch.values = [piecewiseData(:,2); piecewiseData(end,2)];
                        
                    else
                        sineData = csvread(data.stretching.info{iLoop});
                        dt = min(0.001,1./(sineData(2).*d.spar.scalingTime)./60);
                        d.simset.stretch.times = 0:dt:(d.spar.simulationTime*1.1);
                        d.simset.stretch.values = 1 + sineData(1).*sin(2.*pi.*sineData(2).*d.spar.scalingTime.*d.simset.stretch.times + sineData(3));
                    end
                    
                    d.simset.stretch.axis = data.stretching.directions{iLoop};
                end
                
                d = form_substrate(d,app);
                
                switch data.stiffnessType{iLoop}
                    case 'uniform'
                        app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Constant';
                    case 'gradient'
                        app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Gradient';
                        app.stiffnessGradientInformation = csvread(data.stiffnessInfo{iLoop});
                    case 'heterogenous'
                        app.StiffnessstyleButtonGroup.SelectedObject.Text = 'Heterogeneous';
                        app.heterogenousStiffness = csvread(data.stiffnessInfo{iLoop});
                end
                
                expansionMultiplier = 1.5;
                
                while 1
                    
                    d = remove_substrate_points(d,app,expansionMultiplier);
                    if any(d.simset.simulationType == [2,5])
                        d = get_substrate_spring_constants(d,app);
                        d = get_substrate_edge_points(d);
                    end
                    
                    
                    % define focal adhesions
                    [d, ok] = form_focal_adhesions(d,app);
                    if ~ok
                        expansionMultiplier = expansionMultiplier*1.1;
                    else
                        break;
                    end
                end
            end
            
            if d.simset.simulationType == 2
                
                
                
                if strcmp(app.import.simulationType,'pointlike')
                    
                    movementData = csvread([app.import.folderName '/pointlike/movement_data.csv']);
                    d.simset.pointlike.movementTime = [movementData(:,1); movementData(end,1)];
                    d.simset.pointlike.movementY = [movementData(:,2); 1e20];
                    pointlikeData = import_settings([app.import.folderName '/pointlike/pointlike_data.csv']);
                    
                    d.simset.pointlike.cell = pointlikeData.cell;
                    d.simset.pointlike.originalX = pointlikeData.originalX;
                    d.simset.pointlike.originalY = pointlikeData.originalY;
                    
                    originalVertices = csvread([app.import.folderName '/pointlike/original_vertex_locations.csv']);
                    d.simset.pointlike.vertexOriginalX = originalVertices(:,1);
                    d.simset.pointlike.vertexOriginalY = originalVertices(:,2);
                    
                    time = convert_import_time(app,app.import.currentTimePoint,'numberToTime');
                    
                    previousTime = max(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime <= time));
                    nextTime = min(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime > time));
                    
                    previousIdx = find(d.simset.pointlike.movementTime == previousTime);
                    nextIdx = find(d.simset.pointlike.movementTime == nextTime);
                    
                    if previousTime == time
                        displacementY = d.simset.pointlike.movementY(previousIdx);
                    else
                        displacementY = d.simset.pointlike.movementY(previousIdx) + (d.simset.pointlike.movementY(nextIdx) - d.simset.pointlike.movementY(previousIdx))*(time - d.simset.pointlike.movementY(previousIdx))/(d.simset.pointlike.movementTime(nextIdx) - d.simset.pointlike.movementTime(previousIdx));
                    end
                    
                    
                    d.simset.pointlike.movementTime = d.simset.pointlike.movementTime - time;
                    tempIdx = find(d.simset.pointlike.movementTime <= 0);
                    d.simset.pointlike.movementTime(tempIdx) = [];
                    d.simset.pointlike.movementTime = [0 ; 2*d.simset.pointlike.movementTime];
                    
                    if max(tempIdx) > 1
                        d.simset.pointlike.movementY(1:max(tempIdx)-1) = [];
                        d.simset.pointlike.movementY = [displacementY ; d.simset.pointlike.movementY];
                    else
                        d.simset.pointlike.movementY(1) = displacementY;
                    end
                    
                    multiplier = (2 - abs(max(d.simset.pointlike.vertexOriginalY) - d.simset.pointlike.originalY))/2;
                    
                    d.simset.pointlike.pointY = d.simset.pointlike.originalY + displacementY;
                    
                    d.simset.pointlike.vertexY = d.simset.pointlike.vertexOriginalY + displacementY.*multiplier;
                    d.simset.pointlike.vertexX = d.simset.pointlike.vertexOriginalX;
                    
                    
                    
                else
                    
                    importedData = csvread(data.pointlike.pointlikeMovement{iLoop});
                    
                    app.pointlikeProperties.movementTime = importedData(:,1)./d.spar.scalingTime;
                    app.pointlikeProperties.movementY = importedData(:,2)./d.spar.scalingLength;
                    
                    if data.pointlike.cell{iLoop} == 0
                        d.simset.pointlike.cell = get_center_cell(d.cells);
                    else
                        d.simset.pointlike.cell = data.pointlike.cell{iLoop};
                    end
                    d.simset.pointlike.movementTime = app.pointlikeProperties.movementTime;
                    d.simset.pointlike.movementY = app.pointlikeProperties.movementY;
                    d.simset.pointlike.pointX = mean(d.cells(d.simset.pointlike.cell).verticesX);
                    d.simset.pointlike.pointY = mean(d.cells(d.simset.pointlike.cell).verticesY);
                    d.simset.pointlike.originalX = d.simset.pointlike.pointX;
                    d.simset.pointlike.originalY = d.simset.pointlike.pointY;
                    d.simset.pointlike.vertexX = d.cells(d.simset.pointlike.cell).verticesX;
                    d.simset.pointlike.vertexY = d.cells(d.simset.pointlike.cell).verticesY;
                    d.simset.pointlike.vertexOriginalX = d.cells(d.simset.pointlike.cell).verticesX;
                    d.simset.pointlike.vertexOriginalY = d.cells(d.simset.pointlike.cell).verticesY;
                end
            elseif d.simset.simulationType == 5
                
                activationData = csvread(data.opto.activation{iLoop});
                shapeData  = csvread(data.opto.shapes{iLoop});
                
                d.simset.opto.times = [activationData(:,1) ; 1e12]./d.spar.scalingTime;
                d.simset.opto.levels = [activationData(:,2); activationData(end,2)].*d.spar.fullActivationConstant;
                d.simset.opto.shapes = {};
                nShapes = sum(shapeData(:,1) == 0)+1;
                for i = 1:nShapes
                    [~,idx] = find(shapeData(:,1) == 0);
                    if isempty(idx)
                        d.simset.opto.shapes{i} = shapeData;
                        nextZero = 2;
                    else
                        nextZero = min(idx);
                        d.simset.opto.shapes{i} = shapeData(1:nextZero-1,:);
                    end
                    shapeData(1:nextZero,:) = [];
                end
                
                d.simset.opto.cells = [];
                d.simset.opto.vertices = {};
                d.simset.opto.currentTime = 1;
            end
            
            d.ex = setup_exporting(app,d,startingTime);
            
            d.pl = struct();
            d.pl.plot = 0;
            d.pl.videoObject = 0;
            
            d = main_simulation(d,app);
            
            
            
            zip_results(d,app);
        end
        dateVector = clock;
        
        singleSimTime = toc;
        
        % Formats the time
        timeSimulationEnd = datestr(dateVector, 'HH:MM:SS');
        dataSimulationEnd = datestr(dateVector, 'dd/mmm/yyyy');
        runMessage = char(); %#ok<NASGU>
        if singleSimTime >= 60
            % Over an hour
            if singleSimTime >= 3600
                runMessage = sprintf('Simulation %.0f finished after %d h, %d min %.2f s at %s, %s', iLoop, floor(singleSimTime/3600), floor((singleSimTime - 3600*floor(singleSimTime/3600))/60), rem(singleSimTime - 3600*floor(singleSimTime/3600),60), timeSimulationEnd, dataSimulationEnd);
                % Under an hour
            else
                runMessage = sprintf('Simulation %.0f finished after %d min %.2f s at %s, %s', iLoop, floor(singleSimTime/60), rem(singleSimTime,60), timeSimulationEnd, dataSimulationEnd);
            end
            % Under a minute
        else
            runMessage = sprintf('Simulation %.0f finished after %.2f s at %s, %s', iLoop, rem(singleSimTime,60), timeSimulationEnd, dataSimulationEnd);
        end
        
        % Display the message
        disp(runMessage);
%     catch ME
%         runMessage = sprintf('Simulation %.0f failed', iLoop);
%         disp(runMessage);
%         fID = fopen(['simulation_' num2str(iLoop) '_error_log.txt'],'w');
%         fprintf(fID,[ME.identifier '\n' ME.message '\n' ME.stack.file '\n' ME.stack.name '\n' ME.stack.line '\n']);
%         fclose(fID);
%     end
end

if ~isempty(data.initialStateFiles)
    for i = 1:data.nSimulations
        [~,fileName,~] = fileparts(data.initialStateFiles{i});
        folderName = [app.defaultPath  'results/' fileName];
        if exist(folderName,'dir') == 7
            remove_folder_function(folderName);
        end
    end
end

if data.nCores > 1
    delete(gcp('nocreate'));
end

dateVector = clock;

totalTime = toc(overall);

% Formats the time
timeSimulationEnd = datestr(dateVector, 'HH:MM:SS');
dataSimulationEnd = datestr(dateVector, 'dd/mmm/yyyy');

if totalTime >= 60
    % Over an hour
    if totalTime >= 3600
        message = sprintf('The run finished after %d h, %d min %.2f s at %s, %s', floor(totalTime/3600), floor((totalTime - 3600*floor(totalTime/3600))/60), rem(totalTime - 3600*floor(totalTime/3600),60), timeSimulationEnd, dataSimulationEnd);
        % Under an hour
    else
        message = sprintf('The run finished after %d min %.2f s at %s, %s', floor(totalTime/60), rem(totalTime,60), timeSimulationEnd, dataSimulationEnd);
    end
    % Under a minute
else
    message = sprintf('The run finished after %.2f s at %s, %s', rem(totalTime,60), timeSimulationEnd, dataSimulationEnd);
end

% Display the message
disp(message);

