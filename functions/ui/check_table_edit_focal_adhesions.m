function check_table_edit_focal_adhesions(app,eventdata,tempTableData)

if isnan(eventdata.NewData)
    restore_previous_value('The value must be numeric.',eventdata,tempTableData,app)
elseif eventdata.NewData < 0
    restore_previous_value('The value cannot be negative.',eventdata,tempTableData,app)
end

end