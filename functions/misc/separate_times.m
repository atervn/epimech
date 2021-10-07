function timeString = separate_times(d,time)
% SEPARATE_TIMES Get the current simulation time in standard time units
%   The function converts the current simulation time to days, hours,
%   minutes, and seconds and creates a time string whose format depends on
%   the maximum simulation time.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       timeString: formatted time string
%   by Aapo Tervonen, 2021

% get the maximum simulation time in seconds
simulationTime = d.spar.simulationTime*d.spar.scalingTime;

% add small number to the current simulation time (to make sure the floor
% gives the correct value)
time = time + 1e-8;

% if the current time is below 1 minute
if time < 60
    secs = time;
    mins = 0;
    hours = 0;
    days = 0;
    
% if the current time is below 1 hour
elseif time < 60*60
    mins = floor(round(time,1)/60);
    secs = time - mins*60;
    hours = 0;
    days = 0;
    
% if the current time is below 1 day
elseif time < 60*60*24
    hours = floor(time/(60*60));
    mins = floor(time/60 - hours*60);
    secs = time - mins*60 - hours*60*60;
    days = 0;

% otherwise
else
    days = floor(time/(60*60*24));
    hours = floor(time/(60*60) - days*24);
    mins = floor(time/60 - hours*60 - days*24*60);
    secs = time - mins*60 - hours*60*60 - days*24*60*60;
end

% get the time time string depending on the maximum simulation time
if simulationTime <= 60
    timeString = num2str(secs,'%6.4f');
elseif simulationTime <= 60*60 
    timeString = [num2str(mins,'%02.f') ':' num2str(secs,'%05.2f')];
elseif simulationTime < 60*60*24
    timeString = [num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
else
    timeString = [num2str(days,'%d') '-' num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
end

end