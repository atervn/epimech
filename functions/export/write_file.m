function write_file(ex, data, name, number, varargin)
% WRITE_FILE Write matrix to a file
%   The function writes the provided data matrix to a file based on the
%   path provided in the input.
%   INPUTS:
%       ex: export options structure
%       data: data matrix to write to file
%       name: name of the base file
%       number: number of the export time step
%       varargin: used to provide the path for the file if the file is not
%           written into a folder in the root export path with the same
%           name as the base file name (e.g. ".\vertices\vertices_1.csv" is
%           varargin is empty, and .\cell_forces\division\division_1.csv" 
%           if the path "cell_forces\division" is provided in varargin).
%   by Aapo Tervonen, 2021

% if the data is written into a path in style of "./name/name_number.csv"
if numel(varargin) == 0
    
    % write the csv file
    csvwrite([ex.defaultPath '/results/', ex.exportName '/' name '/' name '_'  number '.csv'], data);

% if the path if provided in varargin
else
    
    % write the csv file
    csvwrite([ex.defaultPath '/results/', ex.exportName '/' varargin{1} '/' name '_'  number '.csv'], data);
end

end