function outputStruct = fromTable2Struct(inputCell)

nRows = size(inputCell,1);

for i = 1:nRows
    outputStruct.(inputCell{i,1}) = inputCell{i,2}; 
end

end