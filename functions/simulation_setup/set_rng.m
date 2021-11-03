function set_rng(app)
% SET_RNG Sets the random number generator for the simulation
%   The function either sets the random number generator using a seed 
%   either based on current time or a predefined standard seed. The latter
%   case can be used to run the growth simulation with the same behavior
%   for example to debug the code.
%   INPUT:
%       app: main application object
%   by Aapo Tervonen, 2021

% check if this is growth simulation and if the uniform division times
% checkbox is selected
if strcmp(app.simulationType,'growth') && app.UniformdivisiontimesCheckBox.Value == 1
    
    % use seed 1
    rng(1);

% otherwise
else
    
    % random seed
    rng('shuffle')
end

end