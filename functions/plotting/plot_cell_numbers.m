function plot_cell_numbers(d,k)
if d.pl.cellNumbers && d.pl.cellStyle ~= 0
    cellMiddlePointX = (max(d.cells(k).verticesX) + min(d.cells(k).verticesX))/2;
    cellMiddlePointY = (max(d.cells(k).verticesY) + min(d.cells(k).verticesY))/2;
    if d.pl.cellStyle == 4
        txt = text(d.pl.axesHandle,cellMiddlePointX, cellMiddlePointY, num2str(k),'Color', [1 1 1], 'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    else
        txt = text(d.pl.axesHandle,cellMiddlePointX, cellMiddlePointY, num2str(k),'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    end
    
    axesHandle = gca;
    figureSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
    axisSizeInPixels = d.pl.figureHandle.Position(4)*axesHandle.Position(4);
    scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
    cellDiamaterInPixels = d.spar.rCell/scaledLengthPerPixels;
    
    if cellDiamaterInPixels < 15
        txt.Visible = 'Off';
    else
        txt.Visible = 'On';
        fontSize = cellDiamaterInPixels/4;
        if fontSize > 20
            fontSize = 20;
        elseif fontSize < 10
            fontSize = 10;
        end
        txt.FontSize = fontSize;
    end
    txt.Tag = 'cellnumber';
end