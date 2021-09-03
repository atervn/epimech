function data = read_system_parameter_paths(fID, data)

if strcmp(fgetl(fID),'% system parameters')
    while 1
        line = fgetl(fID);
        if strcmp(line,'')
            if numel(data.systemParameterFiles) > 0
                break
            else
                disp('Error. No system parameter file(s) given.')
                data = 0;
                return
            end
        elseif strcmp(line,'load')
            data.systemParameterFiles{end+1} = 'load';
        elseif strcmp(line,'% cell parameters') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% cell parameters''.')
            data = 0;
            return
        else
            fIDTemp = fopen(line);
            if fIDTemp ~= -1
                fclose(fIDTemp);
                [~,~,ext] = fileparts(line);
                if ~strcmp(ext,'.txt')
                    disp('Error. Wrong file format, should be a .txt file.')
                    data = 0;
                    return
                else
                    data.systemParameterFiles{end+1} = line;
                end
            else
                inputNumber = numel(data.systemParameterFiles)+1;
                words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                disp(['Error. The ' words{inputNumber} ' system parameter file cannot be found or opened'])
                data = 0;
                return
            end
        end
    end
else
    disp('Error. Wrong file format, the third line should be ''% system parameters''.')
    data = 0;
    return
end

if ~any(length(data.systemParameterFiles) == [1 data.nSimulations])
    disp(['Error. The number of of given system parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end