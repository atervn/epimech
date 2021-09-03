function data = read_cell_parameter_paths(fID, data)

if strcmp(fgetl(fID),'% cell parameters')
    while 1
        line = fgetl(fID);
        if strcmp(line,'')
            if numel(data.cellParameterFiles) > 0
                break
            else
                disp('Error. No cell parameter file(s) given.')
                data = 0;
                return
            end
        
        elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% substrate parameters''.')
            data = 0;
            return
        else
            
            line = textscan(line,'%s %s');
            
            [~,~,ext] = fileparts(line{1}{1});
            if strcmp(line{1}{1},'load')
                data.cellParameterFiles{end+1} = 'load';
            else
                fIDTemp = fopen(line{1}{1});
                if fIDTemp ~= -1
                    fclose(fIDTemp);
                    if ~strcmp(ext,'.txt')
                        disp('Error. Wrong file format, should be a .txt file.')
                        data = 0;
                        return
                    else
                        data.cellParameterFiles{end+1} = line{1}{1};
                    end
                else
                    inputNumber = numel(data.cellParameterFiles)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' cell parameter file cannot be found or opened.'])
                    data = 0;
                    return
                end
            end
            
            
            [~,~,ext] = fileparts(line{2}{1});
            if strcmp(line{2}{1},'load')
                data.specificCellParameterFiles{end+1} = 'load';
            else
                
                fIDTemp = fopen(line{2}{1});
                
                if fIDTemp ~= -1
                    fclose(fIDTemp);
                    if ~strcmp(ext,'.txt')
                        disp('Error. Wrong file format, should be a .txt file.')
                        data = 0;
                        return
                    else
                        data.specificCellParameterFiles{end+1} = line{2}{1};
                    end
                else
                    inputNumber = numel(data.specificCellParameterFiles)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' specific cell parameter file cannot be found or opened.'])
                    data = 0;
                    return
                end
            end
        end
    end
else
    disp('Error. Wrong file format, the third line should be ''% cell parameters''.')
    data = 0;
    return
end

if ~any(length(data.cellParameterFiles) == [1 data.nSimulations])
    disp(['Error. The number of of given cell parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end