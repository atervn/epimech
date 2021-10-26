function show_simulation_time(simTime,type,iLoop)
% SHOW_SIMULATION_TIME Show a simulation time after simulation
%   The function shows the message after a single simulation or the whole
%   CMD set finishes.
%   INPUT: 
%       singleSimTime: simulation time
%       type: variable to indicate if this is for the single simulation (1)
%           or for the whole simulation run (2)
%       iLoop: current simulation index
%   by Aapo Tervonen, 2021

% get current time and the time for the simulation
dateVector = clock;

% formats the time and date strings
timeSimulationEnd = datestr(dateVector, 'HH:MM:SS');
dateSimulationEnd = datestr(dateVector, 'dd/mmm/yyyy');

if type == 1
    
    % if the simulation took over an hour
    if simTime >= 3600
        message = sprintf('Simulation %.0f finished after %d h, %d min %.2f s at %s, %s', iLoop, floor(simTime/3600), floor((simTime - 3600*floor(simTime/3600))/60), rem(simTime - 3600*floor(simTime/3600),60), timeSimulationEnd, dateSimulationEnd);
        
    % if the simulation time is between an hour and a minute
    elseif simTime >= 60
        message = sprintf('Simulation %.0f finished after %d min %.2f s at %s, %s', iLoop, floor(simTime/60), rem(simTime,60), timeSimulationEnd, dateSimulationEnd);
        
    % if the simulation time is below one minute
    else
        message = sprintf('Simulation %.0f finished after %.2f s at %s, %s', iLoop, rem(simTime,60), timeSimulationEnd, dateSimulationEnd);
    end

elseif type == 2
   
    % if the simulation took over an hour
    if simTime >= 3600
        message = sprintf('The run finished after %d h, %d min %.2f s at %s, %s', floor(simTime/3600), floor((simTime - 3600*floor(simTime/3600))/60), rem(simTime - 3600*floor(simTime/3600),60), timeSimulationEnd, dateSimulationEnd);
        
    % if the simulation time is between an hour and a minute
    elseif simTime >= 60
        message = sprintf('The run finished after %d min %.2f s at %s, %s', floor(simTime/60), rem(simTime,60), timeSimulationEnd, dateSimulationEnd);
        
    % if the simulation time is below one minute
    else
        message = sprintf('The run finished after %.2f s at %s, %s', rem(simTime,60), timeSimulationEnd, dateSimulationEnd);
    end
end

% display the message
disp(message);

end