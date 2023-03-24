function set_figure_callbacks(app,d)
% SET_FIGURE_CALLBACKS Set callbacks for the resizing, zooming, and panning
%   The function defines the callback functions for the resizing the
%   figure, and zooming and panning in the axis.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% set the callback for changing figure size
set(d.pl.figureHandle,'SizeChangedFcn',{@resize_callback,d.spar,d.pl});

% set the callback for zooming
zoomUtil = zoom;
set(zoomUtil,'ActionPostCallback',{@zoom_pan_callback,d.spar,d.pl,app});

% set the callback for panning
panUtil = pan;
set(panUtil,'ActionPostCallback',{@zoom_pan_callback,d.spar,d.pl,app});

% NOT ENABLED ATM
% % set the callback for restore view (have to find the object handle first)
% axToolstrip = axtoolbar(d.pl.axesHandle, 'default');
% isRestoreButton = strcmpi({axToolstrip.Children.Icon}, 'restoreview');
% restoreButtonHandle = axToolstrip.Children(isRestoreButton);
% set(restoreButtonHandle,'ButtonPushedFcn',{@restoreZoomCallBack,d.spar,d.pl,app});

end

function resize_callback(~, eventData,spar,pl)
% RESIZE_CALLBACK Modify the figure upon resizing
%   The function resizes the axis margins, scale bar, and title, cell
%   number, and vertex number fonts.
%   INPUT:
%       eventData: modified figure object
%       spar: scaled parameters structure
%       pl: plotting options data structure
%   by Aapo Tervonen, 2021

% get the axes handle
axesHandle = eventData.Source.CurrentAxes;

% calculate the axis size in scaled length units and in um
axisSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
axisSizeUm = axisSizeinScaled*spar.scalingLength*1e6;

% get the height and width of the axis in pixels
axisHeight = eventData.Source.Position(4)*axesHandle.Position(4);
axisWidth = eventData.Source.Position(3)*axesHandle.Position(3);

% chesk which one is smaller, and take that as the axis size in pixels
if axisHeight > axisWidth
    axisSizeInPixels = axisWidth;
else
    axisSizeInPixels = axisHeight;
end

% find how many pixels is a unit scaled length
scaledLengthPerPixels = axisSizeinScaled/axisSizeInPixels;

% set the font size for the length text based on the axis size in
% pixels (and make sure that it is between 10 and 15)
fontSize = axisSizeInPixels/40;
if fontSize > 15
    fontSize = 15;
elseif fontSize < 10
    fontSize = 10;
end

% check if scale bar is shown
if isfield(pl,'scaleBar') && pl.scaleBar.show
    
    % get the scale bar length limits and lengths
    figureSizeRanges = pl.scaleBar.lengths(:,2:3);
    possibleBarLengths = pl.scaleBar.lengths(:,1);
    
    % get the correct based on the image width
    selectedBarLength = logical((axisSizeUm > figureSizeRanges(:,1)).*(axisSizeUm <= figureSizeRanges(:,2)));

    % get the bar length label and length in scaled length units
    barLengthLabel = possibleBarLengths(selectedBarLength);
    currentBarLength = possibleBarLengths(selectedBarLength)*1e-6/spar.scalingLength;
    
    % calculate the limits for the scale bar itself
    barPositionBottom = 20*scaledLengthPerPixels + axesHandle.YLim(1);
    barPositionTop = barPositionBottom + axisSizeinScaled.*0.02;
    barPositionRight = axesHandle.XLim(2) - 20*scaledLengthPerPixels;
    barPositionLeft = barPositionRight - currentBarLength;
    
    % define the left, right, bottom, and top limits of the box surrounding the
    % scale bar
    barBoxPositionRight = axesHandle.XLim(2) - 10*scaledLengthPerPixels;
    barBoxPositionLeft = barBoxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
    barBoxPositionBottom = 10*scaledLengthPerPixels + axesHandle.YLim(1);
    barBoxPositionTop = barPositionTop + 10*scaledLengthPerPixels + 1.8*scaledLengthPerPixels*fontSize;
    
    %calculate the bar length in pixels
    barLengthInPixels = currentBarLength/scaledLengthPerPixels;
