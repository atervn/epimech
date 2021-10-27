function d = setup_axis_area_plot(app,d)

if (~ishandle(app.CallingApp.plotHandle) || app.CallingApp.plotHandle == 0) && ~ishandle(1)
    mainWindowPosition = app.CallingApp.EpiMechUIFigure.Position;
    d.pl.figureHandle = figure(1);
    d.pl.figureHandle.Position(1) = mainWindowPosition(1) + 600;
    d.pl.figureHandle.Position(2) = mainWindowPosition(2) + 200;
    app.CallingApp.plotHandle = figure(1);
else
    d.pl.figureHandle = figure(1);
    clf;
    app.CallingApp.plotHandle = figure(1);
end

d.pl.nTitleLines = 1;

d.pl.axesHandle = axes;

figureSize = d.pl.figureHandle.Position(3:4);
bottomGap = 10/figureSize(2);
topGap = 10/figureSize(2);
horzGap = 10/figureSize(1);
axisHeight = 1 - bottomGap - topGap;
axisWidth = 1 - 2*horzGap;
d.pl.axesHandle.Position = [horzGap bottomGap axisWidth axisHeight];

axisHeight = d.pl.figureHandle.Position(4)*d.pl.axesHandle.Position(4);
axisWidth = d.pl.figureHandle.Position(3)*d.pl.axesHandle.Position(3);
if axisHeight > axisWidth
    axisSizeInPixels = axisWidth;
else
    axisSizeInPixels = axisHeight;
end

titleFontSize = axisSizeInPixels/40;
if titleFontSize > 15
    titleFontSize = 15;
elseif titleFontSize < 10
    titleFontSize = 10;
end

d.pl.axesHandle.Title.FontSize = titleFontSize;

topGap = 20/figureSize(2) + d.pl.axesHandle.Title.FontSize/figureSize(2);

d.pl.axesHandle.Position(4) = 1 - bottomGap - topGap;

axis(app.WindowsizeEditField.Value.*[-0.5 0.5 -0.5 0.5])

axis square

d.pl.axesHandle.TickLength = [0 0];
d.pl.axesHandle.XTick = [];
d.pl.axesHandle.XTickLabel = [];
d.pl.axesHandle.YTick = [];
d.pl.axesHandle.YTickLabel = [];
d.pl.axesHandle.XColor = 'none';
d.pl.axesHandle.YColor = 'none';

set_figure_callbacks(app.CallingApp,d)