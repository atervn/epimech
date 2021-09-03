function data = read_number_of_simulations(fID,data)

if strcmp(fgetl(fID),'% number of simulations')
    line = fgetl(fID);
    if strcmp(line,'')
        data.nSimulations = 1;
    elseif strcmp(line,'% system parameters') || strcmp(line(1),'%')
        disp('Error. If no simulation number is given, there should be an empty line between ''% number of simulations'' and ''% system parameters''.')
        data = 0;
        return
    else
        line = textscan(line,'','Delimiter',' ;,');
        if length(line) > 1 || all(size(line{1}) == [0 1])
            disp('Error. The line after ''% number of simulations'' should either be empty of have a single positive integer.')
            data = 0;
            return
        else
            if floor(line{1}) == line{1} && line{1} > 0
                data.nSimulations = line{1};
            else
                disp('Error. The number of simulations should be a positive integer.')
                data = 0;
                return
            end
        end
        
    end
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line between the given number of simulations and ''% system parameters''.')
        data = 0;
        return
    end
else
    disp('Error. Wrong file format, the third line should be ''% number of simulations''.')
    data = 0;
    return
end