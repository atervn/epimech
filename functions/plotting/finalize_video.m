function finalize_video(app,d)
% FINALIZE_VIDEO Finalize the video after simulation or post animation
%   The function finalizes that video after a simulation or post animation.
%   Also, if the animation was stopped, it will ask the user whether to
%   keep the video thusfar or to remove it.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if video is saved
if d.pl.video
    
    % close the video object
    close(d.pl.videoObject);
    
    % set the animation window resizing back to on
    set(gcf,'Resize','on')
    
    % check wherther simulation or post animation
    switch app.appTask
        case 'simulate'
            
            % if simulation was stopped
            if app.simulationStopped
                
                % ask whether to keep the video thusfar
                userResponse = uiconfirm(app.EpiMechUIFigure,'Save the video until now?', 'Save or discard `video', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
                
                % if no, remove the video and return
                if strcmp(userResponse,'Discard')
                    remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);
                    return;
                end
            end
            
            % if compression was selected, compress the video
            if app.CompressvideoCheckBox.Value
                compress_video(app,d);
            end
            
        case 'plotAndAnalyze'
            
            % if animation was stopped
            if app.animationStopped
                
                % ask whether to keep the video thusfar
                userResponse = uiconfirm(app.EpiMechUIFigure,'Save the video until now?', 'Save or discard `video', 'Options', {'Save','Discard'}, 'DefaultOption', 1);
                
                % if no, remove the video and return
                if strcmp(userResponse,'Discard')
                    remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);
                    return;
                end
            end
            
            % if compression was selected, compress the video
            if app.CompressvideoCheckBox_2.Value
                compress_video(app,d);
            end
    end
end

end