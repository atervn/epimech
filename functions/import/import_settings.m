function outputStruct = import_settings(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fID = fopen(filename);
settings = textscan(fID,'%s %f', 'Delimiter', ',', 'MultipleDelimsAsOne', 1, 'CommentStyle', '%');
fclose(fID);
commentLines = find(isnan(settings{2}));

settings{1}(commentLines) = [];
settings{2}(commentLines) = [];

% go through the imported data to construct the struct
for i = 1:length(settings{1})
    outputStruct.(settings{1}{i}) =  settings{2}(i);
end
end

