function folderLoaded = unzip_results(app)
% UNZIP_RESULTS Unzip previous results for import
%   The function unzips the imported results for simulation or post
%   plotting and analysis
%   INPUT:
%       app: main application object
%   OUTPUT:
%       folderLoaded: variable to indicate that a folder was succefully
%       unzipped
%   by Aapo Tervonen, 2021

% variabel to check 
folderLoaded = 1;

% disable GUI elements during the unzipping
app.enabledObjects = findobj(app.EpiMechUIFigure,'Enable','On');
disable_enable_all_function(app,'Off');

% choose a file
switch app.appTask
    
    % if simulation
    case 'simulate'
        [fileNameZip, filePath] = uigetfile({'*.zip'},'Choose simulation to load',[app.defaultPath 'results']);
        
    % if post plotting or analysis
    case 'plotAndAnalyze'
        [fileNameZip, filePath] = uigetfile({'*.zip'},'Choose simulation(s) to load',[app.defaultPath 'results'],'MultiSelect','on');
end

% if no files were selected, enable GUI and return
if ~(ischar(fileNameZip) || iscell(fileNameZip))
    folderLoaded = 0;
    disable_enable_all_function(app,'On')
    figure(app.EpiMechUIFigure)
    return;
end

% call the GUI figure to make sure it is the active window
figure(app.EpiMechUIFigure)

