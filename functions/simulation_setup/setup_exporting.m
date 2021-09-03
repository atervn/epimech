function ex = setup_exporting(app,d,startingTime)

ex = initialize_export_options_structure;

if app.ExportdataCheckBox.Value
    
    ex.export = 1;
    ex.exportDt = app.customExportOptions.exportDtMultiplier*d.spar.maximumTimeStep;
    
    switch app.ExporteddataDropDown.Value
        case 'Suitable for import'
            switch app.simulationType
                case 'growth'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_import_growth.txt']);
                case 'pointlike'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_import_pointlike.txt']);
                case 'stretch'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_import_stretching.txt']);
                case 'opto'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_import_optogenetics.txt']);
            end
        case 'Suitable for basic plotting'
            switch app.simulationType
                case 'growth'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_plotting_growth.txt']);
                case 'pointlike'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_plotting_pointlike.txt']);
                case 'stretch'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_plotting_stretching.txt']);
                case 'opto'
                    exTemp = import_settings([app.defaultPath 'settings/export/export_options_plotting_optogenetics.txt']);
            end
        case 'Full export'
            exTemp = import_settings([app.defaultPath 'settings/export/export_options_full.txt']);
        case 'Custom export'
            exTemp = app.customExportOptions;
    end
    
    fieldNames = fieldnames(exTemp);
    
    if exist('results') ~= 7 %#ok<EXIST>
        mkdir('results');
    end
    
    for i = 1:length(fieldNames)
        ex.(fieldNames{i}) = exTemp.(fieldNames{i});
    end
    
    ex.defaultPath = app.defaultPath;
    
    exportDate = datestr(startingTime, 'yyyymmdd');
    exportTime = datestr(startingTime, 'HHMMSS');
    if strcmp(app.SimulationnameEditField.Value,'Give name')
        ex.exportName = [exportDate '_' exportTime '_simulation'];
    else
        ex.exportName = [exportDate '_' exportTime '_' app.SimulationnameEditField.Value];
    end
    
    if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
        mkdir(app.defaultPath, 'results');
    end
    
    mkdir([app.defaultPath 'results/'], ex.exportName);
    folderPath = [app.defaultPath 'results/' ex.exportName];
    
    if ex.vertices
        mkdir(folderPath, 'vertices');
    end
    if ex.vertexStates
        mkdir(folderPath, 'vertex_states');
    end
    if ex.division
        mkdir(folderPath, 'division');
    end
    if ex.cellStates
        mkdir(folderPath, 'cell_states');
    end
    if ex.junctions
        mkdir(folderPath, 'junctions');
    end
    if ex.boundaryLengths
        mkdir(folderPath, 'boundary_lengths');
    end
    if ex.areas
        mkdir(folderPath, 'areas');
    end
    if ex.perimeters
        mkdir(folderPath, 'perimeters');
    end
    if ex.normProperties
        mkdir(folderPath, 'norm_properties');
    end
    if ex.corticalTensions
        mkdir(folderPath, 'cortical_tension');
    end
    if ex.lineage
        mkdir(folderPath, 'lineage');
    end
    if ex.pointlike && d.simset.simulationType == 2
        mkdir(folderPath, 'pointlike');
        
        pointlikeTemp = d.simset.pointlike;
        pointlikeTemp = rmfield(pointlikeTemp,{'pointX','pointY','vertexOriginalX','vertexOriginalY','vertexX','vertexY','movementTime','movementY'});
        
        fieldNames = fieldnames(pointlikeTemp);
        pointlikeCell = cell2mat(struct2cell(pointlikeTemp));
        fileID = fopen([app.defaultPath 'Results/' ex.exportName '/pointlike/pointlike_data.csv'], 'w');
        % go through the parameters
        for i = 1:length(pointlikeCell)
            fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(pointlikeCell(i)));
        end
        fclose(fileID);
        
        csvwrite([app.defaultPath 'Results/' ex.exportName '/pointlike/original_vertex_locations.csv'],[d.simset.pointlike.vertexOriginalX d.simset.pointlike.vertexOriginalY]);
        
        if size(app.pointlikeProperties.movementTime,1) == 1
            movementData = [d.simset.pointlike.movementTime'  d.simset.pointlike.movementY'];
        else
            movementData = [d.simset.pointlike.movementTime d.simset.pointlike.movementY];
        end
        csvwrite([app.defaultPath 'Results/' ex.exportName '/pointlike/movement_data.csv'],movementData);

    end
    
    if ex.opto && d.simset.simulationType == 5
        mkdir(folderPath, 'opto');
        csvwrite([app.defaultPath 'Results/' ex.exportName '/opto/opto_times.csv'],d.simset.opto.times);
        csvwrite([app.defaultPath 'Results/' ex.exportName '/opto/opto_levels.csv'],d.simset.opto.levels);
        csvwrite([app.defaultPath 'Results/' ex.exportName '/opto/opto_shapes.csv'],d.simset.opto.shapes);
    end
    
    if or(ex.substratePlot,ex.substrateFull) && any(d.simset.simulationType == [2,3,5])
        mkdir(folderPath, 'substrate');
        mkdir(folderPath, 'substrate_auxiliary');
        mkdir(folderPath, 'focal_adhesions');
    end
    if ex.cellForcesArea
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'area');
    end
    if ex.cellForcesCortical
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'cortical');
    end
    if ex.cellForcesJunctions
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'junction');
    end
    if ex.cellForcesDivision && d.simset.simulationType == 1
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'division');
    end
    if ex.cellForcesMembrane
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'membrane');
    end
    if ex.cellForcesFocalAdhesions && any(d.simset.simulationType == [2,3,5])
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'focal_adhesion');
    end
    if ex.cellForcesPointlike && d.simset.simulationType == 2
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'pointlike');
    end
    if ex.cellForcesContact
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'contact');
    end
    if ex.cellForcesTotal
        if exist([folderPath '/cell_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'cell_forces');
        end
        mkdir([folderPath '/cell_forces'], 'total');
    end
    if ex.substrateForcesDirect && any(d.simset.simulationType == [2 5])
        if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'substrate_forces');
        end
        mkdir([folderPath '/substrate_forces'], 'direct');
    end
    if ex.substrateForcesRepulsion && any(d.simset.simulationType == [2 5])
        if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'substrate_forces');
        end
        mkdir([folderPath '/substrate_forces'], 'repulsion');
    end
    if ex.substrateForcesRestoration && any(d.simset.simulationType == [2 5])
        if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'substrate_forces');
        end
        mkdir([folderPath '/substrate_forces'], 'restoration');
    end
    if ex.substrateForcesFocalAdhesions && any(d.simset.simulationType == [2 5])
        if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'substrate_forces');
        end
        mkdir([folderPath '/substrate_forces'], 'focal_adhesion');
    end
    if ex.substrateForcesTotal && any(d.simset.simulationType == [2 5])
        if exist([folderPath '/substrate_forces']) ~= 7 %#ok<EXIST>
            mkdir(folderPath, 'substrate_forces');
        end
        mkdir([folderPath '/substrate_forces'], 'total');
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CELL PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get the parameter field names
    fieldNames = fieldnames(app.cellParameters);
    
    % get the parameter values
    cellParameterMatrix = cell2mat(struct2cell(app.cellParameters));
    
    % create the export file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/cell_parameters.csv'], 'w');
    
    % go through the parameters
    for i = 1:length(cellParameterMatrix)
        
        % write the parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(cellParameterMatrix(i)));
    end
    
    % close the file
    fclose(fileID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SPECIFIC CELL PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get the parameter field names
    fieldNames = fieldnames(app.specificCellParameters);
    
    % get the parameter values
    specificCellParameterMatrix = cell2mat(struct2cell(app.specificCellParameters));
    
    % create the export file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/specific_cell_parameters.csv'], 'w');
    
    % go through the parameters
    for i = 1:length(specificCellParameterMatrix)
        
        % write the parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(specificCellParameterMatrix(i)));
    end
    
    % close the file
    fclose(fileID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SYSTEM PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get the parameter field names
    fieldNames = fieldnames(app.systemParameters);
    
    % get the parameter values
    systemParameterMatrix = cell2mat(struct2cell(app.systemParameters));
    
    % create the export file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/system_parameters.csv'], 'w');
    
    % go through the parameters
    for i = 1:length(systemParameterMatrix)
        
        % write the parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(systemParameterMatrix(i)));
    end
    
    % close the file
    fclose(fileID);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SUBSTRATE PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(app.simulationType,'pointlike') || strcmp(app.simulationType,'opto') 
        
        if strcmp(app.StiffnessstyleButtonGroup.SelectedObject.Text,'Gradient')
            substrateParameters = rmfield(app.substrateParameters,'youngsModulus');
        else
            substrateParameters = app.substrateParameters;
        end
        
        % get the parameter field names
        fieldNames = fieldnames(substrateParameters);
        
        % get the parameter values
        substrateParameterMatrix = cell2mat(struct2cell(substrateParameters));
        
        % create the export file
        fileID = fopen([app.defaultPath 'Results/' ex.exportName '/substrate_parameters.csv'], 'w');
        
        % go through the parameters
        for i = 1:length(substrateParameterMatrix)
            
            % write the parameter name and value
            fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(substrateParameterMatrix(i)));
        end
        
        % close the file
        fclose(fileID);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SCALED PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get the field names
    fieldNames = fieldnames(d.spar);
    
    % get the scaled parameter values
    scaledParameterMatrix = cell2mat(struct2cell(d.spar));
    
    % create the export file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/scaled_parameters.csv'], 'w');
    
    % go through the scaled parameters
    for i = 1:length(scaledParameterMatrix)
        
        % write the scaled parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(scaledParameterMatrix(i)));
    end
    
    % clsoe the file
    fclose(fileID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SUBSTRATE AUX
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if any(d.simset.simulationType == [2,3,5]) && or(ex.substratePlot,ex.substrateFull)
        writematrix(d.sub.pointsOriginalX, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/points_original_x.csv']);
        writematrix(d.sub.pointsOriginalY, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/points_original_y.csv']);
        writematrix(d.sub.interactionSelvesIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/interaction_selves_idx.csv']);
        writematrix(d.sub.interactionPairsIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/interaction_pairs_idx.csv']);
        fileID = fopen([app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/stiffness_type.csv'], 'w');
        fprintf(fileID,app.StiffnessstyleButtonGroup.SelectedObject.Text);
        % close the file
        fclose(fileID);
        switch app.StiffnessstyleButtonGroup.SelectedObject.Text
            case 'Heterogeneous'

            case 'Gradient'
                writematrix(app.stiffnessGradientInformation, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/gradient_information.csv']);
        end
    end
    if any(d.simset.simulationType == [2,5]) && ex.substrateFull
        writematrix(d.sub.interactionLinIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/interaction_lin_idx.csv']);
        writematrix(d.sub.counterInteractionLinIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/counter_interaction_lin_idx.csv']);
        writematrix(d.sub.boundaryRepulsionLinIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/boundary_repulsion_lin_idx.csv']);
        writematrix(d.sub.boundaryRepulsionVectorsIdx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/boundary_repulsion_vectors_idx.csv']);
        writematrix(d.sub.boundaryRepulsionVectors2Idx, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/boundary_repulsion_vectors2_idx.csv']);
        writematrix(d.sub.boundaryRepulsionChangeSigns, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/boundary_repulsion_change_signs.csv']);
        writematrix(d.sub.springMultipliers, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/spring_multipliers.csv']);
        writematrix(d.sub.edgePoints, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/edge_points.csv']);
        writematrix(d.sub.restorativeSpringConstants, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/restorative_spring_constant.csv']);
        writematrix(d.sub.directInteractionSpringConstants, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/direct_interaction_spring_constant.csv']);
        writematrix(d.sub.boundaryRepulsionSpringConstants, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/boudary_repulsion_spring_constant.csv']);
        writematrix(app.fFAInfo, [app.defaultPath 'Results/' ex.exportName '/substrate_auxiliary/focal_adhesion_strengths.csv']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EXPORT OPTIONS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % remove the export name field from the export options
    exportOptions = rmfield(ex,{'exportName','defaultPath'});
    
    % get the field names
    fieldNames = fieldnames(exportOptions);
    
    % get the export values
    exportMatrix = structfun(@(a) double(a), exportOptions);
    
    % create the file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/export_options.csv'], 'w');
    
    % go through the export options
    for i = 1:length(exportMatrix)
        
        %if the fieldname is exportoptions
        if strcmp(fieldNames{i},'exportDt')
            
            % write the with higher accuracy
            fprintf(fileID,'%s,%.8f\r\n', fieldNames{i}, exportMatrix(i));
            
            % if not
        else
            
            % write the fieldname and value
            fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(exportMatrix(i)));
        end
    end
    
    % close the file
    fclose(fileID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SIMULATION TYPE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % create the file
    fileID = fopen([app.defaultPath 'Results/' ex.exportName '/simulation_type.csv'], 'w');
    
    switch d.simset.simulationType
        case 1
            fprintf(fileID,'growth');
        case 2
            fprintf(fileID,'pointlike');
        case 3
            fprintf(fileID,'stretch');
        case 5
            fprintf(fileID,'opto');
    end
    
    % close the file
    fclose(fileID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SIZE TYPE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    csvwrite([app.defaultPath 'Results/' ex.exportName '/size_type.csv'],d.simset.sizeType);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % POINTLIKE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ex.pointlike && d.simset.simulationType == 2
        fileID = fopen([app.defaultPath 'Results/' ex.exportName '/pointlike_properties.csv'], 'w');
        fprintf(fileID,'Cell,%s\r\n', num2str(d.simset.pointlike.cell));
        fprintf(fileID,'originalX,%s\r\n', num2str(d.simset.pointlike.originalX));
        fprintf(fileID,'originalY,%s\r\n', num2str(d.simset.pointlike.originalY));
        fclose(fileID);
    end
    
end