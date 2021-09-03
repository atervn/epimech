function data = read_number_of_cores(fID,data)

if strcmp(fgetl(fID),'% number of cores')
    line = fgetl(fID);
    if strcmp(line,'')
        data.nCores = 1;
    elseif strcmp(line,'% number of simulations') || strcmp(line(1),'%')
        disp('Error. If no core number is given, there should be an empty line between ''% number of cores'' and ''% number of simulations''.')
        data = 0;
        return
    else
        line = textscan(line,'','Delimiter',' ;,');
        if length(line) > 1 || all(size(line{1}) == [0 1])
            disp('Error. The line after ''% number of cores'' should either be empty of have a single positive integer.')
            data = 0;
            return
        else
            if floor(line{1}) == line{1} && line{1} > 0
                data.nCores = line{1};
            else
                disp('Error. The number of cores should be a positive integer.')
                data = 0;
                return
            end
        end
        
    end
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line between the given number of cores and ''% number of simulations''.')
        data = 0;
        return
    end
else
    disp('Error. Wrong file format, the first line should be ''% number of cores''.')
    data = 0;
    return
end