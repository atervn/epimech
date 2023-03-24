function outputCell = struct_to_table(inputStruct)
%STRUCT_TO_TABLECELL Summary of this function goes here
%   Detailed explanation goes here

fieldNames = fieldnames(inputStruct);

outputCell = cell(0);

for i = 1:length(fieldNames)
   
    outputCell{i,1} = fieldNames{i};
    outputCell{i,2} = inputStruct.(fieldNames{i});
    
end

end