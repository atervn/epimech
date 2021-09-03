function finalize_video(app,d)

if d.pl.video
    close(d.pl.videoObject);
    set(gcf,'Resize','on')
    switch app.appTask
        case 'simulate'
            if app.simulationStopped
                userResponse = uiconfirm(app.EpiMechUIFigure,'Save the video until now?', 'Save or discard `video', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
                if strcmp(userResponse,'Discard')
                    remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);
                    return;
                end
            end
            
            if app.CompressvideoCheckBox.Value
                compress_video(d,app);
            end
        case 'plotAndAnalyze'
            if app.animationStopped
                userResponse = uiconfirm(app.EpiMechUIFigure,'Save the video until now?', 'Save or discard `video', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
                if strcmp(userResponse,'Discard')
                    remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);
                    return;
                end
            end
            
            if app.CompressvideoCheckBox_2.Value
                compress_video(d,app);
            end
    end
end