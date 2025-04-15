function d = setup_plotting_options(app, d, plotCase, varargin)
% SETUP_PLOTTING_OPTIONS Setup the plotting options for visualization
%   The function setups the plotting options for the visualization of the
%   simulation, different presimulation settings, or post plotting and
%   analysis. Also, the function creates the figure, sets the figure
%   callbacks and initializes the video, if needed.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%       plotCase: plot case
%       varargin: with the value 'browse' can be used to indicate the need
%           of double lined title for certain plot cases
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the animation is not shown for simulation
if strcmp(plotCase,'simulate') && ~app.ShowanimationCheckBox.Value
    
    % create plot struct and set both plotting and video to false
    d.pl = struct();
    d.pl.plot = false;
    d.pl.video = false;
    
    return
end

% set the plot specific plotting options
if numel(varargin) > 0
    d = setup_specific_plotting_options(app, plotCase,d,varargin);
else
    d = setup_specific_plotting_options(app, plotCase,d);
end

% set the plotting to true
d.pl.plot = true;

% setup the figure
d = setup_figure(app,d,plotCase);

% setup scalebar
d = setup_scalebar(app,d);

% setup figure callbacks
set_figure_callbacks(app,d)

% setups video settings
d = setup_video_settings(app,d,plotCase);

end

function d = setup_specific_plotting_options(app, plotCase,d,varargin)
% SETUP_SPECIFIC_PLOTTING_OPTIONS Setup specific options for plotting
%   The function sets up the specific options for plotting depending on the
%   plot case. It assigns the plotting optins, set the plot type, title
%   type, number of title lines, maximum time, plot time step, highlight
%   type, and automatic size options. Also, for some plot case, there are
%   more specific options.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       plotCase: plot case
%       varargin: with the value 'browse' can be used to indicate the need
%       of double lined title for certain plot cases
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% which plot case
% switch plotCase
    
% simulation
if strcmp(plotCase,'simulate')
    
    % get plotting options
    d.pl = app.plottingOptions;
    
    % set plot type (used to set specific thing needed for this plot)
    d.pl.plotType = 1;
    
    % set title type and number of title lines
    d.pl.titleType = 1;
    d.pl.nTitleLines = 1;
    
    % get the maximum simulation time
    d.pl.maxTime = app.systemParameters.simulationTime;
    
    % get the plot time step
    d.pl.plotDt = app.plottingOptions.plotDtMultiplier*d.spar.maximumTimeStep;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox.Value;
    
% browsing the time points before simulation
elseif strcmp(plotCase,'browse')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 2;
    d.pl.nTitleLines = 2;
    
    % get the maximum simulation time
    d.pl.maxTime = app.import.scaledParameters.simulationTime*app.import.scaledParameters.scalingTime;
    
    % get the plot time step (set to be able to browse through all time
    % points)
    d.pl.plotDt = app.import.scaledParameters.maximumTimeStep;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% adding cells as the initial state of new simulation
elseif strcmp(plotCase,'add_cells')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 3;
    d.pl.nTitleLines = 1;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % set the plotting window size from the GUI (automatic size turned
    % off always)
    d.pl.windowSize = app.plottingOptions.windowSize;
    d.pl.automaticSize = 0;
    
% remove cells be selection
elseif strcmp(plotCase,'remove_cells')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 4;
    d.pl.nTitleLines = 1;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type
    d.pl.highlightType = 3;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% remove cells with shape
elseif strcmp(plotCase,'remove_with_shape')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type (to indicate plot_shape to indicate that this is
    % removal shape)
    d.pl.plotType = 2;
    
    % set title type and number of title lines
    d.pl.titleType = 5;
    d.pl.nTitleLines = 1;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type and highlighted cells
    d.pl.highlightType = 5;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% show substrate size when it is defined manually
elseif strcmp(plotCase,'show_substrate_size')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type (to indicate plot_shape to indicate that this is
    % substrate showing)
    d.pl.plotType = 3;
    
    % set title type and number of title lines
    d.pl.titleType = 6;
    d.pl.nTitleLines = 1;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% select pointlike cell
