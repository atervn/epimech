function outputStruct = table_to_struct(inputCell)
%STRUCT_TO_TABLECELL Summary of this function goes here
%   Detailed explanation goes here
outputStruct = struct;

for i = 1:size(inputCell)
    outputStruct.(inputCell{i,1}) = inputCell{i,2};    
end

end

