function set_import_cells_forces(app)

folderName = app.plotImport(app.selectedFile).folderName;

forceItemsTime = app.ForceDropDown.Items;
forceItemsPlot = app.ForceDropDown_2.Items;

if exist([folderName '/cell_forces/total/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Total forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Total forces'];
    end
    temp = strcmp(forceItemsPlot,'Total forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Total forces'];
    end
else
    temp = strcmp(forceItemsTime,'Total forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Total forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/cortical/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Cortical forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Cortical forces'];
    end
    temp = strcmp(forceItemsPlot,'Cortical forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Cortical forces'];
    end
else
    temp = strcmp(forceItemsTime,'Cortical forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Cortical forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/junction/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Junction forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Junction forces'];
    end
    temp = strcmp(forceItemsPlot,'Junction forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Junction forces'];
    end
else
    temp = strcmp(forceItemsTime,'Junction forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Junction forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/division/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Division forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Division forces'];
    end
    temp = strcmp(forceItemsPlot,'Division forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Division forces'];
    end
else
    temp = strcmp(forceItemsTime,'Division forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Division forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/membrane/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Membrane forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Membrane forces'];
    end
    temp = strcmp(forceItemsPlot,'Membrane forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Membrane forces'];
    end
else
    temp = strcmp(forceItemsTime,'Membrane forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Membrane forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/contact/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Contact forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Contact forces'];
    end
    temp = strcmp(forceItemsPlot,'Contact forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Contact forces'];
    end
else
    temp = strcmp(forceItemsTime,'Contact forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Contact forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/area/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Area forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Area forces'];
    end
    temp = strcmp(forceItemsPlot,'Area forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Area forces'];
    end
else
    temp = strcmp(forceItemsTime,'Area forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Area forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/pointlike/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Pointlike forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Pointlike forces'];
    end
    temp = strcmp(forceItemsPlot,'Pointlike forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Pointlike forces'];
    end
else
    temp = strcmp(forceItemsTime,'Pointlike forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Pointlike forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/cell_forces/focal_adhesion/'],'dir') == 7
    temp = strcmp(forceItemsTime,'Focal adhesion forces');
    if ~any(temp)
        forceItemsTime = [forceItemsTime 'Focal adhesion forces'];
    end
    temp = strcmp(forceItemsPlot,'Focal adhesion forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Focal adhesion forces'];
    end
else
    temp = strcmp(forceItemsTime,'Focal adhesion forces');
    if any(temp)
        forceItemsTime(temp) = [];
    end
    temp = strcmp(forceItemsPlot,'Focal adhesion forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/substrate_forces/total/'],'dir') == 7
    temp = strcmp(forceItemsPlot,'Total substrate forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Total substrate forces'];
    end
else
    temp = strcmp(forceItemsPlot,'Total substrate forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

% LEGACY
if exist([folderName '/substrate_forces/central/'],'dir') == 7 || exist([folderName '/substrate_forces/direct/'],'dir') == 7
    temp = strcmp(forceItemsPlot,'Central substrate forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Central substrate forces'];
    end
else
    temp = strcmp(forceItemsPlot,'Central substrate forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/substrate_forces/restoration/'],'dir') == 7
    temp = strcmp(forceItemsPlot,'Restorative substrate forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Restorative substrate forces'];
    end
else
    temp = strcmp(forceItemsPlot,'Restorative substrate forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/substrate_forces/repulsion/'],'dir') == 7
    temp = strcmp(forceItemsPlot,'Repulsion substrate forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Repulsion substrate forces'];
    end
else
    temp = strcmp(forceItemsPlot,'Repulsion substrate forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end

if exist([folderName '/substrate_forces/focal_adhesion/'],'dir') == 7
    temp = strcmp(forceItemsPlot,'Focal adhesion substrate forces');
    if ~any(temp)
        forceItemsPlot = [forceItemsPlot 'Focal adhesion substrate forces'];
    end
else
    temp = strcmp(forceItemsPlot,'Focal adhesion substrate forces');
    if any(temp)
        forceItemsPlot(temp) = [];
    end
end


app.ForceDropDown.Items = forceItemsTime;
app.ForceDropDown_2.Items = forceItemsPlot;

if ~isempty(app.ForceDropDown.Items)
    app.ForceDropDown.Enable = 'On';
    app.TypeDropDown.Enable = 'On';
    app.CellsListBox.Enable = 'On';
    app.PlotButton_2.Enable = 'On';
else
    app.ForceDropDown.Enable = 'Off';
    app.TypeDropDown.Enable = 'Off';
    app.CellsListBox.Enable = 'Off';
    app.PlotButton_2.Enable = 'Off';
end
end




