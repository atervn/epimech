function disable_enable_all_function(app,option)

if isvalid(app)
    
    if strcmp(option,'Off')
        if isprop(app, 'EpiMechUIFigure')
            app.enabledObjects = findobj(app.EpiMechUIFigure,'Enable','on');
        elseif isprop(app, 'OptogeneticdisplacementandforcesUIFigure')
            app.enabledObjects = findobj(app.OptogeneticdisplacementandforcesUIFigure,'Enable','On');
        elseif isprop(app, 'RemovecellsUIFigure')
            app.enabledObjects = findobj(app.RemovecellsUIFigure,'Enable','On');
        elseif isprop(app, 'PointlikedisplacementandforcesUIFigure')
            app.enabledObjects = findobj(app.PointlikedisplacementandforcesUIFigure,'Enable','On');
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