end

% set legend font size
if ~isempty(axesHandle.Legend)
    axesHandle.Legend.FontSize = fontSize;
end

% set title font size
if ~isempty(axesHandle.Title)
    axesHandle.Title.FontSize = fontSize;
end

% get the size of the figure in pixels
figureSize = eventData.Source.Position(3:4);

% get the relative sizes of the bottom, top and horizontal gaps around the
% axis with the size of 10 pixels
bottomGap = 10/figureSize(2);
horzGap = 10/figureSize(1);

% find the size of the top gap based on the number of title lines
if pl.nTitleLines == 2
    topGap = 20/figureSize(2) + 2*axesHandle.Title.FontSize/figureSize(2);
else
    topGap = 20/figureSize(2) + axesHandle.Title.FontSize/figureSize(2);
end

% calculate the relative axis height and width
axisHeight = 1 - bottomGap - topGap;
axisWidth = 1 - 2*horzGap;

% set the axis position using these values
axesHandle.Position = [horzGap bottomGap axisWidth axisHeight];

% find axis size in pixels
axisSizeInPixels = eventData.Source.Position(4)*axesHandle.Position(4);

% find how many pixels is a unit scaled length
scaledLengthPerPixels = axisSizeinScaled/axisSizeInPixels;

% find the default cell radius in pixels
cellRadiusInPixels = spar.rCell/scaledLengthPerPixels;

% find the axis handle children
axisChildren = allchild(axesHandle);

% go through the children
for i = 1:length(axisChildren)
    
    % if the child has the tag scalebar and scale bar is shown
    if strcmp(axisChildren(i).Tag,'scalebar') && isfield(pl,'scaleBar') && pl.scaleBar.show
        
        % if the child type is patch (a plot object done with the fill
        % command)
        if strcmp(axisChildren(i).Type,'patch')
            
            % update the bar size
            axisChildren(i).XData = [barPositionLeft barPositionRight barPositionRight barPositionLeft];
            axisChildren(i).YData = [barPositionBottom barPositionBottom barPositionTop barPositionTop];
            
        % if the child is text
        elseif strcmp(axisChildren(i).Type,'text')
            
            % bar length in pixel too small, hide the scale bar text
            if barLengthInPixels <= 40
                axisChildren(i).Visible = 'Off';
                
            % otherwise, show the scale bar
            else
                axisChildren(i).Visible = 'On';
                
                % get the scale bar text position in horizontal and
                % vertical directions
                axisChildren(i).Position(1) = (barPositionLeft + barPositionRight)/2;
                axisChildren(i).Position(2) = fontSize/2*scaledLengthPerPixels + barPositionTop;
                
                % set the scale bar text font size
                axisChildren(i).FontSize = fontSize;
                
                % update the scale bar text string
                axisChildren(i).String = [num2str(barLengthLabel) ' ' char(181) 'm'];
            end
        end
        
    % if the child has the tag scalebarbox
    elseif strcmp(axisChildren(i).Tag,'scalebarbox')
        
        % set the x-coordinates for the box
        axisChildren(i).XData = [barBoxPositionLeft barBoxPositionRight barBoxPositionRight barBoxPositionLeft];
        
        % if the scale bar is less then 40 pixels in length
        if barLengthInPixels < 40
            
            % calculate new box top coordinate since the scale bar text is
            % hidden and set the y-coordinate data
            barBoxPositionTop = barBoxPositionBottom + 24*scaledLengthPerPixels;
            axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
       
        % otherwise
        else
            
            % set the y-coordinate data
            axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
        end
      
    % if the child is a text
    elseif strcmp(axisChildren(i).Type,'text')
        
        % if cell number
        if strcmp(axisChildren(i).Tag,'cellnumber')
            
            % check if the cell radius in pixels is less than 15
            if cellRadiusInPixels < 15
                
                % hide the cell numbers
                axisChildren(i).Visible = 'Off';
                
            % otherwise
            else
                
                % show the cell numbers
                axisChildren(i).Visible = 'On';
                
                % set the index font size as one fourth of the cell
                % diameter in pixels
                cellFontSize = cellRadiusInPixels/4;
                
                % if the fontSize is not between 10 and 20, set it to the
                % closest limit
                if cellFontSize > 20
                    cellFontSize = 20;
                elseif cellFontSize < 10
                    cellFontSize = 10;
                end
                
                % set the font size for the text
                axisChildren(i).FontSize = cellFontSize;
            end
            
        % if vertex number
        elseif strcmp(axisChildren(i).Tag,'vertexnumber')
            
            % if the radius is pixels is less than 200 pixels
            if cellRadiusInPixels < 200
                
                % hide the index
                axisChildren(i).Visible = 'Off';
                
            % otherwise
            else
                
                % show the vertex number
                axisChildren(i).Visible = 'On';
                
                % set the index font size as one fiftieth of the cell
                % diameter in pixels
                vertexFontSize = cellRadiusInPixels/50;
                
                % if the fontSize is not between 7 and 20, set it to the
                % closest limit
                if vertexFontSize > 20
                    vertexFontSize = 20;
                elseif vertexFontSize < 7
                    vertexFontSize = 7;
                end
                
                % set the font size for the text
                axisChildren(i).FontSize = vertexFontSize;
            end
        end
    end
