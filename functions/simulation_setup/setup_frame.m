function d = setup_frame(d)
% SETUP_FRAME Setup the frame for the frame simulation
%   The function defines the frame for the frame simulation as a square
%   that surrounds all the cells. The simulation type is currently not
%   active

% if frame simulation
if d.simset.simulationType == 4
    
    % find the square size that fits the epithelium
    maxSize = get_maximum_epithelium_size(d);
    
    % increse the size by cell radius to add some initial buffer between
    % the cells and the frame
    frameSize = maxSize + d.spar.rCell;
    
    % defined the square frame corner coordinates
    d.simset.frame.cornersX = [-frameSize frameSize frameSize -frameSize]';
    d.simset.frame.cornersY = [-frameSize -frameSize frameSize frameSize]';
    
    % define the other cell properties
    d.cells(end+1) = create_frame_cell(d);
end

end