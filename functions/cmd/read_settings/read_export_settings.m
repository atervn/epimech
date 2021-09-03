function data = read_export_settings(fID,data)

if strcmp(fgetl(fID),'% export settings')
    while 1
        line = fgetl(fID);
        if strcmp(line,'')
            if numel(data.exportSettings) > 0
                break
            else
                disp('Error. No export settings file(s) given.')
                data = 0;
                return
            end
        elseif strcmp(line,'% simulation name') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% simulation name''.')
            data = 0;
            return
        else
            line = textscan(line,'%f %s');
            data.exportDt = line{1};
            fIDTemp = fopen(line{2}{1});
            if strcmp(line{2}{1},'load')
                data.exportSettings{end+1} = 'load';
            elseif fIDTemp ~= -1
                fclose(fIDTemp);
                [~,~,ext] = fileparts(line{2}{1});
                if ~strcmp(ext,'.txt')
                    disp('Error. Wrong file format, should be a .txt file.')
                    data = 0;
                    return
                else
                    data.exportSettings{end+1} = line{2}{1};
                end
            else
                inputNumber = numel(data.exportSettings)+1;
                words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                disp(['Error. The ' words{inputNumber} ' export settings file cannot be found or opened'])
                data = 0;
                return
            end
        end
    end
else
    disp('Error. Wrong file format, the third line should be ''% export settings''.')
    data = 0;
    return
end

if ~any(length(data.exportSettings) == [1 data.nSimulations])
    disp(['Error. The number of of given export settings files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end