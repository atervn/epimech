function check_table_edit_system_parameters(app,eventdata,tempTableData)

switch tempTableData{eventdata.Indices(1),1}
    case 'eta'
        if isnan(eventdata.NewData)
            restore_previous_value('eta must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('eta must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'scalingLength'
        if isnan(eventdata.NewData)
            restore_previous_value('scalingLength must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('scalingLength must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'scalingTime'
        if isnan(eventdata.NewData)
            restore_previous_value('scalingTime must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('scalingTime must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'simulationTime'
        if isnan(eventdata.NewData)
            restore_previous_value('simulationTime must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('simulationTime must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'maximumTimeStep'
        if isnan(eventdata.NewData)
            restore_previous_value('maximumTimeStep must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('maximumTimeStep must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'stopDivisionTime'
        if isnan(eventdata.NewData)
            restore_previous_value('stopDivisionTime must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('stopDivisionTime must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'cellMaximumMovement'
        if isnan(eventdata.NewData)
            restore_previous_value('cellMaximumMovement must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('cellMaximumMovement must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'cellMinimumMovement'
        if isnan(eventdata.NewData)
            restore_previous_value('cellMinimumMovement must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('cellMinimumMovement must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'junctionModificationTimeStep'
        if isnan(eventdata.NewData)
            restore_previous_value('junctionModificationTimeStep must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('junctionModificationTimeStep must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'substrateMaximumMovement'
        if isnan(eventdata.NewData)
            restore_previous_value('substrateMaximumMovement must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('substrateMaximumMovement must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'substrateMinimumMovement'
        if isnan(eventdata.NewData)
            restore_previous_value('substrateMinimumMovement must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('substrateMinimumMovement must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'fullActivationConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('fullActivationConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('fullActivationConstant must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'fPointlike'
        if isnan(eventdata.NewData)
            restore_previous_value('fPointlike must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('fPointlike must be nonnegative.',eventdata,tempTableData,app)
        end
end