elseif strcmp(plotCase,'select_pointlike_cell')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 7;
    d.pl.nTitleLines = 1;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type and the highlighted cell
    d.pl.highlightType = 3;
    d.pl.highlightedCells = app.pointlikeProperties.cell;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% normal post plotting (one time point)
elseif strcmp(plotCase,'post')
    
    % get the plotting options
    d.pl = app.importPlottingOptions;
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 8;
    d.pl.nTitleLines = 1;
    
    % get the maximum time from the import
    d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    
    % get the plotting time step from the import
    d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
    
    % set highlight settings depending on the selected special plot
    % type
    d = get_highlighted_cells(app,d);
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    
% browse post plotting
elseif strcmp(plotCase,'post_browse')
    
    % get the plotting options
    d.pl = app.importPlottingOptions;
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 2;
    d.pl.nTitleLines = 2;
    
    % get the maximum time from the import
    d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    
    % get the plotting time step from the import
    d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
    
    % set highlight settings depending on the selected special plot
    % type
    d = get_highlighted_cells(app,d);
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    
% post animation
elseif strcmp(plotCase,'post_animation')
    
    % get the plotting options
    d.pl = app.importPlottingOptions;
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 8;
    d.pl.nTitleLines = 1;
    
    % get the maximum time from the import
    d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    
    % get the plotting time step from the import
    d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
    
    % set highlight settings depending on the selected special plot
    % type
    d = get_highlighted_cells(app,d);
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    
% opto region selection plotting
elseif strcmp(plotCase,'opto_area')
    
    % set substrate solved and included to 0
    d.simset.substrateSolved = 0;
    d.simset.substrateIncluded = 0;
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 9;
    d.pl.nTitleLines = 2;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type and the optogenetic vertices as the
    % highlighted cells
    d.pl.highlightType = 4;
    d.pl.highlightedCells = app.optoVertices;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;

% opto region selection plotting
elseif strcmp(plotCase,'glass_area')
    
    % set substrate solved and included to 0
    d.simset.substrateSolved = 0;
    d.simset.substrateIncluded = 0;
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    d.pl.cellStyle = 1;
    d.pl.substrateStyle = 0;

    d.pl.scaleBar.show = true;

    % set plot type
    d.pl.plotType = 3;
    
    % set title type and number of title lines
    d.pl.titleType = 9;
    d.pl.nTitleLines = 2;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type and the optogenetic vertices as the
    % highlighted cells
    d.pl.highlightType = 0;
    d.pl.highlightedCells = 0;

    d.pl.windowSize = app.SubstratesizeEditField.Value*1e-6;
    % set the automatic sizing to true
    d.pl.automaticSize = 0;
    
% cell selection for optogenetic junction analysis
elseif strcmp(plotCase,'opto_post_cell')
    
    % get the basic plotting options
    d.pl = import_settings([app.defaultPath 'settings/plotting/basic_plotting_options.txt']);
    
    % set plot type
    d.pl.plotType = 0;
    
    % set title type and number of title lines
    d.pl.titleType = 10;
    d.pl.nTitleLines = 2;
    
    % set the maximum simulation time and plotting step (values not
    % important, but step has to have value that is plotted in plot
    % function, e.g. 1)
    d.pl.maxTime = 0;
    d.pl.plotDt = 1;
    
    % set highlight type and highlighted cells
    d.pl.highlightType = 3;
    d.pl.highlightedCells = app.plotImport(app.selectedFile).optoSelectedCells;
    
    % set the automatic sizing to true
    d.pl.automaticSize = 1;
    
% force magnitude plot
elseif strcmp(plotCase,'force_magnitude') || strcmp(plotCase,'force_magnitude_video')
    
    % get the plotting options
    d.pl = app.importPlottingOptions;
    
    % set plot type (to indicate for force plotting that this is
    % magnitude and not quiver)
    d.pl.plotType = 4;
    
    % get the maximum time from the import
    d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    
    % get the plotting time step from the import
    d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    
    % check if the title has two or one line (the browse type requires
    % two lines)
    if numel(varargin) > 0 && strcmp(varargin{1},'browse')
        d.pl.nTitleLines = 2;
    else
        d.pl.nTitleLines = 1;
    end
    
    % get the force magnitude lot settings (marker size and color range
    % limits)
    d.pl.markerSize = app.MarkersizeEditField.Value;
    d.pl.minMagnitude = app.MinimummagnitudeEditField.Value;
    d.pl.maxMagnitude = app.MaximummagnitudeEditField.Value;
    
    % read the colormap from file
    d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap.csv']);
    
    % set all force plotting settings to false to make sure only the
    % selected force is shown
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
    
    % check which force is selected for the magnitude plot, set the
    % plotting for that force true, and set the titleType that is
    % individual for each force
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
    
