function compress_video(app,d)
% COMPRESS VIDEO Compress a video with ffmpeg
%   The function compressed the simulation or post animation video using
%   ffmpeg.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% get the command for the compression
command = ['ffmpeg -i "' app.defaultPath 'videos/' d.pl.exportName '.mp4" -codec copy -codec:v libx264 -pix_fmt yuv420p -crf 23 -codec:a libfdk_aac -preset fast "' app.defaultPath 'videos/' d.pl.exportName '_cmp.mp4"'];

% run the compression command
[~,~] = system(command);

% remove the old uncompressed video
remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);

% rename the compressed file to have the same name as the original
movefile([app.defaultPath 'videos/' d.pl.exportName '_cmp.mp4'],[app.defaultPath 'videos/' d.pl.exportName '.mp4']);

end