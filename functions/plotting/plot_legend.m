function plot_legend(d)

if d.pl.cellStyle == 3

    legendColors = zeros(3, 1);
    legendColors(1) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.6 0.73 0.62],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(2) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.69 0.55],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(3) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.59 0.55],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(4) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.71 0.55 0.59],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(5) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.5 0.59 0.71],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(6) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.59 0.63 0.71],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(7) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.55 0.69 0.70],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legendColors(8) = plot(d.pl.axesHandle,NaN,NaN,'s','MarkerFaceColor',[0.40 0.45 0.41],'MarkerEdgeColor', 'k', 'MarkerSize', 12);
    legend(d.pl.axesHandle,legendColors, '1','2','3','4','5','6','7','7+','FontSize',14);

end