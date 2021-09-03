function check_table_edit_substrate_parameters(app,eventdata,tempTableData)

switch tempTableData{eventdata.Indices(1),1}
    case 'substratePointDistance'
        if isnan(eventdata.NewData)
            restore_previous_value('substratePointDistance must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('substratePointDistance must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'youngsModulus'
        if isnan(eventdata.NewData)
            restore_previous_value('youngsModulus must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('youngsModulus must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'youngsModulusConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('youngsModulusConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('youngsModulusConstant must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'restorativeForceConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('restorativeForceConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('restorativeForceConstant must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'repulsionLengthConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('repulsionLengthConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0 || eventdata.NewData > 1
            restore_previous_value('repulsionLengthConstant must have a value between 0 and 1.',eventdata,tempTableData,app)
        end
    case 'honeycombConstants'
        if isnan(eventdata.NewData)
            restore_previous_value('honeycombConstants must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 100 || eventdata.NewData > 999
            restore_previous_value('honeycombConstants must be a three digit number.',eventdata,tempTableData,app)
        end
    case 'substrateEdgeConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('substrateEdgeConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('substrateEdgeConstant must be nonnegative.',eventdata,tempTableData,app)
        end
end