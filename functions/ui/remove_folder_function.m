function remove_folder_function(folderName)

for i=1:10
    status=rmdir(folderName,'s');
    if status==1
        break
    end
    pause(.1*i)
end

end