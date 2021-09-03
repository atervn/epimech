function import_scale_bar_data(app)

if ~isfield(app.scaleBarSettings, 'barLenghtData')
    try
        tempData = csvread([app.defaultPath 'settings/Misc/scale_bar_lengths.csv']);
        if check_scale_bar_lenghts_file(tempData)
            app.scaleBarSettings.barLenghtData = tempData;
        else
            app.scaleBarSettings.barLenghtData = 0;
        end
        app.scaleBarSettings.type = 2;
    catch
        app.scaleBarSettings.barLenghtData = 0;
        app.scaleBarSettings.barLength = 30;
    end
end

end