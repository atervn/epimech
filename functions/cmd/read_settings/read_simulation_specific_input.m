function data = read_simulation_specific_input(fID,data)

if strcmp(fgetl(fID),'% simulation specific input')
    if strcmp(data.simulationType,'growth')
        
        data.sizeType = [];
        
        while 1
            line = fgetl(fID);
            if strcmp(line,'')
                if numel(data.sizeType) > 0
                    break
                else
                    disp('Error. No size type given (uniform or mdck).')
                    data = 0; return
                end
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.')
                data = 0; return
            else
                line = textscan(line,'%s');
                
                if strcmp('uniform',line{1}{1})
                    data.sizeType(end+1) = 1;
                elseif strcmp('mdck',line{1}{1})
                    data.sizeType(end+1) = 2;
                else
                    inputNumber = numel(data.sizeType)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' simulation specific input is incorrect.'])
                    data = 0; return
                end
            end
        end
    elseif strcmp(data.simulationType,'pointlike')
        data.pointlike.pointlikeMovement = {};
        data.pointlike.cell = {};
        while 1
            line = fgetl(fID);
            if strcmp(line,'')
                if numel(data.pointlike.cell) > 0
                    break
                else
                    disp('Error. No pointlike parameters given.'); data = 0; return
                end
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.'); data = 0; return
            else
                line = textscan(line,'%s %s');
                cellNumber = str2double(line{1}{1});
                
                if isnan(cellNumber)
                    inputNumber = numel(data.pointlike.cell)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' simulation specific input is incorrect.'])
                    data = 0;
                    return
                elseif ~(floor(cellNumber) == cellNumber && cellNumber >= 0)
                    inputNumber = numel(data.pointlike.cell)+1;
                    words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                    disp(['Error. The ' words{inputNumber} ' cell number must be zero or a positive integer.'])
                    data = 0; return
                else
                    data.pointlike.cell{end+1} = cellNumber;
                end
                
                [~,~,ext] = fileparts(line{2}{1});
                
                if strcmp(line{2}{1},'load')
                    data.pointlike.pointlikeMovement{end+1} = 'load';
                elseif ~strcmp(ext,'.txt')
                    disp('Error. Wrong file format, should be a .txt file.')
                    data = 0; return
                else
                    
                    fIDTemp = fopen(line{2}{1});
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.pointlike.pointlikeMovement{end+1} = line{2}{1};
                    else
                        inputNumber = numel(data.pointlike.pointlikeMovement)+1;
                        words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                        disp(['Error. The ' words{inputNumber} ' pointlike movement file cannot be found or opened'])
                        data = 0; return
                    end
                end
            end
        end
    elseif strcmp(data.simulationType,'stretch')
        
        data.stretching.directions = {};
        data.stretching.type = {};
        data.stretching.info = {};
        while 1
            line = fgetl(fID);
            if strcmp(line,'')
                if numel(data.stretching.directions) > 0
                    break
                else
                    disp('Error. No stretching parameters given.'); data = 0; return
                end
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.'); data = 0; return
            else
                line = textscan(line,'%s');
                lineIdx = 1;
                
                if strcmp(line{1}{lineIdx},'uni')
                    data.stretching.directions{end+1} = 1;
                    lineIdx = lineIdx + 1;
                elseif strcmp(line{1}{lineIdx},'bi')
                    data.stretching.directions{end+1} = 2;
                    lineIdx = lineIdx + 1;
                else
                    disp('Error. Stretching direction must be either uni or bi.'); data = 0; return
                end
                
                if strcmp(line{1}{lineIdx},'piecewise')
                    data.stretching.type{end+1} = 1;
                    lineIdx = lineIdx + 1;
                elseif strcmp(line{1}{lineIdx},'sine')
                    data.stretching.type{end+1} = 2;
                    lineIdx = lineIdx + 1;
                else
                    disp('Error. Stretching type must be either piecewise or sine.'); data = 0; return
                end
                
                if data.stretching.type{end} == 1
                    stretchingFile = line{1}{lineIdx};
                    
                    [~,~,ext] = fileparts(stretchingFile);
                    
                    if ~strcmp(ext,'.csv')
                        disp('Error. The piecewise stretching file should be a .csv file.'); data = 0; return
                    else
                        try
                            stretchingData = csvread(stretchingFile);
                        catch
                            disp('Error. Could not open the stretching file.'); data = 0; return
                        end
                        
                        if size(stretchingData,2) ~= 2
                            disp('Error. There must be columns in the stretchin file.'); data = 0; return
                        elseif size(stretchingData,1) <= 1
                            disp('Error. There must be more than one row in the stretching file.'); data = 0; return
                        elseif stretchingData(1,1) ~= 0
                            disp('Error. The first time point must be zero.'); data = 0; return
                        elseif ~all((stretchingData(2:end,1) - stretchingData(1:end-1,1)) > 0 )
                            disp('Error. The time point values must be increasing.'); data = 0; return
                        elseif ~all(stretchingData(:,2) > 0)
                            disp('Error. The stretches must be above zero.'); data = 0; return
                        else
                            data.stretching.info{end+1} = stretchingFile;
                        end
                    end
                elseif data.stretching.type{end+1} == 2
                    stretchingFile = line{1}{lineIdx};
                    
                    [~,~,ext] = fileparts(stretchingFile);
                    
                    if ~strcmp(ext,'.csv')
                        disp('Error. The sine stretching file should be a .csv file.'); data = 0; return
                    else
                        try
                            stretchingData = csvread(stretchingFile);
                        catch
                            disp('Error. Could not open the stretching file.'); data = 0; return
                        end
                        
                        if length(stretchingData) ~= 3
                            disp('Error. There must be three values in the sine stretching file.'); data = 0; return
                        elseif stretchingData(1) < 0
                            disp('Error. The first value in the sine stretching file (amplitude) must be above zero.'); data = 0; return
                        elseif stretchingData(2) <= 0
                            disp('Error. The first value in the sine stretching file (frequency) must be nonnegative.'); data = 0; return
                        else
                            data.stretching.info{end+1} = stretchingFile;
                        end
                    end
                end
            end
        end
    elseif strcmp(data.simulationType,'opto')
        data.opto.activation = {};
        data.opto.shapes = {};
        while 1
            line = fgetl(fID);
            if strcmp(line,'')
                if numel(data.opto.activation) > 0
                    break
                else
                    disp('Error. No opto parameters given.')
                    data = 0; return
                end
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.') ;data = 0; return
            else
                line = textscan(line,'%s %s');
                
                
                [~,~,ext] = fileparts(line{1}{1});
                
                if strcmp(line{1}{1},'load')
                    data.opto.activation{end+1} = 'load';
                elseif ~strcmp(ext,'.csv')
                    disp('Error. Wrong file format, should be a .csv file.'); data = 0; return
                else
                    
                    fIDTemp = fopen(line{1}{1});
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.opto.activation{end+1} = line{1}{1};
                    else
                        inputNumber = numel(data.opto.activation)+1;
                        words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                        disp(['Error. The ' words{inputNumber} ' activation file cannot be found or opened'])
                        data = 0; return
                    end
                end
                
                
                [~,~,ext] = fileparts(line{2}{1});
                
                if strcmp(line{2}{1},'load')
                    data.opto.shapes{end+1} = 'load';
                elseif ~strcmp(ext,'.csv')
                    disp('Error. Wrong file format, should be a .csv file.'); data = 0; return
                else
                    
                    fIDTemp = fopen(line{2}{1});
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.opto.shapes{end+1} = line{2}{1};
                    else
                        inputNumber = numel(data.opto.shapes)+1;
                        words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                        disp(['Error. The ' words{inputNumber} ' shapes file cannot be found or opened'])
                        data = 0; return
                    end
                end
                
                
            end
        end
    else
        disp('Error. Simulation specific input missing.'); data = 0; return
    end
else
    disp('Error. Wrong file format, the third line should be ''% simulation specific input''.')
    data = 0;
    return
end

if strcmp(data.simulationType,'growth')
    if ~any(length(data.sizeType) == [1 data.nSimulations])
        disp(['Error. The number of the given cell size types should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
        data = 0;
        return
    end
elseif strcmp(data.simulationType,'pointlike')
    if ~any(length(data.pointlike.cell) == [1 data.nSimulations])
        disp(['Error. The number of the given pointlike specifications should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
        data = 0;
        return
    end
    % FIX THIS
elseif strcmp(data.simulationType,'stretch')
    if ~any(length(data.initialStateFiles) == [1 data.nSimulations])
        disp(['Error. The number of the given initial state files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
        data = 0;
        return
    end
elseif strcmp(data.simulationType,'opto')
    if ~any(length(data.opto.activation) == [1 data.nSimulations])
        disp(['Error. The number of the given optogenetica activation specifications should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
        data = 0;
        return
    end
end