switch app.appTask
    
    % if simulation
    case 'simulate'
        
        % open a progress dialog
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping',...
            'Indeterminate','on');
        
        % if there was a previous imported simulation, remove its folder
        % folder, remove the folder
        if strcmp(app.modelCase, 'import') && ~strcmp(app.import.folderName,'')
            
            % variable to check if this simulation is imported in the post
            % plotting and analysis tab
            removeFile = 1;
            
            % if there are simulations imported for post plotting or
            % analysis
            if ~isempty(app.plotImport)
                
                % go through the imported simulations and check if any of
                % them is the one being used as the previous import for
                % simulation, if yes, cancel the removal
                for i = 1:length(app.plotImport)
                    if isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(i).folderName)
                        removeFile = 0; break;
                    end
                end
            end
            
            % if the simulation is to be removed, remove it
            if removeFile
                remove_folder(app.import.folderName);
            end
            
            % reset the import folder name
            app.import.folderName = '';
        end
        
        % get the filename for the new import
        [~,fileName,~] = fileparts(fileNameZip);
        
        % define string for the imported folder
        app.import.folderName = [app.defaultPath 'results/' fileName];
        
        % variable to check if the new simulation is imported in the post
        % plotting and analysis tab
        unzipFile = 1;
        
        % if there are simulations imported for post plotting or
        % analysis
        if ~isempty(app.plotImport)
            
            % go through the imported simulations and check if any of them
            % is the the new import for simulation, if yes, cancel the
            % unzipping
            for i = 1:length(app.plotImport)
                if isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(i).folderName)
                    unzipFile = 0; break;
                end
            end
        end
        
        % if the simulation is to be unzipped
        if unzipFile
            
            % try the unzipping
            try
                
                % check if there is a results folder, if not, create it
                if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
                    mkdir(app.defaultPath, 'results');
                end
                
                % check if the system has 7zip
                [status,~] = system('7z');
                
                % if it is found
                if ~status
                    
                    % get the full file path
                    zipPath = [filePath fileNameZip];
                    
                    % define the export path
                    exportPath = [app.defaultPath 'results/'];
                    
                    % run the 7z unzip command
                    [status,~] = system(['7z x ' zipPath ' -o' exportPath ' -aos']);
                    
                    % if there was a problem, unzip using matlab's command
                    if status ~= 0
                        unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                    end
                    
                % otherwise, unzip using matlab's command
                else
                    unzip([filePath fileNameZip],[app.defaultPath 'results/']);
                end
                
            % if there were problems in the unzipping, show error dialog,
            % enable the GUI components and return
            catch
                uialert('Cannot load the data','Bad Input');
                folderLoaded = 0;
                disable_enable_all_function(app,'On')
                figure(app.EpiMechUIFigure)
                return;
            end
        end
        
    % if post plotting and analysis
    case 'plotAndAnalyze'
        
        % if there was only on selected file, make it a cell
        if ischar(fileNameZip)
            fileNameZip = {fileNameZip};
        end
        
        % if there is only one file, create a progress dialog with
        % indeterminate on
        if length(fileNameZip) == 1
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping',...
                'Indeterminate','on');
            
        % if multiple, create a progress dialog showing the progress
        else
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping');
        end
        
        % variable to keep track simulations that have already been
        % imported
        alreadyImported = [];
        
        % go through the selected simulations
        for i = 1:length(fileNameZip)
            
            % get their name
            [~,fileName,~] = fileparts(fileNameZip{i});
            
            % check if this file already exists in the imported simulations
            idx = find(strcmp(app.LoadedfilesDropDown.Items, fileName));
            
            % if yes, add it to the vector
            if numel(idx) > 0
                alreadyImported(end+1) = i; %#ok<AGROW>
            end
        end
        
        % remove the already imported simulations from the new imports
        fileNameZip(alreadyImported) = [];
        
        % if there are no new simulations to import, enable GUI elements
        % and return
        if isempty(fileNameZip)
            disable_enable_all_function(app,'On')
            return;
        end
        
        % get the number of old imports
        numberOfOldImports = length(app.LoadedfilesDropDown.Items);
        
        % get the indices of the new imports
        app.newImports = numberOfOldImports + 1:numberOfOldImports + length(fileNameZip);
        
        % go through the new imports
        for i = 1:length(fileNameZip)
            
            % set the progress dialog message as the file name
            progressdlg.Message = fileNameZip{i};
            
            % set the progress dialog title
            progressdlg.Title = ['Unzipping (' num2str(i) '/' num2str(length(fileNameZip)) ')' ];
            
            % calculate the progress value if there are more than one
            % simulation left
            if length(fileNameZip) ~= 1
                progressdlg.Value = (i-1)/length(fileNameZip);
            end
            
            % get the filename
            [~,fileName,~] = fileparts(fileNameZip{i});
            
            % add the file name to the simulation selection list items and
            % save the folder name to the plotImport structure
            app.LoadedfilesDropDown.Items{end+1} = fileName;
            app.plotImport(app.newImports(i)).folderName = [app.defaultPath 'results/' fileName];
            
            % check if there are imported simulations in the simulation
            % tab and if they are the same as this simulaiton
            if ~(isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(app.newImports(i)).folderName))
                
                
                % try the unzipping
                try
                    
                    % check if there is a results folder, if not, create it
                    if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
                        mkdir(app.defaultPath, 'results');
                    end
                    
                    % check if the system has 7zip
                    [status,~] = system('7z');
                    
                    % if it is found
                    if ~status
                        
                        % get the full file path
                        zipPath = [filePath fileNameZip{i}];
                        
                        % define the export path
                        exportPath = [app.defaultPath 'results/'];
                    
                        % run the 7z unzip command
                        [status,~] = system(['7z x ' zipPath ' -o' exportPath ' -aos']);
                    
                        % if there was a problem, unzip using matlab's command
                        if status ~= 0
                            unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                        end
                        
                    % otherwise, unzip using matlab's command    
                    else
                        unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                    end
                    
                % if there were problems in the unzipping, show error dialog,
                % enable the GUI components and return
                catch
                    uialert(app.EpiMechUIFigure,'Cannot load the data','Bad Input');
                    folderLoaded = 0;
                    disable_enable_all_function(app,'On')
                    figure(app.EpiMechUIFigure)
                    return;
                end
            end
        end
        
        % if there are no selected files yet (if this is the first import),
        % set the selected to be the first item in the list and set the
        % selected file to the correct index
        if app.selectedFile == 0
            app.LoadedfilesDropDown.Value = app.LoadedfilesDropDown.Items{1};
            app.selectedFile = 1;
            
        % if there are previously imported file, set the new selected file
        % as the first of the new imports and set the selected file to the
        % correct index 
        else
            app.LoadedfilesDropDown.Value = app.LoadedfilesDropDown.Items{numberOfOldImports+1};
            app.selectedFile = find(strcmp(app.LoadedfilesDropDown.Items, app.LoadedfilesDropDown.Value));
        end
end

% close the progress dialog
close(progressdlg);

% enable the GUI elements
disable_enable_all_function(app,'On')

end
