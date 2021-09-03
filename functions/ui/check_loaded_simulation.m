function incomplete = check_loaded_simulation(app,varargin)

incomplete = 0;
switch app.appTask
    case 'simulate'
        folderName = app.import.folderName;
    case 'plotAndAnalyze'
        folderName = app.plotImport(varargin{1}).folderName;
end

if exist([folderName '/export_options.csv'],'file') ~= 2
    incomplete = 'export_options.csv file';
    return
end
if exist([folderName '/system_parameters.csv'],'file') ~= 2
    incomplete = 'system_parameters.csv file';
    return
end

if exist([folderName '/scaled_parameters.csv'],'file') ~= 2
    incomplete = 'scaled_parameters.csv';
    return
end

if exist([folderName '/vertices/'],'dir') ~= 7
    incomplete = 'vertices folder';
    return
end

if strcmp(app.appTask,'simulate')
    if exist([folderName '/cell_parameters.csv'],'file') ~= 2
        incomplete = 'cell_parameters.csv file';
        return
    end
    if exist([folderName '/simulation_type.csv'],'file') ~= 2
        incomplete = 'simulation_Type.csv file';
        return
    end
    if exist([folderName '/vertex_states/'],'dir') ~= 7
        incomplete =  'vertex_states folder';
        return
    end
    if exist([folderName '/division/'],'file') ~= 7
        incomplete = 'division folder';
        return
    end
    if exist([folderName '/cell_states/'],'file') ~= 7
        incomplete = 'cell_states folder';
        return
    end
    if exist([folderName '/junctions/'],'file') ~= 7
        incomplete = 'junctions folder';
        return
    end
    if exist([folderName '/norm_properties/'],'file') ~= 7
        incomplete = 'norm_properties folder';
        return
    end
    if exist([folderName '/lineage/'],'file') ~= 7
        incomplete = 'lineage folder';
        return
    end
    if exist([folderName '/size_type.csv'],'file') ~= 2
        incomplete = 'size_type.csv file';
        return
    end
end