% plotting cell shape etc. descriptors using color fill
elseif strcmp(plotCase,'cell_descriptors') || strcmp(plotCase,'cell_descriptors_video')
    
    % get the plotting options
    d.pl = app.importPlottingOptions;
    
    % set plot type
    d.pl.plotType = 0;
    
    % get the maximum time from the import
    d.pl.maxTime = app.plotImport(app.selectedFile).scaledParameters.simulationTime*app.plotImport(app.selectedFile).scaledParameters.scalingTime;
    
    % get the plotting time step from the import
    d.pl.plotDt = app.plotImport(app.selectedFile).scaledParameters.maximumTimeStep;
    
    % set highlight type
    d.pl.highlightType = 0;
    
    % get the automatic sizing
    d.pl.automaticSize = app.AutomaticsizeCheckBox_2.Value;
    
    % get the color range minimum and maximun limits
    d.pl.minMagnitude = app.MinimummagnitudeEditField_2.Value;
    d.pl.maxMagnitude = app.MaximummagnitudeEditField_2.Value;
    
    % read the colormap
    d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap.csv']);
    
    % create a vector of color values for the range
    d.pl.colorLocations = linspace(d.pl.minMagnitude,d.pl.maxMagnitude,64);
    
    % check if the title has two or one line (the browse type requires
    % two lines)
    if numel(varargin) > 0 && strcmp(varargin{1},'browse')
        d.pl.nTitleLines = 2;
    else
        d.pl.nTitleLines = 1;
    end
    
    % check which descriptor is selected for the plotting, set the cell
    % style based on the descriptor, and set the title type (individual
    % for each descriptor)
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
            d.pl.titleType = 46;
            
            % for angle, use a diffent colormap and range that goes
            % from -90 to 90 degrees where the color values are
            % mirrored over the angle of 0 degrees
            d.pl.colormap = csvread([app.defaultPath 'settings/misc/mymap2.csv']);
            d.pl.colormap = [d.pl.colormap;flipud(d.pl.colormap)];
            d.pl.colorLocations = linspace(-90,90,128);
    end
end

% if there is no simulation type set yet, set it to 0, since it is needed
% during plotting
if ~isfield(d,'simset')
    d.simset.simulationType = 0;
    d.simset.substrateIncluded = 0;
    d.simset.substrateSolved = 0;
end

% if the simulation type does not have substrate, set the substrate style
% to hidden (0)
if ~d.simset.substrateIncluded
    d.pl.substrateStyle = 0;
end

% if the simulation type is other than pointlike, set the pointlike
% plotting to false
if ~(d.simset.simulationType == 2)
    d.pl.pointlike = false;
end

end

function d = setup_figure(app,d, plotCase)
% SETUP_FIGURE Create the figure for plotting
%   The function creates the figure and initializes the axis.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       plotCase: plot case
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% set the axis limits for the plot area (this is done even if automatic
% size is used, insce it will take over when the plotting starts)
switch app.appTask
    
    % simulation
    case 'simulate'
        
        % get the plot area limits based on the side length and middle
        % point
        d.pl.axisLimits = [app.MiddlepointxEditField.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointxEditField.Value*1e-6+d.pl.windowSize/2 ...
            app.MiddlepointyEditField.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointyEditField.Value*1e-6+d.pl.windowSize/2]/d.spar.scalingLength;
        
        % plot and analysis
    case 'plotAndAnalyze'
        
        % get the plot area limits based on the side length and middle
        % point
        d.pl.axisLimits = [app.MiddlepointxEditField_2.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointxEditField_2.Value*1e-6+d.pl.windowSize/2 ...
            app.MiddlepointyEditField_2.Value*1e-6-d.pl.windowSize/2 ...
            app.MiddlepointyEditField_2.Value*1e-6+d.pl.windowSize/2]/d.spar.scalingLength;
