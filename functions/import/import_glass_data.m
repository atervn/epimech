function d = import_glass_data(app,d)

if d.pl.glass
    
    folderName = app.plotImport(app.selectedFile).folderName;
    
    shapeData  = csvread([folderName '/glass/glass_shapes.csv']);
    
    glassShapes = {};
    nShapes = sum(shapeData(:,1) == 0)+1;
    for i = 1:nShapes
        [~,idx] = find(shapeData(:,1) == 0);
        if isempty(idx)
            glassShapes{i} = shapeData;
            nextZero = 2;
        else
            nextZero = min(idx);
            glassShapes{i} = shapeData(1:nextZero-1,:);
        end
        shapeData(1:nextZero,:) = [];
    end
    
    
    d.simset.glass.shapes =  glassShapes;
    glassActivation = csvread([folderName '/glass/glass_activation.csv']);
    d.simset.glass.times = glassActivation(:,1);
    d.simset.glass.positions = glassActivation(:,2);
    
end