function outputStruct = import_settings(filename)
% IMPORT_SETTINGS Import data from files into structures
%   The function reads data from csv files into structures. The data in the
%   files is in the form of "fieldName,value" for each line on each field.
%   INPUT:
%       filename: the full path and file name of the file to be read
%   OUTPUT:
%       outputStruct: structure with the imported field and data values
%   by Aapo Tervonen, 2021

% open the file
fID = fopen(filename);

% scan the file into a cell
settings = textscan(fID,'%s %f', 'Delimiter', ',', 'MultipleDelimsAsOne', 1, 'CommentStyle', '%');

% close the file
fclose(fID);

% find comment lines
commentLines = find(isnan(settings{2}));

% remove the comment lines
settings{1}(commentLines) = [];
settings{2}(commentLines) = [];

% go through the imported data and construct the struct
for i = 1:length(settings{1})
    outputStruct.(settings{1}{i}) =  settings{2}(i);
end

end

