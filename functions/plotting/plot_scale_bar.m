function plot_scale_bar(d)

if isfield(d.pl, 'scaleBar') && d.pl.scaleBar.show
    figureSizeinScaled = d.pl.axesHandle.XLim(2) - d.pl.axesHandle.XLim(1);
    figureSizeInMum = figureSizeinScaled*d.spar.scalingLength*1e6;
    
    figureSizeRanges = d.pl.scaleBar.lengths(:,2:3);
    possibleBarLengths = d.pl.scaleBar.lengths(:,1);
    for i = 1:size(figureSizeRanges,1)
        if figureSizeInMum > figureSizeRanges(i,1) && figureSizeInMum <= figureSizeRanges(i,2)
            barLengthLabel = possibleBarLengths(i);
            currentBarLength = possibleBarLengths(i)*1e-6/d.spar.scalingLength;
            break
        end
    end
    
    axisSizeInPixels = d.pl.figureHandle.Position(4)*d.pl.axesHandle.Position(4);
    
    scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
    
    barBoxPositionRight = d.pl.axesHandle.XLim(2) - 10*scaledLengthPerPixels;
    barBoxPositionLeft = barBoxPositionRight - currentBarLength - 20*scaledLengthPerPixels;
    barBoxPositionBottom = 10*scaledLengthPerPixels + d.pl.axesHandle.YLim(1);
    
    barPositionBottomY = 20*scaledLengthPerPixels + d.pl.axesHandle.YLim(1);
    barPositionTopY = barPositionBottomY + figureSizeinScaled.*0.02;
    fontSize = axisSizeInPixels/40;
    if fontSize > 18
        fontSize = 18;
    elseif fontSize < 10
        fontSize = 10;
    end
    barBoxPositionTop = barBoxPositionBottom + 10*scaledLengthPerPixels + 3.7*scaledLengthPerPixels*fontSize;
    
    barTextPositinY = fontSize/2*scaledLengthPerPixels + barPositionTopY;
    
    barPositionRightX = d.pl.axesHandle.XLim(2) - 20*scaledLengthPerPixels;
    barPositionLeftX = barPositionRightX - currentBarLength;
    
    
    
    
    sbarBox = fill(d.pl.axesHandle,[barBoxPositionLeft barBoxPositionRight barBoxPositionRight barBoxPositionLeft],[barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop],[1 1 1]);
    sbarBox.Tag = 'scalebarbox';
    sbar = fill(d.pl.axesHandle,[barPositionLeftX barPositionRightX barPositionRightX barPositionLeftX],[barPositionBottomY barPositionBottomY barPositionTopY barPositionTopY],[0 0 0]);
    sbar.Tag = 'scalebar';
    
    txt = text(d.pl.axesHandle,(barPositionRightX + barPositionLeftX)/2, barTextPositinY, [num2str(barLengthLabel) ' ' char(181) 'm'],'HorizontalAlignment','center','VerticalAlignment', 'bottom','clipping','on','FontSize',fontSize);
    txt.Tag = 'scalebar';
    if currentBarLength/scaledLengthPerPixels < 40
        txt.Visible = 'Off';
        barBoxPositionTop = barBoxPositionBottom + 24*scaledLengthPerPixels;
        sbarBox.YData = [barBoxPositionBottom barBoxPositionBottom barBoxPositionTop barBoxPositionTop];
    end
end