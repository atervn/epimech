function output = check_scale_bar_lenghts_file(tempData)

output = 1;

if size(tempData,2) ~= 3
    output = 0;
    return
end

for i = 1:size(tempData,1)
    
    if tempData(i,2) >= tempData(i,3)
        output = 0;
        return
    end
    if i < size(tempData,1)
        if tempData(i,3) ~= tempData(i+1,2)
            output = 0;
            return
        end
    end
end