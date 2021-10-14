function d = setup_frame(d)

if d.simset.simulationType == 4
    
    
    
    % find the square size that fits the epithelium
    maxSize = get_maximum_epithelium_size(d);
    
    
    frameSize = maxSize + d.spar.rCell;
    
    d.simset.frame.cornersX = [-frameSize frameSize frameSize -frameSize]';
    d.simset.frame.cornersY = [-frameSize -frameSize frameSize frameSize]';
    d.cells(end+1) = create_frame_cell(d);
    
end

end