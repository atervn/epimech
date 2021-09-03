function d = set_plot_figure_position(app,d)

if ~ishandle(app.plotHandle) || app.plotHandle == 0
    mainWindowPosition = app.EpiMechUIFigure.Position;
    d.pl.figureHandle = figure(1);
    d.pl.figureHandle.Position(1) = mainWindowPosition(1) + 600;
    d.pl.figureHandle.Position(2) = mainWindowPosition(2) + 200;
    app.plotHandle = figure(1);
else
    d.pl.figureHandle = figure(1);
    app.plotHandle = figure(1);
end