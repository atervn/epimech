function d = setup_division_settings(app,d)
% SETUP_DIVISION_SETTINGS Setup settings for division
%   The function defines the simulation settings related to cell division
%   and cell sizing.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if growth simulation
if d.simset.simulationType == 1
    
    % if uniform division times is selected
    if app.UniformdivisiontimesCheckBox.Value
        
        % try to load division time file and set the division uniformity
        % type to uniform and size counter to 1
        try
            d.simset.division.randomNumbers = csvread([app.defaultPath 'settings/misc/random_division_numbers.txt']);
            d.simset.division.uniform = 1;
            d.simset.division.counter = 1;
            
        % otherwise, throw error and set division uniformity type to
        % nonuniform
        catch
            errordlg(['No \"random_division_numbers.txt\" file found in ' app.defaultPath 'settings/Misc/ folder.'],'Error','modal')
            d.simset.division.randomNumbers = 0;
            d.simset.division.uniform = 0;
        end
        
    % otherwise, set division uniformity type to nonuniform
    else
        d.simset.division.randomNumbers = 0;
        d.simset.division.uniform = 0;
    end
    
    % check what division type (normal = divide until the end of the
    % simulation, division until = stop at predefined time)
    switch app.DivisiontypeButtongroup.SelectedObject.Text
        case 'Normal division'
            d.simset.division.type = 1;
        case 'Division until'
            d.simset.division.type = 2;
    end
end

% if new simulation
if strcmp(app.modelCase,'new')
    
    % if growth simulation
    if d.simset.simulationType == 1
        
        % set the cell sizing type between uniform and MDCK size
        switch app.CellsizeButtonGroup.SelectedObject.Text
            case 'Uniform sizing'
                d.simset.division.sizeType = 1;
            case 'MDCK sizing'
                d.simset.division.sizeType = 2;
                
                % get MDCK areas ready from the area distribution
                d.simset.newAreas = get_mdck_areas(d.spar);
        end
     
    % otherwise
    else
        d.simset.division.sizeType = 0;
    end
    
% imported simulation
else
    
    % get the size type from the import
    d.simset.division.sizeType = app.import.sizeType;
    
    % if growth simulation
    if d.simset.simulationType == 1
        
        % if MDCK cell sizing
        if d.simset.division.sizeType == 2
            
            % get MDCK areas ready from the area distribution
            d.simset.newAreas = get_mdck_areas(d.spar);
        end
    end
end

end