function edit_field_to_time(app, editFieldUnit,timeParameter,time)

app.systemParameters.(timeParameter) = scaled_time_units(app, editFieldUnit, time)


