function hide_table(app)

set_object_properties_function(app,{'TablePanel'},'Visible',{'Off'});
app.EpiMechUIFigure.Position(3) = 540;
app.tableData = '';
app.UITable.Data = {};
disable_enable_all_function(app,'On')