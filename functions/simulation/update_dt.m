function dt = update_dt(d,dt,time,maxmaxMovement)
% UPDATE_DT Update the simulation time step dt.
%   Checks if the current time step is lower than the maximum time step and
%   increases the time step if the maximum movement of all cell vertices is
%   lower than a set limit and so that the each "normal time step" time
%   point is gone through (for the plotting and exporting at specific time
%   points to work).
%   by Aapo Tervonen, 2021

% if the current time step is lower than the maximum and the max vertex
% movement is below a limit
if dt < d.spar.maximumTimeStep && maxmaxMovement <= d.spar.cellMinimumMovementSq
    % set a multiplier to double the time step
    multiplier = 2;
else
    % no change in dt
    multiplier = 1;
end

% find a time step that does not go over the next "normal time step" time
% point
while 1
    
    % Compare the current time point plus the next possible time step
    % (multiplier*dt) and the next "normal time step" time point
    if round( ((floor(time/d.spar.maximumTimeStep+1e-10)*d.spar.maximumTimeStep + d.spar.maximumTimeStep) - (multiplier*dt+time)),10) >= 0
        
        % if the current time + multiplier*dt is not over the next "normal
        % time step" time point, set the time step
        dt = dt*multiplier;
        break;
    else
        % if the current time + multiplier*dt is now over the next "normal
        % time step" time point, half the multiplier
        multiplier = multiplier/2;
    end
end

end