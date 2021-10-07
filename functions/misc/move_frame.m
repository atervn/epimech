function d = move_frame(d,dt)
% MOVE_FRAME Move the frame in the frame simulation
%   The function moves the points for the frame during the frame simulation
%   based on a predifined pace.
%   INPUTS:
%       d: main simulation data structure
%       dt: current simulation time step
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if frame simulation
if d.simset.simulationType == 4
    
    % move the frame corners
    d.simset.frame.cornersX = d.simset.frame.cornersX + 0.01.*dt.*[1 -1 -1 1]';
    d.simset.frame.cornersY = d.simset.frame.cornersY + 0.01.*dt.*[1 1 -1 -1]';
end

end