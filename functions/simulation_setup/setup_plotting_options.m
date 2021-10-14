function d = setup_plotting_options(app, plotCase,d,varargin)

if strcmp(plotCase,'simulate') && ~app.ShowanimationCheckBox.Value
    d.pl = struct();
    d.pl.plot = false;
    d.pl.video = false;
    return
end

switch plotCase
    case 'simulate'
        d.pl = app.plottingOptions;
        d.pl.plotType = 1;
        d.pl.titleType = 1;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = app.systemParameters.simulationTime;
        d.pl.plotDt = app.plottingOptions.plotDtMultiplier*d.spar.maximumTimeStep;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'browse'
        d.simset.simulationType = 0;scal
        d.spar.scalingTime = app.import.scaledParameters.scalingTime;
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 2;
        d.pl.nTitleLines = 2;
        d.pl.maxTime = app.import.scaledParameters.simulationTime*app.import.scaledParameters.scalingTime;
        d.pl.plotDt = app.import.scaledParameters.maximumTimeStep;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'add_cells'
        d.simset.simulationType = 0;
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 3;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = 0;
    case 'remove_cells'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 4;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 3;
        d.pl.highlightedCells = [];
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'remove_with_shape'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 3;
        d.pl.titleType = 5;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 5;
        d.pl.highlightedCells = [];
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'show_substrate_size'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 4;
        d.pl.titleType = 6;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'select_pointlike_cell'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 7;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 3;
        d.pl.highlightedCells = app.pointlikeProperties.cell;
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'post'
        d.pl = app.importPlottingOptions;
        d.pl.plotType = 2;
        d.pl.titleType = 8;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
        d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
        d = get_highlighted_cells(app,d);
        d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    case 'post_browse'
        d.pl = app.importPlottingOptions;
        d.pl.plotType = 2;
        d.pl.titleType = 2;
        d.pl.nTitleLines = 2;
        d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
        d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
        d = get_highlighted_cells(app,d);
        d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    case 'post_animation'
        d.pl = app.importPlottingOptions;
        d.pl.plotType = 2;
        d.pl.titleType = 8;
        d.pl.nTitleLines = 1;
        d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
        d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
        d = get_highlighted_cells(app,d);
        d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    case 'opto_area'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 9;
        d.pl.nTitleLines = 2;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 4;
        d.pl.highlightedCells = app.optoVertices;
        d.pl.windowSize = app.plottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'opto_post_cell'
        d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
        d.pl.plotType = 2;
        d.pl.titleType = 10;
        d.pl.nTitleLines = 2;
        d.pl.maxTime = 0;
        d.pl.plotDt = 1;
        d.pl.highlightType = 3;
        d.pl.highlightedCells = app.plotImport(app.selectedFile).optoSelectedCells;
        d.pl.windowSize = app.importPlottingOptions.windowSize;
        d.pl.automaticSize = app.AutomaticsizeCheckBox_3.Value;
    case 'force_magnitude'
        d.pl = app.importPlottingOptions;
        d.pl.plotType = 10;
        d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
        d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
        
        d.pl.cellForcesCortical = 0;
        d.pl.cellForcesJunctions = 0;
        d.pl.cellForcesDivision = 0;
        d.pl.cellForcesMembrane = 0;
        d.pl.cellForcesContact = 0;
        d.pl.cellForcesArea = 0;
        d.pl.cellForcesPointlike = 0;
        d.pl.cellForcesFocalAdhesions = 0;
        d.pl.cellForcesTotal = 0;
        d.pl.substrateForcesCentral = 0;
        d.pl.substrateForcesRepulsion = 0;
        d.pl.substrateForcesRestoration = 0;
        d.pl.substrateForcesFocalAdhesions = 0;
        d.pl.substrateForcesTotal = 0;
        
        d.pl.markerSize = app.MarkersizeEditField.Value;
        d.pl.minMagnitude = app.MinimummagnitudeEditField.Value;
        d.pl.maxMagnitude = app.MaximummagnitudeEditField.Value;
        
        d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap.csv']);
        d.pl.colorLocations = linspace(d.pl.minMagnitude,d.pl.maxMagnitude,64);
        
        if numel(varargin) > 0 && strcmp(varargin{1},'browse')
            d.pl.nTitleLines = 2;
        else
            d.pl.nTitleLines = 1;
        end
        
        switch app.ForceDropDown_2.Value
            case 'Total forces'
                d.pl.cellForcesTotal = 1;
                d.pl.titleType = 20;
            case 'Cortical forces'
                d.pl.cellForcesCortical = 1;
                d.pl.titleType = 21;
            case 'Junction forces'
                d.pl.cellForcesJunctions = 1;
                d.pl.titleType = 22;
            case 'Division forces'
                d.pl.cellForcesDivision = 1;
                d.pl.titleType = 23;
            case 'Membrane forces'
                d.pl.cellForcesMembrane = 1;
                d.pl.titleType = 24;
            case 'Contact forces'
                d.pl.cellForcesContact = 1;
                d.pl.titleType = 25;
            case 'Area forces'
                d.pl.cellForcesArea = 1;
                d.pl.titleType = 26;
            case 'Pointlike forces'
                d.pl.cellForcesPointlike = 1;
                d.pl.titleType = 27;
            case 'Focal adhesion forces'
                d.pl.cellForcesFocalAdhesions = 1;
                d.pl.titleType = 28;
            case 'Total substrate forces'
                d.pl.substrateForcesTotal = 1;
                d.pl.titleType = 29;
            case 'Central substrate forces'
                d.pl.substrateForcesCentral = 1;
                d.pl.titleType = 30;
            case 'Restorative substrate forces'
                d.pl.substrateForcesRestoration = 1;
                d.pl.titleType = 31;
            case 'Repulsion substrate forces'
                d.pl.substrateForcesRepulsion = 1;
                d.pl.titleType = 32;
            case 'Focal adhesion substrate forces'
                d.pl.substrateForcesFocalAdhesions = 1;
                d.pl.titleType = 33;
                
        end
    case 'cell_descriptors'
        d.pl = app.importPlottingOptions;
        d.pl.plotType = 2;
        d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
        d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
        d.pl.highlightType = 0;
        d.pl.highlightedCells = [];
        d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
        d.pl.minMagnitude = app.MinimummagnitudeEditField_2.Value;
        d.pl.maxMagnitude = app.MaximummagnitudeEditField_2.Value;
        
        d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap.csv']);
        d.pl.colorLocations = linspace(d.pl.minMagnitude,d.pl.maxMagnitude,64);
        
        if numel(varargin) > 0 && strcmp(varargin{1},'browse')
            d.pl.nTitleLines = 2;
        else
            d.pl.nTitleLines = 1;
        end
        
        switch app.DescriptorDropDown.Value
            case 'Area'
                d.pl.cellStyle = 7;
                d.pl.titleType = 40;
            case 'Area strain'
                d.pl.cellStyle = 8;
                d.pl.titleType = 41;
            case 'Perimeter'
                d.pl.cellStyle = 9;
                d.pl.titleType = 42;
            case 'Perimeter strain'
                d.pl.cellStyle = 10;
                d.pl.titleType = 43;
            case 'Circularity'
                d.pl.cellStyle = 11;
                d.pl.titleType = 44;
            case 'Aspect ratio'
                d.pl.cellStyle = 12;
                d.pl.titleType = 45;
            case 'Angle'
                d.pl.cellStyle = 13;
                d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap2.csv']);
                d.pl.colormap = [d.pl.colormap;flipud(d.pl.colormap)];
                d.pl.colorLocations = linspace(-90,90,128);
                d.pl.titleType = 46;
        end
        
