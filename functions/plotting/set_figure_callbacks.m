function set_figure_callbacks(d,app)

set(d.pl.figureHandle,'SizeChangedFcn',{@resizeCallBack,d.spar,d.pl});

zoomUtil = zoom;
set(zoomUtil,'ActionPostCallback',{@zoomCallBack,d.spar,d.pl,app});
% set(zoomUtil,'Enable','On');

panUtil = pan;
set(panUtil,'ActionPostCallback',{@zoomCallBack,d.spar,d.pl,app});
% set(panUtil,'Enable','On');

    function resizeCallBack(~, evd,spar,pl)
        
        
        axesHandle = evd.Source.CurrentAxes;
        
        figureSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
        figureSizeInMum = figureSizeinScaled*spar.scalingLength*1e6;
        
        axisHeight = evd.Source.Position(4)*axesHandle.Position(4);
        axisWidth = evd.Source.Position(3)*axesHandle.Position(3);
        if axisHeight > axisWidth
            axisSizeInPixels = axisWidth;
        else
            axisSizeInPixels = axisHeight;
        end
        scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
        
        sBarFontSize = axisSizeInPixels/40;
        if sBarFontSize > 18
            sBarFontSize = 18;
        elseif sBarFontSize < 10
            sBarFontSize = 10;
        else
        end
        
        % scale bar
        
        if isfield(pl,'scaleBar') && pl.scaleBar.show
            figureSizeRanges = pl.scaleBar.lengths(:,2:3);
            possibleBarLengths = pl.scaleBar.lengths(:,1);
            for j = 1:size(figureSizeRanges,1)
                if figureSizeInMum > figureSizeRanges(j,1) && figureSizeInMum <= figureSizeRanges(j,2)
                    barLengthLabel = possibleBarLengths(j);
                    currentBarLength = possibleBarLengths(j)*1e-6/spar.scalingLength;
                    break
                end
            end
            
            barBoxPositionRight = axesHandle.XLim(2) - 10*scaledLengthPerPixels;
            barBoxPositionLeft = barBoxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
            barBoxPositionBottom = 10*scaledLengthPerPixels + axesHandle.YLim(1);
            
            barPositionBottomY = 20*scaledLengthPerPixels + axesHandle.YLim(1);
            barPositionTopY = barPositionBottomY + figureSizeinScaled.*0.02;
            
            barPositionRightX = axesHandle.XLim(2) - 20*scaledLengthPerPixels;
            barPositionLeftX = barPositionRightX - currentBarLength;
            
            barLengthInPixels = currentBarLength/scaledLengthPerPixels;
            
            barBoxPositionTop = barBoxPositionBottom + 10*scaledLengthPerPixels + 3.7*scaledLengthPerPixels*sBarFontSize;
            
        end
        
        cellDiamaterInPixels = spar.rCell/scaledLengthPerPixels;
        
        % title font size
        
        titleFontSize = axisSizeInPixels/40;
        if titleFontSize > 15
            titleFontSize = 15;
        elseif titleFontSize < 10
            titleFontSize = 10;
        end
        if ~isempty(axesHandle.Legend)
            axesHandle.Legend.FontSize = sBarFontSize;
        end
        if ~isempty(axesHandle.Title)
            axesHandle.Title.FontSize = titleFontSize;
        end
        
        % axis margins
        
        figureSize = evd.Source.Position(3:4);
        bottomGap = 10/figureSize(2);
        if pl.nTitleLines == 2
            topGap = 20/figureSize(2) + 2*axesHandle.Title.FontSize/figureSize(2);
        else
            topGap = 20/figureSize(2) + axesHandle.Title.FontSize/figureSize(2);
        end
        horzGap = 10/figureSize(1);
        axisHeight = 1 - bottomGap - topGap;
        axisWidth = 1 - 2*horzGap;
        axesHandle.Position = [horzGap bottomGap axisWidth axisHeight];
        
        
        
       % go through the plots
                
        axisChildren = allchild(axesHandle);
        
        for i = 1:length(axisChildren)
            if strcmp(axisChildren(i).Tag,'scalebar') && isfield(pl,'scaleBar') && pl.scaleBar.show
                if strcmp(axisChildren(i).Type,'patch')
                    axisChildren(i).XData = [barPositionLeftX barPositionRightX barPositionRightX barPositionLeftX];
                    axisChildren(i).YData = [barPositionBottomY barPositionBottomY barPositionTopY barPositionTopY];
                elseif strcmp(axisChildren(i).Type,'text')
                    if barLengthInPixels <= 40
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        barTextPositionY = sBarFontSize/2*scaledLengthPerPixels + barPositionTopY;
                        axisChildren(i).Position(1) = (barPositionLeftX + barPositionRightX)/2;
                        axisChildren(i).Position(2) = barTextPositionY;
                        axisChildren(i).FontSize = sBarFontSize;
                        axisChildren(i).String = [num2str(barLengthLabel) ' ' char(181) 'm'];
                    end
                end
            elseif strcmp(axisChildren(i).Tag,'scalebarbox')
                axisChildren(i).XData = [barBoxPositionLeft barBoxPositionRight barBoxPositionRight barBoxPositionLeft];
                if barLengthInPixels < 40
                    barBoxPositionTop = barBoxPositionBottom + 24*scaledLengthPerPixels;
                    axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
                else
                    axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
                end
                
            elseif strcmp(axisChildren(i).Type,'text')
                if strcmp(axisChildren(i).Tag,'cellnumber')
                    if cellDiamaterInPixels < 15
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        cellFontSize = cellDiamaterInPixels/4;
                        if cellFontSize > 18
                            cellFontSize = 18;
                        elseif cellFontSize < 10
                            cellFontSize = 10;
                        end
                        axisChildren(i).FontSize = cellFontSize;
                    end
                elseif strcmp(axisChildren(i).Tag,'vertexnumber')
                    if cellDiamaterInPixels < 300
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        fontSize = cellDiamaterInPixels/50;
                        if fontSize > 15
                            fontSize = 15;
                        elseif fontSize < 7
                            fontSize = 7;
                        end
                        axisChildren(i).FontSize = fontSize;
                    end
                end
            end
        end
    end


    function zoomCallBack(~, evd,spar,pl,app)
        
        
        
        axesHandle = evd.Axes;
        figureHandle = evd.Axes.Parent;
        sizeX = axesHandle.XLim(2) - axesHandle.XLim(1);
        sizeY = axesHandle.YLim(2) - axesHandle.YLim(1);
        
        if sizeX > sizeY
            middleY = (axesHandle.YLim(2) + axesHandle.YLim(1))/2;
            axesHandle.YLim(1) = middleY - sizeX/2;
            axesHandle.YLim(2) = middleY + sizeX/2;
        else
            middleX = (axesHandle.XLim(2) + axesHandle.XLim(1))/2;
            axesHandle.XLim(1) = middleX - sizeY/2;
            axesHandle.XLim(2) = middleX + sizeY/2;
        end
        
        figureSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
        figureSizeInMum = figureSizeinScaled*spar.scalingLength*1e6;
        
        axisSizeInPixels = figureHandle.Position(4)*axesHandle.Position(4);
        scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
        
        if isfield(pl,'scaleBar') && pl.scaleBar.show
            
            figureSizeRanges = pl.scaleBar.lengths(:,2:3);
            possibleBarLengths = pl.scaleBar.lengths(:,1);
            for j = 1:size(figureSizeRanges,1)
                if figureSizeInMum > figureSizeRanges(j,1) && figureSizeInMum <= figureSizeRanges(j,2)
                    barLengthLabel = possibleBarLengths(j);
                    currentBarLength = possibleBarLengths(j)*1e-6/spar.scalingLength;
                    break
                end
            end
            
            barBoxPositionRight = axesHandle.XLim(2) - 10*scaledLengthPerPixels;
            barBoxPositionLeft = barBoxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
            barBoxPositionBottom = 10*scaledLengthPerPixels + axesHandle.YLim(1);
            
            barPositionBottomY = 20*scaledLengthPerPixels + axesHandle.YLim(1);
            barPositionTopY = barPositionBottomY + figureSizeinScaled.*0.02;
            
            barPositionRightX = axesHandle.XLim(2) - 20*scaledLengthPerPixels;
            barPositionLeftX = barPositionRightX - currentBarLength;
            
            barLengthInPixels = currentBarLength/scaledLengthPerPixels;
            sBarFontSize = axisSizeInPixels/40;
            if sBarFontSize > 18
                sBarFontSize = 18;
            elseif sBarFontSize < 10
                sBarFontSize = 10;
            end
            
            barBoxPositionTop = barBoxPositionBottom + 10*scaledLengthPerPixels + 3.7*scaledLengthPerPixels*sBarFontSize;
        end
        
        cellDiamaterInPixels = spar.rCell/scaledLengthPerPixels;
        
        middleX = round(sum(axesHandle.XLim)/2*spar.scalingLength*1e6);
        middleY = round(sum(axesHandle.YLim)/2*spar.scalingLength*1e6);
        windowSize = round((axesHandle.XLim(2)-axesHandle.XLim(1))*spar.scalingLength*1e6);
        
        switch app.appTask
            case 'simulate'
                app.MiddlepointxEditField.Value = middleX;
                app.MiddlepointyEditField.Value = middleY;
                app.WindowsizeEditField.Value = windowSize;
                app.plottingOptions.windowSize = windowSize*1e-6;
                sliderValue = log((app.plottingOptions.windowSize/1e-6-30)/10)/log(77);
                if ~isreal(sliderValue)
                    app.WindowsizeSlider.Value = 0;
                elseif sliderValue > 1
                    app.WindowsizeSlider.Value = 1;
                else
                    app.WindowsizeSlider.Value = sliderValue;
                end
            case 'plotAndAnalyze'
                app.MiddlepointxEditField_2.Value = middleX;
                app.MiddlepointyEditField_2.Value = middleY;
                app.WindowsizeEditField_2.Value = windowSize;
                app.importPlottingOptions.windowSize = windowSize*1e-6;
                sliderValue = log((app.importPlottingOptions.windowSize/1e-6-30)/10)/log(77);
                if ~isreal(sliderValue)
                    app.WindowsizeSlider_2.Value = 0;
                elseif sliderValue > 1
                    app.WindowsizeSlider_2.Value = 1;
                else
                    app.WindowsizeSlider_2.Value = sliderValue;
                end
        end
        
        axesHandle.XLim = [middleX-windowSize/2 middleX+windowSize/2]/spar.scalingLength/1e6;
        axesHandle.YLim = [middleY-windowSize/2 middleY+windowSize/2]/spar.scalingLength/1e6;
        
        
        axisChildren = allchild(axesHandle);
        
        for i = 1:length(axisChildren)
            if strcmp(axisChildren(i).Tag,'scalebar') && isfield(pl,'scaleBar') && pl.scaleBar.show
                if strcmp(axisChildren(i).Type,'patch')
                    axisChildren(i).XData = [barPositionLeftX barPositionRightX barPositionRightX barPositionLeftX];
                    axisChildren(i).YData = [barPositionBottomY barPositionBottomY barPositionTopY barPositionTopY];
                elseif strcmp(axisChildren(i).Type,'text')
                    if barLengthInPixels <= 40
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        barTextPositinY = sBarFontSize/2*scaledLengthPerPixels + barPositionTopY;
                        axisChildren(i).Position(1) = (barPositionLeftX + barPositionRightX)/2;
                        axisChildren(i).Position(2) = barTextPositinY;
                        axisChildren(i).FontSize = sBarFontSize;
                        axisChildren(i).String = [num2str(barLengthLabel) ' ' char(181) 'm'];
                    end
                end
            elseif strcmp(axisChildren(i).Tag,'scalebarbox')
                axisChildren(i).XData = [barBoxPositionLeft barBoxPositionRight barBoxPositionRight barBoxPositionLeft];
                if barLengthInPixels < 40
                    barBoxPositionTop = barBoxPositionBottom + 24*scaledLengthPerPixels;
                    axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
                else
                    axisChildren(i).YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
                end
            
            elseif strcmp(axisChildren(i).Type,'text')
                if strcmp(axisChildren(i).Tag,'cellnumber')
                    if cellDiamaterInPixels < 15
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        cellFontSize = cellDiamaterInPixels/4;
                        if cellFontSize > 18
                            cellFontSize = 18;
                        elseif cellFontSize < 10
                            cellFontSize = 10;
                        end
                        axisChildren(i).FontSize = cellFontSize;
                    end
                elseif strcmp(axisChildren(i).Tag,'vertexnumber')
                    if cellDiamaterInPixels < 300
                        axisChildren(i).Visible = 'Off';
                    else
                        axisChildren(i).Visible = 'On';
                        fontSize = cellDiamaterInPixels/50;
                        if fontSize > 15
                            fontSize = 15;
                        elseif fontSize < 7
                            fontSize = 7;
                        end
                        axisChildren(i).FontSize = fontSize;
                    end
                end
            end
        end
    end
end
