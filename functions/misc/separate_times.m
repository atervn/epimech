function [days, hours, mins, secs] = separate_times(time)
% SEPARATE_TIMES Separate time into seconds, minutes, hours, and days
%   INPUTS:
%       time: input time
%   OUTPUT:
%       days: full days
%       hours: full hours over the full days
%       mins: full minutes over the full hours and days
%       secs: seconds over the full minutes, hours, and days
%   by Aapo Tervonen, 2021

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

end