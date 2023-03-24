function d = import_pointlike_data(app,d)
% IMPORT_POINTLIKE_DATA Import pointlike data for plotting
%   The function imports the pointlike data for plotting the pointlike
%   simulations.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if pointlike is shown
if d.pl.pointlike
   
    % get the folder name
    folderName = app.plotImport(app.selectedFile).folderName;
    
    % get the pointlike positions for the current time point
    importedPositions = csvread([folderName '/pointlike/pointlike_locations_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    d.simset.pointlike.pointX = importedPositions(1);
    d.simset.pointlike.pointY = importedPositions(2);

    % get the pointlike data and assign the cell
    outputStruct = import_settings([folderName '/pointlike/pointlike_data.csv']);
    d.simset.pointlike.cell = outputStruct.cell;
end

end