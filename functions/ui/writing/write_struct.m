function write_struct(exportStruct,exportFile)

% get the parameter field names
    fieldNames = fieldnames(exportStruct);
    
    for i = 1:length(fieldNames)
        exportStruct.(fieldNames{i}) = double(exportStruct.(fieldNames{i}));
    end
    
    % get the parameter values
    structMatrix = cell2mat(struct2cell(exportStruct));
    
    % create the export file
    fileID = fopen(exportFile, 'w');
    
    % go through the parameters
    for i = 1:length(structMatrix)
        
        % write the parameter name and value
        fprintf(fileID,'%s,%s\r\n', fieldNames{i}, num2str(structMatrix(i)));
    end
    
    % close the file
    fclose(fileID);

end