end

% check if the main plotting figure already exists (or if there is a figure
% with the number 1 already)

% if no
if (~ishandle(app.plotHandle) || app.plotHandle == 0) && ~ishandle(1)
    
    % get the position of the main window
    mainWindowPosition = app.EpiMechUIFigure.Position;
    
    % create the figure and save the handle to plotting settings
    d.pl.figureHandle = figure(1);
    
    % move the figure in to a position relative to the main window
    d.pl.figureHandle.Position(1) = mainWindowPosition(1) + 600;
    d.pl.figureHandle.Position(2) = mainWindowPosition(2) + 200;
    
    % save the plot handle to the app structure
    app.plotHandle = figure(1);
    
% if yes
else
    
    % save the figure handle to plotting settings and to the app structure
    d.pl.figureHandle = figure(1);
    app.plotHandle = figure(1);
end

% if the plot case is either animation during simulation or post animation,
% prevent the closure of the plotting figure
if strcmp(plotCase,'simulate') || strcmp(plotCase,'post_animation')
    d.pl.figureHandle.CloseRequestFcn = [];
end

% clear the figure
clf

% save the figure axis handle to plotting settings
d.pl.axesHandle = axes;

% reduce the amount of the gray area around the axis

% get the size of the figure in pixels
figureSize = d.pl.figureHandle.Position(3:4);

% get the relative sizes of the bottom, top and horizontal gaps around the
% axis with the size of 10 pixels
bottomGap = 10/figureSize(2);
horzGap = 10/figureSize(1);

% find the size of the top gap based on the number of title lines
if d.pl.nTitleLines == 2
    topGap = 20/figureSize(2) + 2*d.pl.axesHandle.Title.FontSize/figureSize(2);
else
    topGap = 20/figureSize(2) + d.pl.axesHandle.Title.FontSize/figureSize(2);
end

% calculate the relative axis height and width
axisHeight = 1 - bottomGap - topGap;
axisWidth = 1 - 2*horzGap;

% set the axis position using these values
d.pl.axesHandle.Position = [horzGap bottomGap axisWidth axisHeight];

% get the height and width of the axis in pixels
axisHeight = d.pl.figureHandle.Position(4)*d.pl.axesHandle.Position(4);
axisWidth = d.pl.figureHandle.Position(3)*d.pl.axesHandle.Position(3);

% get the axis size in pixels depending on if the height or the width is
% larger
if axisHeight > axisWidth
    axisSizeInPixels = axisWidth;
else
    axisSizeInPixels = axisHeight;
end

% calculate the title font size
titleFontSize = axisSizeInPixels/40;

% make sure the font size is between (and including) 10 and 15
if titleFontSize > 15
    titleFontSize = 15;
elseif titleFontSize < 10
    titleFontSize = 10;
end

% set the title font size
d.pl.axesHandle.Title.FontSize = titleFontSize;

% set the axis limits
d.pl.axesHandle.XLim = d.pl.axisLimits(1:2);
d.pl.axesHandle.YLim = d.pl.axisLimits(3:4);

% make the axis square
axis square

% set tick lengths to zero and remove the tick and their labels
d.pl.axesHandle.TickLength = [0 0];
d.pl.axesHandle.XTick = [];
d.pl.axesHandle.XTickLabel = [];
d.pl.axesHandle.YTick = [];
d.pl.axesHandle.YTickLabel = [];

% hide the axis lines
d.pl.axesHandle.XColor = 'none';
d.pl.axesHandle.YColor = 'none';

end

function d = setup_scalebar(app,d)
% SETUP_SCALEBAR Define the scale bar length data
%   The function defined the scale bar length data for the plotting
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if scale bar is shown
switch app.appTask
        
    % simulation
    case 'simulate'
        d.pl.scaleBar.show = app.ScalebarCheckBox.Value;
        
    % post plotting
    case 'plotAndAnalyze'
        d.pl.scaleBar.show = app.ScalebarCheckBox_2.Value;
end

