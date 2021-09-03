function remove_file(fileName)

for i=1:10
    lastwarn('');
        delete(fileName);
    [warnMsg,~] = lastwarn;
    if isempty(warnMsg)
        break
    end
    pause(.1*i)
end

end
