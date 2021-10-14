function check_table_edit_cell_parameters(app,eventdata,tempTableData)

switch tempTableData{eventdata.Indices(1),1}
    case 'rCell'
        if isnan(eventdata.NewData)
            restore_previous_value('rCell must be numeric.',eventdata,tempTableData,app)
        elseif ~isempty(app.cellCenters)
            restore_previous_value('Please reset the cells to modify rCell.',eventdata,tempTableData,app);
        elseif strcmp(app.modelCase,'import')
            restore_previous_value('Cannot be edited when simulation is loaded.',eventdata,tempTableData,app);
        elseif eventdata.NewData <= 0
            restore_previous_value('rCell must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'membraneLength'
        if isnan(eventdata.NewData)
            restore_previous_value('membraneLength must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('membraneLength must have a value above zero.',eventdata,tempTableData,app);
        end
    case 'junctionLength'
        if isnan(eventdata.NewData)
            restore_previous_value('junctionLength must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('junctionLength must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'fArea'
        if isnan(eventdata.NewData)
            restore_previous_value('fArea must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fArea must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'fCortex'
        if isnan(eventdata.NewData)
            restore_previous_value('fCortex must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fCortex must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'fJunctions'
        if isnan(eventdata.NewData)
            restore_previous_value('fJunctions must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fJunctions must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'fContact'
        if isnan(eventdata.NewData)
            restore_previous_value('fContact must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fContact must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'perimeterConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('perimeterConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('perimeterConstant must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'perimeterModelingRate'
        if isnan(eventdata.NewData)
            restore_previous_value('perimeterModelingRate must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('perimeterModelingRate must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'fMembrane'
        if isnan(eventdata.NewData)
            restore_previous_value('fMembrane must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fMembrane must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'fDivision'
        if isnan(eventdata.NewData)
            restore_previous_value('fDivision must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('fDivision must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'divisionTimeMean'
        if isnan(eventdata.NewData)
            restore_previous_value('divisionTimeMean must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('divisionTimeMean must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'divisionTimeSD'
        if isnan(eventdata.NewData)
            restore_previous_value('divisionTimeSD must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('divisionTimeSD must have a value above zero.',eventdata,tempTableData,app)
        end
    case 'divisionDistanceConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('divisionDistanceConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData <= 0
            restore_previous_value('divisionDistanceConstant must have a value above zero.',eventdata,tempTableData,app)
        elseif eventdata.NewData > 1
            restore_previous_value('divisionDistanceConstant must have a value below one.',eventdata,tempTableData,app)
        end
    case 'newCellAreaConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('newCellAreaConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('newCellAreaConstant must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'cellGrowthConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('cellGrowthConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('cellGrowthConstant must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'cellGrowthForceConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('cellGrowthForceConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('cellGrowthForceConstant must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'baseDivisionRate'
        if isnan(eventdata.NewData)
            restore_previous_value('baseDivisionRate must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('baseDivisionRate must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'divisionRateExponents'
        if isnan(eventdata.NewData)
            restore_previous_value('divisionRateExponents must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('divisionRateExponents must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'fEdgeCell'
        if isnan(eventdata.NewData)
            restore_previous_value('fEdgeCell must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('fEdgeCell must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'maxMembraneAngle'
        if isnan(eventdata.NewData)
            restore_previous_value('maxMembraneAngle must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('maxMembraneAngle must be nonnegative.',eventdata,tempTableData,app)
        elseif eventdata.NewData > 3.14
            restore_previous_value('maxMembraneAngle must be below pi.',eventdata,tempTableData,app)
        end
    case 'maxJunctionAngleConstant'
        if isnan(eventdata.NewData)
            restore_previous_value('maxJunctionAngleConstant must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('maxJunctionAngleConstant must be nonnegative.',eventdata,tempTableData,app)
        elseif eventdata.NewData > 1
            restore_previous_value('maxJunctionAngleConstant must be below one.',eventdata,tempTableData,app)
        end
    case 'focalAdhesionBreakingForce'
        if isnan(eventdata.NewData)
            restore_previous_value('focalAdhesionBreakingForce must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('focalAdhesionBreakingForce must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'maximumGrowthTime'
        if isnan(eventdata.NewData)
            restore_previous_value('maximumGrowthTime must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('maximumGrowthTime must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'maximumDivisionTime'
        if isnan(eventdata.NewData)
            restore_previous_value('maximumDivisionTime must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('maximumDivisionTime must be nonnegative.',eventdata,tempTableData,app)
        end
    case 'minimumCellSize'
        if isnan(eventdata.NewData)
            restore_previous_value('minimumCellSize must be numeric.',eventdata,tempTableData,app)
        elseif eventdata.NewData < 0
            restore_previous_value('minimumCellSize must be nonnegative.',eventdata,tempTableData,app)
        end
end