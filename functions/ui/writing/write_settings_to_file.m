function write_settings_to_file(app)

switch app.tableData
    case 'cellParameters'
        switch app.simulationType
            case 'growth'
                write_struct(table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:)),[app.defaultPath 'parameters/cell_parameters.txt'])
                write_struct(table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:)),[app.defaultPath 'parameters/specific_parameters_growth.txt'])
            case 'pointlike'
                write_struct(table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:)),[app.defaultPath 'parameters/cell_parameters.txt'])
                write_struct(table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:)),[app.defaultPath 'parameters/specific_parameters_pointlike.txt'])
            case 'stretch'
                write_struct(table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:)),[app.defaultPath 'parameters/cell_parameters.txt'])
                write_struct(table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:)),[app.defaultPath 'parameters/specific_parameters_stretch.txt'])
            case 'edge'
                write_struct(table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:)),[app.defaultPath 'parameters/cell_parameters.txt'])
                write_struct(table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:)),[app.defaultPath 'parameters/specific_parameters_edge.txt'])
            case 'opto'
                write_struct(table_to_struct(app.UITable.Data(1:numel(fieldnames(app.cellParameters)),:)),[app.defaultPath 'parameters/cell_parameters.txt'])
                write_struct(table_to_struct(app.UITable.Data(numel(fieldnames(app.cellParameters))+1:end,:)),[app.defaultPath 'parameters/specific_parameters_opto.txt'])
        end
        
    case 'systemParameters'
        switch app.simulationType
            case 'growth'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/system_parameters_growth.txt'])
            case 'pointlike'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/system_parameters_pointlike.txt'])
            case 'stretch'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/system_parameters_stretch.txt'])
            case 'edge'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/system_parameters_edge.txt'])
            case 'opto'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/system_parameters_opto.txt'])
        end
    case 'plottingOptions'
        switch app.appTask
            case 'simulate'
                switch app.simulationType
                    case 'growth'
                        write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/plotting/plotting_options_growth.txt'])
                    case 'pointlike'
                        write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/plotting/plotting_options_pointlike.txt'])
                    case 'stretch'
                        write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/plotting/plotting_options_stretch.txt'])
                    case 'opto'
                        write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/plotting/plotting_options_opto.txt'])
                end
            case 'plotAndAnalyze'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/plotting/post_plotting_options.txt'])
        end
    case 'customExportOptions'
        switch app.simulationType
            case 'growth'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/export/export_options_custom_growth.txt'])
            case 'pointlike'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/export/export_options_custom_pointlike.txt'])
            case 'stretch'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/export/export_options_custom_stretch.txt'])
            case 'opto'
                write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'settings/export/export_options_custom_opto.txt'])
        end
        
    case 'substrateParameters'
        write_struct(table_to_struct(app.UITable.Data),[app.defaultPath 'parameters/substrate_parameters.txt'])
        
    case 'fFAInfo'
        csvwrite([app.defaultPath 'parameters/focal_adhesion_parameters.csv'],cell2mat(app.UITable.Data));
end