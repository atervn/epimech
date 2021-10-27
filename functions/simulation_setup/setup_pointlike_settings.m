function d = setup_pointlike_settings(app,d)
% SETUP_POINTLIKE_SETTINGS Setup the settings for the pointlike
%   The function either defines the pointlike propreties for the new
%   simulation or imports the data if imported pointlike properties are
%   used.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if pointlike simulation
if d.simset.simulationType == 2
    
    % if new simulation or if the pointlike data from the imported
    % pointlike simulation is not used
    if ~app.UseimportedmovementdataCheckBox.Value
         
        % get the defined movement time points and scale them
        d.simset.pointlike.movementTime = app.pointlikeProperties.movementTime./app.systemParameters.scalingTime;
        
        % get the pointlike movements in relation to initial position and
        % scale them
        d.simset.pointlike.movementY = app.pointlikeProperties.movementY./app.systemParameters.scalingLength;
        
        % if the pointlike cell is selected to be the one closests to
        % to middle of the epithelium patch
        if app.SelectcentercellCheckBox.Value
            app.pointlikeProperties.cell = get_center_cell(d.cells);
        end
        
        % set the pointlike cell
        d.simset.pointlike.cell = app.pointlikeProperties.cell;
        
        % set the pointlike position to the center of the pointlike cell
        d.simset.pointlike.pointX = mean(d.cells(d.simset.pointlike.cell).verticesX);
        d.simset.pointlike.pointY = mean(d.cells(d.simset.pointlike.cell).verticesY);
        
        % set the original pointlike position
        d.simset.pointlike.originalX = d.simset.pointlike.pointX;
        d.simset.pointlike.originalY = d.simset.pointlike.pointY;
        
        % set the pointlike cell vertex coordinates to defined the virtual
        % cell that is moved
        d.simset.pointlike.vertexX = d.cells(d.simset.pointlike.cell).verticesX;
        d.simset.pointlike.vertexY = d.cells(d.simset.pointlike.cell).verticesY;
        
        % set the original virtual cell vertex positions
        d.simset.pointlike.vertexOriginalX = d.cells(d.simset.pointlike.cell).verticesX;
        d.simset.pointlike.vertexOriginalY = d.cells(d.simset.pointlike.cell).verticesY;
    
    % if using imported pointlike data
    else
        
        % read the pointlike movement data
        movementData = csvread([app.import.folderName '/pointlike/movement_data.csv']);
        
        % scale the movement data
        % LEGACY (old import were scaled, so have to scaled them to
        % dimensional values)
        if max(movementData(:,2)) > 0.01
            movementData(:,1) = movementData(:,1).*app.import.systemParameters.scalingTime./d.spar.scalingTime;
            movementData(:,2) = movementData(:,2).*app.import.systemParameters.scalingLength./d.spar.scalingLength;
        else
            movementData(:,1) = movementData(:,1)./d.spar.scalingTime;
            movementData(:,2) = movementData(:,2)./d.spar.scalingLength;
        end
        
        % set the pointlike time and movement values and add values to end
        % of both to make sure there are always values for the current
        % simulation time point (hence the large time value added)
        d.simset.pointlike.movementTime = [movementData(:,1); 1e20];
        d.simset.pointlike.movementY = [movementData(:,2); movementData(end,2)];
        
        % import the pointlike cell and original position data
        pointlikeData = import_settings([app.import.folderName '/pointlike/pointlike_data.csv']);
        
        % set the pointlike cell
        d.simset.pointlike.cell = pointlikeData.cell;
        
        % if there has been cell removed, reduce the cell index by the
        % number of removed cells withn smaller indices
        if numel(app.import.removedCells)
            d.simset.pointlike.cell = d.simset.pointlike.cell - sum(app.import.removedCells < d.simset.pointlike.cell);
        end
        
        % set the pointlike position to the center of the pointlike cell
        d.simset.pointlike.originalX = pointlikeData.originalX;
        d.simset.pointlike.originalY = pointlikeData.originalY;
        
        % read the original cell coordinates
        originalVertices = csvread([app.import.folderName '/pointlike/original_vertex_locations.csv']);
        d.simset.pointlike.vertexOriginalX = originalVertices(:,1);
        d.simset.pointlike.vertexOriginalY = originalVertices(:,2);
        
        % get the imported time point in seconds
        time = convert_import_time(app,app.import.currentTimePoint,'numberToTime');
        
        % get the previous time point in the movementTime compared to the
        % import time 
        previousTime = max(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime <= time));
        
        % get the next time point in the movementTime compared to the
        % import time 
        nextTime = min(d.simset.pointlike.movementTime(d.simset.pointlike.movementTime > time));
        
        % get the indices of the previous and next time points
        previousIdx = find(d.simset.pointlike.movementTime == previousTime);
        nextIdx = find(d.simset.pointlike.movementTime == nextTime);
        
        % if the time is equation to the previous time point
        if previousTime == time
            
            % get the pointlike displacement in the same index 
            displacementY = d.simset.pointlike.movementY(previousIdx);
            
        % otherwise
        else
            
            % interpolate between the previous and next time points to get
            % the pointlike displacement
            displacementY = d.simset.pointlike.movementY(previousIdx) + (d.simset.pointlike.movementY(nextIdx) - d.simset.pointlike.movementY(previousIdx))*(time - d.simset.pointlike.movementY(previousIdx))/(d.simset.pointlike.movementTime(nextIdx) - d.simset.pointlike.movementTime(previousIdx));
        end
        
        % substract the import time from the movement time points
        d.simset.pointlike.movementTime = d.simset.pointlike.movementTime - time;
        
        % find the indices of the negative times
        tempIdx = find(d.simset.pointlike.movementTime <= 0);
        
        % remove the negative times
        d.simset.pointlike.movementTime(tempIdx) = [];
        
        % add zero as the initial time to the beginning
        d.simset.pointlike.movementTime = [0 ; d.simset.pointlike.movementTime];
        
        % remove the pointlike displacements for the negative times
        d.simset.pointlike.movementY(tempIdx) = [];
        
        % add the diplacement in the imported time to the beginning
        d.simset.pointlike.movementY = [displacementY ; d.simset.pointlike.movementY];
        
        % calculate a multiplier that assumes that the final position of
        % the pipette is at the boundary of the manipulated cell (the cell
        % is only moved by (maximum pipette movement - (distance between
        % cell center and the boundary at the direction of the movement))/
        % maximum pipette movement 
        multiplier = (max(d.simset.pointlike.movementY) - abs(max(d.simset.pointlike.vertexOriginalY) - d.simset.pointlike.originalY))/max(d.simset.pointlike.movementY);
                
        % set the pointlike coordinates
        d.simset.pointlike.pointY = d.simset.pointlike.originalY + displacementY;
        d.simset.pointlike.pointX = d.simset.pointlike.originalX;
        
        % set the pointlike cell vertex coordinates
        d.simset.pointlike.vertexY = d.simset.pointlike.vertexOriginalY + displacementY.*multiplier;
        d.simset.pointlike.vertexX = d.simset.pointlike.vertexOriginalX;
    end
end

end