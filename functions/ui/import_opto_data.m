function d = import_opto_data(app,d)

if d.pl.opto
    
    folderName = app.plotImport(app.selectedFile).folderName;
    
    shapeData  = csvread([folderName '/opto/opto_shapes.csv']);
    
    optoShapes = {};
    nShapes = sum(shapeData(:,1) == 0)+1;
    for i = 1:nShapes
        [~,idx] = find(shapeData(:,1) == 0);
        if isempty(idx)
            optoShapes{i} = shapeData;
            nextZero = 2;
        else
            nextZero = min(idx);
            optoShapes{i} = shapeData(1:nextZero-1,:);
        end
        shapeData(1:nextZero,:) = [];
    end
    
    
    d.simset.opto.shapes =  optoShapes;
    d.simset.opto.times = csvread([folderName '/opto/opto_times.csv']);
    d.simset.opto.levels = csvread([folderName '/opto/opto_levels.csv']);
    
end