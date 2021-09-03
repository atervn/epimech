function compress_video(d,app)

command = ['ffmpeg -i "' app.defaultPath 'videos/' d.pl.exportName '.mp4" -codec copy -codec:v libx264 -pix_fmt yuv420p -crf 23 -codec:a libfdk_aac -preset fast "' app.defaultPath 'videos/' d.pl.exportName '_cmp.mp4"'];
[~,~] = system(command);
remove_file([app.defaultPath 'videos/' d.pl.exportName '.mp4']);
movefile([app.defaultPath 'videos/' d.pl.exportName '_cmp.mp4'],[app.defaultPath 'videos/' d.pl.exportName '.mp4']);