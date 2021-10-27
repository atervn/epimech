function remove_file(fileName)
% REMOVE_FILE Remove a file
%   The function removes a file. Since there might be some problems
%   removing the file if the OS doing something with it (e.g. synching
%   somewhere), the function tries the removal multiple times.
%   INPUT: 
%       fileName: file to remova
%   by Aapo Tervonen, 2021

% go through some iterations
for i=1:10
    
    % make sure there are no previous warnings
    lastwarn('');
    
    % try to remove the file
    delete(fileName);
    
    % check if there were warnings
    [warnMsg,~] = lastwarn;
    
    % if there are no warnings, break
    if isempty(warnMsg)
        break
    end
    
    % pause for some time
    pause(.1*i)
end

end
