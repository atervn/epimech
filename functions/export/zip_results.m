function zip_results(app,d)
% ZIP_RESULTS Zip simulation results
%   The function zips the simulation results and removes the export folder.
%   Also, if the user stops the simulation when running from the GUI, it
%   asks if the users wishes to save the data thusfar.
%   INPUT: 
%       app: application object
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if simulation is stopped by the user and exporting is on
if app.simulationStopped && d.ex.export
    
    % ask the user if they wish to save or discard the data that has been
    % exported thusfar
    userResponse = uiconfirm(app.EpiMechUIFigure,'Save the results up to now or discard them?', 'Save or discard results', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
    
    % if save
    if strcmp(userResponse,'Save')
        
        % open a progress dialog
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Zipping results','Indeterminate','on');
        
        % zip the results
        zip([d.ex.defaultPath '/results/' d.ex.exportName '.zip'],[d.ex.defaultPath '/results/' d.ex.exportName]);
        
        % close the progress dialog
        close(progressdlg);
    end
    
    % remove the export folder
    remove_folder([d.ex.defaultPath '/results/' d.ex.exportName]);
    
% if data is exported
elseif d.ex.export
    
     % open a progress dialog if run from GUI
    if isfield(app,'EpiMechUIFigure')
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Zipping results','Indeterminate','on');
    end
    
    % zip the results
    zip([d.ex.defaultPath '/results/' d.ex.exportName '.zip'],[d.ex.defaultPath '/results/' d.ex.exportName]);
    
    % remove the export folder
    remove_folder([d.ex.defaultPath '/results/' d.ex.exportName]);
    
    % close the progress dialog
    if isfield(app,'EpiMechUIFigure')
        close(progressdlg);
    end
end

end