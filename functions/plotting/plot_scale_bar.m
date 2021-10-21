function plot_scale_bar(d)
% PLOT_SCALE_BAR Create the scale bar for the plot
%   The function defines and creates the scale bar for the plot. The scale
%   bar is surrounded by a white box and the length of the scale bar is
%   plotted above the bar. The text is hidden if the scale bar length in
%   pixels is too small.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if scale bar is to be plotted
if isfield(d.pl, 'scaleBar') && d.pl.scaleBar.show
    
    % get the image width in scale length units
    axisSizeScaled = d.pl.axesHandle.XLim(2) - d.pl.axesHandle.XLim(1);
    
    % get the image width in micrometers
    axisSizeUm = axisSizeScaled*d.spar.scalingLength*1e6;
    
    % get the ranges for the different scale bar lengths
    figureSizeRanges = d.pl.scaleBar.lengths(:,2:3);
    
    % get the corresponding scale bar lengths for the ranges
    possibleBarLengths = d.pl.scaleBar.lengths(:,1);
    
    % get the correct based on the image width
    selectedBarLength = logical((axisSizeUm > figureSizeRanges(:,1)).*(axisSizeUm <= figureSizeRanges(:,2)));

    % get the bar length label and length in scaled length units
    barLengthLabel = possibleBarLengths(selectedBarLength);
    currentBarLength = possibleBarLengths(selectedBarLength)*1e-6/d.spar.scalingLength;
    
    % get the axis width in pixels
    axisSizePixels = d.pl.figureHandle.Position(4)*d.pl.axesHandle.Position(4);
    
    % get how pixel size in scaled length units
    scaledLengthPerPixels = axisSizeScaled/axisSizePixels;
    
    % define the left, right, and bottom limits of the box surrounding the
    % scale bar
    boxPositionRight = d.pl.axesHandle.XLim(2) - 10*scaledLengthPerPixels;
    boxPositionLeft = boxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
    boxPositionBottom = 10*scaledLengthPerPixels + d.pl.axesHandle.YLim(1);
    
    % set the font size for the length text based on the axis size in
    % pixels (and make sure that it is between 10 and 15)
    fontSize = axisSizePixels/40;
    if fontSize > 15
        fontSize = 15;
    elseif fontSize < 10
        fontSize = 10;
    end
    
    % calculate the limits for the scale bar itself
    barPositionBottom = 20*scaledLengthPerPixels + d.pl.axesHandle.YLim(1);
    barPositionTop = barPositionBottom + axisSizeScaled.*0.02;
    barPositionRight = d.pl.axesHandle.XLim(2) - 20*scaledLengthPerPixels;
    barPositionLeft = barPositionRight - currentBarLength;
    
    
    % set the top limit of the box surrounding the scale bar based on the
    % font size
    boxPositionTop = barPositionTop + 10*scaledLengthPerPixels + 1.8*scaledLengthPerPixels*fontSize;
    
    
    % y-coordinate for the length text
    barTextPositionY = fontSize/2*scaledLengthPerPixels + barPositionTop;
    
    %  plot the box surrounding the scale bar and give it a tag for editing
    %  it when the image is resized or zoomed
    sbarBox = fill(d.pl.axesHandle,[boxPositionLeft boxPositionRight boxPositionRight boxPositionLeft],[boxPositionBottom boxPositionBottom boxPositionTop boxPositionTop],[1 1 1]);
    sbarBox.Tag = 'scalebarbox';
    
    %  plot the scale bar and give it a tag for editing it when the image
    % is resized or zoomed
    sbar = fill(d.pl.axesHandle,[barPositionLeft barPositionRight barPositionRight barPositionLeft],[barPositionBottom barPositionBottom barPositionTop barPositionTop],[0 0 0]);
    sbar.Tag = 'scalebar';
    
    % plot the scale bar length above the bar and give it a tag for editing
    % it when the image is resized or zoomed
    txt = text(d.pl.axesHandle,(barPositionRight + barPositionLeft)/2, barTextPositionY, [num2str(barLengthLabel) ' ' char(181) 'm'],'HorizontalAlignment','center','VerticalAlignment', 'bottom','clipping','on','FontSize',fontSize);
    txt.Tag = 'scalebar';
    
    % if the scale bar is less than 40 pixels in length, hide the scale bar
    % length (since it would be longer than the scale bar itself)
    if currentBarLength/scaledLengthPerPixels < 40
        txt.Visible = 'Off';
        
        % also, recude the size of the box surrounding the scale bar to
        % account for the missing length text
        boxPositionTop = boxPositionBottom + 24*scaledLengthPerPixels;
        sbarBox.YData = [boxPositionBottom boxPositionBottom boxPositionTop boxPositionTop];
    end
end

end