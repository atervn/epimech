function timeString = get_time_string(d, time, nUnits)
% GET_TIME_STRING Get the current simulation time string in standard time
% units
%   The function converts the current simulation time to days, hours,
%   minutes, and seconds and creates a time string whose format depends on
%   the maximum simulation time.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%       nUnits: variable to indicate the number of time units in the output
%           string: 0, based on the input time; 1, only in seconds; 2, in
%           seconds and minutes; 3, in seconds, minutes, and hours; and 4
%           in seconds, minutes, hours, and days
%   OUTPUT:
%       timeString: formatted time string
%   by Aapo Tervonen, 2021

% get the maximum simulation time in seconds
simulationTime = d.spar.simulationTime*d.spar.scalingTime;

% add small number to the current simulation time (to make sure the floor
% gives the correct value)
time = time + 1e-8;

% get the time in the full time units
[days, hours, mins, secs] = separate_times(time);

% if the string is requrested in seconds or the simulation time is below or
% equal to one minute
if nUnits == 1 || (nUnits == 0 && simulationTime <= 60)
    timeString = num2str(secs,'%.4f');
    
% if the string is requrested in minutes and seconds or the simulation time
% is below or equal to one hour
elseif nUnits == 2 || (nUnits == 0 && simulationTime <= 60*60)
    timeString = [num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
    
% if the string is requrested in hours, minutes, and seconds or the
% simulation time is below or equal to one day
elseif nUnits == 3 || (nUnits == 0 && simulationTime <= 60*60*24)
    timeString = [num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];

% otherwise
else
    timeString = [num2str(days,'%02.f') '-' num2str(hours,'%02.f') ':' num2str(mins,'%02.f') ':' num2str(secs,'%02.f')];
end

end