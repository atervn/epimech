function epimech(varargin)
% EPIMECH Run the epimech simulator
%   The function runs either the GUI or command line version of the epimech
%   simulator.
%   INPUT:
%       varargin: can be used to define the simulation config file for
%       command line simulation
%   by Aapo Tervonen, 2021

% add functions folder to the path
addpath(genpath('functions'));

% if there are no input
if numel(varargin) == 0
    
    % start the epimech GUI and return this function
    epimech_gui;
    return
    
% otherwise
else
    
    % run the command line version with the given config file
    epimech_cmd(varargin{1});
end

end