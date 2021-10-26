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
    optoActivation = csvread([folderName '/opto/opto_activation.csv']);
    d.simset.opto.times = optoActivation(:,1);
    d.simset.opto.levels = optoActivation(:,2);
    
end