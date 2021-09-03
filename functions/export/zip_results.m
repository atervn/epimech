function zip_results(d,app)

if app.simulationStopped && d.ex.export
    userResponse = uiconfirm(app.EpiMechUIFigure,'Save the results up to now or discard them?', 'Save or discard results', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
    if strcmp(userResponse,'Save')
        
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Zipping results','Indeterminate','on');
        
        zip([d.ex.defaultPath '/results/' d.ex.exportName '.zip'],[d.ex.defaultPath '/results/' d.ex.exportName]);
        
        close(progressdlg);
    end
    
    remove_folder_function([d.ex.defaultPath '/results/' d.ex.exportName]);
    
elseif d.ex.export
    
    if isfield(app,'EpiMechUIFigure')
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Zipping results','Indeterminate','on');
    end
    
    zip([d.ex.defaultPath '/results/' d.ex.exportName '.zip'],[d.ex.defaultPath '/results/' d.ex.exportName]);
    
    remove_folder_function([d.ex.defaultPath '/results/' d.ex.exportName]);
    
    if isfield(app,'EpiMechUIFigure')
        close(progressdlg);
    end
end


end