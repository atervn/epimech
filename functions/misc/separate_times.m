function timeString = separate_times(d,time)

simulationTime = d.spar.simulationTime*d.spar.scalingTime;

time = time + 1e-8;

if time < 60
    secs = time;
    mins = 0;
    hours = 0;
    days = 0;
elseif time < 60*60
    mins = floor(round(time,1)/60);
    secs = time - mins*60;
    hours = 0;
    days = 0;
elseif time < 60*60*24
    hours = floor(time/(60*60));
    mins = floor(time/60 - hours*60);
    secs = time - mins*60 - hours*60*60;
    days = 0;
else
    days = floor(time/(60*60*24));
    hours = floor(time/(60*60) - days*24);
    mins = floor(time/60 - hours*60 - days*24*60);
    secs = time - mins*60 - hours*60*60 - days*24*60*60;
end

if simulationTime <= 60
    timeString = num2str(secs,'%6.4f');
elseif simulationTime <= 60*60 
    timeString = [num2str(mins,'%02.f') ':' num2str(secs,'%05.2f')];
elseif simulationTime < 60*60*24
    timeString = [num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
else
    timeString = [num2str(days,'%d') '-' num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
end