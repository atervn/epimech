function disable_enable_all_function(app,option)

if isvalid(app)
    
    if strcmp(option,'Off')
        try
            app.enabledObjects = findobj(app.EpiMechUIFigure,'Enable','On');
        catch
            app.enabledObjects = findobj(app.UIFigure,'Enable','On');
        end
    end
    
    if app.enabledObjects ~= 0
        for i = 1:length(app.enabledObjects)
            if ~(strcmp(app.enabledObjects(i).Tag,'no_disable')) && ~(strcmp(app.enabledObjects(i).Type,'uipanel') || strcmp(app.enabledObjects(i).Type,'uibuttongroup'))
                app.enabledObjects(i).Enable = option;
            end
        end
    end
end
end