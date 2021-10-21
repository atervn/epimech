function folderLoaded = unzip_results(app)

folderLoaded = 1;

% Disable UI elements during the unzipping
app.enabledObjects = findobj(app.EpiMechUIFigure,'Enable','On');
disable_enable_all_function(app,'Off');


% choose a file
switch app.appTask
    case 'simulate'
        [fileNameZip, filePath] = uigetfile({'*.zip'},'Choose simulation to load',[app.defaultPath 'results']);
    case 'plotAndAnalyze'
        [fileNameZip, filePath] = uigetfile({'*.zip'},'Choose simulation to load',[app.defaultPath 'results'],'MultiSelect','on');
end
if ~(ischar(fileNameZip) || iscell(fileNameZip))
    folderLoaded = 0;
    disable_enable_all_function(app,'On')
    figure(app.EpiMechUIFigure)
    return;
end

figure(app.EpiMechUIFigure)

switch app.appTask
    case 'simulate'
        
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping',...
            'Indeterminate','on');
        
        % if the previous simulation was loaded (old) and there is a results
        % folder, remove the folder
        if strcmp(app.modelCase, 'import') && ~strcmp(app.import.folderName,'')
            removeFile = 1;
            if ~isempty(app.plotImport)
                for i = 1:length(app.plotImport)
                    if isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(i).folderName)
                        removeFile = 0;
                        break;
                    end
                end
            end
            if removeFile
                remove_folder_function(app.import.folderName);
            end
            app.import.folderName = '';
        end
        
        %get the filename
        [~,fileName,~] = fileparts(fileNameZip);
        
        % define string for the imported folder
        app.import.folderName = [app.defaultPath 'results/' fileName];
        
        unzipFile = 1;
        if ~isempty(app.plotImport)
            for i = 1:length(app.plotImport)
                if isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(i).folderName)
                    unzipFile = 0;
                    break;
                end
            end
        end
        
        
        if unzipFile
            try
                if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
                    mkdir(app.defaultPath, 'results');
                end
                % check for 7zip
                [status,~] = system('7z');
                if ~status
                    zipPath = [filePath fileNameZip];
                    exportPath = [app.defaultPath 'results/'];
                    [status,~] = system(['7z x ' zipPath ' -o' exportPath ' -aos']);
                    if status ~= 0
                        unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                    end
                else
                    unzip([filePath fileNameZip],[app.defaultPath 'results/']);
                end
            catch
                uialert('Cannot load the data','Bad Input');
                folderLoaded = 0;
                disable_enable_all_function(app,'On')
                figure(app.EpiMechUIFigure)
                return;
            end
        end
        
    case 'plotAndAnalyze'
        

        if ischar(fileNameZip)
            fileNameZip = {fileNameZip};
        end
        
        if length(fileNameZip) == 1
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping',...
                'Indeterminate','on');
        else
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Unzipping');
        end
        
        toRemove = [];
        for i = 1:length(fileNameZip)
            [~,fileName,~] = fileparts(fileNameZip{i});
            idx = find(strcmp(app.LoadedfilesDropDown.Items, fileName));
            if numel(idx) > 0
                toRemove(end+1) = i; %#ok<AGROW>
            end
        end
        fileNameZip(toRemove) = [];
        
        if isempty(fileNameZip)
            disable_enable_all_function(app,'On')
            return;
        end
        
        numberOfOldImports = length(app.LoadedfilesDropDown.Items);
        
        app.newImports = length(app.LoadedfilesDropDown.Items)+1:length(app.LoadedfilesDropDown.Items)+length(fileNameZip);
        
        for i = 1:length(fileNameZip)
            progressdlg.Message = fileNameZip{i};
            progressdlg.Title = ['Unzipping (' num2str(i) '/' num2str(length(fileNameZip)) ')' ];
            if length(fileNameZip) ~= 1
                progressdlg.Value = (i-1)/length(fileNameZip);
            end
            
            %get the filename
            [~,fileName,~] = fileparts(fileNameZip{i});
            
            app.LoadedfilesDropDown.Items{end+1} = fileName;
            app.plotImport(app.newImports(i)).folderName = [app.defaultPath 'results/' fileName];
            
            if ~(isfield(app.import, 'folderName') && strcmp(app.import.folderName, app.plotImport(app.newImports(i)).folderName))
                % unzip the file, if possible
                try
                    if exist([app.defaultPath 'results']) ~= 7 %#ok<EXIST>
                        mkdir(app.defaultPath, 'results');
                    end
                    % check for 7zip
                    [status,~] = system('7z');
                    if ~status
                        zipPath = [filePath fileNameZip{i}];
                        exportPath = [app.defaultPath 'results/'];
                        [status,~] = system(['7z x ' zipPath ' -o' exportPath ' -aos']);
                        if status ~= 0
                            unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                        end
                    else
                        unzip([filePath fileNameZip{i}],[app.defaultPath 'results/'])
                    end
                catch
                    uialert(app.EpiMechUIFigure,'Cannot load the data','Bad Input');
                    folderLoaded = 0;
                    disable_enable_all_function(app,'On')
                    figure(app.EpiMechUIFigure)
                    return;
                end
            end
            
        end
        if app.selectedFile == 0
            app.LoadedfilesDropDown.Value = app.LoadedfilesDropDown.Items{1};
            app.selectedFile = find(strcmp(app.LoadedfilesDropDown.Items, app.LoadedfilesDropDown.Value));
        else
            app.LoadedfilesDropDown.Value = app.LoadedfilesDropDown.Items{numberOfOldImports+1};
            app.selectedFile = find(strcmp(app.LoadedfilesDropDown.Items, app.LoadedfilesDropDown.Value));
        end
        
end


close(progressdlg);

disable_enable_all_function(app,'On')
