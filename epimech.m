function epimech(varargin)

addpath(genpath('Functions'));

if numel(varargin) == 0
    epimech_gui;
    return
else
    epimech_cmd(varargin{1});
end

