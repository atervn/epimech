function change_import_parameter_panel(app)

app.ImportParameterDropDown.Items = {};

if exist([app.plotImport(app.selectedFile).folderName '/cell_parameters.csv'],'file') == 2
    app.ImportParameterDropDown.Items{end+1} = 'Cell parameters';
end

if exist([app.plotImport(app.selectedFile).folderName '/substrate_parameters.csv'],'file') == 2
    app.ImportParameterDropDown.Items{end+1} = 'Substrate parameters';
end

if exist([app.plotImport(app.selectedFile).folderName '/system_parameters.csv'],'file') == 2
    app.ImportParameterDropDown.Items{end+1} = 'System parameters';
end

if exist([app.plotImport(app.selectedFile).folderName '/scaled_parameters.csv'],'file') == 2
    app.ImportParameterDropDown.Items{end+1} = 'Scaled parameters';
end

if ~isempty(app.ImportParameterDropDown.Value)
    app.ImportParameterDropDown.Value = app.ImportParameterDropDown.Items{1};
    app.ShowButton.Enable = 'On';
else
    app.ShowButton.Enable = 'Off';
end

end