end

end

function zoom_pan_callback(~, eventData,spar,pl,app)
% ZOOM_PAN_CALLBACK Modify the figure upon zooming or panning
%   The function modifies the scale bar, and title, cell
%   number, and vertex number fonts when zooming or panning.
%   INPUT:
%       eventData: modified figure object
%       spar: scaled parameters structure
%       pl: plotting options data structure
%       app: main application data structure
%   by Aapo Tervonen, 2021

% get the axes handle
axesHandle = eventData.Axes;

% get the axis size in x and y-directions
sizeX = axesHandle.XLim(2) - axesHandle.XLim(1);
sizeY = axesHandle.YLim(2) - axesHandle.YLim(1);

% if the axis width is larger than the height
if sizeX > sizeY
    
    % find the middle point in vertical direction
    middleY = (axesHandle.YLim(2) + axesHandle.YLim(1))/2;
    
    % set the new vertical limits so that the height is the same as the
    % width
    axesHandle.YLim(1) = middleY - sizeX/2;
    axesHandle.YLim(2) = middleY + sizeX/2;
    
% otherwise
else
    
    % find the middle point in horizontal direction
    middleX = (axesHandle.XLim(2) + axesHandle.XLim(1))/2;
    
    % set the new horinzontal limits so that the width is the same as the
    % height
    axesHandle.XLim(1) = middleX - sizeY/2;
    axesHandle.XLim(2) = middleX + sizeY/2;
end

% calculate the axis size in scaled length units and in um
axisSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
axisSizeUm = axisSizeinScaled*spar.scalingLength*1e6;

% get the axis size in pixels and find how many pixels is a unit scaled
% length
axisSizeInPixels = pl.figureHandle.Position(4)*axesHandle.Position(4);
scaledLengthPerPixels = axisSizeinScaled/axisSizeInPixels;

