function time_to_edit_field(app, editFieldUnit,editFieldName,time)

switch app.(editFieldUnit).Value
    case 'days'
        app.(editFieldName).Value = time/24/60/60;
    case 'hours'
        app.(editFieldName).Value = time/60/60;
    case 'mins'
        app.(editFieldName).Value = time/60;
    case 'secs'
        app.(editFieldName).Value = time;
end

