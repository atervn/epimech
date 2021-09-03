function hide_table(app)

app.EpiMechUIFigure.Position(3) = 540;
set_object_properties_function(app,{'TablePanel'},'Visible',{'Off'});
app.tableData = '';
app.UITable.Data = {};
disable_enable_all_function(app,'On')