% check if scale bar is shown
if isfield(pl,'scaleBar') && pl.scaleBar.show
    
    % get the scale bar length limits and lengths
    figureSizeRanges = pl.scaleBar.lengths(:,2:3);
    possibleBarLengths = pl.scaleBar.lengths(:,1);
    
    % get the correct based on the image width
    selectedBarLength = logical((axisSizeUm > figureSizeRanges(:,1)).*(axisSizeUm <= figureSizeRanges(:,2)));

    % get the bar length label and length in scaled length units
    barLengthLabel = possibleBarLengths(selectedBarLength);
    currentBarLength = possibleBarLengths(selectedBarLength)*1e-6/spar.scalingLength;
    
    % set the font size for the length text based on the axis size in
    % pixels (and make sure that it is between 10 and 15)
    fontSize = axisSizeInPixels/40;
    if fontSize > 15
        fontSize = 15;
    elseif fontSize < 10
        fontSize = 10;
    end
    
    % calculate the limits for the scale bar itself
    barPositionBottom = 20*scaledLengthPerPixels + axesHandle.YLim(1);
    barPositionTop = barPositionBottom + axisSizeinScaled.*0.02;
    barPositionRight = axesHandle.XLim(2) - 20*scaledLengthPerPixels;
    barPositionLeft = barPositionRight - currentBarLength;
        
    % define the left, right, bottom, and top limits of the box surrounding the
    % scale bar
    barBoxPositionRight = axesHandle.XLim(2) - 10*scaledLengthPerPixels;
    barBoxPositionLeft = barBoxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
    barBoxPositionBottom = 10*scaledLengthPerPixels + axesHandle.YLim(1);
    barBoxPositionTop = barPositionTop + 10*scaledLengthPerPixels + 1.8*scaledLengthPerPixels*fontSize;


    %calculate the bar length in pixels
    barLengthInPixels = currentBarLength/scaledLengthPerPixels;
end

% find the middle point and side length of the plot in um
middleX = round(sum(axesHandle.XLim)/2*spar.scalingLength*1e6);
middleY = round(sum(axesHandle.YLim)/2*spar.scalingLength*1e6);
windowSize = round((axesHandle.XLim(2)-axesHandle.XLim(1))*spar.scalingLength*1e6);

switch app.appTask
    
    % simulation
    case 'simulate'
        
        % set the middpe point and window size values to the GUI
        app.MiddlepointxEditField.Value = middleX;
        app.MiddlepointyEditField.Value = middleY;
        app.WindowsizeEditField.Value = windowSize;
        
        % set the windows size into plotting option as the new value
        app.plottingOptions.windowSize = windowSize*1e-6;
        
        % calculate the new size slider value
        sliderValue = log((app.plottingOptions.windowSize/1e-6-30)/10)/log(77);
        
        % if the slider is below the lower limit, set to 0
        if ~isreal(sliderValue)
            app.WindowsizeSlider.Value = 0;
            
        % if higher than upper limit, set to 1
        elseif sliderValue > 1
            app.WindowsizeSlider.Value = 1;
            
        % otherwise, set the value
        else
            app.WindowsizeSlider.Value = sliderValue;
        end
        
    % post plot and analsis
    case 'plotAndAnalyze'
        
        % set the middpe point and window size values to the GUI
        app.MiddlepointxEditField_2.Value = middleX;
        app.MiddlepointyEditField_2.Value = middleY;
        app.WindowsizeEditField_2.Value = windowSize;
        
        % set the windows size into plotting option as the new value
        app.importPlottingOptions.windowSize = windowSize*1e-6;
        
        % calculate the new size slider value
        sliderValue = log((app.importPlottingOptions.windowSize/1e-6-30)/10)/log(77);
        
        % if the slider is below the lower limit, set to 0
        if ~isreal(sliderValue)
            app.WindowsizeSlider_2.Value = 0;
            
        % if higher than upper limit, set to 1
        elseif sliderValue > 1
            app.WindowsizeSlider_2.Value = 1;
            
        % otherwise, set the value
        else
            app.WindowsizeSlider_2.Value = sliderValue;
        end
end

% set the new limits to the axis
axesHandle.XLim = [middleX-windowSize/2 middleX+windowSize/2]/spar.scalingLength/1e6;
axesHandle.YLim = [middleY-windowSize/2 middleY+windowSize/2]/spar.scalingLength/1e6;

% find the default cell radius in pixels
cellRadiusInPixels = spar.rCell/scaledLengthPerPixels;

