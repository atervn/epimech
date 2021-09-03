function plot_substrate(d)

switch d.pl.substrateStyle
    case 1
        plot(d.pl.axesHandle,d.sub.pointsX,d.sub.pointsY,'o','color',[0.8 0.8 0.8]);
%         plot(d.pl.axesHandle,d.sub.pointsX(d.sub.edgePoints),d.sub.pointsY(d.sub.edgePoints),'x','color',[0.8 0.8 0.8]);
    case 2
        pointsX = d.sub.pointsX(d.sub.interactionSelvesIdx)';
        pointsY = d.sub.pointsY(d.sub.interactionSelvesIdx)';
        pairsX = d.sub.pointsX(d.sub.interactionPairsIdx)';
        pairsY = d.sub.pointsY(d.sub.interactionPairsIdx)';
        plot([pointsX ; pairsX],[pointsY ; pairsY],'-','color',[0.8 0.8 0.8])
end

if d.pl.focalAdhesions
    plotXs = [];
    plotYs = [];
%     markerX = [];
%     markerY = [];
    for k = 1:length(d.cells)
       centerX = mean(d.cells(k).verticesX);
       centerY = mean(d.cells(k).verticesY);
       if centerX > d.pl.axisLimits(1)-1 && centerX < d.pl.axisLimits(2)+1 && centerY > d.pl.axisLimits(3)-1 && centerY < d.pl.axisLimits(4)+1

           connected = find(d.cells(k).substrate.connected);
 
           substrateX = d.sub.pointsX(d.cells(k).substrate.pointsLin);
           substrateY = d.sub.pointsY(d.cells(k).substrate.pointsLin);
           
           adhesionPointsX = sum(reshape(substrateX.*d.cells(k).substrate.weightsLin,[],3),2);
           adhesionPointsY = sum(reshape(substrateY.*d.cells(k).substrate.weightsLin,[],3),2);
           
           
           plotXs = [plotXs [d.cells(k).verticesX(connected)' ; adhesionPointsX']]; %#ok<AGROW>
           plotYs = [plotYs [d.cells(k).verticesY(connected)' ; adhesionPointsY']]; %#ok<AGROW>
%            markerX = [markerX ; d.cells(k).verticesX(connected)]; %#ok<AGROW>
%            markerY = [markerY ; d.cells(k).verticesY(connected)]; %#ok<AGROW>
           
       end
    end
    plot(plotXs,plotYs,'-k')
%     plot(markerX,markerY,'o', 'MarkerFaceColor', 'k');
end