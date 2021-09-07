function forceItems = set_forces_to_dropdown(forceItems,folderName)

if exist([folderName '/cell_forces/total/'],'dir') == 7
    temp = strcmp(forceItems,'Total forces');
    if ~any(temp)
        forceItems = [forceItems 'Total forces'];
    end
else
    temp = strcmp(forceItems,'Total forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/cortical/'],'dir') == 7
    temp = strcmp(forceItems,'Cortical forces');
    if ~any(temp)
        forceItems = [forceItems 'Cortical forces'];
    end
else
    temp = strcmp(forceItems,'Cortical forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/junction/'],'dir') == 7
    temp = strcmp(forceItems,'Junction forces');
    if ~any(temp)
        forceItems = [forceItems 'Junction forces'];
    end
else
    temp = strcmp(forceItems,'Junction forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/division/'],'dir') == 7
    temp = strcmp(forceItems,'Division forces');
    if ~any(temp)
        forceItems = [forceItems 'Division forces'];
    end
else
    temp = strcmp(forceItems,'Division forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/membrane/'],'dir') == 7
    temp = strcmp(forceItems,'Membrane forces');
    if ~any(temp)
        forceItems = [forceItems 'Membrane forces'];
    end
else
    temp = strcmp(forceItems,'Membrane forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/contact/'],'dir') == 7
    temp = strcmp(forceItems,'Contact forces');
    if ~any(temp)
        forceItems = [forceItems 'Contact forces'];
    end
else
    temp = strcmp(forceItems,'Contact forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/area/'],'dir') == 7
    temp = strcmp(forceItems,'Area forces');
    if ~any(temp)
        forceItems = [forceItems 'Area forces'];
    end
else
    temp = strcmp(forceItems,'Area forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/pointlike/'],'dir') == 7
    temp = strcmp(forceItems,'Pointlike forces');
    if ~any(temp)
        forceItems = [forceItems 'Pointlike forces'];
    end
else
    temp = strcmp(forceItems,'Pointlike forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/cell_forces/focal_adhesion/'],'dir') == 7
    temp = strcmp(forceItems,'Focal adhesion forces');
    if ~any(temp)
        forceItems = [forceItems 'Focal adhesion forces'];
    end
else
    temp = strcmp(forceItems,'Focal adhesion forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/substrate_forces/total/'],'dir') == 7
    temp = strcmp(forceItems,'Total substrate forces');
    if ~any(temp)
        forceItems = [forceItems 'Total substrate forces'];
    end
else
    temp = strcmp(forceItems,'Total substrate forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/substrate_forces/direct/'],'dir') == 7
    temp = strcmp(forceItems,'Direct substrate forces');
    if ~any(temp)
        forceItems = [forceItems 'Direct substrate forces'];
    end
else
    temp = strcmp(forceItems,'Direct substrate forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/substrate_forces/restoration/'],'dir') == 7
    temp = strcmp(forceItems,'Restorative substrate forces');
    if ~any(temp)
        forceItems = [forceItems 'Restorative substrate forces'];
    end
else
    temp = strcmp(forceItems,'Restorative substrate forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/substrate_forces/repulsion/'],'dir') == 7
    temp = strcmp(forceItems,'Repulsion substrate forces');
    if ~any(temp)
        forceItems = [forceItems 'Repulsion substrate forces'];
    end
else
    temp = strcmp(forceItems,'Repulsion substrate forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

if exist([folderName '/substrate_forces/focal_adhesion/'],'dir') == 7
    temp = strcmp(forceItems,'Focal adhesion substrate forces');
    if ~any(temp)
        forceItems = [forceItems 'Focal adhesion substrate forces'];
    end
else
    temp = strcmp(forceItems,'Focal adhesion substrate forces');
    if any(temp)
        forceItems(temp) = [];
    end
end

end