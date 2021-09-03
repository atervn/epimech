function data = read_initial_state_paths(fID,data)

if strcmp(fgetl(fID),'% initial state')
    while 1
        line = fgetl(fID);
        if strcmp(line,'')
            break
        else
            line = textscan(line,'%s');
            if strcmp(line{1}{1},'load')
                data.initialStateFiles{end+1} = 'load';
            elseif strcmp(line{1}{1},'% simulation type') || strcmp(line{1}{1},'%')
                disp('Error. Wrong file format, there should be an empty line before ''% simulation type''.')
                data = 0;
                return
            else
                if exist(line{1}{1},'file') == 0
                    inputNumber = numel(data.initialStateFiles)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' initial state file not found (' line{1}{1} ').'])
                    data = 0;
                    return
                end
                [~,~,ext] = fileparts(line{1}{1});
                if ~strcmp(ext,'.zip')
                    disp('Error. Wrong file format, should be a .zip file.')
                    data = 0;
                    return
                else
                    data.initialStateFiles{end+1} = line{1}{1};
                end
            end
            
            if isempty(line{1}{2})
                disp('Error. the flag after the file name for either given or loaded cell parameters is missing (0 or 1)')
                data = 0;
                return
            elseif ~(strcmp(line{1}{2},'0') || strcmp(line{1}{2},'1'))
                disp('Error. the flag must be either 0 or 1 for given or loaded cell parameters, respectively')
                data = 0;
                return
            else
                data.loadedParameters(end+1) = str2double(line{1}{2});
            end
            
            if length(line{1}) > 2
               string = line{1}{3};
               if length(string) < 2
                   disp('Error. The cell removal flag must have the shape type (c or s) followed by the size in µm.')
                   data = 0;
                   return
               end
               if ~(strcmp(string(1),'c') || strcmp(string(1),'r'))
                   disp('Error. The cell removal shape type must be the first letter (c or s) of the removal flag.')
                   data = 0;
                   return
               else
                   data.removeCells.type{end+1} = string(1);
               end
               
               rSize = str2double(string(2:end));
               
               if isnan(rSize) 
                   disp('Error. Cannot read the cell removal size, not a number.')
                   data = 0;
                   return
               elseif rSize <= 0
                   disp('Error. The cell removal size must be a positive number.')
                   data = 0;
                   return
               else
                   data.removeCells.size{end+1} = rSize;
               end
               
            end
            
        end
    end
else
    disp('Error. Wrong file format, the next line should be ''% simulation time''.')
    data = 0;
    return
end

if ~any(length(data.initialStateFiles) == [0 1 data.nSimulations])
    disp(['Error. The number of of given initial state files must be zero, one, or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end