end

if ~any(d.simset.simulationType == [2 3 5])
    d.pl.substrateStyle = 0;
end
if ~(d.simset.simulationType == 2)
    d.pl.pointlike = false;
end


d.pl.plot = true;
switch app.appTask
    case 'simulate'
        d.pl.axisLimits = [app.MiddlepointxEditField.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointxEditField.Value*1e-6+d.pl.windowSize/2 ...
            app.MiddlepointyEditField.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointyEditField.Value*1e-6+d.pl.windowSize/2]/d.spar.scalingLength;
    case 'plotAndAnalyze'
        d.pl.axisLimits = [app.MiddlepointxEditField_2.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointxEditField_2.Value*1e-6+d.pl.windowSize/2 ...
            app.MiddlepointyEditField_2.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointyEditField_2.Value*1e-6+d.pl.windowSize/2]/d.spar.scalingLength;
end


if (~ishandle(app.plotHandle) || app.plotHandle == 0) && ~ishandle(1)
    mainWindowPosition = app.EpiMechUIFigure.Position;
    d.pl.figureHandle = figure(1);
    d.pl.figureHandle.Position(1) = mainWindowPosition(1) + 600;
    d.pl.figureHandle.Position(2) = mainWindowPosition(2) + 200;
    app.plotHandle = figure(1);
