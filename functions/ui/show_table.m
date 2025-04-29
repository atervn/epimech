function show_table(app,inputStruct)
%SHOW_TABLE Summary of this function goes here
%   Detailed explanation goes here

app.enabledObjects = findobj(app.EpiMechUIFigure,'Enable','On');
disable_enable_all_function(app,'Off')
drawnow()

set_object_properties_function(app,{'SavetofileButton','SavechangesButton','DiscardchangesButton','ResettodefaultButton','UITable','tableTipsImage'},'Enable',{'On'})

switch app.appTask
    case 'simulate'
        if ~strcmp(inputStruct,'fFAInfo')
            if strcmp(inputStruct,'cellParameters')
                tableData = [struct_to_table(app.cellParameters) ; struct_to_table(app.specificCellParameters)];
                app.UITable.Data = tableData;
            else
                app.UITable.Data = struct_to_table(app.(inputStruct));
            end
        else
            app.UITable.Data = num2cell(app.(inputStruct));
        end
    case 'plotAndAnalyze'
        switch inputStruct
            case 'cellParametersImport'
                tableData = [struct_to_table(app.plotImport(app.selectedFile).cellParameters) ; struct_to_table(app.plotImport(app.selectedFile).specificCellParameters)];
                app.UITable.Data = tableData;
            case 'substrateParametersImport'
                app.UITable.Data = struct_to_table(app.plotImport(app.selectedFile).substrateParameters);
            case 'systemParametersImport'
                app.UITable.Data = struct_to_table(app.plotImport(app.selectedFile).systemParameters);
            case 'scaledParametersImport'
                app.UITable.Data = struct_to_table(app.plotImport(app.selectedFile).scaledParameters);
            case 'plottingOptions'
                app.UITable.Data = struct_to_table(app.importPlottingOptions);
        end
end
switch inputStruct
    case 'cellParameters'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'systemParameters'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'plottingOptions'
        app.UITable.ColumnName = {'Plot component','Value','Explanation'}';
        app.UITable.ColumnFormat = {};
    case 'customExportOptions'
        app.UITable.ColumnName = {'Export component','Value','Explanation'}';
        app.UITable.ColumnFormat = {};
    case 'substrateParameters'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'fFAInfo'
        app.UITable.ColumnName = {'Youngs modulus','fFA'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'cellParametersImport'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'substrateParametersImport'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'systemParametersImport'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
    case 'scaledParametersImport'
        app.UITable.ColumnName = {'Parameter','Value','Explanation'}';
        app.UITable.ColumnFormat = {'char','shortG','char'};
end

if strcmp(inputStruct,'cellParametersImport') || strcmp(inputStruct,'substrateParametersImport') || strcmp(inputStruct,'systemParametersImport') || strcmp(inputStruct,'scaledParametersImport')
    app.SavechangesButton.Visible = 'Off';
    app.DiscardchangesButton.Visible = 'Off';
    app.SavetofileButton.Visible = 'Off';
    app.ResettodefaultButton.Visible = 'Off';
    app.CloseButton.Visible = 'On';
    app.CloseButton.Position(1:2) = app.SavechangesButton.Position(1:2);
    app.UITable.ColumnEditable = logical([0 0 0]);
    app.tableTipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/table_post_settings.txt']);
else
    app.SavechangesButton.Visible = 'On';
    app.DiscardchangesButton.Visible = 'On';
    app.SavetofileButton.Visible = 'On';
    app.ResettodefaultButton.Visible = 'On';
    app.CloseButton.Visible = 'Off';
    app.UITable.ColumnEditable = logical([0 1 0]);
    app.tableTipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/table_simulation_settings.txt']);
end


app.EpiMechUIFigure.Position(3) = 890;
set_object_properties_function(app,{'TablePanel'},'Visible',{'On'}); 
app.tableData = inputStruct;

end