% if scale bar is shown
if d.pl.scaleBar.show
    
    % if static scale bar
    if app.scaleBarSettings.type == 1
        
        % get the length data (add the column data for the limits for the
        % use of this scale bar length, in this case values are chosen so
        % that the displayed scale is always between them)
        d.pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
        
    % if dynamic scale bar
    elseif app.scaleBarSettings.type == 2
        
        % if there are no length data, use the default length and add the
        % limit columns
        if app.scaleBarSettings.barLenghtData == 0
            d.pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
            
        % otherwise, use the dynamica bar length data
        else
            d.pl.scaleBar.lengths = app.scaleBarSettings.barLenghtData;
        end
    end
end

end

function d = setup_video_settings(app,d,plotCase)
% SETUP_VIDEO_SETTINGS Setup video for animation saving
%   The function creates a video object for saving the animation during the
%   simulation or for post animation
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       plotCase: plot case
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

switch app.appTask
    
    % simulation
    case 'simulate'
        
        % check if the plot case is simulation
        if strcmp(plotCase,'simulate')
            
            % get the video selection
            d.pl.video = logical(app.SavevideoCheckBox.Value);
            
        % otherwise, no video
        else
            d.pl.video = false;
        end
        
    % post animation
    case 'plotAndAnalyze'
        
        % check if post animation, force magnitude or cell descriptor plot
        if strcmp(plotCase,'post_animation') || strcmp(plotCase,'force_magnitude_video') || strcmp(plotCase,'cell_descriptors_video')
            
            % get the video selection
            d.pl.video = logical(app.SavevideoCheckBox_2.Value);
            
        % otherwise, no video
        else
            d.pl.video = false;
        end
end

% if video is saved
if d.pl.video
    
    % get current time
    startingTime = clock;
    
    % create strings for current date and time
    exportDate = datestr(startingTime, 'yyyymmdd');
    exportTime = datestr(startingTime, 'HHMMSS');
    
    % get the video name from either simulation or plot and analysis tabs
    switch app.appTask
        case 'simulate'
            simulationName = app.SimulationnameEditField.Value;
        case 'plotAndAnalyze'
            simulationName = app.VideonameEditField.Value;
    end
    
    % if the name in the simulation/video field is the default "Give name",
    % give the video the name of "simulation"
    if strcmp(simulationName,'Give name')
        d.pl.exportName = [exportDate '_' exportTime '_simulation'];
        
    % otherwise, use the given name
    else
        d.pl.exportName = [exportDate '_' exportTime '_' simulationName];
    end
    
    % display a message in the plot window the resize the window for the
    % required video size (set the text position and wait for user pressing
    % a key)
    message = ['Resize the plot window' newline 'and press any key'];
    text(mean(d.pl.axisLimits(1:2)), mean(d.pl.axisLimits(3:4)), message,'HorizontalAlignment','center','VerticalAlignment','middle','HorizontalAlignment','center','Color','red','FontSize',14);
    pause
    cla
    
    % display Thank you in the figure window
    text(mean(d.pl.axisLimits(1:2)), mean(d.pl.axisLimits(3:4)), 'Thank you!','HorizontalAlignment','center','VerticalAlignment','middle','HorizontalAlignment','center','Color','red','FontSize',14);
    drawnow
    
    % check if the videos folder already exists in the epimech root folder
    if exist([app.defaultPath 'videos']) ~= 7 %#ok<EXIST>
        
        % if no, create it
        mkdir(app.defaultPath , 'videos');
    end
    
    % create the video object
    d.pl.videoObject = VideoWriter([app.defaultPath 'Videos/' d.pl.exportName], 'MPEG-4');
    
    % set the video quality and framerate from the plotting options
    d.pl.videoObject.Quality = d.pl.videoQuality;
    d.pl.videoObject.FrameRate = d.pl.videoFramerate;
    
    % open the video object
    open(d.pl.videoObject);
    
    % turn of the warning about video padding (this error is given if the
    % video resolution is not divisible by 2, and matlab will automatically
    % pad the video)
    warning off MATLAB:audiovideo:VideoWriter:mp4FramePadded
    
    % turn of resizing from the video
    set(gcf,'Resize','off')
    
% if no video is created, create an empty object
else
    d.pl.videoObject = [];
end

end