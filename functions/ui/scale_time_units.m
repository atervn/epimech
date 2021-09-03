function scaledTime = scale_time_units(app, editFieldUnit, time, direction)
switch direction
    case 'field'
        switch app.(editFieldUnit).Value
            case 'days'
                scaledTime = time/24/60/60;
            case 'hours'
                scaledTime = time/60/60;
            case 'mins'
                scaledTime = time/60;
            case 'secs'
                scaledTime = time;
            case 'msecs'
                scaledTime = time*1000;
                
        end
    case 'parameters'
        switch app.(editFieldUnit).Value
            case 'days'
                scaledTime = time*24*60*60;
            case 'hours'
                scaledTime = time*60*60;
            case 'mins'
                scaledTime = time*60;
            case 'secs'
                scaledTime = time;
            case 'msecs'
                scaledTime = time/1000;
        end
end