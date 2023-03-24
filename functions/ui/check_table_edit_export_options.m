function check_table_edit_export_options(app,eventdata,tempTableData)

switch tempTableData{eventdata.Indices(1),1}
    case 'exportDtMultiplier'
        if isnan(eventdata.NewData)
            restore_previous_value('exportDtMultiplier must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('exportDtMultiplier must have a value above zero.',eventdata,tempTableData,app);
        elseif mod(eventdata.NewData,1) ~= 0
            restore_previous_value('exportDtMultiplier must be an integer.',eventdata,tempTableData,app);
        end
end