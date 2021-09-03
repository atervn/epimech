function plot_vertex_numbers(d,k)

if d.pl.vertexNumbers
    numberVector = 1:d.cells(k).nVertices;
    numberVector = strtrim(cellstr(num2str(numberVector(:))));
    txt = text(d.pl.axesHandle,d.cells(k).verticesX, d.cells(k).verticesY, numberVector,'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    
    
    axesHandle = gca;
    figureSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
    axisSizeInPixels = d.pl.figureHandle.Position(4)*axesHandle.Position(4);
    scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
    cellDiamaterInPixels = d.spar.rCell/scaledLengthPerPixels;
    for i = 1:length(txt)
        if cellDiamaterInPixels < 200
            txt(i).Visible = 'Off';
        else
            txt(i).Visible = 'On';
            fontSize = cellDiamaterInPixels/50;
            if fontSize > 20
                fontSize = 20;
            elseif fontSize < 7
                fontSize = 7;
            end
            txt(i).FontSize = fontSize;
        end
        txt(i).BackgroundColor = [1 1 1];
        txt(i).Tag = 'vertexnumber';
        txt(i).EdgeColor = [0 0 0];
    end
end