% find the axis handle children
axisChildren = allchild(axesHandle);

% go through the children
for i = 1:length(axisChildren)
    
    % if the child has the tag scalebar and scale bar is shown
    if strcmp(axisChildren(i).Tag,'scalebar') && isfield(pl,'scaleBar') && pl.scaleBar.show
        
        % if the child type is patch (a plot object done with the fill
        % command)
        if strcmp(axisChildren(i).Type,'patch')
            
            % update the bar size
            axisChildren(i).XData = [barPositionLeft barPositionRight barPositionRight barPositionLeft];
            axisChildren(i).YData = [barPositionBottom barPositionBottom barPositionTop barPositionTop];
        
        % if the child is text
        elseif strcmp(axisChildren(i).Type,'text')
            
            % bar length in pixel too small, hide the scale bar text
            if barLengthInPixels <= 40
                axisChildren(i).Visible = 'Off';
                
            % otherwise, show the scale bar
            else
                axisChildren(i).Visible = 'On';
                
                % get the scale bar text position in horizontal and
                % vertical directions
                axisChildren(i).Position(1) = (barPositionLeft + barPositionRight)/2;
                axisChildren(i).Position(2) = fontSize/2*scaledLengthPerPixels + barPositionTop;
                
                % set the scale bar text font size
                axisChildren(i).FontSize = fontSize;
                
                % update the scale bar text string
                axisChildren(i).String = [num2str(barLengthLabel) ' ' char(181) 'm'];
            end
        end
        
    % if the child has the tag scalebarbox
    elseif strcmp(axisChildren(i).Tag,'scalebarbox')
        
        % set the x-coordinates for the box
        axisChildren(i).XData = [barBoxPositionLeft barBoxPositionRight barBoxPositionRight barBoxPositionLeft];
        
        % if the scale bar is less then 40 pixels in length
        if barLengthInPixels < 40
            
            % calculate new box top coordinate since the scale bar text is
            % hidden and set the y-coordinate data
            barBoxPositionTop = barBoxPositionBottom + 24*scaledLengthPerPixels;
            axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
        
        % otherwise
        else
            
            % set the y-coordinate data
            axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
        end
        
    % if the child is a text
    elseif strcmp(axisChildren(i).Type,'text')
        
        % if cell number
        if strcmp(axisChildren(i).Tag,'cellnumber')
            
            % check if the cell radius in pixels is less than 15
            if cellRadiusInPixels < 15
                
                % hide the cell numbers
                axisChildren(i).Visible = 'Off';
                
            % otherwise
            else
                
                % show the cell numbers
                axisChildren(i).Visible = 'On';
                
                % set the index font size as one fourth of the cell
                % diameter in pixels
                cellFontSize = cellRadiusInPixels/4;
                
                % if the fontSize is not between 10 and 20, set it to the
                % closest limit
                if cellFontSize > 20
                    cellFontSize = 20;
                elseif cellFontSize < 10
                    cellFontSize = 10;
                end
                
                % set the font size for the text
                axisChildren(i).FontSize = cellFontSize;
            end
            
        % if vertex number    
        elseif strcmp(axisChildren(i).Tag,'vertexnumber')
            
            % if the radius is pixels is less than 200 pixels
            if cellRadiusInPixels < 200
                
                % hide the index
                axisChildren(i).Visible = 'Off';
                
            % otherwise
            else
                
                % show the vertex number
                axisChildren(i).Visible = 'On';
                
                % set the index font size as one fiftieth of the cell
                % diameter in pixels
                vertexFontSize = cellRadiusInPixels/50;
                
                % if the fontSize is not between 7 and 20, set it to the
                % closest limit
                if vertexFontSize > 20
                    vertexFontSize = 20;
                elseif vertexFontSize < 7
                    vertexFontSize = 7;
                end
                
                % set the font size for the text
                axisChildren(i).FontSize = vertexFontSize;
            end
        end
    end
end

end