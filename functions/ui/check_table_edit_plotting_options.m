function check_table_edit_plotting_options(app,eventdata,tempTableData)

switch tempTableData{eventdata.Indices(1),1}
    case 'plotDtMultiplier'
        if isnan(eventdata.NewData)
            restore_previous_value('plotDtMultiplier must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('plotDtMultiplier must have a value above zero.',eventdata,tempTableData,app);
        elseif mod(eventdata.NewData,1) ~= 0
            restore_previous_value('plotDtMultiplier must be an integer.',eventdata,tempTableData,app);
        end
    case 'videoQuality'
        if isnan(eventdata.NewData)
            restore_previous_value('videoQuality must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0 || eventdata.NewData > 100
            restore_previous_value('videoQuality must be between 0 and 100.',eventdata,tempTableData,app);
        end
    case 'videoFramerate'
        if isnan(eventdata.NewData)
            restore_previous_value('videoFramerate must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('videoFramerate must have a value above zero.',eventdata,tempTableData,app);
        elseif mod(eventdata.NewData,1) ~= 0
            restore_previous_value('videoFramerate must be an integer.',eventdata,tempTableData,app);
        end
    case 'windowSize'
        if isnan(eventdata.NewData)
            restore_previous_value('windowSize must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('windowSize must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'plotCellStyle'
        switch app.appTask
            case 'simulate'
                if isnan(eventdata.NewData)
                    restore_previous_value('plotCellStyle must be numeric.',eventdata,tempTableData,app)
                elseif ~any(eventdata.NewData == [0:5])
                    restore_previous_value('plotCellStyle must be 0, 1, 2, 3, 4, or 5.',eventdata,tempTableData,app);
                end
            case 'plotAndAnalyze'
                if isnan(eventdata.NewData)
                    restore_previous_value('plotCellStyle must be numeric.',eventdata,tempTableData,app)
                elseif ~any(eventdata.NewData == [0:5])
                    restore_previous_value('plotCellStyle must be 0, 1, 2, 3, 4, or 5.',eventdata,tempTableData,app);
                elseif exist([app.plotImport(app.selectedFile).folderName '/junctions/'],'dir') ~= 7
                    restore_previous_value('No junction data, so number of neighbors cannot be determined.',eventdata,tempTableData,app);
                end
        end
    case 'plotSubstrateStyle'
        switch app.appTask
            case 'simulate'
                if isnan(eventdata.NewData)
                    restore_previous_value('plotSubstrateStyle must be numeric.',eventdata,tempTableData,app)
                elseif ~any(eventdata.NewData == [0 1 2])
                    restore_previous_value('plotSubstrateStyle must be 0, 1, or 2.',eventdata,tempTableData,app);
                end
            case 'plotAndAnalyze'
                if isnan(eventdata.NewData)
                    restore_previous_value('plotSubstrateStyle must be numeric.',eventdata,tempTableData,app)
                elseif ~any(eventdata.NewData == [0 1 2])
                    restore_previous_value('plotSubstrateStyle must be 0, 1 or 2.',eventdata,tempTableData,app);
                end
        end
end

if strcmp(app.appTask,'plotAndAnalyze')
    
    folderName = app.plotImport(app.selectedFile).folderName;
    
    switch tempTableData{eventdata.Indices(1),1}
        case 'junctions'
            if eventdata.NewData && exist([folderName '/junctions/'],'dir') ~= 7
                restore_previous_value('Junction data not available.',eventdata,tempTableData,app)
            end
        case 'focalAdhesions'
            if eventdata.NewData && exist([folderName '/focal_adhesions/'],'dir') ~= 7
                restore_previous_value('Focal adhesion data not available.',eventdata,tempTableData,app)
            end
        case 'pointlike'
            if eventdata.NewData && ~(exist([folderName '/pointlike'],'dir') == 7 && exist([folderName '/pointlike_properties.csv'],'file') == 2)
                restore_previous_value('Pointlike data not available.',eventdata,tempTableData,app)
            end
        case 'opto'
            if eventdata.NewData && ~(exist([folderName '/opto'],'dir') == 7)
                restore_previous_value('Opto data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesTotal'
            if eventdata.NewData && exist([folderName '/cell_forces/total/'],'dir') ~= 7
                restore_previous_value('Total force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesCortical'
            if eventdata.NewData && exist([folderName '/cell_forces/cortical/'],'dir') ~= 7
                restore_previous_value('Cortical force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesJunctions'
            if eventdata.NewData && exist([folderName '/cell_forces/junction/'],'dir') ~= 7
                restore_previous_value('Junction force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesDivision'
            if eventdata.NewData && exist([folderName '/cell_forces/division/'],'dir') ~= 7
                restore_previous_value('Division force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesMembrane'
            if eventdata.NewData && exist([folderName '/cell_forces/membrane/'],'dir') ~= 7
                restore_previous_value('Membrane force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesContact'
            if eventdata.NewData && exist([folderName '/cell_forces/contact/'],'dir') ~= 7
                restore_previous_value('Contact force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesArea'
            if eventdata.NewData && exist([folderName '/cell_forces/area/'],'dir') ~= 7
                restore_previous_value('Area force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesPointlike'
            if eventdata.NewData && exist([folderName '/cell_forces/pointlike/'],'dir') ~= 7
                restore_previous_value('Pointlike force data not available.',eventdata,tempTableData,app)
            end
        case 'cellForcesFocalAdhesions'
            if eventdata.NewData && exist([folderName '/cell_forces/focal_adhesion/'],'dir') ~= 7
                restore_previous_value('Substrate force data not available.',eventdata,tempTableData,app)
            end
        case 'substrateForcesCentral'
            if eventdata.NewData && exist([folderName '/substrate_forces/central/'],'dir') ~= 7
                % LEGACY
                if eventdata.NewData && exist([folderName '/substrate_forces/direct/'],'dir') ~= 7
                    restore_previous_value('Central substrate force data not available.',eventdata,tempTableData,app)
                end
            end
        case 'substrateForcesRepulsion'
            if eventdata.NewData && exist([folderName '/substrate_forces/repulsion/'],'dir') ~= 7
                restore_previous_value('Boundary repulsion substrate force data not available.',eventdata,tempTableData,app)
            end
        case 'substrateForcesRestoration'
            if eventdata.NewData && exist([folderName '/substrate_forces/restoration/'],'dir') ~= 7
                restore_previous_value('Restorative substrate force data not available.',eventdata,tempTableData,app)
            end
        case 'substrateForcesFocalAdhesions'
            if eventdata.NewData && exist([folderName '/substrate_forces/focal_adhesion/'],'dir') ~= 7
                restore_previous_value('Cell substrate force data not available.',eventdata,tempTableData,app)
            end
        case 'substrateForcesTotal'
            if eventdata.NewData && exist([folderName '/substrate_forces/total/'],'dir') ~= 7
                restore_previous_value('Total substrate force data not available.',eventdata,tempTableData,app)
            end
    end
end