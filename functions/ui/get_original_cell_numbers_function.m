function originalCellNumbers = get_original_cell_numbers_function(app,varargin)

switch app.appTask
    case 'simulate'
        importedVertices = (csvread([app.import.folderName '/vertices/vertices_' num2str(app.import.currentTimePoint) '.csv']))';
        originalCellNumbers = 1:size(importedVertices,1)/2;
    case 'plotAndAnalyze'
        i = varargin{1};
        importedVertices = (csvread([app.plotImport(i).folderName '/vertices/vertices_' num2str(app.plotImport(i).currentTimePoint) '.csv']))';
        originalCellNumbers = 1:size(importedVertices,1)/2;
end