function d = import_pointlike_data(app,d)

if d.pl.pointlike
   
    folderName = app.plotImport(app.selectedFile).folderName;
    
    importedLocations = csvread([folderName '/pointlike/pointlike_locations_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    d.simset.pointlike.pointX = importedLocations(1);
    d.simset.pointlike.pointY = importedLocations(2);

    outputStruct = import_settings([folderName '/pointlike/pointlike_data.csv']);
    d.simset.pointlike.cell = outputStruct.cell;
end