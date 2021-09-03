function data = read_substrate_parameter_paths(fID, data)

if strcmp(fgetl(fID),'% substrate parameters')
    if ~strcmp(data.simulationType,'growth')
        data.fFAInfo = {};
        data.stiffnessType = {};
        data.stiffness = {};
        data.stiffnessInfo = {};
        
        while 1
            line = fgetl(fID);
            lineIdx = 1;
            if strcmp(line,'')
                if numel(data.stiffnessType) > 0
                    break
                else
                    disp('Error. No substrate parameters given.')
                    data = 0;
                    return
                end
            elseif strcmp(line,'% initial state') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% initial state''.'); data = 0; return
            else
                line = textscan(line,'%s');
                
                if strcmp(line{1}{lineIdx},'uniform')
                    data.stiffnessType{end+1} = 'uniform';
                    lineIdx = lineIdx + 1;
                    stiffness = str2double(line{1}{lineIdx});
                    data.stiffnessInfo{end+1} = 0;
                    if isnan(stiffness)
                        disp('Error. Stiffness is not a number'); data = 0; return
                    elseif stiffness < 0
                        disp('Error. Stiffness must be positive'); data = 0; return
                    else
                        data.stiffness{end+1} = stiffness;
                        lineIdx = lineIdx + 1;
                    end
                elseif strcmp(line{1}{lineIdx},'gradient')
                    data.stiffnessType{end+1} = 'gradient';
                    data.stiffness{end+1} = 0;
                    lineIdx = lineIdx + 1;
                    
                    stiffnessGradientFile = line{1}{lineIdx};
                    if strcmp(stiffnessGradientFile,'load')
                        data.stiffnessInfo{end+1} = 'load';
                        lineIdx = lineIdx + 1;
                    else
                        [~,~,ext] = fileparts(stiffnessGradientFile);
                        if ~strcmp(ext,'.csv')
                            disp('Error. Gradient file must be .csv file'); data = 0; return
                        else
                            try
                                gradientInfoTemp = csvread(stiffnessGradientFile);
                            catch
                                disp('Error. Cannot open gradient file'); data = 0; return
                            end
                            if size(gradientInfoTemp,2) ~= 3
                                disp('Error. Gradient file must have three columns (one for positions, one for stiffnesses, and one for rotation angle).'); data = 0; return
                            elseif any(gradientInfoTemp(:,2) <= 0)
                                disp('Error. All values in the second column of the gradient file must be larger than zero.'); data = 0; return
                            elseif any(diff(gradientInfoTemp(:,1)) <= 0)
                                disp('Error. The position values in the first column of the gradient file must be increasing'); data = 0; return
                            elseif size(gradientInfoTemp,1) > 1 && ~any(gradientInfoTemp(2:end,3) == 0)
                                disp('Error. The values in the third column of the gradient file should be zeroes excluding the first value (which can be zero).'); data = 0; return
                            end
                            
                            data.stiffnessInfo{end+1} = stiffnessGradientFile;
                            lineIdx = lineIdx + 1;
                            
                        end
                    end
                elseif strcmp(line{1}{lineIdx},'heterogenous')
                    data.stiffnessType{end+1} = 'heterogenous';
                    lineIdx = lineIdx + 1;
                    
                    stiffness = str2double(line{1}{lineIdx});
                    if isnan(stiffness)
                        disp('Error. Stiffness is not a number'); data = 0; return
                    elseif stiffness < 0
                        disp('Error. Stiffness must be positive'); data = 0; return
                    else
                        data.stiffness{end+1} = stiffness;
                        lineIdx = lineIdx + 1;
                    end
                    
                    stiffnessHeterogeneityFile = line{1}{lineIdx};
                    if strcmp(stiffnessHeterogeneityFile,'load')
                        data.stiffnessInfo{end+1} = 'load';
                        lineIdx = lineIdx + 1;
                    else
                        [~,~,ext] = fileparts(stiffnessHeterogeneityFile);
                        if ~strcmp(ext,'.csv')
                            disp('Error. Stiffness heterogeneity file must be .csv file'); data = 0; return
                        else
                            try
                                heterogeneityInfoTemp = csvread(stiffnessHeterogeneityFile);
                            catch
                                disp('Error. Cannot open heterogeneity file'); data = 0; return
                            end
                            if heterogeneityInfoTemp(1) <= 0 || heterogeneityInfoTemp(2) <= 0 || heterogeneityInfoTemp(3) < 0
                                disp('Error. Stiffness heterogeneity file must have two autocorrelation length values (larger than zero), amplitude of the hetergeneity (nonnegative), and the rotation in rads'); data = 0; return
                            else
                                data.stiffnessInfo{end+1} = stiffnessHeterogeneityFile;
                                lineIdx = lineIdx + 1;
                            end
                        end
                    end
                else
                    if ~strcmp(data.simulationType,'stretch')
                        disp('Error. No proper stiffness type given, must be either uniform, heterogenous, or gradient'); data = 0; return
                    else
                        data.stiffnessType{end+1} = 'uniform';
                        data.stiffness{end+1} = 0;
                        data.stiffnessInfo{end+1} = 0;
                    end
                end
                                
                [~,~,ext] = fileparts(line{1}{lineIdx});
                if strcmp(line{1}{lineIdx},'load')
                    data.substrateParameterFiles{end+1} = 'load';
                    lineIdx = lineIdx + 1;
                elseif ~strcmp(ext,'.txt')
                    disp('Error. Wrong file format, the substrate parameters should be a .txt file.')
                    data = 0;
                    return
                else
                    fIDTemp = fopen(line{1}{lineIdx});
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.substrateParameterFiles{end+1} = line{1}{lineIdx};
                        lineIdx = lineIdx + 1;
                    else
                        inputNumber = numel(data.substrateParameterFiles)+1;
                        words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                        disp(['Error. The ' words{inputNumber} ' substrate parameter file cannot be found or opened'])
                        data = 0;
                        return
                    end
                end
                
                [~,~,ext] = fileparts(line{1}{lineIdx});
                
                if strcmp(line{1}{lineIdx},'load')
                    data.fFAInfo{end+1} = 'load';
                elseif ~strcmp(ext,'.csv')
                    disp('Error. Wrong file format, focal adhesion parameter file should be a .csv file.')
                    data = 0;
                    return
                else
                    
                    fIDTemp = fopen(line{1}{lineIdx});
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.fFAInfo{end+1} = line{1}{lineIdx};
                    else
                        inputNumber = numel(data.fFAInfo)+1;
                        words = {'first','second','third','fourth','fifth','sixth','seventh','eighth', 'ninth','tenth'};
                        disp(['Error. The ' words{inputNumber} ' fFAInfo file cannot be found or opened'])
                        data = 0;
                        return
                    end
                end
            end
        end
        
    else
       fgetl(fID); 
    end
end

if ~strcmp(data.simulationType,'growth') && ~any(length(data.substrateParameterFiles) == [1 data.nSimulations])
    disp(['Error. The number of of given substrate parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end

end