function remove_folder_function(folderName)
% REMOVE_FOLDER_FUNCTION Remove export folder
%   The function removes the folder that the results were exported in.
%   Since there might be some problems removing the folder if the OS doing
%   something with it (e.g. synching somewhere), the function tries the
%   removal multiple times.
%   INPUT: 
%       folderName: folder to remova
%   by Aapo Tervonen, 2021

% go through some iterations
for i=1:10
    
    % try to remove the folder
    status=rmdir(folderName,'s');
    
    % if the removal was succesfull, break out
    if status==1
        break
    end
    
    % pause for some time
    pause(.1*i)
end

end