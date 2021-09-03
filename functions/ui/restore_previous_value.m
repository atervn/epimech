function restore_previous_value(msg,eventdata,tableData,app)


uialert(app.EpiMechUIFigure,msg,'Bad Input');

tableData{eventdata.Indices(1), eventdata.Indices(2)} = eventdata.PreviousData;
app.UITable.Data = tableData;


end