else
    d.pl.figureHandle = figure(1);
    app.plotHandle = figure(1);
end

if strcmp(plotCase,'simulate') || strcmp(plotCase,'post_animation')
    d.pl.figureHandle.CloseRequestFcn = [];
end

clf

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

if d.pl.nTitleLines == 2
    topGap = 20/figureSize(2) + 2*d.pl.axesHandle.Title.FontSize/figureSize(2);
else
    topGap = 20/figureSize(2) + d.pl.axesHandle.Title.FontSize/figureSize(2);
end
d.pl.axesHandle.Position(4) = 1 - bottomGap - topGap;

d.pl.axesHandle.XLim = d.pl.axisLimits(1:2);
d.pl.axesHandle.YLim = d.pl.axisLimits(3:4);


axis square

d.pl.axesHandle.TickLength = [0 0];
d.pl.axesHandle.XTick = [];
d.pl.axesHandle.XTickLabel = [];
d.pl.axesHandle.YTick = [];
d.pl.axesHandle.YTickLabel = [];
d.pl.axesHandle.XColor = 'none';
d.pl.axesHandle.YColor = 'none';


switch app.appTask
    case 'simulate'
        d.pl.scaleBar.show = app.ScalebarCheckBox.Value;
    case 'plotAndAnalyze'
        d.pl.scaleBar.show = app.ScalebarCheckBox_2.Value;
end
if d.pl.scaleBar.show
    if app.scaleBarSettings.type == 1
        d.pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
    elseif app.scaleBarSettings.type == 2
        if app.scaleBarSettings.barLenghtData == 0
            d.pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
        else
            d.pl.scaleBar.lengths = app.scaleBarSettings.barLenghtData;
        end
    end
end

switch app.appTask
    case 'simulate'
        if strcmp(plotCase,'simulate')
            d.pl.video = logical(app.SavevideoCheckBox.Value);
        else
            d.pl.video = false;
        end
    case 'plotAndAnalyze'
        if strcmp(plotCase,'post_animation') || strcmp(plotCase,'force_magnitude') || strcmp(plotCase,'cell_descriptors')
            d.pl.video = logical(app.SavevideoCheckBox_2.Value);
        else
            d.pl.video = false;
        end
end

set_figure_callbacks(d,app)

if d.pl.video
    startingTime = clock;
    exportDate = datestr(startingTime, 'yyyymmdd');
    exportTime = datestr(startingTime, 'HHMMSS');
    switch app.appTask
        case 'simulate'
            simulationName = app.SimulationnameEditField.Value;
        case 'plotAndAnalyze'
            simulationName = app.VideonameEditField.Value;
    end
    
    
    if strcmp(simulationName,'Give name')
        d.pl.exportName = [exportDate '_' exportTime '_simulation'];
    else
        d.pl.exportName = [exportDate '_' exportTime '_' simulationName];
    end
    
    message = ['Resize the plot window' newline 'and press any key'];
    text(mean(d.pl.axisLimits(1:2)), mean(d.pl.axisLimits(3:4)), message,'HorizontalAlignment','center','VerticalAlignment','middle','HorizontalAlignment','center','Color','red','FontSize',14);
    pause
    cla
    
    text(mean(d.pl.axisLimits(1:2)), mean(d.pl.axisLimits(3:4)), 'Thank you!','HorizontalAlignment','center','VerticalAlignment','middle','HorizontalAlignment','center','Color','red','FontSize',14);
    drawnow
    if exist([app.defaultPath 'videos']) ~= 7 %#ok<EXIST>
        mkdir(app.defaultPath , 'videos');
    end
    d.pl.videoObject = VideoWriter([app.defaultPath 'Videos/' d.pl.exportName], 'MPEG-4');
    d.pl.videoObject.Quality = d.pl.videoQuality;
    d.pl.videoObject.FrameRate = d.pl.videoFramerate;
    open(d.pl.videoObject);
    warning off MATLAB:audiovideo:VideoWriter:mp4FramePadded
    set(gcf,'Resize','off')
else
    d.pl.videoObject = [];
end