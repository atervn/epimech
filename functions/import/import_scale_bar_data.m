function import_scale_bar_data(app)
% IMPORT_SCALE_BAR_DATA Import data for the scale bar
%   The function imports and checks the scale bar data for plotting.
%   INPUT:
%       app: main application object
%   by Aapo Tervonen, 2021

% if barLengthData is not part of the scale bar settings
if ~isfield(app.scaleBarSettings, 'barLenghtData')
    
    % try to read the scale bar lengths
    try
        
        % read the scale bar lengths
        tempData = csvread([app.defaultPath 'settings/misc/scale_bar_lengths.csv']);
        
        % check that the imported data is corretcly defined
        if check_scale_bar_lenghts_file(tempData)
            
            % if yes, use the data
            app.scaleBarSettings.barLenghtData = tempData;
            
        % otherwise
        else
            app.scaleBarSettings.barLenghtData = 0;
        end
        
        % set the length type to constant
        app.scaleBarSettings.type = 2;
        
    % if file not found etc., use constant length of 30 um
    catch
        app.scaleBarSettings.barLenghtData = 0;
        app.scaleBarSettings.barLength = 30;
    end
end

end