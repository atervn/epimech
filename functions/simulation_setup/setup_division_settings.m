function d = setup_division_settings(app,d)

if d.simset.simulationType == 1
    if app.UniformdivisiontimesCheckBox.Value
        try
            d.simset.division.randomNumbers = csvread([app.defaultPath 'settings/Misc/random_division_numbers.txt']);
            d.simset.division.uniform = 1;
            d.simset.division.counter = 1;
        catch
            errordlg(['No \"random_division_numbers.txt\" file found in ' app.defaultPath 'settings/Misc/ folder.'],'Error','modal')
            d.simset.division.randomNumbers = 0;
            d.simset.division.uniform = 0;
        end
    else
        d.simset.division.randomNumbers = 0;
        d.simset.division.uniform = 0;
    end
    
    switch app.DivisiontypeButtongroup.SelectedObject.Text
        case 'Normal division'
            d.simset.division.type = 1;
        case 'Division until'
            d.simset.division.type = 2;
    end
    
    if strcmp(app.modelCase,'new')
        if d.simset.simulationType == 1
            switch app.CellsizeButtonGroup.SelectedObject.Text
                case 'Uniform sizing'
                    d.simset.division.sizeType = 1;
                case 'MDCK sizing'
                    d.simset.division.sizeType = 2;
                    
                    % get new mdck areas
                    d.simset.newAreas = get_mdck_areas(d.spar);
            end
            
        else
            d.simset.division.sizeType = 0;
        end
    else
        d.simset.division.sizeType = app.import.sizeType;
        if d.simset.simulationType == 1
            if d.simset.division.sizeType == 2
                
                % get new mdck areas
                d.simset.newAreas = get_mdck_areas(d.spar);
            end
        end
    end
    
end

end